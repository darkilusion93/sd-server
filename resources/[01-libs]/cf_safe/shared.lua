-- ════════════════════════════════════════════════════════════════
--  cf_safe — validação de valores vindos do cliente (NUNCA confiar)
--  Uso:
--     local amount = exports.cf_safe:Amount(arg)   -- inteiro > 0 ou nil
--     if not amount then return end
--  Mata a raiz sistémica da auditoria: montantes negativos / fracionados
--  / não-numéricos em handlers de dinheiro e itens.
-- ════════════════════════════════════════════════════════════════

CFSafe = {}

--- Montante monetário/quantidade: inteiro estritamente positivo, ou nil.
-- @param v any  valor cru do cliente
-- @param max number|nil  teto opcional (rejeita acima)
-- @return number|nil
function CFSafe.Amount(v, max)
    v = tonumber(v)
    if not v then return nil end
    v = math.floor(v)
    if v <= 0 then return nil end
    if max and v > max then return nil end
    return v
end

--- Inteiro dentro de [min, max] (inclusive), ou nil.
function CFSafe.Int(v, min, max)
    v = tonumber(v)
    if not v then return nil end
    v = math.floor(v)
    if min and v < min then return nil end
    if max and v > max then return nil end
    return v
end

--- Quantidade de item: inteiro >= 1 (com teto opcional), ou nil.
function CFSafe.Count(v, max)
    return CFSafe.Amount(v, max)
end

--- String "segura" para nomes de ficheiro/ids: só [%w_-], <= maxlen, ou nil.
-- Protege contra path traversal e injeções via nomes.
function CFSafe.Slug(s, maxlen)
    if type(s) ~= 'string' then return nil end
    if #s == 0 or #s > (maxlen or 64) then return nil end
    if s:find('[^%w_%-]') then return nil end
    return s
end

--- Confirma que `id` corresponde a um jogador online; devolve o source ou nil.
-- Server-only. Evita nil-deref de GetPlayerFromId com id forjado.
function CFSafe.OnlinePlayer(id)
    if IsDuplicityVersion and IsDuplicityVersion() then
        local n = GetPlayerName(tostring(id))
        if n then return tonumber(id) end
    end
    return nil
end

-- Exports (uso cross-resource)
exports('Amount', function(v, max) return CFSafe.Amount(v, max) end)
exports('Int',    function(v, min, max) return CFSafe.Int(v, min, max) end)
exports('Count',  function(v, max) return CFSafe.Count(v, max) end)
exports('Slug',   function(s, maxlen) return CFSafe.Slug(s, maxlen) end)
exports('OnlinePlayer', function(id) return CFSafe.OnlinePlayer(id) end)

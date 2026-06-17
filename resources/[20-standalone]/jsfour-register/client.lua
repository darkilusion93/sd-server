-- jsfour-register (base limpa Sem Destino RP) — criação de personagem
-- Fluxo: identidade (sexo, nome, apelido, nascimento, altura) -> grava na DB
--        -> editor de aparência do cframework (esx_skin:openSaveableMenu) -> grava skin.
-- O registo é obrigatório: os diálogos reabrem se forem cancelados/inválidos.

local ESX = nil
CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(100)
    end
end)

local registering = false

-- ── Validações de UX (o servidor revalida tudo) ────────────────────────────
local function isValidName(s)
    if type(s) ~= 'string' then return false end
    s = s:gsub('^%s+', ''):gsub('%s+$', '')
    if #s < 2 or #s > 20 then return false end
    if s:find('[<>"\\;%d]') then return false end   -- sem dígitos nem caracteres perigosos
    if not s:find('%a') then return false end        -- pelo menos uma letra
    return true
end

local function isValidDob(s)
    return type(s) == 'string' and s:match('^%d%d/%d%d/%d%d%d%d$') ~= nil
end

local function isValidHeight(s)
    local n = tonumber(s)
    return n ~= nil and n >= 120 and n <= 220
end

-- ── Diálogo de texto obrigatório (reabre até ser válido) ────────────────────
local function askText(title, validator)
    local value, done = nil, false
    local function open()
        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'jsreg_dialog', { title = title },
            function(data, menu)
                -- o menu_dialog do cframework converte valores numéricos em number;
                -- normalizar sempre para string antes de validar/processar.
                local raw = tostring(data.value or '')
                if validator(raw) then
                    value = (raw:gsub('^%s+', ''):gsub('%s+$', ''))
                    done = true
                    menu.close()
                else
                    menu.close()
                    ESX.ShowNotification('~r~Valor inválido. Tenta novamente.')
                    open()
                end
            end,
            function(data, menu)
                menu.close()
                ESX.ShowNotification('~y~Tens de completar o registo.')
                open()
            end)
    end
    open()
    while not done do Wait(50) end
    return value
end

-- ── Escolha de sexo (define o modelo base) ──────────────────────────────────
local function askSex()
    local value, done = nil, false
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'jsreg_sex', {
        title    = 'Sexo da personagem',
        align    = 'top-left',
        elements = {
            { label = 'Masculino', value = 'm' },
            { label = 'Feminino',  value = 'f' }
        }
    }, function(data, menu)
        value = data.current.value
        done = true
        menu.close()
    end, function(data, menu) end)  -- sem cancelar
    while not done do Wait(50) end
    return value
end

-- ── Editor de aparência (do cframework) — obrigatório ───────────────────────
local function openAppearance(onDone)
    TriggerEvent('esx_skin:openSaveableMenu',
        function(data, menu)   -- submit: o esx_skin:save (dentro do OpenSaveableMenu) já gravou o skin
            onDone()
        end,
        function(data, menu)   -- cancel: criação obrigatória -> reabrir
            ESX.ShowNotification('~y~Escolhe o visual da tua personagem.')
            openAppearance(onDone)
        end)
end

-- ── Entrada: disparado pelo cl_spawnmanager quando o jogador não tem skin ────
AddEventHandler('jsfour-register:open', function()
    if registering then return end
    registering = true

    CreateThread(function()
        while ESX == nil do Wait(100) end

        local ped = PlayerPedId()
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)

        local sex = askSex()

        -- carregar o modelo base (mp_m_freemode_01 / mp_f_freemode_01)
        TriggerEvent('skinchanger:loadDefaultModel', sex == 'm')
        Wait(750)
        FreezeEntityPosition(PlayerPedId(), true)

        local firstname = askText('Primeiro nome', isValidName)
        local lastname  = askText('Apelido', isValidName)
        local dob       = askText('Data de nascimento (DD/MM/AAAA)', isValidDob)
        local height    = askText('Altura em cm (120-220)', isValidHeight)

        TriggerServerEvent('jsfour-register:save', {
            firstname   = firstname,
            lastname    = lastname,
            dateofbirth = dob,
            sex         = sex,
            height      = tostring(math.floor(tonumber(height)))
        })

        ESX.ShowNotification('~g~Identidade criada! Agora personaliza o teu visual.')

        openAppearance(function()
            local p = PlayerPedId()
            FreezeEntityPosition(p, false)
            SetEntityInvincible(p, false)
            ESX.ShowNotification('~g~Bem-vindo(a) a Sem Destino RP!')
            registering = false
        end)
    end)
end)

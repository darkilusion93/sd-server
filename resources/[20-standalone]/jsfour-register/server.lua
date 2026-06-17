-- jsfour-register — gravação server-autoritária da identidade
-- Toda a validação é refeita no servidor (não confia no cliente). Query parametrizada.

local ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local function cleanName(s)
    if type(s) ~= 'string' then return nil end
    s = s:gsub('^%s+', ''):gsub('%s+$', '')
    if #s < 2 or #s > 20 then return nil end
    if s:find('[<>"\\;%d]') then return nil end
    if not s:find('%a') then return nil end
    return s
end

RegisterServerEvent('jsfour-register:save')
AddEventHandler('jsfour-register:save', function(data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end
    if type(data) ~= 'table' then return end

    local firstname = cleanName(data.firstname)
    local lastname  = cleanName(data.lastname)
    local dob       = data.dateofbirth
    local sex       = data.sex
    local height    = tonumber(data.height)

    if not firstname or not lastname then return end
    if type(dob) ~= 'string' or not dob:match('^%d%d/%d%d/%d%d%d%d$') then return end
    if sex ~= 'm' and sex ~= 'f' then return end
    if not height or height < 120 or height > 220 then return end
    height = tostring(math.floor(height))

    MySQL.Async.execute(
        'UPDATE users SET firstname = @firstname, lastname = @lastname, dateofbirth = @dob, sex = @sex, height = @height WHERE identifier = @identifier',
        {
            ['@firstname']  = firstname,
            ['@lastname']   = lastname,
            ['@dob']        = dob,
            ['@sex']        = sex,
            ['@height']     = height,
            ['@identifier'] = xPlayer.identifier
        }
    )
end)

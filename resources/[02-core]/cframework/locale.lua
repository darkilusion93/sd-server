Locales = {}

function translateString(str, ...)  -- Translate string
	if Locales[Config.Locale] ~= nil then

		if Locales[Config.Locale][str] ~= nil then
			local translation = ''

			local params = ParamPacker(...)

			local success, error = pcall(function()
				translation = string.format(Locales[Config.Locale][str], ParamUnpacker(params))
			end)

			if success then
				return translation
			else
				print('[ERROR] Translation not found -> ' .. Locales[Config.Locale][str])
				return Locales[Config.Locale][str]
			end
		else
			return 'Translation [' .. Config.Locale .. '][' .. str .. '] does not exist'
		end

	else
		return 'Locale [' .. Config.Locale .. '] does not exist'
	end
end

function _U(str, ...) -- Translate string first char uppercase
	return tostring(translateString(str, ...):gsub("^%l", string.upper))
end


--Translation function
function T(key)
    local locale = GetConvar("sv_lang", "PT")

    if LANG[locale] == nil then
        return key
    end

    if LANG[locale][key] == nil then
        if LANG["EN"][key] ~= nil then
            return LANG["EN"][key]
        end

        return key
    end

    return LANG[locale][key]
end

--RegisterNUICallback('getTranslation', function(data, cb)
--    local key = data.key
--    cb(T(key))
--end)


RegisterNUICallback("getTranslations", function(_, cb)
    local locale = GetConvar("sv_lang", "PT")

    cb(LANG[locale] or {})
end)

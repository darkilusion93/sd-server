

Citizen.CreateThread(function()
    Citizen.Wait(100)
    SetDiscordAppId(GetConvar("rich_presence_app_id", ""))
    SetDiscordRichPresenceAsset('logo')

    local sv_name = GetConvar("sv_name", "")

    SetRichPresence(sv_name)
end)
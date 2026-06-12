

local usableClips <const> = {
    "micro_clip",
    "tec9_clip",
    "tecpistol_clip",
    "appistol_clip",
    "heavypistol_clip",
    "pistol50_clip",
    "gusenberg_clip",
    "assaultsmg_clip",
    "pdw_clip",
    "bullpup_clip",
    "specialcarbine_clip",
    "assaultrifle_clip",
    "compactrifle_clip",
    "carbinerifle_clip",
    "combatpistol_clip",
    "heavyrifle_clip",
    "pistol_clip",
    "smg_clip",
    "sns_clip",
    "tactical_clip",
    "vintage_clip",

    "clip12",
    "clip_rubber",
    "clip45",
    "clip556",
    "clip762",
    "clip9"
}

Citizen.CreateThread(function()
    for _, clip in ipairs(usableClips) do
        ESX.RegisterUsableItem(clip, function(source, slot)
            TriggerClientEvent("cframework:useClip", source, slot, clip)
        end)
    end
end)

RegisterServerEvent("cframework:clipRemove", function(slot, clip, weaponSlot, ammo)
    local source <const> = source
    local inventory <const> = ESX.getInvContainer(source)

    inventory.removeItem(clip, 1, slot)
    inventory.updateMetadata(weaponSlot, "ammo", ammo)
end)
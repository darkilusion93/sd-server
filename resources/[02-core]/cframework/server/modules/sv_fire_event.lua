

AddEventHandler('fireEvent', function(sender, data)
    if ESX.getPlayTime(sender) < 3600 then
        CancelEvent()
    end

    if data[1][1].weaponHash == -1569615261 and data[1][1].isEntity then
        DropPlayer(sender, 'Sem Destino Anti-Cheat: Fogo')
        CancelEvent()
    end
end)
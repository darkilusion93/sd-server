CreateThread(function()
    local name = GetCurrentResourceName()
    Wait(5000)
    SendNUIMessage({
        config = config,
        translate = translate,
        NameResource = name
    })
end)

CreateThread(function()
    while true do
        if oppened then
            if IsControlJustPressed(0, config_keys.moveUP) then
                keysNUI('up')
            elseif IsControlJustPressed(0, config_keys.moveDown) then
                keysNUI('down')
            elseif IsControlJustPressed(0, config_keys.moveLeft) then
                keysNUI('left')
            elseif IsControlJustPressed(0, config_keys.moveRight) then
                keysNUI('right')
            elseif IsControlJustPressed(0, config_keys.enter) then
                keysNUI('enter')
            elseif IsControlJustPressed(0, config_keys.back) then
                keysNUI('back')
            end
        end

        Wait(0);
    end
end)
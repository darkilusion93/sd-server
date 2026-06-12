local emuso = false

Citizen.CreateThread(function()
	Citizen.Wait(20 * 1000)

	local s = Scaleform.Request("MIDSIZED_MESSAGE")
	s:CallFunction("SHOW_MIDSIZED_MESSAGE", '', Config.Strings.HospitalCheckIn)

	while true do
		Citizen.Wait(1)

		local plyCoords = GetEntityCoords(PlayerPedId(), 0)

		local distance = #(vector3(Config.Hospital.Location.x, Config.Hospital.Location.y, Config.Hospital.Location.z) - plyCoords)
		local distance2 = #(vector3(Config.Hospital.Location2.x, Config.Hospital.Location2.y, Config.Hospital.Location2.z) - plyCoords)
		local distance3 = #(vector3(Config.Hospital.Location3.x, Config.Hospital.Location3.y, Config.Hospital.Location3.z) - plyCoords)
		local distance4 = #(vector3(Config.Hospital.Location4.x, Config.Hospital.Location4.y, Config.Hospital.Location4.z) - plyCoords)

		if distance < 10 then

			DrawMarker(25,
				Config.Hospital.Location.x,
				Config.Hospital.Location.y,
				Config.Hospital.Location.z - 0.99,
				0, 0, 0, 0, 0, 0,
				0.5, 0.5, 1.0,
				3, 104, 168, 250,
				false, false, 2, false, false, false, false
			)

			if distance < 3 then
				s:Render3D(
					Config.Hospital.Location.x,
					Config.Hospital.Location.y,
					Config.Hospital.Location.z - 0.5,
					0.0, 0.0,
					-GetGameplayCamRot().z,
					3.5, 3.5, 0.0
				)

				if IsControlJustReleased(0, Config.Keys.Revive) and emuso == false then
					emuso = true

					local success = lib.progressBar({
						duration = 2500,
						label = Config.Strings.HospitalCheckInAction,
						useWhileDead = true,
						canCancel = true,
						disable = {
							move = true,
							car = true,
							combat = true,
							mouse = false,
						},
						anim = not IsEntityDead(PlayerPedId()) and {
							dict = "missheistdockssetup1clipboard@base",
							clip = "base",
							flag = 49,
						} or nil,
						prop = not IsEntityDead(PlayerPedId()) and {
							{
								model = `p_amb_clipboard_01`,
								bone = 18905,
								pos = vec3(0.10, 0.02, 0.08),
								rot = vec3(-80.0, 0.0, 0.0),
							},
							{
								model = `prop_pencil_01`,
								bone = 58866,
								pos = vec3(0.12, 0.0, 0.001),
								rot = vec3(-150.0, 0.0, 0.0),
							}
						} or nil,
					})

					if success then
						isInHospitalBed = true

						if IsScreenFadedOut() then
							DoScreenFadeIn(100)
						end

						if IsEntityDead(PlayerPedId()) then
							TriggerEvent('mythic_hospital:client:RPCheckPos2')
							TriggerServerEvent('esx:killerlog3', 'usou o blip hospital enquanto morto')
						else
							TriggerEvent('mythic_hospital:client:RPCheckPos2')
							TriggerServerEvent('esx:killerlog3', 'usou o blip hospital enquanto vivo')
						end

						emuso = false
					else
						isInHospitalBed = false
						emuso = false
					end
				end
			end

		elseif distance2 < 10 then

			DrawMarker(25,
				Config.Hospital.Location2.x,
				Config.Hospital.Location2.y,
				Config.Hospital.Location2.z - 0.99,
				0, 0, 0, 0, 0, 0,
				0.5, 0.5, 1.0,
				3, 104, 168, 250,
				false, false, 2, false, false, false, false
			)

			if distance2 < 3 then
				s:Render3D(
					Config.Hospital.Location2.x,
					Config.Hospital.Location2.y,
					Config.Hospital.Location2.z - 0.5,
					0.0, 0.0,
					-GetGameplayCamRot().z,
					3.5, 3.5, 0.0
				)

				if IsControlJustReleased(0, Config.Keys.Revive) and emuso == false then
					emuso = true

					local success = lib.progressBar({
						duration = 2500,
						label = Config.Strings.HospitalCheckInAction,
						useWhileDead = true,
						canCancel = true,
						disable = {
							move = true,
							car = true,
							combat = true,
							mouse = false,
						},
						anim = not IsEntityDead(PlayerPedId()) and {
							dict = "missheistdockssetup1clipboard@base",
							clip = "base",
							flag = 49,
						} or nil,
						prop = not IsEntityDead(PlayerPedId()) and {
							{
								model = `p_amb_clipboard_01`,
								bone = 18905,
								pos = vec3(0.10, 0.02, 0.08),
								rot = vec3(-80.0, 0.0, 0.0),
							},
							{
								model = `prop_pencil_01`,
								bone = 58866,
								pos = vec3(0.12, 0.0, 0.001),
								rot = vec3(-150.0, 0.0, 0.0),
							}
						} or nil,
					})

					if success then
						isInHospitalBed = true

						if IsScreenFadedOut() then
							DoScreenFadeIn(100)
						end

						if IsEntityDead(PlayerPedId()) then
							TriggerEvent('mythic_hospital:client:RPCheckPos')
							TriggerServerEvent('esx:killerlog3', 'usou o blip hospital enquanto morto')
						else
							TriggerEvent('mythic_hospital:client:RPCheckPos')
							TriggerServerEvent('esx:killerlog3', 'usou o blip hospital enquanto vivo')
						end

						emuso = false
					else
						isInHospitalBed = false
						emuso = false
					end
				end
			end

		else
			Citizen.Wait(1000)
		end
	end
end)

Citizen.CreateThread(function()
    while true do
        if not IsEntityDead(PlayerPedId()) then
            local short, dist = IsNearTeleport()
            if dist ~= nil and currentTp ~= nil then
                local player = PlayerPedId()
                if IsControlJustReleased(0, Config.Keys.Revive) then
                    if not IsPedInAnyVehicle(player, true) then
                        DoScreenFadeOut(500)
                        while not IsScreenFadedOut() do
                            Citizen.Wait(10)
                        end
                
                        SetEntityCoords(player, Config.Teleports[currentTp.destination].x, Config.Teleports[currentTp.destination].y, Config.Teleports[currentTp.destination].z, 0, 0, 0, false)
                        SetEntityHeading(player, Config.Teleports[currentTp.destination].h)
                
                        Citizen.Wait(100)
                
                        DoScreenFadeIn(1000)
                    end
                end

                Citizen.Wait(1)
            elseif short < 25 then
                Citizen.Wait(5)
            else
                Citizen.Wait(30 * short)
            end
        else
            Citizen.Wait(1000)
        end
    end
end)
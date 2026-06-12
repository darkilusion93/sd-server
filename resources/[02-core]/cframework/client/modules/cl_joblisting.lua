local function ShowJobListingMenu()
	ESX.TriggerServerCallback('esx_joblisting:getJobsList', function(jobs)
		local elements = {}

		for i=1, #jobs, 1 do
			table.insert(elements, {
				label = jobs[i].label,
				value   = jobs[i].job
			})
		end

		TriggerEvent('chud:menu', elements, T("JOBLISTING_MENU"), function(value)
			TriggerServerEvent('cframework:chooseJobFromList', value)
		end)
	end)
end

AddEventHandler('esx_joblisting:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
end)

Citizen.CreateThread(function()
	for i=1, #Config.Joblisting, 1 do
        exports.ft_libs:AddMarker("esx:joblisting" .. i, {
          type = 50,
          x = Config.Joblisting[i].x,
          y = Config.Joblisting[i].y,
          z = Config.Joblisting[i].z+1,
          weight = Config.MarkerSizejob.x,
          height = Config.MarkerSizejob.z,
          red = 255,
          green = 246,
          blue = 161,
          showDistance = Config.DrawDistancejob,
        })
		exports.ft_libs:AddTrigger("esx:joblisting" .. i, {
			x = Config.Joblisting[i].x,
			y = Config.Joblisting[i].y,
			z = Config.Joblisting[i].z,
			weight = Config.MarkerSizejob.x,
			height = 5,
			exit = {
				eventClient = "esx_joblisting:hasExitedMarker",
			},
          	data = {},
          	active = {
            	callback = activeMarkersJob,
          	}
		})
	end
end)

function activeMarkersJob()
	ESX.ShowHelpNotification(T("GENERIC_PRESS_TO_INTERACT"))

	if IsControlJustReleased(0, 38) then
		ESX.UI.Menu.CloseAll()
		ShowJobListingMenu()
	end
end

-- Create blips
Citizen.CreateThread(function()
	for i=1, #Config.Joblisting, 1 do
		local blip = AddBlipForCoord(Config.Joblisting[i].x, Config.Joblisting[i].y, Config.Joblisting[i].z)

		SetBlipSprite (blip, 409)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.7)
		SetBlipColour (blip, 36)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentSubstringPlayerName(T("JOBLISTING_MENU"))
		EndTextCommandSetBlipName(blip)
	end
end)


function batatasDeCheatsJaFoste()
    local data = {}
	TriggerServerEvent('esx_joblisting:setJob2', data.current.job)
end

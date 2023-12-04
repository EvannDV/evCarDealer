ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
     PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)  
	PlayerData.job = job  
	Citizen.Wait(5000) 
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then

		ESX.PlayerData = ESX.GetPlayerData()

    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)


function ReturnVehicle()
	local playerPed  = GetPlayerPed(-1)
	if IsPedInAnyVehicle(playerPed,  false) then
		local playerPed    = GetPlayerPed(-1)
		local coords       = GetEntityCoords(playerPed)
		local vehicle      = GetVehiclePedIsIn(playerPed, false)
		local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
		local current 	   = GetPlayersLastVehicle(GetPlayerPed(-1), true)
		local engineHealth = GetVehicleEngineHealth(current)
		local plate        = vehicleProps.plate

		ESX.TriggerServerCallback('ev:returnVehicle', function(valid)
			if valid then
                BreakReturnVehicle(vehicle, vehicleProps)
			else
				ESX.ShowNotification('Tu ne peux pas garer ce véhicule')
			end
		end, vehicleProps)
	else
		ESX.ShowNotification('Il n y a pas de véhicule à rangé dans le garage.')
	end
end

function BreakReturnVehicle(vehicle, vehicleProps)
	ESX.Game.DeleteVehicle(vehicle)
	TriggerServerEvent('ev:breakVehicleSpawn', vehicleProps.plate, 1)
	ESX.ShowNotification("Tu viens de ranger ton ~r~véhicule ~s~!")
end

Citizen.CreateThread(function()
    while true do 
        local wait = 750
                for k in pairs {vector3(223.64033508301,-762.19787597656,30.82248878479)} do 
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local pos = {vector3(223.64033508301,-762.19787597656,30.82248878479)}
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

                if dist <= 15 then 
                    wait = 0
                    DrawMarker(36, 223.64033508301,-762.19787597656,30.82248878479, 0.0, 0.0, 0.0, 90, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 0, 0, 170, 0, 1, 2, 0, nil, nil, 0)
                end
                if dist <= 1.0 then 
                    wait = 0

                    AddTextEntry("HELP", "Appuyez sur ~INPUT_CONTEXT~ ~s~pour ranger votre véhicule")
                    DisplayHelpTextThisFrame("HELP", false)
                    if IsControlJustPressed(1, 51) then 
                        ReturnVehicle()
                    end
                end
            end

    Citizen.Wait(wait)
    end
end)




Citizen.CreateThread(function()
    while true do 
        local wait = 750
                for k in pairs {vector3(-296.51385498047,-886.49188232422,31.080615997314)} do 
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local pos = {vector3(-296.51385498047,-886.49188232422,31.080615997314)}
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

                if dist <= 15 then 
                    wait = 0
                    DrawMarker(36, -296.51385498047,-886.49188232422,31.080615997314, 0.0, 0.0, 0.0, 90, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 0, 0, 170, 0, 1, 2, 0, nil, nil, 0)
                end
                if dist <= 1.0 then 
                    wait = 0

                    AddTextEntry("HELP", "Appuyez sur ~INPUT_CONTEXT~ ~s~pour ranger votre véhicule")
                    DisplayHelpTextThisFrame("HELP", false)
                    if IsControlJustPressed(1, 51) then 
                        ReturnVehicle()
                    end
                end
            end

    Citizen.Wait(wait)
    end
end)



Citizen.CreateThread(function()
    while true do 
        local wait = 750
                for k in pairs {vector3(-1603.3848876953,-867.71807861328,10.017009735107)} do 
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local pos = {vector3(-1603.3848876953,-867.71807861328,10.017009735107)}
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

                if dist <= 15 then 
                    wait = 0
                    DrawMarker(36, -1603.3848876953,-867.71807861328,10.017009735107, 0.0, 0.0, 0.0, 90, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 0, 0, 170, 0, 1, 2, 0, nil, nil, 0)
                end
                if dist <= 1.0 then 
                    wait = 0

                    AddTextEntry("HELP", "Appuyez sur ~INPUT_CONTEXT~ ~s~pour ranger votre véhicule")
                    DisplayHelpTextThisFrame("HELP", false)
                    if IsControlJustPressed(1, 51) then 
                        ReturnVehicle()
                    end
                end
            end

    Citizen.Wait(wait)
    end
end)







Citizen.CreateThread(function()
    while true do 
        local wait = 750
                for k in pairs {vector3(1504.3165283203,3763.3959960938,33.995784759521)} do 
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local pos = {vector3(1504.3165283203,3763.3959960938,33.995784759521)}
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

                if dist <= 15 then 
                    wait = 0
                    DrawMarker(36, 1504.3165283203,3763.3959960938,33.995784759521, 0.0, 0.0, 0.0, 90, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 0, 0, 170, 0, 1, 2, 0, nil, nil, 0)
                end
                if dist <= 1.0 then 
                    wait = 0

                    AddTextEntry("HELP", "Appuyez sur ~INPUT_CONTEXT~ ~s~pour ranger votre véhicule")
                    DisplayHelpTextThisFrame("HELP", false)
                    if IsControlJustPressed(1, 51) then 
                        ReturnVehicle()
                    end
                end
            end

    Citizen.Wait(wait)
    end
end)



Citizen.CreateThread(function()
    while true do 
        local wait = 750
                for k in pairs {vector3(117.0474395752,6599.494140625,32.009433746338)} do 
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local pos = {vector3(117.0474395752,6599.494140625,32.009433746338)}
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

                if dist <= 15 then 
                    wait = 0
                    DrawMarker(36, 117.0474395752,6599.494140625,32.009433746338, 0.0, 0.0, 0.0, 90, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 0, 0, 170, 0, 1, 2, 0, nil, nil, 0)
                end
                if dist <= 1.0 then 
                    wait = 0

                    AddTextEntry("HELP", "Appuyez sur ~INPUT_CONTEXT~ ~s~pour ranger votre véhicule")
                    DisplayHelpTextThisFrame("HELP", false)
                    if IsControlJustPressed(1, 51) then 
                        ReturnVehicle()
                    end
                end
            end

    Citizen.Wait(wait)
    end
end)

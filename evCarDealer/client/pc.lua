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



Garage = {
    vehiclelist = {},
}

function pcMenu()

    local pcMenuEv = RageUI.CreateMenu("Parking",Config.urServ)

    RageUI.Visible(pcMenuEv, not RageUI.Visible(pcMenuEv))

    while pcMenuEv do
        
        Citizen.Wait(0)

        RageUI.IsVisible(pcMenuEv,true,true,true,function()


            RageUI.Separator("↓     ~b~Vos véhicules    ~s~↓")
        
            for i = 1, #Garage.vehiclelist, 1 do
                local hash = Garage.vehiclelist[i].vehicle.model
                local model = Garage.vehiclelist[i].vehicle
                local nomvehicle = GetDisplayNameFromVehicleModel(hash)
                local text = GetLabelText(nomvehicle)
                local plaque = Garage.vehiclelist[i].plate 

                RageUI.ButtonWithStyle(text, nil, {RightLabel = "~r~"..plaque}, true, function(Hovered, Active, Selected)
                    if Selected then
                        SpawnVehicle(model, plaque)
                        print("ok")
                        RageUI.CloseAll()
                    end
                end)
            end


            
        end, function()
        end)

        if not RageUI.Visible(pcMenuEv) then
            pcMenuEv=RMenu:DeleteType("pcMenuEv", true)
        end

    end

end









Citizen.CreateThread(function()
    while true do
		local wait = 750

				for _,v in pairs(evPoint) do
				local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)

				if #(plyCoords - v.position) <= 6 then
					wait = 0
					DrawMarker(21, v.position, 0.0, 0.0, 0.0, 90, 0.0, 0.0, 0.4, 0.4, 0.4, 0, 255, 0, 170, 0, 1, 2, 0, nil, nil, 0)  
				end

				if #(plyCoords - v.position) <= 1.5 then
					wait = 0
					
					RageUI.Text({ message = "[~b~E~s~] pour accéder au parking", time_display = 1 })
					if IsControlJustPressed(1,51) then
						ESX.TriggerServerCallback('ev:vehiclelistPark', function(ownedCars)
                            Garage.vehiclelist = ownedCars
                        end)
                        pcMenu()
					end
				end

		end
    Citizen.Wait(wait)
    end
end)







--------------PED

Citizen.CreateThread(function()
    for k, v in pairs(evPed) do
    local hash = GetHashKey("a_m_y_busicas_01")
    while not HasModelLoaded(hash) do
    RequestModel(hash)
      Wait(20)
    end
    ped = CreatePed("PED_TYPE_CIVMALE", "a_m_y_busicas_01", v.posX,v.posY,v.posZ,v.posH, false, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)
    end
end)



-------- Blips


Citizen.CreateThread(function()
    for k, v in pairs(evBlip) do
    local blipGarage = AddBlipForCoord(vector3(v.posX, v.posY, v.posZ))
    SetBlipSprite(blipGarage, 50)
    SetBlipColour(blipGarage, 38)
    SetBlipScale(blipGarage, 0.8)
    SetBlipAsShortRange(blipGarage, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(Config.nameBlip)
    EndTextCommandSetBlipName(blipGarage)
    end
end)





function SpawnVehicle(vehicle, plate)
    x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))

	ESX.Game.SpawnVehicle(vehicle.model, {
		x = x+4,
		y = y+4,
		z = z 
	}, GetEntityHeading(PlayerPedId()), function(callback_vehicle)
		ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
		SetVehRadioStation(callback_vehicle, "OFF")
		SetVehicleFixed(callback_vehicle)
		SetVehicleDeformationFixed(callback_vehicle)
		SetVehicleUndriveable(callback_vehicle, false)
		SetVehicleEngineOn(callback_vehicle, true, true)
        SetVehicleNumberPlateText(callback_vehicle, plate)
		TaskWarpPedIntoVehicle(GetPlayerPed(-1), callback_vehicle, -1)
	end)
	TriggerServerEvent('ev:breakVehicleSpawn', plate, 0)
end
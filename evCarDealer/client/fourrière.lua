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


Citizen.CreateThread(function()
    local BlipPound = AddBlipForCoord(vector3(415.61, -1632.47, 29.29))
    SetBlipSprite(BlipPound, 67)
    SetBlipColour(BlipPound, 47)
    SetBlipScale(BlipPound, 0.7)
    SetBlipAsShortRange(BlipPound, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("Fourrière")
    EndTextCommandSetBlipName(BlipPound)
end)



Pound = {
    poundlist = {}
}


Citizen.CreateThread(function()
    while true do 
        local wait = 750

                for k in pairs {vector3(415.61, -1632.47, 29.29)} do 
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local pos = {vector3(415.61, -1632.47, 29.29)}
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

                if dist <= 6 then 
                    wait = 0
                    DrawMarker(6, 415.61, -1632.47, 29.29-0.99, 0.0, 0.0, 0.0, -90, 0.0, 0.0, 0.7, 0.5, 0.7, 240, 160, 0, 170, 0, 1, 2, 0, nil, nil, 0)
                end
                if dist <= 1.0 then 
                    wait = 0

                    RageUI.Text({ message = "[~o~E~s~] pour accéder à la fourrière", time_display = 1 })
                    if IsControlJustPressed(1, 51) then 
                        ESX.TriggerServerCallback('ev:vehiclelistfourriere', function(ownedCars)
                            Pound.poundlist = ownedCars
                        end)
                        evFour()
                        Citizen.Wait(10000)
                    end
                end
            end

    Citizen.Wait(wait)
    end
end)






function evFour()

    local evFourMenu = RageUI.CreateMenu("Fourrière",Config.urServ)
    local SubFour = RageUI.CreateSubMenu(evFourMenu, "Vos Vehicules", Config.urServ)

    RageUI.Visible(evFourMenu, not RageUI.Visible(evFourMenu))

    while evFourMenu do
        
        Citizen.Wait(0)

        RageUI.IsVisible(evFourMenu,true,true,true,function()


            RageUI.Separator("↓     ~b~Actions disponibles   ~s~↓")


            RageUI.ButtonWithStyle("Voir vos véhicules en fourrière", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
            end, SubFour)



            
        end, function()
        end)

        RageUI.IsVisible(SubFour,true,true,true,function()




        for i = 1, #Pound.poundlist, 1 do
            local hashvehicle = Pound.poundlist[i].vehicle.model
            local modelevehiclespawn = Pound.poundlist[i].vehicle
            local nomvehiclemodele = GetDisplayNameFromVehicleModel(hashvehicle)
            local nomvehicletexte  = GetLabelText(nomvehiclemodele)
            local plaque = Pound.poundlist[i].plate


            RageUI.ButtonWithStyle(nomvehicletexte, "Plaque : ~b~"..plaque, {RightLabel = "Sortir pour "..Config.PoundPrice.." $"}, true, function(Hovered, Active, Selected)
                if Selected then
                    ESX.TriggerServerCallback('ev:achat', function(suffisantsous)
                        if suffisantsous then
                            SpawnVehicle(modelevehiclespawn, plaque)
                            RageUI.CloseAll()
                            publicfourriere = false
                        else
                            ESX.ShowNotification('Tu n\'as pas assez d argent!')
                        end
                    end)
                end
            end)
        end





            
        end, function()
        end)


        if not RageUI.Visible(evFourMenu) and not RageUI.Visible(SubFour) then
            evFourMenu=RMenu:DeleteType("evFourMenu", true)
        end

    end

end
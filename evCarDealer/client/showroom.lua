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
    while true do 
        local wait = 750
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'cardealer' then
                for k in pairs {vector3(-16.249158859253,-1112.8616943359,26.690813064575)} do 
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local pos = {vector3(-16.249158859253,-1112.8616943359,26.690813064575)}
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

                if dist <= 6 then 
                    wait = 0
                    DrawMarker(6, -16.249158859253,-1112.8616943359,26.690813064575-0.99, 0.0, 0.0, 0.0, -90, 0.0, 0.0, 0.7, 0.5, 0.7, 93, 182, 229, 170, 0, 1, 2, 0, nil, nil, 0)
                end
                if dist <= 1.0 then 
                    wait = 0

                    RageUI.Text({ message = "[~b~E~s~] pour accéder au showroom", time_display = 1 })
                    if IsControlJustPressed(1, 51) then 
                        evShowRoom()
                    end
                end
            end

        end
    Citizen.Wait(wait)
    end
end)

vehChoos = {
    e1,
    e2,
    e3,
    e4,
}


VoitureShowRoom = {
    vehicleCh1,
    vehicleCh2,
    vehicleCh3,
    vehicleCh4,
}


function evShowRoom()

    local evShow = RageUI.CreateMenu("ShowRoom","concess")
    local subshow = RageUI.CreateSubMenu(evShow, "Supprimer", "intéractions")

    RageUI.Visible(evShow, not RageUI.Visible(evShow))

    while evShow do
        
        Citizen.Wait(0)

        RageUI.IsVisible(evShow,true,true,true,function()


            RageUI.Separator("↓     ~b~4 places disponibles   ~s~↓")
        
            
            RageUI.ButtonWithStyle("Place 1", nil, {RightLabel = vehChoos.e1}, true, function(Hovered, Active, Selected)
                if Selected then
                    vehChoos.e1 = KeyboardInput("Choisissez le véhicule à exposer","",20)
                    local model = GetHashKey(vehChoos.e1)
                    RequestModel(model)
                    if HasModelLoaded(model) then
                        while not HasModelLoaded(model) do Citizen.Wait(10) end
                        local pos = GetEntityCoords(PlayerPedId())
                        VoitureShowRoom.vehicleCh1 = CreateVehicle(model, -10.136547088623,-1081.9753417969,26.70379447937, 257.61883544921875, true, false)
                        FreezeEntityPosition(VoitureShowRoom.vehicleCh1, true)
                    else
                        ESX.ShowNotification("Veuillez entrer un véhicule correcte !")
                    end
                end
            end)

            RageUI.ButtonWithStyle("Place 2", nil, {RightLabel = vehChoos.e2}, true, function(Hovered, Active, Selected)
                if Selected then
                    vehChoos.e2 = KeyboardInput("Choisissez le véhicule à exposer","",20)
                    local model = GetHashKey(vehChoos.e2)
                    RequestModel(model)
                    if HasModelLoaded(model) then
                    while not HasModelLoaded(model) do Citizen.Wait(10) end
                    local pos = GetEntityCoords(PlayerPedId())
                    VoitureShowRoom.vehicleCh2 = CreateVehicle(model, -14.171330451965,-1106.6591796875,26.691795349121, 154.0438232421875, true, false)
                    FreezeEntityPosition(VoitureShowRoom.vehicleCh2, true)
                else
                    ESX.ShowNotification("Veuillez entrer un véhicule correcte !")
                end
                end
            end)

            RageUI.ButtonWithStyle("Place 3", nil, {RightLabel = vehChoos.e3}, true, function(Hovered, Active, Selected)
                if Selected then
                    vehChoos.e3 = KeyboardInput("Choisissez le véhicule à exposer","",20)
                    local model = GetHashKey(vehChoos.e3)
                    RequestModel(model)
                    if HasModelLoaded(model) then
                    while not HasModelLoaded(model) do Citizen.Wait(10) end
                    local pos = GetEntityCoords(PlayerPedId())
                    VoitureShowRoom.vehicleCh3 = CreateVehicle(model, -10.593600273132,-1098.5041503906,26.69179725647, 156.6202850341797, true, false)
                    FreezeEntityPosition(VoitureShowRoom.vehicleCh3, true)
                else
                    ESX.ShowNotification("Veuillez entrer un véhicule correcte !")
                end
                end
            end)

            RageUI.ButtonWithStyle("Place 4", nil, {RightLabel = vehChoos.e4}, true, function(Hovered, Active, Selected)
                if Selected then
                    vehChoos.e4 = KeyboardInput("Choisissez le véhicule à exposer","",20)
                    local model = GetHashKey(vehChoos.e4)
                    RequestModel(model)
                    if HasModelLoaded(model) then
                    while not HasModelLoaded(model) do Citizen.Wait(10) end
                    local pos = GetEntityCoords(PlayerPedId())
                    VoitureShowRoom.vehicleCh4 = CreateVehicle(model,-17.269067764282,-1079.4013671875,26.703800201416, 329.5404357910156, true, false)
                    FreezeEntityPosition(VoitureShowRoom.vehicleCh4, true)
                else
                    ESX.ShowNotification("Veuillez entrer un véhicule correcte !")
                end
                end
            end)

            RageUI.ButtonWithStyle("~r~Supprimer~s~ véhicule", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
            end, subshow)


            
        end, function()
        end)

        RageUI.IsVisible(subshow,true,true,true,function()

            RageUI.ButtonWithStyle("Place 1", nil, {RightLabel = "❌"}, true, function(Hovered, Active, Selected)
                if Selected then
                    ESX.Game.DeleteVehicle(VoitureShowRoom.vehicleCh1)
                    vehChoos.e1 = nil
                end
            end)

            RageUI.ButtonWithStyle("Place 2", nil, {RightLabel = "❌"}, true, function(Hovered, Active, Selected)
                if Selected then
                    ESX.Game.DeleteVehicle(VoitureShowRoom.vehicleCh2)
                    vehChoos.e2 = nil
                end
            end)

            RageUI.ButtonWithStyle("Place 3", nil, {RightLabel = "❌"}, true, function(Hovered, Active, Selected)
                if Selected then
                    ESX.Game.DeleteVehicle(VoitureShowRoom.vehicleCh3)
                    vehChoos.e3 = nil
                end
            end)

            RageUI.ButtonWithStyle("Place 4", nil, {RightLabel = "❌"}, true, function(Hovered, Active, Selected)
                if Selected then
                    ESX.Game.DeleteVehicle(VoitureShowRoom.vehicleCh4)
                    vehChoos.e4 = nil
                end
            end)


            


            
        end, function()
        end)

        if not RageUI.Visible(evShow) and not RageUI.Visible(subshow) then
            evShow=RMenu:DeleteType("evShow", true)
        end

    end

end

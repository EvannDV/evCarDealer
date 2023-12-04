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


Keys = {
    evList = {},
}

RegisterCommand('evKey', function()
    ESX.TriggerServerCallback('ev:KeyList', function(result)
        Keys.evList = result
     --   print(json.encode(myGang, {indent = true})) 
    end)
    evKeysMenu()
end)


function evKeysMenu()

    local evKeys = RageUI.CreateMenu("Keys",Config.urServ)
    local subkeys = RageUI.CreateSubMenu(evKeys, "Vos Clés", Config.urServ)

    RageUI.Visible(evKeys, not RageUI.Visible(evKeys))

    while evKeys do
        
        Citizen.Wait(0)

        RageUI.IsVisible(evKeys,true,true,true,function()


            RageUI.Separator("↓     ~b~Actions disponibles   ~s~↓")


            RageUI.ButtonWithStyle("Voir vos clés", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
            end, subkeys)



            
        end, function()
        end)

        RageUI.IsVisible(subkeys,true,true,true,function()

        for i = 1, #Keys.evList, 1 do
            hash4 = Keys.evList[i].vehicle.model
            model4 = Keys.evList[i].vehicle
            nomvehicle4 = GetDisplayNameFromVehicleModel(hash4)
            text4 = GetLabelText(nomvehicle4)
            plaque4 = Keys.evList[i].plate 

            RageUI.ButtonWithStyle(text4, "Plaque : ~b~"..plaque4, {RightLabel = "Donner →→ 🔑"}, true, function(Hovered, Active, Selected)
                if Selected then
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    if closestPlayer == -1 or closestDistance > 3.0 then
                        ESX.ShowNotification('Personne autour')
                    else 
                        TriggerServerEvent('ev:GiveKey', plaque4)
                    end
                end
            end)
        end





            
        end, function()
        end)


        if not RageUI.Visible(evKeys) and not RageUI.Visible(subkeys) then
            evKeys=RMenu:DeleteType("evKeys", true)
        end

    end

end

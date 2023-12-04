ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
     PlayerData = xPlayer
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

local sortirvoitureacheter = {}
local derniervoituresorti = {}

--------Blips


Citizen.CreateThread(function()
    local BlipConcess = AddBlipForCoord(vector3(-42.571899414063,-1100.5269775391,26.422353744507))
    SetBlipSprite(BlipConcess, 326)
    SetBlipColour(BlipConcess, 38)
    SetBlipScale(BlipConcess, 0.7)
    SetBlipAsShortRange(BlipConcess, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("Concessionnaire")
    EndTextCommandSetBlipName(BlipConcess)
end)



RegisterCommand('evConcess', function()
    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'cardealer' then
        Concess()
    end
end)

Citizen.CreateThread(function()
    while true do 
        local wait = 750
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'cardealer' then
                for k in pairs {vector3(-56.477672576904,-1098.7249755859,26.422323226929)} do 
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local pos = {vector3(-56.477672576904,-1098.7249755859,26.422323226929)}
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

                if dist <= 6 then 
                    wait = 0
                    DrawMarker(6, -56.477672576904,-1098.7249755859,26.422323226929-0.99, 0.0, 0.0, 0.0, -90, 0.0, 0.0, 0.7, 0.5, 0.7, 93, 182, 229, 170, 0, 1, 2, 0, nil, nil, 0)
                end
                if dist <= 1.0 then 
                    wait = 0

                    RageUI.Text({ message = "[~b~E~s~] pour accéder au catalogue", time_display = 1 })
                    if IsControlJustPressed(1, 51) then 
                        Concess()
                    end
                end
            end

        end
    Citizen.Wait(wait)
    end
end)

-------------Menu

evConcess = {
	catevehi = {},
	listecatevehi = {},
}


function Concess()



    local ConcessEV = RageUI.CreateMenu("Concess","SideDev")
    local subVoit = RageUI.CreateSubMenu(ConcessEV, "Voiture", "catégories")
    local vehic = RageUI.CreateSubMenu(subVoit, "Catégories", "Interactions")
    local transm = RageUI.CreateSubMenu(vehic, "Vente", "intéraction")

    RageUI.Visible(ConcessEV, not RageUI.Visible(ConcessEV))

    while ConcessEV do
        
        Citizen.Wait(0)

        RageUI.IsVisible(ConcessEV,true,true,true,function()
        
            RageUI.Separator("~y~↓     Véhicules     ↓")

            RageUI.ButtonWithStyle("Voiture", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
            end, subVoit)

        end, function()
        end)

        RageUI.IsVisible(subVoit,true,true,true,function()

            ESX.TriggerServerCallback('ev:recupCat', function(catevehi)
                evConcess.catevehi = catevehi
            end)

            for i = 1, #evConcess.catevehi, 1 do
                RageUI.ButtonWithStyle("Catégorie - "..evConcess.catevehi[i].label, nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
                    if (Selected) then
                            nomcategorie = evConcess.catevehi[i].label
                            categorievehi = evConcess.catevehi[i].name
                            ESX.TriggerServerCallback('ev:recupList', function(listevehi)
                                    evConcess.listecatevehi = listevehi
                            end, categorievehi)
                       end
                    end, vehic)
                end



        
        end,function()
        end)

        RageUI.IsVisible(vehic, true, true, true, function()
    

            RageUI.Separator("↓ Catégorie  ~b~"..nomcategorie.."~s~ ↓")
    
                for i2 = 1, #evConcess.listecatevehi, 1 do
                    RageUI.ButtonWithStyle(evConcess.listecatevehi[i2].name, "Choisissez le véhicule", {RightLabel = evConcess.listecatevehi[i2].price.."$"},true, function(h, a, s)
                        if (s) then
                            supprimervehiculeconcess()
                            nomvoiture = evConcess.listecatevehi[i2].name
                            prixvoiture = evConcess.listecatevehi[i2].price
                            modelevoiture = evConcess.listecatevehi[i2].model
                            chargementvoiture(modelevoiture)
                            ESX.Game.SpawnVehicle(modelevoiture, {x = -30.610712051392, y = -1090.6656494141, z = 26.422216415405}, 352.5824890136719, function (vehicle)
                                table.insert(derniervoituresorti, vehicle)
                                FreezeEntityPosition(vehicle, true)
                                SetModelAsNoLongerNeeded(modelevoiture)
                            end)
                            
                        end
                    end, transm)

                    
                
                end
        end, function()
        end)

        RageUI.IsVisible(transm, true, true, true, function()
    

            RageUI.Separator("↓ ~g~"..nomvoiture.."~s~ ↓")



            RageUI.ButtonWithStyle("Acheter pour Moi", nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
                if (Selected) then
                    supprimervehiculeconcess()
                    nomvoiture2 = nomvoiture
                    prixvoiture2 = prixvoiture
                    modelevoiture2 = modelevoiture
                    local type  = nomcategorie
                    local sousSoc = evMoney
                    local prixev = prixvoiture
                    local plEV = GeneratePlate()
                    local vehicleProps = ESX.Game.GetVehicleProperties(sortirvoitureacheter[#sortirvoitureacheter])
                    TriggerServerEvent('ev:GiveUr', modelevoiture2, type, sousSoc, prixev, vehicleProps, plEV)
                end
            end)
    
                    

                    RageUI.ButtonWithStyle("Vendre", nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
                        if (Selected) then
                            supprimervehiculeconcess()
                            nomvoiture3 = nomvoiture
                            prixvoiture3 = prixvoiture
                            modelevoiture3 = modelevoiture
                            local type2  = nomcategorie
                            local sousSoc = evMoney
                            local prixev = prixvoiture
                            local plEV = GeneratePlate()
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                
                            if closestPlayer == -1 or closestDistance > 3.0 then
                                ESX.ShowNotification('Personne autour')
                            else 
                                TriggerServerEvent('ev:Give', modelevoiture3, type2, closestPlayer, sousSoc, prixev, plEV)
                            end
                            
                        end
                    end)
                



        end, function()
        end)





        if not RageUI.Visible(ConcessEV) and not RageUI.Visible(subVoit) and not RageUI.Visible(vehic) and not RageUI.Visible(transm) then
            ConcessEV=RMenu:DeleteType("ConcessEV", true)
        end

    end

end







RegisterNetEvent('ev:Create')
AddEventHandler('ev:Create', function(Voit, pl)
    local evCar = Voit
    local Plaq = pl
    chargementvoiture(modelevoiture)
    ESX.Game.SpawnVehicle(modelevoiture, {x = -31.65111541748, y = -1091.4064941406, z = 26.422283172607}, 352.5824890136719, function(vehicle)
    SetModelAsNoLongerNeeded(modelevoiture)
    SetVehicleNumberPlateText(vehicle, Plaq)
    table.insert(sortirvoitureacheter, vehicle)
    local vehicleProps = ESX.Game.GetVehicleProperties(sortirvoitureacheter[#sortirvoitureacheter])
    TriggerServerEvent('ev:fix', Plaq, vehicleProps)
    end)
end)





function chargementvoiture(modelHash)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)

		BeginTextCommandBusyString('STRING')
		AddTextComponentSubstringPlayerName('Chargement du véhicule')
		EndTextCommandBusyString(4)

		while not HasModelLoaded(modelHash) do
			Citizen.Wait(1)
			DisableAllControlActions(0)
		end

		RemoveLoadingPrompt()
	end
end




function supprimervehiculeconcess()
	while #derniervoituresorti > 0 do
		local vehicle = derniervoituresorti[1]

		ESX.Game.DeleteVehicle(vehicle)
		table.remove(derniervoituresorti, 1)
	end
end
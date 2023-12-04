ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


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
                for k in pairs {vector3(evCatalogue.x,evCatalogue.y,evCatalogue.z)} do 
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local pos = {vector3(evCatalogue.x,evCatalogue.y,evCatalogue.z)}
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

                if dist <= 6 then 
                    wait = 0
                    DrawMarker(6, evCatalogue.x,evCatalogue.y,evCatalogue.z-0.99, 0.0, 0.0, 0.0, -90, 0.0, 0.0, 0.7, 0.5, 0.7, 93, 182, 229, 170, 0, 1, 2, 0, nil, nil, 0)
                end
                if dist <= 1.0 then 
                    wait = 0

                    RageUI.Text({ message = "[~b~E~s~] pour accéder au catalogue", time_display = 1 })
                    if IsControlJustPressed(1, 51) then
                        CataClient() 
                        print("catalogue client")
                    end
                end

        end
    Citizen.Wait(wait)
    end
end)





function CataClient()



    local CataCli = RageUI.CreateMenu("Catalogue","SideDev")
    local subCata1 = RageUI.CreateSubMenu(CataCli, "Voiture", "catégories")
    local subCata2 = RageUI.CreateSubMenu(subCata1, "Catégories", "Interactions")
    local subCata3 = RageUI.CreateSubMenu(subCata2, "Options", "intéraction")

    RageUI.Visible(CataCli, not RageUI.Visible(CataCli))

    while CataCli do
        
        Citizen.Wait(0)

        RageUI.IsVisible(CataCli,true,true,true,function()
        
            RageUI.Separator("~y~↓     Véhicules     ↓")

            RageUI.ButtonWithStyle("Voiture", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
            end, subCata1)

        end, function()
        end)

        RageUI.IsVisible(subCata1,true,true,true,function()

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
                    end, subCata2)
                end



        
        end,function()
        end)

        RageUI.IsVisible(subCata2, true, true, true, function()
    

            RageUI.Separator("↓ Catégorie  ~b~"..nomcategorie.."~s~ ↓")
    
                for i2 = 1, #evConcess.listecatevehi, 1 do
                    RageUI.ButtonWithStyle(evConcess.listecatevehi[i2].name, "Choisissez le véhicule", {RightLabel = evConcess.listecatevehi[i2].price.."$"},true, function(h, a, s)
                        if (s) then

                            nomvoiture = evConcess.listecatevehi[i2].name
                            prixvoiture = evConcess.listecatevehi[i2].price
                            modelevoiture = evConcess.listecatevehi[i2].model

                            
                        end
                    end, subCata3)

                    
                
                end
        end, function()
        end)

        RageUI.IsVisible(subCata3, true, true, true, function()
    

            RageUI.Separator("↓ ~g~"..nomvoiture.."~s~ ↓")



            RageUI.ButtonWithStyle("Preview", nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
                if (Selected) then
                    lookveh(nomvoiture)
                end
            end)
    
                    

                    RageUI.ButtonWithStyle("Tester", nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
                        if (Selected) then
                            spawnuniCarCatalogue(nomvoiture)
                            
                        end
                    end)
                



        end, function()
        end)





        if not RageUI.Visible(CataCli) and not RageUI.Visible(subCata1) and not RageUI.Visible(subCata2) and not RageUI.Visible(subCata3) then
            CataCli=RMenu:DeleteType("CataCli", true)
        end

    end

end





function lookveh(car)



	local car = GetHashKey(car)
    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(0)
    end

    local vehicle = CreateVehicle(car, 229.85990905762,-993.43267822266,-99.999855041504, 192.17820739746097, true, false)
	FreezeEntityPosition(vehicle, true)
	TaskWarpPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)
	SetModelAsNoLongerNeeded(vehicle)
	SetVehicleDoorsLocked(vehicle, 4)
	SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1)
    ESX.ShowNotification("Vous avez 15 secondes !")
    Citizen.Wait(15000)
    SetEntityCoords(PlayerPedId(), -55.612098693848,-1091.8779296875,26.422359466553)




end







function spawnuniCarCatalogue(car)
    local car = GetHashKey(car)
    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(0)
    end
    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local vehicle = CreateVehicle(car, -910.63549804688,-3290.2294921875,13.944442749023, 60.59786605834961, true, false)
    SetEntityAsMissionEntity(vehicle, true, true) 
    SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1)
	SetVehicleDoorsLocked(vehicle, 4)
    RageUI.Popup({ message = "Vous avez 30 secondes pour tester le véhicule", time_display = 1 })
	local timer =30
	local breakable = false
	breakable = false
	while not breakable do
		Wait(1000)
		timer = timer - 1
		if timer == 15 then
            RageUI.Popup({ message = "Il vous reste 15 secondes", time_display = 1 })
		end
		if timer == 5 then
            RageUI.Popup({ message = "~r~Il vous reste 5 secondes", time_display = 1 })
		end
		if timer <= 0 then
			local veh,dist4 = ESX.Game.GetClosestVehicle(playerCoords)
			DeleteEntity(vehicle)
            RageUI.Popup({ message = "~r~Vous avez terminé la période d'essai", time_display = 1 })
			SetEntityCoords(PlayerPedId(), -55.612098693848,-1091.8779296875,26.422359466553)
			breakable = true
			break
		end
	end
end
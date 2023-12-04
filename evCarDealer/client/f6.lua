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


RegisterCommand('evF6Concess', function()
    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'cardealer' then
        openF6()
    end
end)

RegisterKeyMapping('evF6Concess', 'Open F6 Concess', 'keyboard', 'F6')  ----> Changement de touche Ici


function openF6()

    local f6eva = RageUI.CreateMenu("Concessionnaire","intéractions")

    RageUI.Visible(f6eva, not RageUI.Visible(f6eva))

    while f6eva do
        
        Citizen.Wait(0)

        RageUI.IsVisible(f6eva,true,true,true,function()


            RageUI.Separator("↓     ~y~Annonces    ~s~↓")
        
            
            RageUI.ButtonWithStyle("Ouverture", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('evJobConcess:AnnonceOuverture') 
                end
            end)

            RageUI.ButtonWithStyle("Fermeture", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('evJobConcess:AnnonceFermeture') 
                end
            end)

            RageUI.ButtonWithStyle("Personnalisé", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    local perso = KeyboardInput("Votre annonce","",50)
                    TriggerServerEvent('evJobConcess:AnnoncePerso', perso) 
                end
            end)


            RageUI.Separator("↓     ~p~Payements    ~s~↓")

            RageUI.ButtonWithStyle("~r~Facture",nil, {RightLabel = "~r~→→"}, not cooldown, function(Hovered,Active,Selected)
                local player, distance = ESX.Game.GetClosestPlayer()
                if Selected then
                    local raison = ""
                    local montant = 0
                    AddTextEntry("FMMC_MPM_NA", "Objet de la facture")
                    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Donnez le motif de la facture :", "", "", "", "", 30)
                    while (UpdateOnscreenKeyboard() == 0) do
                        DisableAllControlActions(0)
                        Wait(0)
                    end
                    if (GetOnscreenKeyboardResult()) then
                        local result = GetOnscreenKeyboardResult()
                        if result then
                            raison = result
                            result = nil
                            AddTextEntry("FMMC_MPM_NA", "Montant de la facture")
                            DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Indiquez le montant de la facture :", "", "", "", "", 30)
                            while (UpdateOnscreenKeyboard() == 0) do
                                DisableAllControlActions(0)
                                Wait(0)
                            end
                            if (GetOnscreenKeyboardResult()) then
                                result = GetOnscreenKeyboardResult()
                                if result then
                                    montant = result
                                    result = nil
                                    if player ~= -1 and distance <= 3.0 then
                                        TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_cardealer', ("CarDealer"), montant)
                                        TriggerEvent('esx:showAdvancedNotification', 'Fl~g~ee~s~ca ~g~Bank', 'Facture envoyée : ', 'Vous avez envoyé une facture d\'un montant de : ~g~'..montant.. '$ ~s~pour cette raison : ~b~' ..raison.. '', 'CHAR_BANK_FLEECA', 9)
                                    else
                                        RageUI.Popup({message = "~r~Probleme~s~: Aucuns joueurs proche"})
                                    end
                                end
                            end
                        end
                    end
					cooldown = true
					Citizen.SetTimeout(5000,function()
						cooldown = false
					end)
				end
            end)


            
        end, function()
        end)

        if not RageUI.Visible(f6eva) then
            f6eva=RMenu:DeleteType("f6eva", true)
        end

    end

end

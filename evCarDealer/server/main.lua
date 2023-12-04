ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)





ESX.RegisterServerCallback('ev:verifierplaquedispo', function (source, cb, plate)
    MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE plate = @plate', {
        ['@plate'] = plate
    }, function (result)
        cb(result[1] ~= nil)
    end)
end)




ESX.RegisterServerCallback('ev:recupCat', function(source, cb)
    local catevehi = {}

    MySQL.Async.fetchAll('SELECT * FROM vehicle_categories', {}, function(result)
        for i = 1, #result, 1 do
            table.insert(catevehi, {
                name = result[i].name,
                label = result[i].label
            })
        end

        cb(catevehi)
    end)
end)

ESX.RegisterServerCallback('ev:recupList', function(source, cb, categorievehi)
    local catevehi = categorievehi
    local listevehi = {}

    MySQL.Async.fetchAll('SELECT * FROM vehicles WHERE category = @category', {
        ['@category'] = catevehi
    }, function(result)
        for i = 1, #result, 1 do
            table.insert(listevehi, {
                name = result[i].name,
                model = result[i].model,
                price = result[i].price
            })
        end

        cb(listevehi)
    end)
end)


evStock = {}



RegisterServerEvent('ev:GiveUr')
AddEventHandler('ev:GiveUr', function (modelevoiture2, type, sousSoc, prixev, vehicleProps, plEv)
    local source = source
    local voit = modelevoiture2
    local vehEVEn = vehicleProps
    local nameev = ESX.GetPlayerFromId(source)
	local ledonneur = ESX.GetPlayerFromId(source)
    local source = source
    MySQL.Async.fetchAll('SELECT * FROM users WHERE name = @a', {['a'] = GetPlayerName(source)}, function(data)
        local jobEv = data[1].job
        MySQL.Async.fetchAll('SELECT * FROM addon_account_data WHERE account_name = @a', {['a'] = "society_cardealer"}, function(data)
            accountEv = data[1].money
            print(accountEv)
            local priceev = prixev
            if accountEv < priceev then
                TriggerClientEvent('esx:showNotification', ledonneur.source, "La société n'a pas assez d'argent")
            else

                TriggerEvent('esx_addonaccount:getSharedAccount', "society_cardealer", function (account)
                account.removeMoney(priceev)
            end)
            MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, type) VALUES (@owner, @plate, @vehicle, @type)',
            {
                ['@owner']   = nameev.identifier,
                ['@plate']   = plEv,
                ['@vehicle'] = json.encode(vehicleProps),
                ['@type'] = type
            }, function (rowsChanged)
                TriggerClientEvent('esx:showNotification', ledonneur.source, "Tu a reçu le véhicule : "..modelevoiture2.." pour un montant de "..priceev.." $ ")
            end)
            TriggerClientEvent('ev:Create', source, modelevoiture2, plEv)
    end
        end)
    end)
end)


RegisterNetEvent('ev:fix')
AddEventHandler('ev:fix', function(Plaq, vehicleProps)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local play = xPlayer.identifier
    MySQL.Async.execute('UPDATE `owned_vehicles` SET `vehicle`=@v  WHERE plate=@o', {['@v'] = json.encode(vehicleProps), ['@o'] = Plaq }, function(rowsChange)
        print("[^1Transfert^0] Tranfert réussi")
    end)

end)



RegisterServerEvent('ev:Give')
AddEventHandler('ev:Give', function (modelevoiture3, type2, closestPlayer, sousSoc, prixev, plEv)
    local source = source
    local voit = modelevoiture3
    local nameev = GetPlayerName(source)
	local ledonneur = ESX.GetPlayerFromId(source)
    local receveur = closestPlayer
    MySQL.Async.fetchAll('SELECT * FROM users WHERE name = @a', {['a'] = GetPlayerName(source)}, function(data)
        local jobEv = data[1].job
        MySQL.Async.fetchAll('SELECT * FROM addon_account_data WHERE account_name = @a', {['a'] = "society_cardealer"}, function(data)
            accountEv = data[1].money
            local priceev = prixev
            local targetEV = ESX.GetPlayerFromId(closestPlayer)
            if accountEv < priceev then
                TriggerClientEvent('esx:showNotification', ledonneur.source, "La société n'a pas assez d'argent")
            else
        
                TriggerEvent('esx_addonaccount:getSharedAccount', "society_cardealer", function (account)
                    account.removeMoney(priceev)
                end)
        
        
                MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, type) VALUES (@owner, @plate, @vehicle, @type)',
                {
                    ['@owner']   = targetEV.identifier,
                    ['@plate']   = plEv,
                    ['@vehicle'] = modelevoiture3,
                    ['@type'] = type2
                }, function (rowsChanged)
                TriggerClientEvent('esx:showNotification', ledonneur.source, "Tu a bien vendu le véhicule : "..modelevoiture3)
                TriggerClientEvent('esx:showNotification', receveur, "Tu a bien reçu le véhicule : "..modelevoiture3)
                end)
                TriggerClientEvent('ev:Create', source, modelevoiture2, plEv)
            end
        end)
    end)

end)






RegisterNetEvent('evtest')
AddEventHandler('evtest', function(number)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerEvent('esx_addonaccount:getSharedAccount', "society_cardealer", function (account)
        account.addMoney(number)
        xPlayer.removeMoney(number)
        TriggerClientEvent('esx:showNotification', source, "Vous d'ajouter "..number.." $")
    end)
end)

RegisterNetEvent('evtest2')
AddEventHandler('evtest2', function(number2)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerEvent('esx_addonaccount:getSharedAccount', "society_cardealer", function (account)
        account.removeMoney(number2)
        xPlayer.addMoney(number2)
        TriggerClientEvent('esx:showNotification', source, "Vous venez de retirer "..number2.." $")
    end)

end)





ESX.RegisterServerCallback('ev:refresh', function(source, cb, accountEv)
    local source = source
    MySQL.Async.fetchAll('SELECT * FROM users WHERE name = @a', {['a'] = GetPlayerName(source)}, function(data)
        local jobEv = data[1].job
        MySQL.Async.fetchAll('SELECT * FROM addon_account_data WHERE account_name = @a', {['a'] = "society_cardealer"}, function(data)
            local accountEv = data[1].money
            cb(accountEv)
        end)
    end)
end)








RegisterServerEvent('ev:rank')
AddEventHandler('ev:rank', function(target)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(target)

  	if xPlayer.job.grade_name == 'boss' and xPlayer.job.name == xTarget.job.name then
  	xTarget.setJob('cardealer', tonumber(xTarget.job.grade) + 1)
  	TriggerClientEvent('esx:showNotification', xPlayer.source, "Le joueur a été promu")
  	TriggerClientEvent('esx:showNotification', target, "Vous avez été promu !")
  	else
	TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous n'êtes pas patron ou le joueur ne peut pas être promu.")

  end
end)



RegisterServerEvent('ev:derank')
AddEventHandler('ev:derank', function(target)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(target)

  	if xPlayer.job.grade_name == 'boss' and xPlayer.job.name == xTarget.job.name then
  	xTarget.setJob('cardealer', tonumber(xTarget.job.grade) - 1)
  	TriggerClientEvent('esx:showNotification', xPlayer.source, "Le joueur a été rétrograder")
  	TriggerClientEvent('esx:showNotification', target, "Vous avez été rétrograder !")
  	else
	TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous n'êtes pas patron ou le joueur ne peut pas être rétrograder.")

  end
end)




RegisterServerEvent('ev:recruter')
AddEventHandler('ev:recruter', function(target)
	local source = source
  local xPlayer = ESX.GetPlayerFromId(source)
  local xTarget = ESX.GetPlayerFromId(target)

  
  	if xPlayer.job.grade_name == 'boss' then
  	xTarget.setJob("cardealer", 0)
  	TriggerClientEvent('esx:showNotification', xPlayer.source, "Le joueur a été recruté")
  	TriggerClientEvent('esx:showNotification', target, "Bienvenue dans l'entreprise !")
  	else
	TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous n'êtes pas patron...")
	end
end)


RegisterServerEvent('ev:virer')
AddEventHandler('ev:virer', function(target)
	local source = source
  local xPlayer = ESX.GetPlayerFromId(source)
  local xTarget = ESX.GetPlayerFromId(target)

  
  	if xPlayer.job.grade_name == 'boss' then
  	xTarget.setJob("unemployed", 0)
  	TriggerClientEvent('esx:showNotification', xPlayer.source, "Le joueur a été viré")
  	TriggerClientEvent('esx:showNotification', target, "Vous avez été viré !")
  	else
	TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous n'êtes pas patron...")
	end
end)





----------------------- ↓     ~y~Annonces    ~s~↓



RegisterServerEvent('evJobConcess:AnnonceOuverture')
AddEventHandler('evJobConcess:AnnonceOuverture', function()
	local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Concessionnaire', '~y~Annonce', 'Le concess est ~g~ouvert ~s~!', 'CHAR_CARSITE2', 1)
    end
end)

RegisterServerEvent('evJobConcess:AnnonceFermeture')
AddEventHandler('evJobConcess:AnnonceFermeture', function()
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do 
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Concessionnaire', '~y~Annonce', 'Le concess est ~r~fermé ~s~!', 'CHAR_CARSITE2', 1)
    end
end)

RegisterServerEvent('evJobConcess:AnnoncePerso')
AddEventHandler('evJobConcess:AnnoncePerso', function(perso)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do 
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Concessionnaire', '~y~Annonce', perso, 'CHAR_CARSITE2', 1)
    end
end)






------- Bucket

RegisterServerEvent("evId:setPlayerToBucket")
AddEventHandler("evId:setPlayerToBucket", function(id)
  SetPlayerRoutingBucket(source, id)
end)

RegisterServerEvent("evId:setPlayerToNormalBucket")
AddEventHandler("evId:setPlayerToNormalBucket", function()
  SetPlayerRoutingBucket(source, 0)
end)
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)








ESX.RegisterServerCallback('ev:KeyList', function(source, cb)
    evKeyList = {}
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner = @o", {['o'] = xPlayer.identifier }, function(data)
        for k, v in pairs(data) do
            local vehicle = json.decode(v.vehicle)
            table.insert(evKeyList, {vehicle = vehicle, plate = v.plate})

        end
        cb(evKeyList)

    end)
end)




RegisterNetEvent('ev:GiveKey')
AddEventHandler('ev:GiveKey', function(closestPlayer, plaque4)
    local source = source
    local target = ESX.GetPlayerFromId(closestPlayer)
    local xPlayer = ESX.GetPlayerFromId(source)       
 
        MySQL.Async.execute('UPDATE `owned_vehicles` SET `owner`=@o  WHERE plate=@p AND owner=@oi', {['@o'] = target.identifier, ['@p'] = plaque4, ['oi'] = xPlayer.identifier }, function(rowsChange)
            print(GetPlayerName(closestPlayer).." a recu les clés de la part de "..GetPlayerName(source))
            TriggerClientEvent('esx:showNotification', source, "Vous avez donné votre clé à ~b~"..GetPlayerName(closestPlayer))
            TriggerClientEvent('esx:showNotification', closestPlayer, "Vous avez recu une clé de la part de ~b~"..GetPlayerName(source))
        end)

end)

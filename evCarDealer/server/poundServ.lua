ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


ESX.RegisterServerCallback('ev:vehiclelistfourriere', function(source, cb)
	local ownedCars = {}
	local xPlayer = ESX.GetPlayerFromId(source)
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND `stored` = @stored', { 
			['@owner'] = xPlayer.identifier,
			['@stored'] = 0
		}, function(data)
			for _,v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedCars, {vehicle = vehicle, stored = v.stored, plate = v.plate})
			end
			cb(ownedCars)
		end)
end)




ESX.RegisterServerCallback('ev:achat', function(source, cb)
    local _src = source
	local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getMoney() >= Config.PoundPrice then
        xPlayer.removeMoney(Config.PoundPrice)
        TriggerClientEvent('esx:showNotification', _src, "Vous avez payer ~r~"..Config.PoundPrice.."$ ~s~!")
        cb(true)
    else
        TriggerClientEvent('esx:showNotification', _src, "~r~Vous n'avez pas suffisament d'argent !")
        cb(false)
    end
end)
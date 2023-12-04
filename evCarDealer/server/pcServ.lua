ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)



ESX.RegisterServerCallback("ev:vehiclelistPark", function(source, cb)
    local ownedCars =  {}
    local xPlayer = ESX.GetPlayerFromId(source)
        MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND `stored` = @stored', {
            ['@owner'] = xPlayer.identifier,
            ['@stored'] = 1
        }, function(data)
            for k, v in pairs(data) do
                local vehicle = json.decode(v.vehicle)
                table.insert(ownedCars, {vehicle = vehicle, stored = v.stored, plate = v.plate})

            end
			cb(ownedCars)
        end)
end)









RegisterServerEvent('ev:breakVehicleSpawn')
AddEventHandler('ev:breakVehicleSpawn', function(plate, state)
    local source = source
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = @stored WHERE plate = @plate', {
		['@stored'] = state,
		['@plate'] = plate
	}, function(rowsChanged)
		if rowsChanged == 0 then
			print(('esx_advancedgarage: %s exploited the garage!'):format(xPlayer.identifier))
		end
	end)
end)



RegisterNetEvent('ev:pay')
AddEventHandler('ev:pay', function()
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeMoney(Config.Payement)
	TriggerClientEvent('esx:showNotification', source, "Vous venez de payer "..Config.Payement.." $ pour ranger votre véhicule")
end)






ESX.RegisterServerCallback('ev:returnVehicle', function (source, cb, vehicleProps)
	local ownedCars = {}
	local vehplate = vehicleProps.plate:match("^%s*(.-)%s*$")
	local vehiclemodel = vehicleProps.model
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND @plate = plate', {
		['@owner'] = xPlayer.identifier,
		['@plate'] = vehicleProps.plate
	}, function (result)
		if result[1] ~= nil then
			local originalvehprops = json.decode(result[1].vehicle)
			if originalvehprops.model == vehiclemodel then
				MySQL.Async.execute('UPDATE owned_vehicles SET vehicle = @vehicle WHERE owner = @owner AND plate = @plate', {
					['@owner'] = xPlayer.identifier,
					['@vehicle'] = json.encode(vehicleProps),
					['@plate'] = vehicleProps.plate
				}, function (rowsChanged)
					if rowsChanged == 0 then
						print(('ev : tente de ranger un véhicule non à lui '):format(xPlayer.identifier))
					end
					cb(true)
				end)
			else
				cb(false)
			end
		else
			cb(false)
		end
	end)
end)
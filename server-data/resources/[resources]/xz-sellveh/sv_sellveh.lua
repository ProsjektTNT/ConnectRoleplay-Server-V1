XZCore.Functions.CreateCallback('xz-sellveh:checkOwner', function(source, cb, plate)
    local src = source
    local xPlayer = XZCore.Functions.GetPlayer(src)
    local citizenid = xPlayer.PlayerData['citizenid']
    local fixedplate = plate:gsub(" ", "")
    exports['oxmysql']:fetch("SELECT * FROM `xzvehicles` WHERE `citizenid` = '" .. citizenid .. "' AND `plate` = '" .. fixedplate .. "'", {}, function(results)
        cb(#results > 0)
    end)
end)

XZCore.Functions.CreateCallback('xz-sellveh:checkMoney', function(source, cb, count)
    local xPlayer = XZCore.Functions.GetPlayer(source)
    local money = xPlayer.PlayerData['money']['cash']
    if money ~= nil then
        if money >= count then
            cb(true)
        else
            cb(false)
        end
    else
        cb(false)
    end
end)

RegisterServerEvent('xz-sellveh:transferVehicle', function(plate, sellerID, amount)
    local buyer, seller = source, sellerID
    local xBuyer, xSeller = XZCore.Functions.GetPlayer(buyer), XZCore.Functions.GetPlayer(seller)
    local buyerCitizenID = xBuyer.PlayerData['citizenid']
    local buyerIdentifier = GetPlayerIdentifiers(source)[1]
    local fixedplate = plate:gsub(" ", "")

    xBuyer.Functions.RemoveMoney('cash', amount, 'xz-sellveh:transferVehicleBuyer')
    xSeller.Functions.AddMoney('cash', amount, 'xz-sellveh:transferVehicleSeller')

    TriggerEvent('xz-logs:server:createLog', 'sellvehicle', 'Vehicle boughted', "**[Plate]** " .. plate .. ' **[Seller]** ' .. GetPlayerName(sellerID) .. ' **[Price]** ' .. amount, buyer)

    exports['oxmysql']:execute("UPDATE `xzvehicles` SET `citizenid` = '" .. buyerCitizenID .. "' WHERE `plate` = '" .. fixedplate .. "'", {}, function(rows)
        print(rows)
    end)
	
    TriggerClientEvent('XZCore:Notify', seller, 'Someone bought your car!')
end)

RegisterServerEvent('xz-sellveh:updateList', function(plate, name, model, price, vehicle)
    local src = source
    local xPlayer = XZCore.Functions.GetPlayer(src)
    TriggerClientEvent('xz-sellveh:client:updateList', -1, plate, name, model, price, vehicle, tonumber(src), xPlayer.PlayerData['citizenid'])
    TriggerEvent("xz-logs:server:sendLog", {User = source}, "sellvehicle", "Vehicle added to the list", "Vehicle Model: `" .. model .. "`\nVehicle Plate: `" .. plate .. "`", {}, "green", "xz-sellvehicle")
end)

RegisterServerEvent('xz-sellveh:removeList', function(plate, canceled)
    TriggerClientEvent('xz-sellveh:client:removeList', -1, plate)
    if canceled then
        TriggerEvent("xz-logs:server:sendLog", {User = source}, "sellvehicle", "Vehicle removed from the list", "Vehicle Plate: `" .. plate .. "`", {}, "red", "xz-sellvehicle")
    end
end)

XZCore.Commands.Add("sellvehicle", "Sell owned vehicle", {{name="price", help="Price to sell"}}, false, function(source, args)
    local price = tonumber(args[1])
    TriggerClientEvent('xz-sellveh:client:sellvehicle', source, price)
end)
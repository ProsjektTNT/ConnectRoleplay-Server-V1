XZCore = nil

TriggerEvent('XZCore:GetObject', function(obj) XZCore = obj end)

local chicken = vehicleBaseRepairCost

RegisterServerEvent('xz-bennys:attemptPurchase')
AddEventHandler('xz-bennys:attemptPurchase', function(type, upgradeLevel)
    local source = source
    local Player = XZCore.Functions.GetPlayer(source)
    if type == "repair" then
        if Player.PlayerData.money.cash >= chicken then
            Player.Functions.RemoveMoney('cash', chicken)
            TriggerClientEvent('xz-bennys:purchaseSuccessful', source)
        else
            TriggerClientEvent('xz-bennys:purchaseFailed', source)
        end
    elseif type == "performance" then
        if Player.PlayerData.money.cash >= vehicleCustomisationPrices[type].prices[upgradeLevel] then
            TriggerClientEvent('xz-bennys:purchaseSuccessful', source)
            Player.Functions.RemoveMoney('cash', vehicleCustomisationPrices[type].prices[upgradeLevel])
        else
            TriggerClientEvent('xz-bennys:purchaseFailed', source)
        end
    else
        if Player.PlayerData.money.cash >= vehicleCustomisationPrices[type].price then
            TriggerClientEvent('xz-bennys:purchaseSuccessful', source)
            Player.Functions.RemoveMoney('cash', vehicleCustomisationPrices[type].price)
        else
            TriggerClientEvent('xz-bennys:purchaseFailed', source)
        end
    end
end)

RegisterServerEvent('xz-bennys:updateRepairCost')
AddEventHandler('xz-bennys:updateRepairCost', function(cost)
    chicken = cost
end)

RegisterServerEvent("updateVehicle")
AddEventHandler("updateVehicle", function(myCar)
	local src = source
    if IsVehicleOwned(myCar.plate) then
        exports.oxmysql:executeSync('UPDATE `xzvehicles` SET `props` = ? WHERE `plate` = ?', { json.encode(myCar), myCar.plate })
    end
end)

function IsVehicleOwned(plate)
    local result = exports.oxmysql:scalarSync('SELECT plate FROM `xzvehicles` WHERE `plate` = ?', { plate })

    return result == nil and false or true
end
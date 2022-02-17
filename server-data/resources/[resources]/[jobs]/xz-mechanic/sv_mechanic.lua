XZCore = nil
TriggerEvent('XZCore:GetObject', function(obj) XZCore = obj end)

RegisterServerEvent("xz-mechanic:attemptPurchase", function(cheap, type, upgradeLevel)
    local src = source
    local price = 0

    if vehicleCustomisationPrices[type] and vehicleCustomisationPrices[type].prices and upgradeLevel then
        price = vehicleCustomisationPrices[type].prices[upgradeLevel]
    elseif vehicleCustomisationPrices[type] and vehicleCustomisationPrices[type].price then 
        price = vehicleCustomisationPrices[type].price
    end

    if exports['xz-bossmenu']:GetAccount("mechanic") >= price then
        TriggerEvent("xz-bossmenu:server:removeAccountMoney", "mechanic", price)
        TriggerClientEvent("xz-mechanic:purchaseSuccessful", src)
        TriggerEvent("xz-logs:server:sendLog", {Mechanic = source}, "mechanic", "Mechanic Upgrade Purchased", GetPlayerName(source) .. " Purchased a mechanic upgrade type `" .. type .. "` for `" .. price .. "$`", {}, "green", "xz-mechanic")
    else
        TriggerClientEvent("xz-mechanic:purchaseFailed", src)
    end
end)

RegisterServerEvent("xz-mechanic:updateVehicle", function(plate, vehicleMods)
    exports.oxmysql:executeSync('UPDATE `xzvehicles` SET `props` = ? WHERE `plate` = ?', { json.encode(vehicleMods), plate })
end)

function IsAuthorized(CitizenId)
    local retval = false
    for _, cid in pairs(Config.AuthorizedIds) do
        if cid == CitizenId then
            retval = true
            break
        end
    end
    return retval
end
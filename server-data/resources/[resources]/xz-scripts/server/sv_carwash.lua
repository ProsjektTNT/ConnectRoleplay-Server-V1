XZCore = nil
TriggerEvent('XZCore:GetObject', function(obj) XZCore = obj end)

RegisterServerEvent('xz-carwash:server:washCar')
AddEventHandler('xz-carwash:server:washCar', function()
    local src = source
    local Player = XZCore.Functions.GetPlayer(src)

    if Player.Functions.RemoveMoney('cash', Carwash.DefaultPrice, "car-washed") then
        TriggerEvent('xz-bossmenu:server:addAccountMoney', 'dedeshop', Carwash.DefaultPrice)
        TriggerClientEvent('xz-carwash:client:washCar', src)
    elseif Player.Functions.RemoveMoney('bank', Carwash.DefaultPrice, "car-washed") then
        TriggerEvent('xz-bossmenu:server:addAccountMoney', 'dedeshop', Carwash.DefaultPrice)
        TriggerClientEvent('xz-carwash:client:washCar', src)
    else
        TriggerClientEvent('XZCore:Notify', src, 'Not enough money.', 'error')
    end
end)

XZCore.Functions.CreateUseableItem("cleaningkit", function(source, item)
    local Player = XZCore.Functions.GetPlayer(source)
    TriggerClientEvent("clean:kit", source)
end)
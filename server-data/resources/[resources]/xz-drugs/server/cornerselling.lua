XZCore.Functions.CreateCallback('xz-drugs:server:cornerselling:getAvailableDrugs', function(source, cb)
    local AvailableDrugs = {}
    local src = source
    local Player = XZCore.Functions.GetPlayer(src)

    for i = 1, #Config.CornerSellingDrugsList, 1 do
        local item = Player.Functions.GetItemByName(Config.CornerSellingDrugsList[i])

        if item ~= nil then
            table.insert(AvailableDrugs, {
                item = item.name,
                amount = item.amount,
                label = XZCore.Shared.Items[item.name]["label"]
            })
        end
    end

    if next(AvailableDrugs) ~= nil then
        cb(AvailableDrugs)
    else
        cb(nil)
    end
end)

RegisterServerEvent('xz-drugs:server:sellCornerDrugs')
AddEventHandler('xz-drugs:server:sellCornerDrugs', function(item, amount, price)
    local src = source
    local Player = XZCore.Functions.GetPlayer(src)
    local AvailableDrugs = {}

    if Player.Functions.RemoveItem(item, amount) then
        Player.Functions.AddMoney('cash', price, "sold-cornerdrugs")

        TriggerClientEvent('inventory:client:ItemBox', src, XZCore.Shared.Items[item], "remove")

        for i = 1, #Config.CornerSellingDrugsList, 1 do
            local item = Player.Functions.GetItemByName(Config.CornerSellingDrugsList[i])

            if item ~= nil then
                table.insert(AvailableDrugs, {
                    item = item.name,
                    amount = item.amount,
                    label = XZCore.Shared.Items[item.name]["label"]
                })
            end
        end
    end

    TriggerClientEvent('xz-drugs:client:refreshAvailableDrugs', src, AvailableDrugs)
end)

RegisterServerEvent('xz-drugs:server:robCornerDrugs')
AddEventHandler('xz-drugs:server:robCornerDrugs', function(item, amount, price)
    local src = source
    local Player = XZCore.Functions.GetPlayer(src)
    local AvailableDrugs = {}

    Player.Functions.RemoveItem(item, amount)

    TriggerClientEvent('inventory:client:ItemBox', src, XZCore.Shared.Items[item], "remove")

    for i = 1, #Config.CornerSellingDrugsList, 1 do
        local item = Player.Functions.GetItemByName(Config.CornerSellingDrugsList[i])

        if item ~= nil then
            table.insert(AvailableDrugs, {
                item = item.name,
                amount = item.amount,
                label = XZCore.Shared.Items[item.name]["label"]
            })
        end
    end

    TriggerClientEvent('xz-drugs:client:refreshAvailableDrugs', src, AvailableDrugs)
end)

XZCore.Functions.CreateCallback('xz-drugs:server:cornerselling:getStealAmount', function(source, cb, itemName)
    local src = source
    local Player = XZCore.Functions.GetPlayer(src)
    local amount = 0
    local itemAmount = math.random(1, 30)

    local Items = Player.PlayerData.items
    if Items ~= nil and next(Items) ~= nil then 
        for k, v in pairs(Items) do 
            local item = Items[k]
            if item and item.name == itemName then 
                amount = amount + item.amount
                if amount > itemAmount then
                    break
                end
            end
        end
    end

    -- print(amount > itemAmount and "itemAmount" or "amount")
    -- print("amount: " .. tostring(amount))
    -- print("itemAmount: " .. tostring(itemAmount))
    cb(amount > itemAmount and itemAmount or amount)
end)
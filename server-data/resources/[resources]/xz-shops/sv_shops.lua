RegisterServerEvent('xz-shops:server:UpdateShopItems', function(shop, itemData, amount)
    Shops.Locations[shop]["products"][itemData.slot].amount =  Shops.Locations[shop]["products"][itemData.slot].amount - amount
    if Shops.Locations[shop]["products"][itemData.slot].amount <= 0 then 
        Shops.Locations[shop]["products"][itemData.slot].amount = 0
    end
    TriggerClientEvent('xz-shops:client:SetShopItems', -1, shop, Shops.Locations[shop]["products"])
end)

RegisterServerEvent('xz-shops:server:RestockShopItems', function(shop)
    if Shops.Locations[shop]["products"] ~= nil then 
        local randAmount = math.random(10, 50)
        for k, v in pairs(Shops.Locations[shop]["products"]) do 
            Shops.Locations[shop]["products"][k].amount = Shops.Locations[shop]["products"][k].amount + randAmount
        end
        TriggerClientEvent('xz-shops:client:RestockShopItems', -1, shop, randAmount)
    end
end)
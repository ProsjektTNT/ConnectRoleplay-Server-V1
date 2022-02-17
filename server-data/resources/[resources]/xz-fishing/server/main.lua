XZCore = nil

TriggerEvent('XZCore:GetObject', function(obj) XZCore = obj end)

XZCore.Functions.CreateCallback('xz-fishing:GetItemData', function(source, cb, itemName)
	local retval = false
	local Player = XZCore.Functions.GetPlayer(source)
	if Player ~= nil then 
		if Player.Functions.GetItemByName(itemName) ~= nil then
			retval = true
		end
	end
	
	cb(retval)
end)	

XZCore.Functions.CreateUseableItem("fishingrod", function(source, item)
    local Player = XZCore.Functions.GetPlayer(source)

    TriggerClientEvent('xz-fishing:tryToFish', source)
end)

RegisterServerEvent('xz-fishing:receiveFish')
AddEventHandler('xz-fishing:receiveFish', function(cabin, house)
    local src = source
    local Player = XZCore.Functions.GetPlayer(src)
    local luck = math.random(1, 100)
    local itemFound = true
    local itemCount = 1

    if itemFound then
        for i = 1, itemCount, 1 do
            local randomItem = Config.FishingItems["type"]math.random(1, 2)
            local itemInfo = XZCore.Shared.Items[randomItem]
			if luck >= 99 and luck <= 100 then
				randomItem = "stingraymeat"
				itemInfo = XZCore.Shared.Items[randomItem]
                Player.Functions.AddItem(randomItem, 1)
				TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "add")
			elseif luck >= 95 and luck <= 97 then
				randomItem = "salmon"
				itemInfo = XZCore.Shared.Items[randomItem]
                Player.Functions.AddItem(randomItem, 1)
				TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "add")
			elseif luck >= 93 and luck <= 95 then
				randomItem = "largemouthbass"
				itemInfo = XZCore.Shared.Items[randomItem]
                Player.Functions.AddItem(randomItem, 1)
				TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "add")
			elseif luck >= 0 and luck <= 70 then
				randomItem = "fish"
				itemInfo = XZCore.Shared.Items[randomItem]
                Player.Functions.AddItem(randomItem, 1)
				TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "add")
            end
            Citizen.Wait(500)
        end
    end
end)

RegisterServerEvent("xz-fishing:sellFish")
AddEventHandler("xz-fishing:sellFish", function()
    local src = source
	local Player = XZCore.Functions.GetPlayer(src)
	local price = 0
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then 
        for k, v in pairs(Player.PlayerData.items) do 
            if Player.PlayerData.items[k] ~= nil then 
                if Player.PlayerData.items[k].name == "fish" then 
                    price = price + (Config.FishingItems["fish"]["price"] * Player.PlayerData.items[k].amount)
                    Player.Functions.RemoveItem("fish", Player.PlayerData.items[k].amount, k)
				elseif Player.PlayerData.items[k].name == "largemouthbass" then 
                    price = price + (Config.FishingItems["largemouthbass"]["price"] * Player.PlayerData.items[k].amount)
					Player.Functions.RemoveItem("largemouthbass", Player.PlayerData.items[k].amount, k)
				elseif Player.PlayerData.items[k].name == "salmon" then 
                    price = price + (Config.FishingItems["salmon"]["price"] * Player.PlayerData.items[k].amount)
					Player.Functions.RemoveItem("salmon", Player.PlayerData.items[k].amount, k)
				elseif Player.PlayerData.items[k].name == "stingraymeat" then 
                    price = price + (Config.FishingItems["stingraymeat"]["price"] * Player.PlayerData.items[k].amount)
					Player.Functions.RemoveItem("stingraymeat", Player.PlayerData.items[k].amount, k)
                end
            end
        end
        Player.Functions.AddMoney("cash", price, "sold-fish")
		TriggerClientEvent('XZCore:Notify', src, "You have sold your fish")
	end
end)
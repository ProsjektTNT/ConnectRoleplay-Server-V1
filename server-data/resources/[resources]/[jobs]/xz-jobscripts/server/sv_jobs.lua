XZCore = nil
TriggerEvent('XZCore:GetObject', function(obj) XZCore = obj end)

local jobDeliverys = {}

RegisterServerEvent('xz-jobs:server:readyForDelivery')
AddEventHandler('xz-jobs:server:readyForDelivery', function(job, item)
	local src = source
	local xPlayer = XZCore.Functions.GetPlayer(src)
	local count = xPlayer.Functions.GetItemByName(item).amount

	if count >= 1 then
		xPlayer.Functions.RemoveItem(item, count)
		if jobDeliverys[job] ~= nil then
			jobDeliverys[job].count = jobDeliverys[job].count + count
		else
			jobDeliverys[job] = {}
			jobDeliverys[job].count = count
		end

		TriggerClientEvent('XZCore:Notify', src, "You put " .. tostring(count) .. " bags out for delivery.", "success")
	else
		TriggerClientEvent('XZCore:Notify', src, "You don't have any bags for that.", "error")
	end
end)

RegisterServerEvent('xz-jobs:server:startFromDelivery')
AddEventHandler('xz-jobs:server:startFromDelivery', function(job)
	local src = source
	local xPlayer = XZCore.Functions.GetPlayer(src)
	local count = jobDeliverys[job] ~= nil and jobDeliverys[job].count or 0

	if count >= 1 then
		jobDeliverys[job].count = jobDeliverys[job].count - 1
		xPlayer.Functions.AddItem(Config.Jobs[job]['settings'].bag_item, 1)
		TriggerClientEvent("xz-jobs:client:startDelivery", src, job)
		TriggerClientEvent('XZCore:Notify', src, "You took a bag out to deliver.", "success")
	else
		TriggerClientEvent('XZCore:Notify', src, "There are no deliveries.", "error")
	end
end)

RegisterServerEvent('xz-jobs:server:dropoff')
AddEventHandler('xz-jobs:server:dropoff', function(job)
	local src = source
	local xPlayer = XZCore.Functions.GetPlayer(src)
	local jobitem = Config.Jobs[job]['settings'].bag_item
	local count = xPlayer.Functions.GetItemByName(jobitem).amount

	if count >= 1 then
		local money = math.random(Config.Jobs[job]['settings'].payment[1], Config.Jobs[job]['settings'].payment[2])
		xPlayer.Functions.AddMoney('cash', math.floor(money * 0.65))
		xPlayer.Functions.RemoveItem(jobitem, count)
		TriggerClientEvent('XZCore:Notify', src, "Drop Off Completed", "success")
		TriggerEvent("xz-bossmenu:server:addAccountMoney", job, math.floor(money * 0.35))

		if job == "taco" then
			local extra = false
			for drug, price in pairs(Config.Drugs) do
				if xPlayer.Functions.RemoveItem(drug, 1) then
					extra = math.floor(math.random(price[1], price[2]))
					break
				end
			end

			if not extra then
				TriggerClientEvent("XZCore:Notify", src, "Thanks, no extra sauce though?!", "error")
			else
				xPlayer.Functions.AddMoney('cash', extra, 'taco-tip')
				TriggerClientEvent("XZCore:Notify", src, "Thanks for the extra sauce!", "success")
			end
		end
	else
		TriggerClientEvent('XZCore:Notify', src, "Dropoff failed", "error")
	end
end)

RegisterServerEvent('xz-jobs:server:addItem')
AddEventHandler('xz-jobs:server:addItem', function(item, count)
	local src = source
	local xPlayer = XZCore.Functions.GetPlayer(src)
	xPlayer.Functions.AddItem(item, count)

	TriggerClientEvent('inventory:client:ItemBox', src, XZCore.Shared.Items[item], "add")
end)

RegisterServerEvent('xz-jobs:server:removeItem')
AddEventHandler('xz-jobs:server:removeItem', function(item, count)
	local src = source
	local xPlayer = XZCore.Functions.GetPlayer(src)
	xPlayer.Functions.RemoveItem(item, count)

	TriggerClientEvent('inventory:client:ItemBox', src, XZCore.Shared.Items[item], "remove")
end)

XZCore.Functions.CreateCallback('xz-burgershot:server:get:ingredientMurderMeal', function(source, cb)
    local src = source
    local Ply = XZCore.Functions.GetPlayer(src)
    local fries = Ply.Functions.GetItemByName("fries")
    local heartstopper = Ply.Functions.GetItemByName("heartstopper")
    local software = Ply.Functions.GetItemByName("softdrink")
    if fries ~= nil and heartstopper ~= nil and software ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

XZCore.Functions.CreateUseableItem("burger-murdermeal", function(source, item)
    local Player = XZCore.Functions.GetPlayer(source)
    TriggerClientEvent("xz-burgershot:MurderMeal", source, item.name)
  end)


XZCore.Functions.CreateCallback('xz-jobs:server:getItemCount', function(source, cb, item, count)
	local src = source
	local xPlayer = XZCore.Functions.GetPlayer(src)
	local qu = xPlayer.Functions.GetItemByName(item) ~= nil and xPlayer.Functions.GetItemByName(item).amount or 0
    if qu ~= nil and tonumber(qu) >= count then
        cb(true)
    else
        cb(false)
    end
end)
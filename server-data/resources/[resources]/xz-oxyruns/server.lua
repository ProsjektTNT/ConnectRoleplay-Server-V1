RegisterServerEvent('oxydelivery:server', function()
	local player = XZCore.Functions.GetPlayer(source)

	if player.PlayerData.money['cash'] >= Config.StartOxyPayment then
		player.Functions.RemoveMoney('cash', Config.StartOxyPayment)
		
		TriggerClientEvent("oxydelivery:startDealing", source)
	else
		TriggerClientEvent('XZCore:Notify', source, 'You dont have enough money', 'error')
	end
end)

RegisterServerEvent('oxydelivery:receiveBigRewarditem', function()
	local player = XZCore.Functions.GetPlayer(source)

	player.PlayerData.AddItem(Config.BigRewarditem, 1)
	TriggerClientEvent('inventory:client:ItemBox', source, XZCore.Shared.Items[Config.BigRewarditem], "add")
end)

RegisterServerEvent('oxydelivery:receiveoxy', function()
	local player = XZCore.Functions.GetPlayer(source)

	player.Functions.AddMoney('cash', Config.Payment / 2)
	player.Functions.AddItem(Config.Item, Config.OxyAmount)
	TriggerClientEvent('inventory:client:ItemBox', source, XZCore.Shared.Items[Config.Item], "add")
end)

RegisterServerEvent('oxydelivery:receivemoneyyy', function()
	local player = XZCore.Functions.GetPlayer(source)

	player.Functions.AddMoney('cash', Config.Payment)
end)
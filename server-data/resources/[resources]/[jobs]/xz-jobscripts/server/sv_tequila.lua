XZCore = nil
TriggerEvent('XZCore:GetObject', function(obj) XZCore = obj end)

RegisterServerEvent('tequilla:pay')
AddEventHandler('tequilla:pay', function()
	local src = source
    local Player = XZCore.Functions.GetPlayer(src)

	if Player.PlayerData.money.cash >= 150 then
		Player.Functions.RemoveMoney("cash", 150, 'tequilla:pay')
		TriggerEvent("xz-bossmenu:server:addAccountMoney", "tequila", 150)
	else
		TriggerClientEvent('XZCore:Notify', src, 'Not enough money.', 'error')
		end
		TriggerClientEvent("tequila:mail", -1, {
            sender = "Tequi-la-la",
            subject = "Tequi-la-la Receipt",
            message = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname .. " has paid 150$ entry fee for the Tequi-la-la Club.",
            button = {}
		})
end)
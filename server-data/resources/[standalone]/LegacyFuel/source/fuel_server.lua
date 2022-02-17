XZCore = nil

TriggerEvent('XZCore:GetObject', function(obj) XZCore = obj end)

RegisterServerEvent('fuel:pay')
AddEventHandler('fuel:pay', function(price, source)
	local xPlayer = XZCore.Functions.GetPlayer(source)
	local amount = math.floor(price + 0.5)

	if price > 0 then
		xPlayer.Functions.RemoveMoney('cash', amount, 'vehicle-fuel')
	end
end)

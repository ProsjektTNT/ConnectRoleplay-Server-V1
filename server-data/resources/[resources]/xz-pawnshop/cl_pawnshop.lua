isLoggedIn = false

RegisterNetEvent('xz-pawnshop:client:trySell', function()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	local time = GetClockHours()
	for k, v in pairs(Config.Shops) do
		if #(coords - v.coords) < 3.0 then
			if time >= v.openinghours.min and time <= v.openinghours.max then
				if v.type == 'pawn' then
					if GetSellingPrice() > 0 then
						XZCore.Functions.Progressbar("sell_pawn_items", "Selling ​​Items..", math.random(10000, 20000), false, true, {}, {}, {}, {}, function() -- Done
							ClearPedTasks(ped)
							TriggerServerEvent("xz-pawnshop:server:sellPawnItems")
							TriggerEvent("debug", 'Pawn Shop: Sell ​​Stuff', 'success')
						end, function() -- Cancel
							ClearPedTasks(ped)
							XZCore.Functions.Notify("Canceled..", "error")
						end)
					else
						XZCore.Functions.Notify('You have nothing to sell', 'error')
					end
				end
			else
				XZCore.Functions.Notify('The Pawnshop is currently closed, come back later', 'error')
			end
		end
	end
end)

RegisterNetEvent('xz-hardware:client:trySell', function()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	local time = GetClockHours()
	for k, v in pairs(Config.Shops) do
		if #(coords - v.coords) < 3.0 then
			if time >= v.openinghours.min and time <= v.openinghours.max then
				if v.type == 'hardware' then
					if GetSellingHardwarePrice() > 0 then
						XZCore.Functions.Progressbar("sell_hardware_items", "Selling Hardware..", math.random(10000, 20000), false, true, {}, {}, {}, {}, function() -- Done
							ClearPedTasks(ped)
							TriggerServerEvent("xz-pawnshop:server:sellHardwarePawnItems")
							TriggerEvent("debug", 'Pawn Shop: Sell ​​Stuff', 'success')
						end, function() -- Cancel
							ClearPedTasks(ped)
							XZCore.Functions.Notify("Canceled..", "error")
						end)
					else
						XZCore.Functions.Notify('You have nothing to sell', 'error')
					end
				end
			else
				XZCore.Functions.Notify('The Pawnshop is currently closed, come back later', 'error')
			end
		end
	end
end)

function GetSellingPrice()
	local price = 0
	XZCore.Functions.TriggerCallback('xz-pawnshop:server:getSellPrice', function(result)
		price = result
	end)
	Wait(500)
	return price
end

function GetSellingHardwarePrice()
	local price = 0
	XZCore.Functions.TriggerCallback('xz-pawnshop:server:getSellHardwarePrice', function(result)
		price = result
	end)
	Wait(500)
	return price
end
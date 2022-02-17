XZCore = nil
cachedData = {}

Citizen.CreateThread(function()
	while not XZCore do
		TriggerEvent('XZCore:GetObject', function(obj) XZCore = obj end)

		Citizen.Wait(0)
	end
end)

function CreateBlips()
	for i, zone in ipairs(Config.FishingZones) do
		local coords = zone.secret and ((zone.coords / 1.5) - 133.37) or zone.coords
		local name = zone.name
		if not zone.secret then
			local x = AddBlipForCoord(coords)
			SetBlipSprite (x, 405)
			SetBlipDisplay(x, 4)
			SetBlipScale  (x, 0.35)
			SetBlipAsShortRange(x, true)
			SetBlipColour(x, 69)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentSubstringPlayerName(name)
			EndTextCommandSetBlipName(x)
		end
	end
end

function DeleteBlips()
	if DoesBlipExist(coords) then
		RemoveBlip(coords)
	end
end


RegisterNetEvent("xz-fishing:tryToFish")
AddEventHandler("xz-fishing:tryToFish", function()
	TryToFish() 
end)

RegisterNetEvent("xz-fishing:calculatedistances")
AddEventHandler("xz-fishing:calculatedistances", pos, function()
end)

Citizen.CreateThread(function()
	Citizen.Wait(500)
	HandleStore()
	while true do
		local sleepThread = 500
		local ped = cachedData["ped"]
		if DoesEntityExist(cachedData["storeOwner"]) then
			local pedCoords = GetEntityCoords(ped)
			local dstCheck = #(pedCoords - GetEntityCoords(cachedData["storeOwner"]))
			if dstCheck < 3.0 then
					sleepThread = 5
					local displayText = not IsEntityDead(cachedData["storeOwner"]) and "Press ~INPUT_CONTEXT~ to sell your collected fish." or "The owner is dead, and therefore can not speak."
					if IsControlJustPressed(0, 38) then
						DeleteBlips()
						SellFish()
					end
					ShowHelpNotification(displayText)
			end
		end
		Citizen.Wait(sleepThread)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1500)

		local ped = PlayerPedId()

		if cachedData["ped"] ~= ped then
			cachedData["ped"] = ped
		end
	end
end)
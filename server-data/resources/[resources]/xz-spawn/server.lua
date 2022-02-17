XZCore = nil
TriggerEvent('XZCore:GetObject', function(obj) XZCore = obj end)
Citizen.CreateThread(function()
	local HouseGarages = {}
	exports.oxmysql:fetch("SELECT * FROM `houselocations`", {}, function(result)
		if result[1] ~= nil then
			for k, v in pairs(result) do
				local owned = false
				if tonumber(v.owned) == 1 then
					owned = true
				end
				local garage = v.garage ~= nil and json.decode(v.garage) or {}
				Config.Houses[v.name] = {
					coords = json.decode(v.coords),
					owned = v.owned,
					price = v.price,
					locked = true,
					adress = v.label, 
					tier = v.tier,
					garage = garage,
					decorations = {},
				}
				HouseGarages[v.name] = {
					label = v.label,
					takeVehicle = garage,
				}
			end
		end
		TriggerClientEvent("xz-garages:client:houseGarageConfig", -1, HouseGarages)
		TriggerClientEvent("xz-houses:client:setHouseConfig", -1, Config.Houses)
	end)
end)

XZCore.Functions.CreateCallback('xz-spawn:server:isJailed', function(source, cb, cid)
	if cid ~= nil then
		exports.oxmysql:fetch('SELECT `metadata` FROM `players` WHERE `citizenid` = ?', { cid }, function(res)
			if res[1] ~= nil then
				local zzzz = json.decode(res[1].metadata)['injail']
				if tonumber(zzzz) ~= nil and tonumber(zzzz) > 0 then
					cb(true, tonumber(zzzz))
					return
				end
			end
		end)
	end

	Wait(3000)
	cb(false)
end)

XZCore.Functions.CreateCallback('xz-spawn:server:getOwnedHouses', function(source, cb, cid)
	if cid ~= nil then
		exports.oxmysql:fetch('SELECT * FROM `player_houses` WHERE `citizenid` = ?', { cid }, function(houses)
			if houses[1] ~= nil then
				cb(houses)
			else
				cb(nil)
			end
		end)
	else
		cb(nil)
	end
end)
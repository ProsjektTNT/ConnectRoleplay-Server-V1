XZCore = nil
TriggerEvent('XZCore:GetObject', function(obj) XZCore = obj end)

Citizen.CreateThread(function()
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
				Config.HouseGarages[v.name] = {
					label = v.label,
					takeVehicle = garage,
				}
			end
		end
		TriggerClientEvent("xz-garages:client:houseGarageConfig", -1, Config.HouseGarages)
		TriggerClientEvent("xz-houses:client:setHouseConfig", -1, Config.Houses)
	end)
end)

local houseowneridentifier = {}
local houseownercid = {}
local housekeyholders = {}
local managementAccess = {}

RegisterServerEvent('houses:server:managementAccess', function(bool)
	managementAccess[source] = bool
end)

RegisterServerEvent('xz-houses:server:setHouses', function()
	local src = source
	TriggerClientEvent("xz-houses:client:setHouseConfig", src, Config.Houses)
	TriggerClientEvent("xz-garages:client:houseGarageConfig", -1, Config.HouseGarages)
end)

RegisterServerEvent('xz-houses:server:addNewHouse', function(street, coords, price, tier)
	local src = source
	local street = street:gsub("%'", "")
	local price = tonumber(price)
	local tier = tonumber(tier)
	local houseCount = GetHouseStreetCount(street)
	local name = street:lower() .. tostring(houseCount)
	local label = street .. " " .. tostring(houseCount)
	exports.oxmysql:insert("INSERT INTO `houselocations` (`name`, `label`, `coords`, `owned`, `price`, `tier`) VALUES (?, ?, ?, 0, ?, ?)", { name, label, json.encode(coords), price, tier }, function() end)
	Config.Houses[name] = {
		coords = coords,
		owned = false,
		price = price,
		locked = true,
		adress = label, 
		tier = tier,
		garage = {},
		decorations = {},
	}
	TriggerClientEvent("xz-houses:client:setHouseConfig", -1, Config.Houses)
	TriggerClientEvent('XZCore:Notify', src, "You have added a house: "..label)
end)

RegisterServerEvent('xz-houses:server:addGarage', function(house, coords)
	local src = source
	exports.oxmysql:execute("UPDATE `houselocations` SET `garage` = ? WHERE `name` = ?", { json.encode(coords), house })
	Config.HouseGarages[house] = {
		label = Config.Houses[house].adress,
		takeVehicle = coords,
	}
	TriggerClientEvent("xz-garages:client:addHouseGarage", -1, house, Config.HouseGarages[house])
	TriggerClientEvent('XZCore:Notify', src, "You have added a garage to: "..Config.HouseGarages[house].label)
end)

RegisterServerEvent('xz-houses:server:viewHouse', function(house)
	local src     		= source
	local pData 		= XZCore.Functions.GetPlayer(src)

	local houseprice   	= Config.Houses[house].price
	local brokerfee 	= 0
	local bankfee 		= 0
	local taxes 		= 0

	TriggerClientEvent('xz-houses:client:viewHouse', src, houseprice, brokerfee, bankfee, taxes, pData.PlayerData.charinfo.firstname, pData.PlayerData.charinfo.lastname)
end)

RegisterServerEvent('xz-houses:server:buyHouse', function(house)
	local src     	= source
	local pData 	= XZCore.Functions.GetPlayer(src)
	local price   	= Config.Houses[house].price
	local HousePrice = math.ceil(price * 1.21)
	local bankBalance = pData.PlayerData.money["bank"]

	if (bankBalance >= HousePrice) then
		houseowneridentifier[house] = pData.PlayerData.steam
		houseownercid[house] = pData.PlayerData.citizenid
		housekeyholders[house] = {}
		housekeyholders[house][1] = pData.PlayerData.citizenid

		exports.oxmysql:insert("INSERT INTO `player_houses` (`house`, `identifier`, `citizenid`, `keyholders`) VALUES (?, ?, ?, ?)", { house, XZCore.Functions.GetIdentifier(src, "steam"), pData.PlayerData.citizenid, json.encode(housekeyholders[house]) })

		exports.oxmysql:execute("UPDATE `houselocations` SET `owned` = 1 WHERE `name` = ?", { house })
		TriggerClientEvent('xz-houses:client:SetClosestHouse', src)
		pData.Functions.RemoveMoney('bank', HousePrice, "bought-house") -- 21% Extra house costs
        TriggerEvent("xz-bossmenu:server:addAccountMoney", "realestate", (HousePrice / 100) * math.random(18, 25))
        TriggerEvent('xz-garages:server:buyHouseGarage', house, pData.PlayerData.citizenid, src)
	else
		TriggerClientEvent('XZCore:Notify', source, "You do not have enough money..", "error")
	end
end)

RegisterServerEvent('xz-houses:server:lockHouse', function(bool, house)
	TriggerClientEvent('xz-houses:client:lockHouse', -1, bool, house)
end)

RegisterServerEvent('xz-houses:server:SetRamState', function(bool, house)
	Config.Houses[house].IsRaming = bool
	TriggerClientEvent('xz-houses:server:SetRamState', -1, bool, house)
end)

--------------------------------------------------------------

--------------------------------------------------------------

XZCore.Functions.CreateCallback('xz-houses:server:hasKey', function(source, cb, house)
	cb(PlayerHasKey(house,source))
end)

function PlayerHasKey(house, src)
	local Player = XZCore.Functions.GetPlayer(src)
	if Player ~= nil then 
		local identifier = Player.PlayerData.steam
		local CharId = Player.PlayerData.citizenid
		if hasKey(identifier, CharId, house) then
			return true
		else
			return managementAccess[src] == true
		end
	end
end

XZCore.Functions.CreateCallback('xz-houses:server:isOwned', function(source, cb, house)
	if houseowneridentifier[house] ~= nil and houseownercid[house] ~= nil then
		cb(true)
	else
		if XZCore.Functions.HasPermission(source, 'god') then
			cb(true)
			return
		end
		cb(false)
	end
end)

XZCore.Functions.CreateCallback('xz-houses:server:getHouseOwner', function(source, cb, house)
	cb(houseownercid[house])
end)

XZCore.Functions.CreateCallback('xz-houses:server:getHouseKeyHolders', function(source, cb, house)
	local retval = {}
	local Player = XZCore.Functions.GetPlayer(source)
	if housekeyholders[house] ~= nil then 
		for i = 1, #housekeyholders[house], 1 do
			if Player.PlayerData.citizenid ~= housekeyholders[house][i] then
				exports.oxmysql:scalar("SELECT `charinfo` FROM `players` WHERE `citizenid` = ?", { housekeyholders[house][i] }, function(result)
					if result[1] ~= nil then 
						local charinfo = json.decode(result[1].charinfo)
						table.insert(retval, {
							firstname = charinfo.firstname,
							lastname = charinfo.lastname,
							citizenid = housekeyholders[house][i],
						})
					end
					cb(retval)
				end)
			end
		end
	else
		cb(nil)
	end
end)

function hasKey(identifier, cid, house)
	if houseowneridentifier[house] ~= nil and houseownercid[house] ~= nil then
		if houseowneridentifier[house] == identifier and houseownercid[house] == cid then
			return true
		else
			if housekeyholders[house] ~= nil then 
				for i = 1, #housekeyholders[house], 1 do
					if housekeyholders[house][i] == cid then
						return true
					end
				end
			end
		end
	end
	return false
end

function getOfflinePlayerData(citizenid)
	exports['oxmysql']:fetch("SELECT `charinfo` FROM `players` WHERE `citizenid` = '"..citizenid.."'", function(result)
		Citizen.Wait(100)
		if result[1] ~= nil then 
			local charinfo = json.decode(result[1].charinfo)
			return charinfo
		else
			return nil
		end
	end)
end

RegisterServerEvent('xz-houses:server:giveKey', function(house, target)
	local pData = XZCore.Functions.GetPlayer(target)

	table.insert(housekeyholders[house], pData.PlayerData.citizenid)
    exports.oxmysql:execute(false, "UPDATE `player_houses` SET `keyholders` = ? WHERE `house` = ?", { json.encode(housekeyholders[house]), house })
    TriggerEvent('xz-garages:server:updateHouseAccess', housekeyholders[house], house)
end)

RegisterServerEvent('xz-houses:server:removeHouseKey', function(house, citizenData)
	local src = source
	local newHolders = {}

	if not PlayerHasKey(house,src) then
		TriggerClientEvent('XZCore:Notify', src, 'You cannot remove key of this house!', 'error', 3500)
		return false
	end

	if housekeyholders[house] ~= nil then 
		for k, v in pairs(housekeyholders[house]) do
			if housekeyholders[house][k] ~= citizenData.citizenid then
				table.insert(newHolders, housekeyholders[house][k])
			end
		end
	end
	housekeyholders[house] = newHolders
	TriggerClientEvent('XZCore:Notify', src, citizenData.firstname .. " " .. citizenData.lastname .. "'s keys removed.", 'error', 3500)
    exports.oxmysql:execute("UPDATE `player_houses` SET `keyholders` = ? WHERE `house` = ?", {json.encode(housekeyholders[house]), house})
    TriggerEvent('xz-garages:server:updateHouseAccess', housekeyholders[house], house)
end)

XZCore.Functions.CreateCallback('xz-phone:server:TransferCid', function(source, cb, NewCid, house)
	exports.oxmysql:scalar("SELECT * FROM `players` WHERE `citizenid` = ?", {NewCid}, function(result)
		if result[1] ~= nil then
			local HouseName = house.name
			housekeyholders[HouseName] = {}
			housekeyholders[HouseName][1] = NewCid
			houseownercid[HouseName] = NewCid
			houseowneridentifier[HouseName] = result[1].steam

			exports.oxmysql:execute("UPDATE `player_houses` SET citizenid = ?', keyholders = ?, identifier = ? WHERE `house` = ?", { NewCid, json.encode(housekeyholders[HouseName]), result[1].steam, HouseName })
			cb(true)
		else
			cb(false)
		end
	end)
end)

function typeof(var)
    local _type = type(var);
    if(_type ~= "table" and _type ~= "userdata") then
        return _type;
    end
    local _meta = getmetatable(var);
    if(_meta ~= nil and _meta._NAME ~= nil) then
        return _meta._NAME;
    else
        return _type;
    end
end

local housesLoaded = false

Citizen.CreateThread(function()
	while true do
		if not housesLoaded then
			exports['oxmysql']:fetch('SELECT * FROM player_houses', {}, function(houses)
				if houses ~= nil then
					for _,house in pairs(houses) do
						houseowneridentifier[house.house] = house.identifier
						houseownercid[house.house] = house.citizenid
						housekeyholders[house.house] = json.decode(house.keyholders)
					end
				end
			end)
			housesLoaded = true
		end
		Citizen.Wait(7)
	end
end)

RegisterServerEvent('xz-houses:server:OpenDoor', function(target, house)
    local src = source
    local OtherPlayer = XZCore.Functions.GetPlayer(target)
    if OtherPlayer ~= nil then
        TriggerClientEvent('xz-houses:client:SpawnInApartment', OtherPlayer.PlayerData.source, house)
    end
end)

RegisterServerEvent('xz-houses:server:RingDoor', function(house)
    local src = source
    TriggerClientEvent('xz-houses:client:RingDoor', -1, src, house)
end)

RegisterServerEvent('xz-houses:server:savedecorations', function(house, decorations)
	local src = source
	exports.oxmysql:execute("UPDATE `player_houses` SET `decorations` = ? WHERE `house` = ?", { json.encode(decorations), house })
	TriggerClientEvent("xz-houses:server:sethousedecorations", -1, house, decorations)
end)

XZCore.Functions.CreateCallback('xz-houses:server:getHouseDecorations', function(source, cb, house)
	local retval = nil

	exports.oxmysql:fetch("SELECT * FROM `player_houses` WHERE `house` = ?", { house }, function(result)
		if result[1] ~= nil then
			if result[1].decorations ~= nil then
				retval = json.decode(result[1].decorations)
			end
		end
		cb(retval)
	end)
end)

XZCore.Functions.CreateCallback('xz-houses:server:getHouseLocations', function(source, cb, house)
	local retval = nil
	exports.oxmysql:fetch("SELECT * FROM `player_houses` WHERE `house` = ?", { house }, function(result)
		if result[1] ~= nil then
			retval = result[1]
		end
		cb(retval)
	end)
end)

XZCore.Functions.CreateCallback('xz-houses:server:getHouseKeys', function(source, cb)
	local src = source
	local pData = XZCore.Functions.GetPlayer(src)
	local cid = pData.PlayerData.citizenid
end)

function mysplit (inputstr, sep)
	if sep == nil then
			sep = "%s"
	end
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
			table.insert(t, str)
	end
	return t
end

XZCore.Functions.CreateCallback('xz-houses:server:getOwnedHouses', function(source, cb)
	local src = source
	local pData = XZCore.Functions.GetPlayer(src)

	if pData then
		exports['oxmysql']:fetch('SELECT * FROM player_houses WHERE citizenid = @citizenid', {['@identifier'] = pData.PlayerData.steam, ['@citizenid'] = pData.PlayerData.citizenid}, function(houses)
			local ownedHouses = {}

			for i=1, #houses, 1 do
				table.insert(ownedHouses, houses[i].house)
			end

			if houses ~= nil then
				cb(ownedHouses)
			else
				cb(nil)
			end
		end)
	end
end)

function GetHouseStreetCount(street)
	local count = 1
	exports.oxmysql:fetch("SELECT * FROM `houselocations` WHERE `name` LIKE ?", { "%" .. street .. "%" }, function(result)
		if result[1] ~= nil then 
			for i = 1, #result, 1 do
				count = count + 1
			end
		end
		return count
	end)
	return count
end

RegisterServerEvent('xz-houses:server:LogoutLocation', function()
	local src = source
	local Player = XZCore.Functions.GetPlayer(src)
	local MyItems = Player.PlayerData.items
	exports.oxmysql:execute("UPDATE `players` SET `inventory` = ? WHERE `citizenid` = ?", { XZCore.EscapeSqli(json.encode(MyItems)), Player.PlayerData.citizenid })
	XZCore.Player.Logout(src)
	TriggerClientEvent("xz:multicharacters:logout", src)
	TriggerEvent("xz-logs:server:sendLog", {User = src}, "character", "A Character Logged out", GetPlayerName(src) .. " Logged out and unloaded his character. ", {}, "red", "xz-apartments")
end)

RegisterServerEvent('xz-houses:server:giveHouseKey', function(target, house)
	local src = source
	local tPlayer = XZCore.Functions.GetPlayer(target)
	
	if tPlayer ~= nil then
		if not PlayerHasKey(house,src) then
			TriggerClientEvent('XZCore:Notify', src, 'You cannot give key of this house!', 'error', 3500)
			return false
		end
		
		if housekeyholders[house] ~= nil then
			for _, cid in pairs(housekeyholders[house]) do
				if cid == tPlayer.PlayerData.citizenid then
					TriggerClientEvent('XZCore:Notify', src, 'This person already has the keys to this house!', 'error', 3500)
					return
				end
			end		
			table.insert(housekeyholders[house], tPlayer.PlayerData.citizenid)
			exports.oxmysql:execute("UPDATE `player_houses` SET `keyholders` = ? WHERE `house` = ?", { json.encode(housekeyholders[house]), house })
			TriggerClientEvent('xz-houses:client:refreshHouse', tPlayer.PlayerData.source)
			TriggerClientEvent('XZCore:Notify', tPlayer.PlayerData.source, 'You have the keys '..Config.Houses[house].adress..' receive!', 'success', 2500)
		else
			local sourceTarget = XZCore.Functions.GetPlayer(src)
			housekeyholders[house] = {
				[1] = sourceTarget.PlayerData.citizenid
			}
			table.insert(housekeyholders[house], tPlayer.PlayerData.citizenid)
			exports.oxmysql:execute("UPDATE `player_houses` SET `keyholders` = ? WHERE `house` = ?", { json.encode(housekeyholders[house]), house })
			TriggerClientEvent('xz-houses:client:refreshHouse', tPlayer.PlayerData.source)
			TriggerClientEvent('XZCore:Notify', tPlayer.PlayerData.source, 'The keys to '..Config.Houses[house].adress..' receive!', 'success', 2500)
		end
	else
		TriggerClientEvent('XZCore:Notify', src, 'Something went wrong. Please try again!', 'error', 2500)
	end
end)

RegisterServerEvent('xz-houses:server:setLocation', function(coords, house, type)
	local src = source
	local Player = XZCore.Functions.GetPlayer(src)
	local result

	if(type == 1) then
		result = "stash"
	elseif(type == 2) then
		result = "outfit"
	else
		result = "logout"
	end

	exports.oxmysql:execute("UPDATE `player_houses` SET `" .. result .. "` = ? WHERE `house` = ?", { json.encode(coords), house })

	TriggerClientEvent('xz-houses:client:refreshLocations', -1, house, json.encode(coords), type)
end)

RegisterServerEvent('xz-houses:server:SetInsideMeta', function(insideId, bool)
    local src = source
    local Player = XZCore.Functions.GetPlayer(src)
    local insideMeta = Player.PlayerData.metadata["inside"]

    if bool then
        insideMeta.apartment.apartmentType = nil
        insideMeta.apartment.apartmentId = nil
        insideMeta.house = insideId

        Player.Functions.SetMetaData("inside", insideMeta)
    else
        insideMeta.apartment.apartmentType = nil
        insideMeta.apartment.apartmentId = nil
        insideMeta.house = nil

        Player.Functions.SetMetaData("inside", insideMeta)
    end
end)

XZCore.Functions.CreateCallback('xz-phone:server:GetPlayerHouses', function(source, cb)
	local src = source
	local Player = XZCore.Functions.GetPlayer(src)
	local MyHouses = {}

	exports.oxmysql:fetch("SELECT * FROM `player_houses` WHERE `citizenid` = ?", { Player.PlayerData.citizenid }, function(result)
		if result[1] ~= nil then
			for k, v in pairs(result) do
				table.insert(MyHouses, {
					name = v.house,
					keyholders = {},
					owner = Player.PlayerData.citizenid,
					price = Config.Houses[v.house].price,
					label = Config.Houses[v.house].adress,
					tier = Config.Houses[v.house].tier,
					garage = Config.Houses[v.house].garage,
				})

				if v.keyholders ~= "null" then
					v.keyholders = json.decode(v.keyholders)
					if v.keyholders ~= nil then
						for f, data in pairs(v.keyholders) do
							exports.oxmysql:fetch("SELECT * FROM `players` WHERE `citizenid` = ?", { data }, function(keyholderdata)
								if keyholderdata[1] ~= nil then
									keyholderdata[1].charinfo = json.decode(keyholderdata[1].charinfo)
									table.insert(MyHouses[k].keyholders, keyholderdata[1])
								end
							end)
						end
					else
						MyHouses[k].keyholders[1] = Player.PlayerData
					end
				else
					MyHouses[k].keyholders[1] = Player.PlayerData
				end
			end
				
			cb(MyHouses)
		else
			cb({})
		end
	end)
end)

XZCore.Functions.CreateCallback('xz-phone:server:GetHouseKeys', function(source, cb)
	local src = source
	local Player = XZCore.Functions.GetPlayer(src)
	local MyKeys = {}

	exports.oxmysql:fetch("SELECT * FROM `player_houses`", function(result)
		for k, v in pairs(result) do
			if v.keyholders ~= "null" then
				v.keyholders = json.decode(v.keyholders)
				for s, p in pairs(v.keyholders) do
					if p == Player.PlayerData.citizenid and (v.citizenid ~= Player.PlayerData.citizenid) then
						table.insert(MyKeys, {
							HouseData = Config.Houses[v.house]
						})
					end
				end
			end

			if v.citizenid == Player.PlayerData.citizenid then
				table.insert(MyKeys, {
					HouseData = Config.Houses[v.house]
				})
			end
		end

		cb(MyKeys)
	end)
end)

function escape_sqli(source)
    local replacements = { ['"'] = '\\"', ["'"] = "\\'" }
    return source:gsub( "['\"]", replacements ) -- or string.gsub( source, "['\"]", replacements )
end

XZCore.Functions.CreateCallback('xz-phone:server:MeosGetPlayerHouses', function(source, cb, input)
	local src = source
	if input ~= nil then
		local search = escape_sqli(input)
		local searchData = {}
		
			exports.oxmysql:fetch('SELECT * FROM `players` WHERE `citizenid` = ? OR `charinfo` LIKE ?', { search, "%" .. search .. "%" }, function(result)
				if result[1] ~= nil then
					exports.oxmysql:fetch("SELECT * FROM `player_houses` WHERE `citizenid` = ?", { result[1].citizenid }, function(houses)
						if houses[1] ~= nil then
								for k, v in pairs(houses) do
									if Config.Houses[v.house].tier ~= 8 then
										table.insert(searchData, {
											name = v.house,
											keyholders = keyholders,
											owner = v.citizenid,
											price = Config.Houses[v.house].price,
											label = Config.Houses[v.house].adress,
											tier = Config.Houses[v.house].tier,
											garage = Config.Houses[v.house].garage,
											charinfo = json.decode(result[1].charinfo),
											coords = {
												x = Config.Houses[v.house].coords.enter.x,
												y = Config.Houses[v.house].coords.enter.y,
												z = Config.Houses[v.house].coords.enter.z,
											}
										})
									end
								end
							
							cb(searchData)
						end
					end)
				else
					cb(nil)
				end
			end)
		
	else
		cb(nil)
	end
end)

local DoorLocked = true
RegisterServerEvent('xz-houses:server:doorState', function(bool)
	if bool == nil then
		TriggerClientEvent('xz-houses:client:doorState', source, DoorLocked)
		return
	end

	DoorLocked = bool
	TriggerClientEvent('xz-houses:client:doorState', -1, DoorLocked)
end)

XZCore.Functions.CreateUseableItem("police_stormram", function(source, item)
	local Player = XZCore.Functions.GetPlayer(source)

	if Player.PlayerData.job.name == "police" then
		TriggerClientEvent("xz-houses:client:HomeInvasion", source)
	else
		TriggerClientEvent('XZCore:Notify', source, "This is only possible for emergency services!", "error")
	end
end)

RegisterServerEvent('xz-houses:server:SetHouseRammed', function(bool, house)
	Config.Houses[house].IsRammed = bool
	TriggerClientEvent('xz-houses:client:SetHouseRammed', -1, bool, house)
end)

XZCore.Commands.Add("enter", "Enter house.", {}, false, function(source, args)
    local src = source
    local Player = XZCore.Functions.GetPlayer(src)
	
	if XZCore.Functions.HasPermission(src, 'god') then
		TriggerClientEvent('xz-houses:client:EnterHouse', src, true)
	else
		TriggerClientEvent('xz-houses:client:EnterHouse', src, false)
	end
end)

XZCore.Commands.Add("ring", "Ring the bell at home.", {}, false, function(source, args)
    local src = source
    local Player = XZCore.Functions.GetPlayer(src)
 
    TriggerClientEvent('xz-houses:client:RequestRing', src)
end)

XZCore.Commands.Add("createhouse", "Create a house (Realestate Agent)", {{name="price", help="Price of the house"},{name="tier", help="Name of the item (no label)"}}, true, function(source, args)
	local Player = XZCore.Functions.GetPlayer(source)
	local price = tonumber(args[1])
	local tier = tonumber(args[2])
	if Player.PlayerData.job.name == "realestate" then
		if price >= Config.MinAmounts[tostring(tier)] then
			TriggerClientEvent("xz-houses:client:createHouses", source, price, tier)
			TriggerEvent('xz-logs:server:createLog', 'realestate', '**House Added:**', "**[Tier]** "..tier.. "\n **[Price]** "..price.."$" , source)
		else
			TriggerClientEvent('XZCore:Notify', source, "The min price of tier " .. tostring(tier) .. ' is ' .. tostring(Config.MinAmounts[tostring(tier)]) .. '$', "error")
		end
	end
end)

XZCore.Commands.Add("addgarage", "Add garage to nearest house", {}, false, function(source, args)
	local Player = XZCore.Functions.GetPlayer(source)
	if Player.PlayerData.job.name == "realestate" then
		TriggerClientEvent("xz-houses:client:addGarage", source)
	end
end)

XZCore.Commands.Add("decorate", "Decorate your cottage :)", {}, false, function(source, args)
	TriggerClientEvent("xz-houses:client:decorate", source)
end)
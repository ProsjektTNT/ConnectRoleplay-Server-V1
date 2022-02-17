XZCore.Functions = {}

XZCore.Functions.ExecuteSql = function(wait, query, cb)
	local rtndata = {}
	local waiting = true
	exports['oxmysql']:execute(query, {}, function(data)
		if cb ~= nil and wait == false then
			cb(data)
		end
		rtndata = data
		waiting = false
	end)
	if wait then
		while waiting do
			Citizen.Wait(5)
		end
		if cb ~= nil and wait == true then
			cb(rtndata)
		end
	end
	return rtndata
end

XZCore.Functions.GetEntityCoords = function(entity)
    local coords = GetEntityCoords(entity, false)
    local heading = GetEntityHeading(entity)
    return {
        x = coords.x,
        y = coords.y,
        z = coords.z,
        a = heading
    }
end

XZCore.Functions.GetIdentifier = function(source, idtype)
	local idtype = idtype ~=nil and idtype or XZConfig.IdentifierType
	for _, identifier in pairs(GetPlayerIdentifiers(source)) do
		if string.find(identifier, idtype) then
			return identifier
		end
	end
	return nil
end

XZCore.Functions.GetSource = function(identifier)
	for src, player in pairs(XZCore.Players) do
		local idens = GetPlayerIdentifiers(src)
		for _, id in pairs(idens) do
			if identifier == id then
				return src
			end
		end
	end
	return 0
end

XZCore.Functions.GetPlayer = function(source)
	if type(source) == "number" then
		return XZCore.Players[source]
	else
		return XZCore.Players[XZCore.Functions.GetSource(source)]
	end
end

XZCore.Functions.GetPlayerByCitizenId = function(citizenid)
	for src, player in pairs(XZCore.Players) do
		local cid = citizenid
		if XZCore.Players[src].PlayerData.citizenid == cid then
			return XZCore.Players[src]
		end
	end
	return nil
end

XZCore.Functions.GetPlayerByPhone = function(number)
	for src, player in pairs(XZCore.Players) do
		local cid = citizenid
		if XZCore.Players[src].PlayerData.charinfo.phone == number then
			return XZCore.Players[src]
		end
	end
	return nil
end

XZCore.Functions.GetPlayers = function()
	local sources = {}
	for k, v in pairs(XZCore.Players) do
		table.insert(sources, k)
	end
	return sources
end

XZCore.Functions.CreateCallback = function(name, cb)
	XZCore.ServerCallbacks[name] = cb
end

XZCore.Functions.TriggerCallback = function(name, source, cb, ...)
	if XZCore.ServerCallbacks[name] ~= nil then
		XZCore.ServerCallbacks[name](source, cb, ...)
	end
end

XZCore.Functions.CreateUseableItem = function(item, cb)
	XZCore.UseableItems[item] = cb
end

XZCore.Functions.CanUseItem = function(item)
	return XZCore.UseableItems[item] ~= nil
end

XZCore.Functions.UseItem = function(source, item)
	XZCore.UseableItems[item.name](source, item)
end

XZCore.Functions.Kick = function(source, reason, setKickReason, deferrals)
	local src = source
	reason = "\n"..reason.."\n🔸 Check our Discord for further information: "..XZCore.Config.Server.discord
	if(setKickReason ~=nil) then
		setKickReason(reason)
	end
	Citizen.CreateThread(function()
		if(deferrals ~= nil)then
			deferrals.update(reason)
			Citizen.Wait(2500)
		end
		if src ~= nil then
			DropPlayer(src, reason)
		end
		local i = 0
		while (i <= 4) do
			i = i + 1
			while true do
				if src ~= nil then
					if(GetPlayerPing(src) >= 0) then
						break
					end
					Citizen.Wait(100)
					Citizen.CreateThread(function() 
						DropPlayer(src, reason)
					end)
				end
			end
			Citizen.Wait(5000)
		end
	end)
end

XZCore.Functions.IsWhitelisted = function(source)
	local identifiers = GetPlayerIdentifiers(source)
	local rtn = false
	if (XZCore.Config.Server.whitelist) then
		local result = exports.oxmysql:fetchSync('SELECT * FROM whitelist WHERE license=@license', {['@license'] = XZCore.Functions.GetIdentifier(source, 'license')})
		local data = result[1]
		if data ~= nil then
			for _, id in pairs(identifiers) do
				if data.license == id then
					rtn = true
				end
			end
		end
	else
		rtn = true
	end
	return rtn
end

XZCore.Functions.AddPermission = function(source, permission)
	local Player = XZCore.Functions.GetPlayer(source)
	if Player ~= nil then 
		XZCore.Config.Server.PermissionList[XZCore.Functions.GetIdentifier(source, 'license')] = {
			license = XZCore.Functions.GetIdentifier(source, 'license'),
			permission = permission:lower(),
		}
		exports.oxmysql:execute('DELETE FROM permissions WHERE license=@license', {['@license'] = XZCore.Functions.GetIdentifier(source, 'license')})

		exports.oxmysql:insert('INSERT INTO permissions (name, license, permission) VALUES (@name, @license, @permission)', {
			['@name'] = GetPlayerName(source),
			['@license'] = XZCore.Functions.GetIdentifier(source, 'license'),
			['@permission'] = permission:lower()
		})

		Player.Functions.UpdatePlayerData()
		TriggerClientEvent('XZCore:Client:OnPermissionUpdate', source, permission)
	end
end

XZCore.Functions.RemovePermission = function(source)
	local Player = XZCore.Functions.GetPlayer(source)
	if Player ~= nil then 
		XZCore.Config.Server.PermissionList[XZCore.Functions.GetIdentifier(source, 'license')] = nil	
		exports.oxmysql:execute('DELETE FROM permissions WHERE license=@license', {['@license'] = XZCore.Functions.GetIdentifier(source, 'license')})
		Player.Functions.UpdatePlayerData()
	end
end

XZCore.Functions.HasPermission = function(source, permission)
	local retval = false
	local license = XZCore.Functions.GetIdentifier(source, 'license')
	local permission = tostring(permission:lower())
	if permission == "user" then
		retval = true
	else
		if XZCore.Config.Server.PermissionList[license] ~= nil then 
			if XZCore.Config.Server.PermissionList[license].license == license then
				if XZCore.Config.Server.PermissionList[license].permission == permission or XZCore.Config.Server.PermissionList[license].permission == "god" then
					retval = true
				end
			end
		end
	end
	return retval
end

XZCore.Functions.GetPermission = function(source)
	local retval = "user"
	Player = XZCore.Functions.GetPlayer(source)
	local license = XZCore.Functions.GetIdentifier(source, 'license')
	if Player ~= nil then
		if XZCore.Config.Server.PermissionList[Player.PlayerData.license] ~= nil then 
			if XZCore.Config.Server.PermissionList[Player.PlayerData.license].license == license then
				retval = XZCore.Config.Server.PermissionList[Player.PlayerData.license].permission
			end
		end
	end
	return retval
end

XZCore.Functions.IsOptin = function(source)
	local retval = false
	local license = XZCore.Functions.GetIdentifier(source, 'license')
	if XZCore.Functions.HasPermission(source, "admin") then
		retval = XZCore.Config.Server.PermissionList[license].optin
	end
	return retval
end

XZCore.Functions.ToggleOptin = function(source)
	local license = XZCore.Functions.GetIdentifier(source, 'license')
	if XZCore.Functions.HasPermission(source, "admin") then
		XZCore.Config.Server.PermissionList[license].optin = not XZCore.Config.Server.PermissionList[license].optin
	end
end

XZCore.Functions.IsPlayerBanned = function (source)
	local retval = false
	local message = ""
    local result = exports.oxmysql:fetchSync('SELECT * FROM bans WHERE license=@license', {['@license'] = XZCore.Functions.GetIdentifier(source, 'license')})
    if result[1] ~= nil then
        if os.time() < result[1].expire then
            retval = true
            local timeTable = os.date("*t", tonumber(result.expire))
            message = "You have been banned from the server:\n"..result[1].reason.."\nYour ban expires "..timeTable.day.. "/" .. timeTable.month .. "/" .. timeTable.year .. " " .. timeTable.hour.. ":" .. timeTable.min .. "\n"
        else
            exports.oxmysql:execute('DELETE FROM bans WHERE id=@id', {['@id'] = result[1].id})
        end
    end
	return retval, message
end

XZCore.Functions.IsLicenseInUse = function(license)
    local players = GetPlayers()
    for _, player in pairs(players) do
        local identifiers = GetPlayerIdentifiers(player)
        for _, id in pairs(identifiers) do
            if string.find(id, 'license') then
                local playerLicense = id
                if playerLicense == license then
                    return true
                end
            end
        end
    end
    return false
end
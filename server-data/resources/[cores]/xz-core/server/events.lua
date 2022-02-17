-- Player joined
RegisterServerEvent("XZCore:PlayerJoined")
AddEventHandler('XZCore:PlayerJoined', function()
	local src = source
	SetPlayerRoutingBucket(src, 0)
end)

AddEventHandler('playerDropped', function(reason) 
	local src = source
	if XZCore.Players[src] then
		local Player = XZCore.Players[src]
		TriggerEvent("xz-log:server:CreateLog", "joinleave", "Dropped", "red", "**".. GetPlayerName(src) .. "** ("..Player.PlayerData.license..") left..")
		Player.Functions.Save()
		XZCore.Players[src] = nil
	end
end)

local token = "YOUR TOKEN HERE"
local cooldowns = {}

local function OnPlayerConnecting(name, setKickReason, deferrals)
    local player = source
    local license, discord
    local identifiers = GetPlayerIdentifiers(player)
    deferrals.defer()

    -- mandatory wait!
    Wait(0)

    -- deferrals.update(string.format("Hello %s. Validating Your Rockstar License", name))

    for _, v in pairs(identifiers) do
        if string.find(v, 'license') then
            license = v
		elseif(string.find(v, 'discord')) then
			discord = v:gsub("discord:", "")
        end
    end

    -- mandatory wait!
    Wait(2500)

    -- deferrals.update(string.format("Hello %s. We are checking if you are banned.", name))
	
    local isBanned, Reason = XZCore.Functions.IsPlayerBanned(player)
    local isLicenseAlreadyInUse = XZCore.Functions.IsLicenseInUse(license)

    Wait(2500)
	
    -- deferrals.update(string.format("Welcome %s to XZone RolePlay.", name))

    if not license then
        deferrals.done('No Valid Rockstar License Found')
    elseif isBanned then
	    deferrals.done(Reason)
    elseif isLicenseAlreadyInUse then
        deferrals.done('Duplicate Rockstar License Found')
    else
        deferrals.done()
        Wait(1000)
		TriggerEvent("xz-queue:playerConnecting", player, setKickReason, deferrals)
    end
    --Add any additional defferals you may need!
end

AddEventHandler("playerConnecting", OnPlayerConnecting)

RegisterServerEvent("XZCore:server:CloseServer")
AddEventHandler('XZCore:server:CloseServer', function(reason)
    local src = source
    local Player = XZCore.Functions.GetPlayer(src)

    if XZCore.Functions.HasPermission(source, "admin") or XZCore.Functions.HasPermission(source, "god") then 
        local reason = reason ~= nil and reason or "No reason specified..."
        XZCore.Config.Server.closed = true
        XZCore.Config.Server.closedReason = reason
        TriggerClientEvent("qbadmin:client:SetServerStatus", -1, true)
	else
		XZCore.Functions.Kick(src, "You don't have permissions for this..", nil, nil)
    end
end)

RegisterServerEvent("XZCore:server:OpenServer")
AddEventHandler('XZCore:server:OpenServer', function()
    local src = source
    local Player = XZCore.Functions.GetPlayer(src)
    if XZCore.Functions.HasPermission(source, "admin") or XZCore.Functions.HasPermission(source, "god") then
        XZCore.Config.Server.closed = false
        TriggerClientEvent("qbadmin:client:SetServerStatus", -1, false)
    else
        XZCore.Functions.Kick(src, "You don't have permissions for this..", nil, nil)
    end
end)

RegisterServerEvent("XZCore:UpdatePlayer")
AddEventHandler('XZCore:UpdatePlayer', function(data)
	local src = source
	local Player = XZCore.Functions.GetPlayer(src)
	if Player ~= nil then
		Player.PlayerData.position = data.position
		local newHunger = Player.PlayerData.metadata["hunger"] - XZCore.Config.Player.HungerRate
		local newThirst = Player.PlayerData.metadata["thirst"] - XZCore.Config.Player.ThirstRate
		if newHunger <= 0 then newHunger = 0 end
		if newThirst <= 0 then newThirst = 0 end
		Player.Functions.SetMetaData("thirst", newThirst)
		Player.Functions.SetMetaData("hunger", newHunger)
		TriggerClientEvent("hud:client:UpdateNeeds", src, newHunger, newThirst)
		Player.Functions.Save()
	end
end)

RegisterServerEvent("XZCore:UpdatePlayerPosition")
AddEventHandler("XZCore:UpdatePlayerPosition", function(position)
	local src = source
	local Player = XZCore.Functions.GetPlayer(src)
	if Player ~= nil then
		Player.PlayerData.position = position
	end
end)

RegisterServerEvent("XZCore:Server:TriggerCallback")
AddEventHandler('XZCore:Server:TriggerCallback', function(name, ...)
	local src = source
	XZCore.Functions.TriggerCallback(name, src, function(...)
		TriggerClientEvent("XZCore:Client:TriggerCallback", src, name, ...)
	end, ...)
end)

RegisterServerEvent("XZCore:Server:UseItem")
AddEventHandler('XZCore:Server:UseItem', function(item)
	local src = source
	local Player = XZCore.Functions.GetPlayer(src)
	if item ~= nil and item.amount > 0 then
		if XZCore.Functions.CanUseItem(item.name) then
			XZCore.Functions.UseItem(src, item)
		end
	end
end)

RegisterServerEvent("XZCore:Server:RemoveItem")
AddEventHandler('XZCore:Server:RemoveItem', function(itemName, amount, slot)
	local src = source
	local Player = XZCore.Functions.GetPlayer(src)
	Player.Functions.RemoveItem(itemName, amount, slot)
end)

RegisterServerEvent("XZCore:Server:AddItem")
AddEventHandler('XZCore:Server:AddItem', function(itemName, amount, slot, info)
	local src = source
	local Player = XZCore.Functions.GetPlayer(src)
	Player.Functions.AddItem(itemName, amount, slot, info)
end)

RegisterServerEvent('XZCore:Server:SetMetaData')
AddEventHandler('XZCore:Server:SetMetaData', function(meta, data)
    local src = source
	local Player = XZCore.Functions.GetPlayer(src)
	if meta == "hunger" or meta == "thirst" then
		if data > 100 then
			data = 100
		end
	end
	if Player ~= nil then 
		Player.Functions.SetMetaData(meta, data)
	end
	TriggerClientEvent("hud:client:UpdateNeeds", src, Player.PlayerData.metadata["hunger"], Player.PlayerData.metadata["thirst"])
end)

AddEventHandler('chatMessage', function(source, n, message)
	if string.sub(message, 1, 1) == "/" then
		local args = XZCore.Shared.SplitStr(message, " ")
		local command = string.gsub(args[1]:lower(), "/", "")
		CancelEvent()
		if XZCore.Commands.List[command] ~= nil then
			local Player = XZCore.Functions.GetPlayer(tonumber(source))
			if Player ~= nil then
				table.remove(args, 1)
				if (XZCore.Functions.HasPermission(source, "god") or XZCore.Functions.HasPermission(source, XZCore.Commands.List[command].permission)) then
					if (XZCore.Commands.List[command].argsrequired and #XZCore.Commands.List[command].arguments ~= 0 and args[#XZCore.Commands.List[command].arguments] == nil) then
					    TriggerClientEvent('XZCore:Notify', source, "All arguments must be filled out!", "error")
					    local agus = ""
					    for name, help in pairs(XZCore.Commands.List[command].arguments) do
					    	agus = agus .. " ["..help.name.."]"
					    end
					else
						XZCore.Commands.List[command].callback(source, args)
						local logType = "commands"
						if(XZCore.Commands.List[command].permission ~= "user") then
							logType = "admin"
						end
						local ar = #args == 0 and " With No Args" or " With `" .. table.concat(args, " ") .. "`"
						TriggerEvent("xz-logs:server:sendLog", {Executor = source}, logType, "A Player Used A Command", string.format("%s Used `/%s`", GetPlayerName(source), command) .. ar, {}, "default", "xz-core")
					end
				else
					TriggerClientEvent('XZCore:Notify', source, "No Access To This Command", "error")
				end
			end
		end
	end
end)

RegisterServerEvent('XZCore:CallCommand')
AddEventHandler('XZCore:CallCommand', function(command, args)
	if XZCore.Commands.List[command] ~= nil then
		local Player = XZCore.Functions.GetPlayer(tonumber(source))
		if Player ~= nil then
			if (XZCore.Functions.HasPermission(source, "god")) or (XZCore.Functions.HasPermission(source, XZCore.Commands.List[command].permission)) or (XZCore.Commands.List[command].permission == Player.PlayerData.job.name) then
				if (XZCore.Commands.List[command].argsrequired and #XZCore.Commands.List[command].arguments ~= 0 and args[#XZCore.Commands.List[command].arguments] == nil) then
					TriggerClientEvent('XZCore:Notify', source, "All arguments must be filled out!", "error")
					local agus = ""
					for name, help in pairs(XZCore.Commands.List[command].arguments) do
						agus = agus .. " ["..help.name.."]"
					end
				else
					XZCore.Commands.List[command].callback(source, args)
				end
			else
				TriggerClientEvent('XZCore:Notify', source, "No Access To This Command", "error")
			end
		end
	end
end)

RegisterServerEvent("XZCore:AddCommand")
AddEventHandler('XZCore:AddCommand', function(name, help, arguments, argsrequired, callback, persmission)
	XZCore.Commands.Add(name, help, arguments, argsrequired, callback, persmission)
end)

RegisterServerEvent("XZCore:ToggleDuty")
AddEventHandler('XZCore:ToggleDuty', function()
	local src = source
	local Player = XZCore.Functions.GetPlayer(src)
	if Player.PlayerData.job.onduty then
		Player.Functions.SetJobDuty(false)
		TriggerClientEvent('XZCore:Notify', src, "You are now off duty!")
	else
		Player.Functions.SetJobDuty(true)
		TriggerClientEvent('XZCore:Notify', src, "You are now on duty!")
	end
	TriggerClientEvent("XZCore:Client:SetDuty", src, Player.PlayerData.job.onduty)
end)

Citizen.CreateThread(function()
	local result = exports.oxmysql:fetchSync('SELECT * FROM permissions', {})
	if result[1] ~= nil then
		for k, v in pairs(result) do
			XZCore.Config.Server.PermissionList[v.license] = {
				license = v.license,
				permission = v.permission,
				optin = true,
			}
		end
	end
end)

XZCore.Functions.CreateCallback('XZCore:HasItem', function(source, cb, items, amount)
	local retval = false
	local Player = XZCore.Functions.GetPlayer(source)
	if Player ~= nil then
		if type(items) == 'table' then
			local count = 0
            		local finalcount = 0
			for k, v in pairs(items) do
				if type(k) == 'string' then
                    			finalcount = 0
                    			for i, _ in pairs(items) do
                        			if i then finalcount = finalcount + 1 end
                    			end
					local item = Player.Functions.GetItemByName(k)
					if item ~= nil then
						if item.amount >= v then
							count = count + 1
							if count == finalcount then
								retval = true
							end
						end
					end
				else
                    			finalcount = #items
					local item = Player.Functions.GetItemByName(v)
					if item ~= nil then
						if amount ~= nil then
							if item.amount >= amount then
								count = count + 1
								if count == finalcount then
									retval = true
								end
							end
						else
							count = count + 1
							if count == finalcount then
								retval = true
							end
						end
					end
				end
			end
		else
			local item = Player.Functions.GetItemByName(items)
			if item ~= nil then
				if amount ~= nil then
					if item.amount >= amount then
						retval = true
					end
				else
					retval = true
				end
			end
		end
	end

	cb(retval)
end)

RegisterServerEvent('XZCore:Command:CheckOwnedVehicle')
AddEventHandler('XZCore:Command:CheckOwnedVehicle', function(VehiclePlate)
	if VehiclePlate ~= nil then
		local result = exports.oxmysql:fetchSync('SELECT * FROM player_vehicles WHERE plate=@plate', {['@plate'] = VehiclePlate})
		if result[1] ~= nil then
			exports.oxmysql:execute('UPDATE player_vehicles SET state=@state WHERE citizenid=@citizenid', {['@state'] = 1, ['@citizenid'] = result[1].citizenid})
			TriggerEvent('xz-garages:server:RemoveVehicle', result[1].citizenid, VehiclePlate)
		end
	end
end)

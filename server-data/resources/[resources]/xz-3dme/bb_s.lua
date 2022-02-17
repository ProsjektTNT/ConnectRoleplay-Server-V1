XZCore = nil
TriggerEvent('XZCore:GetObject', function(obj) XZCore = obj end)

XZCore.Commands.Add('me', 'Me message.', {}, false, function(source, args)
	if source == 0 or source == "Console" then return end

	args = table.concat(args, ' ')
	TriggerClientEvent('u7x!A%D*', -1, source, args, "me")
	TriggerEvent("xz-logs:server:sendLog", {User = source}, "3dme", "A Command Got Used", GetPlayerName(source) .. " Used `/me " .. args .. "`", {}, "green", "xz-3dme")
end)

XZCore.Commands.Add('do', 'Do message.', {}, false, function(source, args)
	if source == 0 then return end

	args = table.concat(args, ' ')
	TriggerClientEvent('u7x!A%D*', -1, source, args, "do")
	TriggerEvent("xz-logs:server:sendLog", {User = source}, "3dme", "A Command Got Used", GetPlayerName(source) .. " Used `/do " .. args .. "`", {}, "green", "xz-3dme")
end)
DiscordName = ""

RegisterNetEvent("xz-discordconnector:SavePlayer")
AddEventHandler("xz-discordconnector:SavePlayer", function(discname)
    DiscordName = discname
end)

CreateThread(function()
    TriggerServerEvent("xz-discordconnector:checkPlayer")
end)

-- RegisterCommand('refreshname', function()
--     TriggerServerEvent("xz-discordconnector:checkPlayer")
-- end)

-- RegisterCommand('ooc', function(source, args, rawCommand)
-- 	local msg = rawCommand:sub(4)
-- 	TriggerServerEvent('xz-chat:sendOocGlobally', DiscordName, msg)
-- end, false)

RegisterCommand('ac', function(source, args, rawCommand)
	local msg = rawCommand:sub(4)
	TriggerServerEvent('bbcha:adminchatpermmision', DiscordName, msg)
end, false)
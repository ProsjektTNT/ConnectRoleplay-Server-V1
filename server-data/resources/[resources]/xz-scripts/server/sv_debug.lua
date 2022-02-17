
RegisterServerEvent("Scripts:ready")
AddEventHandler("Scripts:ready", function()
    XZCore.Commands.Add("dev", "Toggle debug mode", {}, false, function(source, args)
        TriggerClientEvent('debug:toggle', source)
    end, 'god')
end)

XZCore.Commands.Add("debug", "Turn debug mode on / off", {}, false, function(source, args)
	TriggerClientEvent('koil-debug:toggle', source)
end, "god")

RegisterServerEvent('XZCore:Server:OnPlayerLoaded')
AddEventHandler('XZCore:Server:OnPlayerLoaded', function()
    TriggerClientEvent('debug', -1, 'XZCore: ' .. GetPlayerName(source) .. ' (' .. source .. ') Loaded!', 'normal')
end)

AddEventHandler('playerDropped', function(reason)
    TriggerClientEvent('debug', -1, 'XZCore: ' .. GetPlayerName(source) .. ' (' .. source .. ') Dropped! (' .. reason .. ')', 'normal')
end)
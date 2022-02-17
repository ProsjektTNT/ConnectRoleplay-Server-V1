RegisterServerEvent("Scripts:ready")
AddEventHandler("Scripts:ready", function()
    XZCore.Commands.Add('echat', 'EMS Chat', {}, false, function(source, args)
        local src = source
        local Player = XZCore.Functions.GetPlayer(src)

        if Player and (Player.PlayerData.job.name == 'ambulance' and Player.PlayerData.job.onduty) then
            TriggerClientEvent('ems:chatMessage', -1, {(Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname), table.concat(args, " ")})
        else
            TriggerClientEvent('chat:addMessage', src, {
                template = '<div class="chat-message server">SYSTEM: {0}</div>',
                args = { 'This command is for emergency services!' }
            })
        end
        
    end)
end)
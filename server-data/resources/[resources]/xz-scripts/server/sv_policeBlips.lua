XZCore = nil
TriggerEvent('XZCore:GetObject', function(obj) XZCore = obj end)

local Blips = {}
RegisterServerEvent("xz-blips:server:updateBlips")
AddEventHandler("xz-blips:server:updateBlips", function()
    local players = XZCore.Functions.GetPlayers()
    Blips = {}
    for k, v in pairs(players) do
        local player = XZCore.Functions.GetPlayer(v)
        local hasradar = player.Functions.GetItemByName('signalradar') ~= nil and true or false
        if hasradar == true then
            local callsign = player.PlayerData.metadata["callsign"] ~= nil and player.PlayerData.metadata["callsign"] or "Police"
            if player.PlayerData.job.name == "police" and player.PlayerData.job.onduty then
                table.insert(Blips, {v, 'police', callsign})
            elseif player.PlayerData.job.name == "ambulance" and player.PlayerData.job.onduty then
                table.insert(Blips, {v, 'ambulance', callsign})
            end
        end
    end

    TriggerClientEvent('xz-blips:client:updateBlips', -1, Blips)
end)

XZCore.Commands.Add("setsign", "Set your callsign (call number)", {{name="name", help="Name of your callsign"}}, true, function(source, args)
    local Player = XZCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == 'ambulance' then
        Player.Functions.SetMetaData("callsign", table.concat(args, " "))
        TriggerEvent('xz-policeActives:server:updateOfficers')
    end
end)

CreateThread(function()
    while true do
        TriggerEvent("xz-blips:server:updateBlips")
        Wait(25000)
    end
end)
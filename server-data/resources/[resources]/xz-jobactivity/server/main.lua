local XZCore = nil
local PlayersData = {}

TriggerEvent('XZCore:GetObject', function(obj) XZCore = obj end)

Citizen.CreateThread(function()
    for _, jobName in pairs(Config.Jobs) do
        PlayersData[jobName] = {
            label = Config.JobsLabels[jobName] or jobName,
            players = {}
        }
    end
end)

RegisterNetEvent("xz-jobactivity:server:removePlayer", function(jobName)
    local src    = tostring(source)

    PlayersData[jobName].players[tostring(src)] = nil

    for Player, _ in pairs(PlayersData[jobName].players) do
        TriggerClientEvent("xz-jobactivity:client:jobListUpdate", Player, PlayersData[jobName])
    end
end)

RegisterNetEvent("xz-jobactivity:server:addPlayer", function(name, jobName, jobGrade, radioChannel, callSign, isBoss)
    local src = tostring(source)

    -- Check If Jobs Exists
    if(PlayersData[jobName] == nil) then
        return
    end
    
    -- Check If Player On Another List
    for _, jobList in pairs(PlayersData) do
        if(jobList[tostring(src)] ~= nil and jobName ~= _) then
            jobList[tostring(src)] = nil
        end
    end

    PlayersData[jobName].players[tostring(src)] = {
        playerName = name,
        gradeName = jobGrade,
        radioChannel = exports["xz-voice"]:getPlayerRadio(src) --[[radioChannel == -1 and "x" or radioChannel]],
        callSign = callSign,
        isBoss = isBoss
    }

    for Player, _ in pairs(PlayersData[jobName].players) do
        TriggerEvent("xz-blips:server:updateBlips")
        TriggerClientEvent("xz-jobactivity:client:jobListUpdate", Player, PlayersData[jobName])
    end
end)

RegisterNetEvent("xz-jobactivity:server:updatePlayer", function(jobName, gradeName, isBoss)
    local src = source

    if(PlayersData[jobName] == nil) then
        return
    end

    PlayersData[jobName].players[tostring(src)].gradeName = gradeName
    PlayersData[jobName].players[tostring(src)].isBoss = isBoss

    
    for Player, _ in pairs(PlayersData[jobName].players) do
        TriggerClientEvent("xz-jobactivity:client:jobListUpdate", Player, PlayersData[jobName])
    end
end)

RegisterNetEvent("xz-jobactivity:server:setRank", function(jobName, newRank)
    local src    = source
    local Player = XZCore.Functions.GetPlayer(src)

    if(PlayersData[jobName] == nil) then
        return
    end

    if(newRank ~= nil) then
        Player.Functions.SetMetaData("callsign", newRank)
        PlayersData[jobName].players[tostring(src)].callSign = newRank
    
        for Player, _ in pairs(PlayersData[jobName].players) do
            TriggerClientEvent("xz-jobactivity:client:jobListUpdate", Player, PlayersData[jobName])
        end
    end
end)

--RegisterNetEvent("xz-jobactivity:client:setRadioChannel", function(newChannel)
RegisterNetEvent("xz-jobactivity:server:updateChannel", function(source, newChannel)
    local src     = source
    local Player  = XZCore.Functions.GetPlayer(src)
    local jobName = Player.PlayerData.job.name

    -- Check If Jobs Exists
    if(PlayersData[jobName] == nil) then
        return
    end

    PlayersData[jobName].players[tostring(src)].radioChannel = newChannel

    for Player, _ in pairs(PlayersData[jobName].players) do
        TriggerClientEvent("xz-jobactivity:client:jobListUpdate", Player, PlayersData[jobName])
    end
end)

RegisterNetEvent("playerDropped", function()
    local src = tostring(source)
    local jobName
    for _, JobData in pairs(PlayersData) do
        if(JobData.players[src] ~= nil) then
            jobName = _
        end
    end

    if(jobName == nil) then
        return
    end

    PlayersData[jobName].players[src] = nil

    for PlayerId, _ in pairs(PlayersData[jobName].players) do
        TriggerClientEvent("xz-jobactivity:client:jobListUpdate", PlayerId, PlayersData[jobName])
    end
end)

RegisterCommand("plistdebug", function()
    for _, jobName in pairs(PlayersData) do
        for PlayerId, PlayerData in pairs(jobName.players) do
            print("Job: " .. _ .. "\nPlayer ID: " .. PlayerId)
            print(string.format("Player IC Name: %s\nGrade Name: %s\nRadio Channel: %s\nCall Sign: %s", PlayerData.playerName, PlayerData.gradeName, PlayerData.radioChannel, PlayerData.callSign))
        end
    end
end)
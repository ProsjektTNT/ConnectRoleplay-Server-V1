local XZCore = nil
local isPlayerOnList = false
local PlayerId = GetPlayerServerId(PlayerId())
local resourceName = GetCurrentResourceName();
local jobList = {}
local PlayerData = {}

Citizen.CreateThread(function() 
    while XZCore == nil do
        TriggerEvent("XZCore:GetObject", function(obj) XZCore = obj end)    
        Wait(200)
    end

    while XZCore.Functions.GetPlayerData().job == nil do
        Wait(200)
    end

    PlayerData = XZCore.Functions.GetPlayerData()
    if(isJobAllowed()) then
        TriggerServerEvent("xz-jobactivity:server:addPlayer", PlayerData.charinfo.firstname .. " " .. PlayerData.charinfo.lastname, PlayerData.job.name, PlayerData.job.grade.name, "x", PlayerData.metadata["callsign"], PlayerData.job.isboss)
        isPlayerOnList = true
    end
end)

RegisterNetEvent("XZCore:Client:OnJobUpdate", function(jobInfo)
    local oldJob = PlayerData.job.name
    PlayerData.job = jobInfo
    
    if(isPlayerOnList and not isJobAllowed()) then
        SendNUIMessage({action = "close"})
        jobList = {}
        TriggerServerEvent("xz-jobactivity:server:removePlayer", oldJob)
        isPlayerOnList = false
    elseif(oldJob == PlayerData.job.name) then
        TriggerServerEvent("xz-jobactivity:server:updatePlayer", PlayerData.job.name, PlayerData.job.grade.name, PlayerData.job.isboss)
    elseif(oldJob ~= PlayerData.job.name) then
        TriggerServerEvent("xz-jobactivity:server:setRank", "No Tag")
        TriggerServerEvent("xz-jobactivity:server:addPlayer", PlayerData.charinfo.firstname .. " " .. PlayerData.charinfo.lastname, PlayerData.job.name, PlayerData.job.grade.name, "x", PlayerData.metadata["callsign"], PlayerData.job.isboss)
        isPlayerOnList = true
    end

end)

RegisterNetEvent("XZCore:Client:OnDutyUpdate", function(Job)
    PlayerData.job = Job

    if(isPlayerOnList and not isJobAllowed()) then
        SendNUIMessage({action = "close"})
        TriggerServerEvent("xz-jobactivity:server:removePlayer", PlayerData.job.name)
        isPlayerOnList = false
    elseif(not isPlayerOnList and isJobAllowed()) then
        TriggerServerEvent("xz-jobactivity:server:addPlayer", PlayerData.charinfo.firstname .. " " .. PlayerData.charinfo.lastname, PlayerData.job.name, PlayerData.job.grade.name, "x", PlayerData.metadata["callsign"], PlayerData.job.isboss)
        isPlayerOnList = true
    end
end)

RegisterNetEvent("xz-jobactivity:client:jobListUpdate", function(data)
    jobList = data
    jobList.players[tostring(PlayerId)].me = true
    SendNUIMessage({
        action = "update",
        jobData = jobList
    })
end)

RegisterNetEvent("XZCore:Client:OnPlayerLoaded", function()
    if(isJobAllowed()) then
        TriggerServerEvent("xz-jobactivity:server:addPlayer", PlayerData.charinfo.firstname .. " " .. PlayerData.charinfo.lastname, PlayerData.job.name, PlayerData.job.grade.name, "x", PlayerData.metadata["callsign"], PlayerData.job.isboss)
        isPlayerOnList = true
    end
end)

RegisterNetEvent("XZCore:Client:OnPlayerUnload", function()
    if(isJobAllowed()) then
        TriggerServerEvent("xz-jobactivity:server:removePlayer", PlayerData.job.name)
        SendNUIMessage({action = "close"})
        jobList = {}
        isPlayerOnList = false
    end
end)

RegisterNetEvent("xz:interact:init:" .. resourceName, function(Nevo);
    Nevo.Mapping:Listen("joblist", "(Player) Job List", "keyboard", "Equals", function(state);
    if(state and isJobAllowed()) then
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = "openSettings"
        })
    end
end);

Nevo.Mapping:Listen("movething", "(Player) Job List - Quick Move", "keyboard", "", function(state);
    if(state and isJobAllowed()) then
        SetNuiFocus(true, true)
        end
    end)
end);

RegisterNUICallback("closeSettings", function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback("setRank", function(data)
    TriggerServerEvent("xz-jobactivity:server:setRank", PlayerData.job.name ,data.newRank);
end)

function isJobAllowed()
    for _, jobName in pairs(Config.Jobs) do
        if PlayerData.job.name == jobName and PlayerData.job.onduty then
            return true
        end
    end

    return false
end

CreateThread(function()
    TriggerEvent("xz:interact:init", resourceName, "Mapping");
end);

RegisterNetEvent("xz:interact:ready", function()
    TriggerEvent("xz:interact:init", resourceName, "Mapping");
end);
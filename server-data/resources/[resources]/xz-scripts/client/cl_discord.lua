local XZCore = nil
function FirstToUpper(input)
    return (input:gsub("^%l", string.upper))
end

CreateThread(function()
    UpdateDiscordRichPresence("Selecting Character")
    while not XZCore do
        TriggerEvent("XZCore:GetObject", function(obj) XZCore = obj end)
        Wait(500)
    end
end)



RegisterNetEvent("XZCore:Client:OnPlayerLoaded")
AddEventHandler("XZCore:Client:OnPlayerLoaded", function()
    local PlayerData = XZCore.Functions.GetPlayerData()
    if PlayerData then
        local plyID = GetPlayerServerId(PlayerId())
        local plyName = (FirstToUpper(PlayerData.charinfo.firstname) .. " " .. FirstToUpper(PlayerData.charinfo.lastname))
        UpdateDiscordRichPresence("[" .. plyID .. "] " .. plyName .. " [" .. PlayerData.citizenid .. "]")
    end
end)



RegisterNetEvent('XZCore:Client:OnPlayerUnload')
AddEventHandler('XZCore:Client:OnPlayerUnload', function()
    UpdateDiscordRichPresence("Selecting Character")
end)



function UpdateDiscordRichPresence(msg)
    SetDiscordAppId(846548790307455036)
    SetDiscordRichPresenceAsset("big")
    SetRichPresence(msg)
    SetDiscordRichPresenceAssetSmall("small")
    --SetDiscordRichPresenceAction(1, "Connect", "fivem://connect/cfx.re/join/p65lrm")
    --SetDiscordRichPresenceAction(0, "Discord", "https://discord.gg/Rss88ESsWA")
end

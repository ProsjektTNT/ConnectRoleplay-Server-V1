RegisterServerEvent("xz-logs:server:sendLog", function(players, webhookType, title, description, fields, color, resourceName, alert)
    local src = source
    if(src ~= nil) then
        DropPlayer(src, "Used a Unauthorized log trigger")
    end

    if(resourceName == nil) then
        return print(string.format("Unknown resource tried to send a webhook | Webhook type: %s", webhookType))
    elseif(Config.Webhooks[webhookType] == nil) then
        return print(string.format("- [%s] - Unknown Webhook %s", resourceName, webhookType))
    end

    local embed = {
        {
            ["title"] = string.format("%s - %s", resourceName, title or ""),
            ["description"] = description or "No Description",
            ["color"] = Config.Colors[color] or Config.Colors["default"],
            ["fields"] = {},
            ["footer"] = {
                ["text"] = "All Rights Reserved To XZone - XZone Public Logs - " .. os.date("%c")
            },
        }
    }

    local Embed = embed[1]
    -- Get All Player(s) Identifiers And Split Them
    local playersIdentifiers = {}
    for PlayerTag, PlayerId in pairs(players) do
        if(playersIdentifiers[PlayerTag] == nil) then
            playersIdentifiers[PlayerTag] = ""
        end

        playersIdentifiers[PlayerTag] = playersIdentifiers[PlayerTag] .. string.format("Name: %s\n", GetPlayerName(PlayerId))
        
        local ids = GetPlayerIdentifiers(PlayerId);
        
        if isDiscordAuth(ids, players, webhookType, title, description, fields, color, resourceName, alert) ~= 200 then
            return false;
        end

        for _, Identifier in ipairs(GetPlayerIdentifiers(PlayerId)) do
            local identifierSplited = split(Identifier, ":")

            if(Config.VaildIdentifiers[identifierSplited[1]] == true) then
                if(Config.Webhooks[webhookType].isManagment and identifierSplited[1] == "ip") then
                    if(identifierSplited[1] == "discord") then
                        playersIdentifiers[PlayerTag] = playersIdentifiers[PlayerTag] .. string.format("%s: <@%s>\n", identifierSplited[1], identifierSplited[2])
                    else
                        playersIdentifiers[PlayerTag] = playersIdentifiers[PlayerTag] .. string.format("%s: %s\n", identifierSplited[1], identifierSplited[2])
                    end
                end
            else
                playersIdentifiers[PlayerTag] = playersIdentifiers[PlayerTag] .. string.format("%s: %s\n", identifierSplited[1], Identifier)
            end
        end

        local Player = XZCore.Functions.GetPlayer(PlayerId)
        if Player ~= nil then
            playersIdentifiers[PlayerTag] = playersIdentifiers[PlayerTag] .. string.format("\nCitizen ID: %s\nCharacter Name: %s", Player.PlayerData.citizenid, Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname)
        end
    end

    -- Add All Player(s) To Fields
    for PlayerTag, Identifiers in pairs(playersIdentifiers) do
        Embed["fields"][#Embed["fields"] + 1] = {name = PlayerTag, value = Identifiers, inline = true}
    end

    -- Merge Fields
    for k,v in pairs(fields) do
        Embed["fields"][#Embed["fields"] + 1] = v
    end

    local isAlert = alert == true and "@everyone" or nil

    PerformHttpRequest(Config.Webhooks[webhookType].webhook, function(code, a, b)
        if(code ~= 204) then
            return print("- [" .. resourceName .. "]: Tried to send a log to a webhook but got error code [" .. code .. "]")
        end
    end, "POST", json.encode({embeds = embed, content = isAlert}), { ['Content-Type'] = 'application/json' })
end)

RegisterNetEvent("txaLogger:DeathNotice", function(killer, reason)
    local src = source
    local players = {Player = src}
    local txt = ""

    if(killer ~= false) then
        players["Killer"] = killer
        txt = string.format("`%s` Died because of `%s` using `%s`", GetPlayerName(src), GetPlayerName(killer), reason)
    else
        txt = string.format("`%s` Died because `%s`", GetPlayerName(src), reason)
    end

    TriggerEvent("xz-logs:server:sendLog", players, "death", "A Player Died", txt, {}, "red", "xz-logs")

end)

function split (inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

function isVaildIdentifier(identifierPrefix)
    for _, Identifier in pairs(Config.VaildIdentifiers) do
        if(identifierPrefix == Identifier) then
            return true
        end
    end

    return false
end

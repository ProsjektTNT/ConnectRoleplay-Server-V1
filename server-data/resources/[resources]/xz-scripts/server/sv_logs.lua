local chat = 'https://discord.com/api/webhooks/862568535439048705/rG5rKtglsfDBgM86RGOVeuQx79wezcOVuekWdokyNdO0RDFM5JZLC0zL6nV_9EnteoYI'
local resourceStart = 'https://discord.com/api/webhooks/862570157280460800/GkZUhAl5hIIrg5sl6A5w6iZdr826K8H3rOGWu_pU8GNlNVn36qYmWlg1SziXqoI6lrkq'
local resourceStop = 'https://discord.com/api/webhooks/862570023608254484/VfCz7jyaTNc01NWmPb1pTk__qpWqyj04oCSP60X_kvt1ZW2YXsh5I8Vura_r_taWxVBJ'

AddEventHandler('chatMessage', function(source, name, message)
    local embed = {
        {
                ["color"] = "7419530",
                ["author"] = {
                ["name"] = 'XZone Public Logs',
                ["icon_url"] = "https://cdn.discordapp.com/attachments/860600829052583946/862566777643859978/bank-logo.png",
            },
                ["footer"] = {
                ["text"] = os.date("%c"),
            },
                ["description"] = message
            }
        }
    PerformHttpRequest(chat, function(err, text, headers) end, 'POST', json.encode({username = name .. " | " .. GetPlayerIdentifiers(source)[1], embeds = embed}), { ['Content-Type'] = 'application/json' })
end)


AddEventHandler('onResourceStart', function(resourceName)
    local embed = {
    {
            ["color"] = "7419530",
            ["title"] = "Resource has been started.",
            ["author"] = {
            ["name"] = 'XZone Public Logs',
            ["icon_url"] = "https://cdn.discordapp.com/attachments/860600829052583946/862566777643859978/bank-logo.png",
        },
            ["footer"] = {
            ["text"] = os.date("%c"),
        },
            ["description"] = resourceName
        }
    }

    PerformHttpRequest(resourceStart, function(err, text, headers) end, 'POST', json.encode({username = 'XZone Logs', embeds = embed}), { ['Content-Type'] = 'application/json' })
end)


AddEventHandler('onResourceStop', function(resourceName)
    local embed = {
    {
            ["color"] = "7419530",
            ["title"] = "Resource has been stopped.",
            ["author"] = {
            ["name"] = 'XZone Public Logs',
            ["icon_url"] = "https://cdn.discordapp.com/attachments/860600829052583946/862566777643859978/bank-logo.png",
        },
            ["footer"] = {
            ["text"] = os.date("%c"),
        },
            ["description"] = resourceName
        }
    }

    PerformHttpRequest(resourceStop, function(err, text, headers) end, 'POST', json.encode({username = 'XZone Logs', embeds = embed}), { ['Content-Type'] = 'application/json' })
end)
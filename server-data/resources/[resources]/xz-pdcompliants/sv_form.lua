local webhook = "https://discord.com/api/webhooks/870384694661881937/fdLAgsIkNxDoQ_Xvl_KBfkMg-GukwQHMI_OI94-OPh-iMQkVHWqoiGqsWpr_azYAAUlw"

RegisterNetEvent("police-froms:server:send")
AddEventHandler("police-froms:server:send", function(data)
    local description = [[
        **First name:** %s
        **Last name:** %s
        **Date:** %s
        **Phone number:** %s
        
        **Complaint:**
        %s   
    ]]

    local embed = {
        {
            ["color"] = "143792",
            ["title"] = "Formal Police Complaint",
            ["description"] = description:format(data.name,data.lastName,data.date,data.phone,data.complaint),
            ["footer"] = {
                ["text"] = "Los Santos Police Department",
            },
        }
    }

    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "Los Santos Police Department", embeds = embed}), { ['Content-Type'] = 'application/json' })
end)
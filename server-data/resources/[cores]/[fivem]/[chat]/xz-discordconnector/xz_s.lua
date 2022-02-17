RegisterServerEvent("xz-discordconnector:checkPlayer")
AddEventHandler("xz-discordconnector:checkPlayer", function()
    local donor = ""
    local num = 0
    local num2 = GetNumPlayerIdentifiers(source)
    local source = source
    if GetNumPlayerIdentifiers(source) > 0 then
        local discord = nil
        while num < num2 and not discord do
            local a = GetPlayerIdentifier(source, num)
            if string.find(a, "discord") then discord = a end
            num = num+1
        end
        if discord then
            PerformHttpRequest("https://discordapp.com/api/guilds/776605690269270028/members/"..string.sub(discord, 9), function(err, text, headers) 
                if GetNumPlayerIdentifiers(source) > 0 and json.decode(text) then
                    local member = json.decode(text)
                    local name, dec = "", ""
                    for k, v in pairs(member.user) do
                        if k == "username" then
                            name = v
                        elseif k == "discriminator" then
                            dec = tostring(v)
                        end
                    end
                    donor = name .. "#" .. tostring(dec)
                    TriggerClientEvent("xz-discordconnector:SavePlayer", source, donor)
                end
            end, "GET", "", {["Content-type"] = "application/json", ["Authorization"] = "Bot ODYwOTc5MjcxOTc4NzEzMDk4.YODHbg.a4KJqDNqsL2NhIFV5srR3KtOOh0"})
        end
    end 
end)
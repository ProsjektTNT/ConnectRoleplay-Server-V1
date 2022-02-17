local policeTimeouts = {}
local emsTimeouts = {}
local policeCalls = {}
local emsCalls = {}

XZCore = nil
TriggerEvent('XZCore:GetObject', function(obj) XZCore = obj end)

XZCore.Commands.Add('911', 'Send a Emergancy 911 Signal.', {{name = 'content', help = 'Message Content'}}, true, function(source, args)
    local src = source
    local xPlayer = XZCore.Functions.GetPlayer(src)
	if not xPlayer.PlayerData.metadata["ishandcuffed"] then
    if policeTimeouts[src] == nil or policeTimeouts[src] == true then
        CreateThread(function()
            policeTimeouts[src] = false
            Wait(60000)
            policeTimeouts[src] = true
        end)
        local item = xPlayer.Functions.GetItemByName('phone')
        if item ~= nil and item.amount > 0 then
            local id =#policeCalls+1
            policeTimeouts[src] = GetGameTimer()

            local coords = GetEntityCoords(GetPlayerPed(src))
            local name = GetName(src)
            
            -- table.remove(args, 1)
            -- table.remove(args, 1)
            local message = table.concat(args, ' ')

            policeCalls[id] = { name = name, message = message, source = src }

            TriggerClientEvent('xz-911:client:createBlip', -1, 'police', coords, name, message, id, src)
            TriggerClientEvent('xz-911:client:justcalled', src)
        else
            TriggerClientEvent('XZCore:Notify', src, "You dont have phone.", "error")
        end
    else
        TriggerClientEvent('XZCore:Notify', src, "Please wait till your next message.", "error")
		end
	else
		TriggerClientEvent('XZCore:Notify', src, "You cant do that while cuffed!", "error")
	end
end)

XZCore.Commands.Add('911r', 'Reply to 911 call. (Police Only)', {{name = 'id', help = 'Call #ID'}, {name = 'content', help = 'Message Content'}}, true, function(source, args)
    local src = source
    local xPlayer = XZCore.Functions.GetPlayer(src)

    if xPlayer.PlayerData.job.name == 'police' or xPlayer.PlayerData.job.name == 'ambulance' then
        local item = xPlayer.Functions.GetItemByName('phone')
        if item ~= nil and item.amount > 0 then
            local id = tonumber(args[1])
            table.remove(args, 1)
            local message = table.concat(args, ' ')
            if policeCalls[id] then
                if not policeCalls[id].reply then
                    policeCalls[id].reply = true
                    TriggerClientEvent('xz-911:client:justcalled', src)
                    TriggerClientEvent('xz-911:client:reply', -1, 'police', id, message,xPlayer.PlayerData.charinfo.firstname:sub(1,1) .. '. ' .. xPlayer.PlayerData.charinfo.lastname, policeCalls[id].source)
                else
                    TriggerClientEvent('XZCore:Notify', src, "Message already replied.", "error")
                end
            else
                TriggerClientEvent('XZCore:Notify', src, "Invaild call #ID.", "error")
            end
        else
            TriggerClientEvent('XZCore:Notify', src, "You dont have phone.", "error")
        end
    end
end)

function GetName(source)
    local src = source
    local Player = XZCore.Functions.GetPlayer(src)
    if Player.PlayerData.charinfo.firstname ~= nil then
        return Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname
    else
        return GetPlayerName(src)
    end
end
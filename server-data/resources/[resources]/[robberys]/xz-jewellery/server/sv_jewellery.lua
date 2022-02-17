XZCore = nil
TriggerEvent('XZCore:GetObject', function(obj) XZCore = obj end)

local timeOut = false
local isintimeout = false
local alarmTriggered = false

RegisterServerEvent('xz-jewellery:server:setVitrineState')
AddEventHandler('xz-jewellery:server:setVitrineState', function(stateType, state, k)
    Jewellery.Locations[k][stateType] = state
    TriggerClientEvent('xz-jewellery:client:setVitrineState', -1, stateType, state, k)
end)

RegisterServerEvent('xz-jewellery:server:vitrineReward')
AddEventHandler('xz-jewellery:server:vitrineReward', function()
    local src = source
    local Player = XZCore.Functions.GetPlayer(src)
    if Player.Functions.AddItem("rolex", math.random(4, 6)) then
        TriggerClientEvent('inventory:client:ItemBox', src, XZCore.Shared.Items["rolex"], 'add')
    else
        TriggerClientEvent('XZCore:Notify', src, 'You dont have space on your bag', 'error')
    end
end)

RegisterServerEvent('xz-jewellery:server:setTimeout')
AddEventHandler('xz-jewellery:server:setTimeout', function()
    if not timeOut then
        timeOut = true
        Citizen.CreateThread(function()
            Citizen.Wait(Jewellery.Timeout)

            for k, v in pairs(Jewellery.Locations) do
                Jewellery.Locations[k]["isOpened"] = false
                TriggerClientEvent('xz-jewellery:client:setVitrineState', -1, 'isOpened', false, k)
                TriggerClientEvent('xz-jewellery:client:setAlertState', -1, false)
                TriggerClientEvent('xz-jewellery:client:resetCameras', -1)
            end
            timeOut = false
            alarmTriggered = false
        end)
    end
end)

XZCore.Functions.CreateCallback('xz-jewellery:server:getCops', function(source, cb)
	local amount = 0
    for k, v in pairs(XZCore.Functions.GetPlayers()) do
        local Player = XZCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                amount = amount + 1
            end
        end
	end
	cb(amount)
end)

RegisterServerEvent('xz-jewellery:server:startglobaltimeout')
AddEventHandler('xz-jewellery:server:startglobaltimeout', function()
    isintimeout = true
    TriggerClientEvent('lkjasdlksa:syncclientnoder', -1, true)
    CreateThread(function()
        Wait(60000 * 120) -- 2 hrs
        isintimeout = false
        TriggerClientEvent('lkjasdlksa:syncclientnoder', -1, false)
    end)
end)

XZCore.Functions.CreateCallback('xz-jewellery:gettimeoutstatus', function(source, cb)
	cb(isintimeout)
end)
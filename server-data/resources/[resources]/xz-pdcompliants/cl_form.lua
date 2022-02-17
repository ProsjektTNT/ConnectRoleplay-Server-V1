local open = false
local XZCore = nil
local PlayerJob = {}

CreateThread(function()
    TriggerEvent("XZCore:GetObject", function(obj) XZCore = obj end)
    while XZCore == nil do
        Wait(100)
        TriggerEvent("XZCore:GetObject", function(obj) XZCore = obj end)
    end

    while XZCore.Functions.GetPlayerData().job == nil do Wait(100) end
    PlayerJob = XZCore.Functions.GetPlayerData().job
end)

RegisterNetEvent('XZCore:Client:OnPlayerLoaded')
AddEventHandler('XZCore:Client:OnPlayerLoaded', function()
    PlayerJob = XZCore.Functions.GetPlayerData().job
end)

RegisterNetEvent('XZCore:Client:OnJobUpdate')
AddEventHandler('XZCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

CreateThread(function()
    local waitTime = 750 
    while (true) do
        if XZCore then
            waitTime = 750
            local ped = PlayerPedId()
            if PlayerJob and PlayerJob.name == Config.job then
                for _,loc in pairs(Config.locations) do
                    local dist = Vdist2(GetEntityCoords(ped),loc)
                    if dist < 2.0 and (not open) then
                        waitTime = 0
                        DrawText3Ds(loc.x,loc.y,loc.z,"Press [~g~E~w~] to open forms")
                        if IsControlJustPressed(0,38) then
                            open = true
                            SetNuiFocus(true, true)
                            TriggerEvent("police-froms:client:anim")
                            SendNUIMessage({action = "open-from"})
                        end
                    end
                end
            end
        else
            Wait(1000)
        end
        Wait(waitTime)
    end
end)

local prop = nil
local secondaryprop = nil
RegisterNetEvent('police-froms:client:anim')
AddEventHandler('police-froms:client:anim', function()
    local player = PlayerPedId()
    local ad = "missheistdockssetup1clipboard@base"
                
    local prop_name = 'prop_notepad_01'
    local secondaryprop_name = 'prop_pencil_01'
    
    if DoesEntityExist(player) and not IsEntityDead(player) then 
        loadAnimDict(ad)
        if IsEntityPlayingAnim( player, ad, "base", 3 ) then 
            TaskPlayAnim( player, ad, "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
            Wait(100)
            ClearPedSecondaryTask(player)
            DetachEntity(prop, 1, 1)
            DeleteObject(prop)
            DetachEntity(secondaryprop, 1, 1)
            DeleteObject(secondaryprop)
        else
            local x,y,z = table.unpack(GetEntityCoords(player))
            prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
            secondaryprop = CreateObject(GetHashKey(secondaryprop_name), x, y, z+0.2,  true,  true, true)
            AttachEntityToEntity(prop, player, GetPedBoneIndex(player, 18905), 0.1, 0.02, 0.05, 10.0, 0.0, 0.0, true, true, false, true, 1, true)
            AttachEntityToEntity(secondaryprop, player, GetPedBoneIndex(player, 58866), 0.12, 0.0, 0.001, -150.0, 0.0, 0.0, true, true, false, true, 1, true)
            TaskPlayAnim(player, ad, "base", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
        end 
    end
end)
    
RegisterNUICallback("send", function(data,cb)
    if data.data then
        close()
        TriggerServerEvent("police-froms:server:send", data.data)
    end
end)

RegisterNUICallback("close", function(data,cb)
    close()
end)

function close()
    TaskPlayAnim(PlayerPedId(), "missheistdockssetup1clipboard@base", "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
    Wait(100)
    ClearPedSecondaryTask(PlayerPedId())
    DetachEntity(prop, 1, 1)
    DeleteObject(prop)
    DetachEntity(secondaryprop, 1, 1)
    DeleteObject(secondaryprop)

    open = false
    SetNuiFocus(false, false)
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(10)
    end
end

function DrawText3Ds(x,y,z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    if onScreen then
      SetTextScale(0.30, 0.30)
      SetTextFont(4)
      SetTextProportional(1)
      SetTextColour(255, 255, 255, 215)
      SetTextEntry("STRING")
      SetTextCentre(1)
      AddTextComponentString(text)
      DrawText(_x,_y)
      local factor = (string.len(text)) / 370
      DrawRect(_x,_y+0.0120, factor, 0.026, 41, 11, 41, 68)
    end
end

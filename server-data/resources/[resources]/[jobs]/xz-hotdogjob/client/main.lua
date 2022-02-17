XZCore = nil
local isLoggedIn = false
PlayerData = {}
PlayerJob = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if XZCore == nil then
            TriggerEvent('XZCore:GetObject', function(obj) XZCore = obj end)
            Citizen.Wait(200)
        end
    end
end)

local HotdogBlip = nil
local IsWorking = false
local StandObject = nil
local IsPushing = false
local IsSelling = false
local IsUIActive = false
local PreparingFood = false
local SpatelObject = nil
local runningStands = {}

local SellingData = {
    Enabled = false,
    Target = nil,
    HasTarget = false,
    RecentPeds = {},
    Hotdog = nil,
}
local OffsetData = {
    x = 0.0,
    y = -0.8,
    z = 1.0,
    Distance = 0.5
}
local LastStandPos = nil

local AnimationData = {
    lib = "missfinale_c2ig_11",
    anim = "pushcar_offcliff_f",
}

RegisterNetEvent('XZCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerData = XZCore.Functions.GetPlayerData()
    PlayerJob = PlayerData.job
    UpdateLevel()
    UpdateBlip()
end)

RegisterNetEvent('XZCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    UpdateBlip()
end)

function UpdateBlip()
    Citizen.CreateThread(function()
        local coords = Config.Locations["take"].coords

        if HotdogBlip ~= nil then
            RemoveBlip(HotdogBlip)
        end

        HotdogBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
        
        SetBlipSprite(HotdogBlip, 80)
        SetBlipDisplay(HotdogBlip, 4)
        SetBlipScale(HotdogBlip, 0.6)
        SetBlipAsShortRange(HotdogBlip, true)
        SetBlipColour(HotdogBlip, 9)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Hotdog Stand")
        EndTextCommandSetBlipName(HotdogBlip)
    end)
end

function UpdateLevel()
    local MyRep = PlayerData.metadata["jobrep"]["hotdog"]

    if MyRep ~= nil then
        if MyRep >= 1 and MyRep < 50 then
            Config.MyLevel = 1
        elseif MyRep >= 50 and MyRep < 100 then
            Config.MyLevel = 2
        elseif MyRep >= 100 and MyRep < 200 then
            Config.MyLevel = 3
        elseif MyRep >= 100 and MyRep < 200 then
            Config.MyLevel = 3
        elseif MyRep >= 200 then
            Config.MyLevel = 4
        end
    else
        Config.MyLevel = 1
    end

    local ReturnData = {
        lvl = Config.MyLevel,
        rep = MyRep
    }

    return ReturnData
end

function DrawText3Ds(x, y, z, text)
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

Citizen.CreateThread(function()
    while true do
        local inRange = false
        if isLoggedIn then
            if Config ~= nil then
                local PlayerPed = PlayerPedId()
                local PlayerPos = GetEntityCoords(PlayerPed)

                local v = Config.Locations["take"]
                local distance = GetDistanceBetweenCoords(PlayerPos, v.coords.x, v.coords.y, v.coords.z, true)
                if distance < 10 then
                    inRange = true
                    DrawMarker(2, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 0, 0, 255, 0, 0, 0, 1, 0, 0, 0)
                    if not IsWorking then
                        if distance < OffsetData.Distance then
                            DrawText3Ds(v.coords.x, v.coords.y, v.coords.z, "~g~E~w~ - Start working")
                            if IsControlJustPressed(0, Keys["E"]) then
                                StartWorking()
                            end
                        elseif distance < 3 then
                            DrawText3Ds(v.coords.x, v.coords.y, v.coords.z, "Start working")
                        end
                    else
                        if distance < OffsetData.Distance then
                            DrawText3Ds(v.coords.x, v.coords.y, v.coords.z, "~g~E~w~ - Stop working")
                            if IsControlJustPressed(0, Keys["E"]) then
                                StopWorking()
                            end
                        elseif distance < 3 then
                            DrawText3Ds(v.coords.x, v.coords.y, v.coords.z, "Stop working")
                        end
                    end
                end

                local z = Config.Locations["take"]
            end
        end
        if not inRange then
            Citizen.Wait(1000)
        end
        Citizen.Wait(3)
    end
end)

RegisterNetEvent('xz-hotdogjob:client:updateRunningStand', function(shouldRemove, serverID)
    if shouldRemove then
        table.remove(runningStands, serverID)
    else
        table.insert(runningStands, serverID)
    end
end)

function StartWorking()
    XZCore.Functions.TriggerCallback('xz-hotdogjob:server:HasMoney', function(HasMoney)
        if HasMoney then
            local PlayerPed = PlayerPedId()
            local SpawnCoords = Config.Locations["spawn"].coords
            IsWorking = true
        
            LoadModel("prop_hotdogstand_01")
            StandObject = CreateObject(GetHashKey('prop_hotdogstand_01'), SpawnCoords.x, SpawnCoords.y, SpawnCoords.z, true)
            PlaceObjectOnGroundProperly(StandObject)
            SetEntityHeading(StandObject, SpawnCoords.h - 90)
            FreezeEntityPosition(StandObject, true)
            HotdogLoop()
            UpdateUI()
            CheckLoop()
            XZCore.Functions.Notify('You paid 200$.', 'success')
        else
            XZCore.Functions.Notify('You have no money for the deposit ..', 'error')
        end
    end)
end

function UpdateUI()
    IsUIActive = true
    Citizen.CreateThread(function()
        while true do
            SendNUIMessage({
                action = "UpdateUI",
                IsActive = IsUIActive,
                Stock = Config.Stock,
                Level = UpdateLevel()
            })
            if not IsUIActive then
                break
            end
            Citizen.Wait(1000)
        end
    end)
end

function HotdogLoop()
    Citizen.CreateThread(function()
        while true do
            local PlayerPed = PlayerPedId()
            local PlayerPos = GetEntityCoords(PlayerPed)
            local ClosestObject = GetClosestObjectOfType(PlayerPos.x, PlayerPos.y, PlayerPos.z, 3.0, GetHashKey("prop_hotdogstand_01"), 0, 0, 0)

            if StandObject ~= nil then
                if ClosestObject ~= nil and ClosestObject == StandObject then
                    local ObjectOffset = GetOffsetFromEntityInWorldCoords(ClosestObject, 1.0, 0.0, 1.0)
                    local ObjectDistance = GetDistanceBetweenCoords(PlayerPos, ObjectOffset.x, ObjectOffset.y, ObjectOffset.z, true)

                    if ObjectDistance < 1.0 then
                        if not IsPushing then
                            DrawText3Ds(ObjectOffset.x, ObjectOffset.y, ObjectOffset.z, '~g~E~w~ - Grab stall')
                            if IsControlJustPressed(0, Keys["E"]) then
                                TakeHotdogStand()
                            end
                        else
                            DrawText3Ds(ObjectOffset.x, ObjectOffset.y, ObjectOffset.z, '~g~E~w~ - Release stall')
                            if IsControlJustPressed(0, Keys["E"]) then
                                LetKraamLose()
                            end
                        end
                    elseif ObjectDistance < 3.0 then
                        DrawText3Ds(ObjectOffset.x, ObjectOffset.y, ObjectOffset.z, 'Grab stall')
                    end
                end
            else
                break
            end

            Citizen.Wait(3)
        end
    end)

    Citizen.CreateThread(function()
        while true do
            local PlayerPed = PlayerPedId()
            local PlayerPos = GetEntityCoords(PlayerPed)
            local ClosestObject = GetClosestObjectOfType(PlayerPos.x, PlayerPos.y, PlayerPos.z, 3.0, GetHashKey("prop_hotdogstand_01"), 0, 0, 0)

            if StandObject ~= nil then
                if ClosestObject ~= nil and ClosestObject == StandObject then
                    local ObjectOffset = GetOffsetFromEntityInWorldCoords(StandObject, 0.0, 0.0, 1.0)
                    local ObjectDistance = GetDistanceBetweenCoords(PlayerPos, ObjectOffset.x, ObjectOffset.y, ObjectOffset.z, true)

                    if ObjectDistance < 1.0 then
                        DrawText3Ds(ObjectOffset.x, ObjectOffset.y, ObjectOffset.z, '~g~E~w~ - Prepare Hotdogs')
                        if IsControlJustPressed(0, Keys["E"]) then
                            StartHotdogMinigame()
                        end
                    end
                end
            else
                break
            end

            Citizen.Wait(3)
        end
    end)
end

RegisterNetEvent('xz-hotdogjob:client:UpdateReputation', function(JobRep)
    PlayerData.metadata["jobrep"] = JobRep
    UpdateLevel()
end)

RegisterNetEvent('xz-hotdogjob:client:ToggleSell', function(data)
    if not SellingData.Enabled then
        SellingData.Enabled = true
        ToggleSell()
    else
        if SellingData.Target ~= nil then
            SetPedKeepTask(SellingData.Target, false)
            SetEntityAsNoLongerNeeded(SellingData.Target)
            ClearPedTasksImmediately(SellingData.Target)
        end
        SellingData.Enabled = false
        SellingData.Target = nil
        SellingData.HasTarget = false
    end
end)

function ToggleSell()
    local pos = GetEntityCoords(PlayerPedId())
    local objpos = GetEntityCoords(StandObject)
    local dist = GetDistanceBetweenCoords(pos, objpos.x, objpos.y, objpos.z, true)

    if StandObject ~= nil then
        if dist < 5.0 then
            Citizen.CreateThread(function()
                while true do
                    if SellingData.Enabled then
                        local player = PlayerPedId()
                        local coords = GetOffsetFromEntityInWorldCoords(StandObject, OffsetData.x, OffsetData.y, OffsetData.z)

                        if not SellingData.HasTarget then
                            local PlayerPeds = {}
                            if next(PlayerPeds) == nil then
                                for _, player in ipairs(GetActivePlayers()) do
                                    local ped = GetPlayerPed(player)
                                    table.insert(PlayerPeds, ped)
                                end
                            end
                            
                            local closestPed, closestDistance = XZCore.Functions.GetClosestPed(coords, PlayerPeds)

                            if closestDistance < 15.0 and closestPed ~= 0 then
                                SellToPed(closestPed)
                            end
                        end
                    else
                        break
                    end
                    Citizen.Wait(100)
                end
            end)
        else
            XZCore.Functions.Notify('You are too far from your Hotdog Stand..', 'error')
        end
    else
        XZCore.Functions.Notify('You dont have a Hotdog stand', 'error')
    end
end

function GetAvailableHotdog()
    local retval = nil
    local AvailableHotdogs = {}
    for k, v in pairs(Config.Stock) do
        if v.Current > 0 then
            table.insert(AvailableHotdogs, {
                key = k,
                value = v,
            })
        end
    end
    if next(AvailableHotdogs) ~= nil then
        local Random = math.random(1, #AvailableHotdogs)
        retval = AvailableHotdogs[Random].key
    end
    return retval
end

function SellToPed(ped)
    SellingData.HasTarget = true
    for i = 1, #SellingData.RecentPeds, 1 do
        if SellingData.RecentPeds[i] == ped then
            SellingData.HasTarget = false
            return
        end
    end

    SetEntityAsNoLongerNeeded(ped)
    ClearPedTasks(ped)

    local SellingPrice = 0
    local HotdogsForSale = 0

    local Selling = false
    local HotdogObject = nil
    local HotdogObject2 = nil
    local AnimPlayed = false

    SellingData.Hotdog = GetAvailableHotdog()

    if SellingData.Hotdog ~= nil then
        if Config.Stock[SellingData.Hotdog].Current > 1 then
            if Config.Stock[SellingData.Hotdog].Current >= 3 then
                HotdogsForSale = math.random(1, 3)
            else
                HotdogsForSale = math.random(1, Config.Stock[SellingData.Hotdog].Current)
            end
        elseif Config.Stock[SellingData.Hotdog].Current == 1 then
            HotdogsForSale = 1
        end

        if SellingData.Hotdog ~= nil then
            SellingPrice = math.random(Config.Stock[SellingData.Hotdog].Price[Config.MyLevel].min, Config.Stock[SellingData.Hotdog].Price[Config.MyLevel].max)
        end
    end

    local coords = GetOffsetFromEntityInWorldCoords(StandObject, OffsetData.x, OffsetData.y, OffsetData.z)
    local pedCoords = GetEntityCoords(ped)
    local pedDist = GetDistanceBetweenCoords(coords, pedCoords)
    local PlayerDist = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coords.x, coords.y, coords.z)

    TaskGoStraightToCoord(ped, coords, 1.2, -1, 0.0, 0.0)

    while pedDist > OffsetData.Distance do
        coords = GetOffsetFromEntityInWorldCoords(StandObject, OffsetData.x, OffsetData.y, OffsetData.z)
        PlayerDist = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coords.x, coords.y, coords.z)
        pedCoords = GetEntityCoords(ped)    
        TaskGoStraightToCoord(ped, coords, 1.2, -1, 0.0, 0.0)
        pedDist = GetDistanceBetweenCoords(coords, pedCoords)
        if PlayerDist > 15.0 then
            SellingData.HasTarget = false
            SetPedKeepTask(ped, false)
            SetEntityAsNoLongerNeeded(ped)
            ClearPedTasksImmediately(ped)
            table.insert(SellingData.RecentPeds, ped)
            SellingData = {
                Enabled = false,
                Target = nil,
                HasTarget = false,
                Hotdog = nil,
            }
            XZCore.Functions.Notify('Youre too far from your stall...', 'error')
            break
        end
        Citizen.Wait(100)
    end

    FreezeEntityPosition(ped, true)
    TaskLookAtEntity(ped, PlayerPedId(), 5500.0, 2048, 3)
    TaskTurnPedToFaceEntity(ped, PlayerPedId(), 5500)
    local heading = (GetEntityHeading(PlayerPedId()) + 180)
    SetEntityHeading(ped, heading)
    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT", 0, false)
    SellingData.Target = ped

    while pedDist < OffsetData.Distance and SellingData.HasTarget do
        coords = GetOffsetFromEntityInWorldCoords(StandObject, OffsetData.x, OffsetData.y, OffsetData.z)
        PlayerDist = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coords.x, coords.y, coords.z)
        pedCoords = GetEntityCoords(ped)
        pedDist = GetDistanceBetweenCoords(coords, pedCoords)

        if PlayerDist < 7.5 then
            if SellingData.Hotdog ~= nil then
                if HotdogsForSale == 0 and SellingPrice == 0 then
                    if Config.Stock[SellingData.Hotdog].Current > 1 then
                        if Config.Stock[SellingData.Hotdog].Current >= 3 then
                            HotdogsForSale = math.random(1, 3)
                        else
                            HotdogsForSale = math.random(1, Config.Stock[SellingData.Hotdog].Current)
                        end
                    elseif Config.Stock[SellingData.Hotdog].Current == 1 then
                        HotdogsForSale = 1
                    end
            
                    if SellingData.Hotdog ~= nil then
                        SellingPrice = math.random(Config.Stock[SellingData.Hotdog].Price.min, Config.Stock[SellingData.Hotdog].Price.max)
                    end
                end
                XZCore.Functions.DrawText3D(pedCoords.x, pedCoords.y, pedCoords.z, '[7] Sale '..HotdogsForSale..'x for €'..(HotdogsForSale * SellingPrice)..' / [8] Reject')
                if IsControlJustPressed(0, Keys["7"]) or IsDisabledControlJustPressed(0, Keys["7"]) then
                    TriggerEvent('xz-scripts:client:locationChange', 'b')
                    XZCore.Functions.Notify(HotdogsForSale..'x Hotdog(\'s) sold for €'..(HotdogsForSale * SellingPrice)..'.', 'success')
                    TriggerServerEvent('xz-hotdogjob:server:Pay', HotdogsForSale, SellingPrice)
                    SellingData.HasTarget = false
                    local Myped = PlayerPedId()

                    Selling = true

                    while Selling do
                        if not IsEntityPlayingAnim(Myped, 'mp_common', 'givetake1_b', 3) then
                            LoadAnim('mp_common')
                            if not AnimPlayed then
                                TaskPlayAnim(Myped, 'mp_common', 'givetake1_b', 8.0, 8.0, 1100, 48, 0.0, 0, 0, 0)
                                AnimPlayed = true
                            end
                            if HotdogObject == nil then
                                HotdogObject = CreateObject(GetHashKey("prop_cs_hotdog_01"), 0, 0, 0, true, true, true)
                            end
                            AttachEntityToEntity(HotdogObject, Myped, GetPedBoneIndex(Myped, 57005), 0.12, 0.0, -0.05, 220.0, 120.0, 0.0, true, true, false, true, 1, true)
                            SetTimeout(1250, function()
                                Selling = false
                            end)
                        end

                        Citizen.Wait(0)
                    end

                    if HotdogObject ~= nil then
                        DetachEntity(HotdogObject, 1, 1)
                        DeleteEntity(HotdogObject)
                        AnimPlayed = false
                        HotdogObject = nil
                    end

                    FreezeEntityPosition(ped, false)
                    SetPedKeepTask(ped, false)
                    SetEntityAsNoLongerNeeded(ped)
                    ClearPedTasksImmediately(ped)
                    table.insert(SellingData.RecentPeds, ped)
                    Config.Stock[SellingData.Hotdog].Current = Config.Stock[SellingData.Hotdog].Current - HotdogsForSale
                    SellingData.Hotdog = nil
                    SellingPrice = 0
                    HotdogsForSale = 0
                    break
                end

                if IsControlJustPressed(0, Keys["8"]) or IsDisabledControlJustPressed(0, Keys["8"]) then
                    XZCore.Functions.Notify('Customer refused!', 'error')
                    SellingData.HasTarget = false

                    FreezeEntityPosition(ped, false)
                    SetPedKeepTask(ped, false)
                    SetEntityAsNoLongerNeeded(ped)
                    ClearPedTasksImmediately(ped)
                    table.insert(SellingData.RecentPeds, ped)
                    SellingData.Hotdog = nil
                    SellingPrice = 0
                    HotdogsForSale = 0
                    break
                end
            else
                SellingData.Hotdog = GetAvailableHotdog()
                XZCore.Functions.DrawText3D(pedCoords.x, pedCoords.y, pedCoords.z, 'You have no stock ../ [8] Refuse customer')

                if IsControlJustPressed(0, Keys["8"]) or IsDisabledControlJustPressed(0, Keys["8"]) then
                    XZCore.Functions.Notify('Customer refused!', 'error')
                    SellingData.HasTarget = false

                    FreezeEntityPosition(ped, false)
                    SetPedKeepTask(ped, false)
                    SetEntityAsNoLongerNeeded(ped)
                    ClearPedTasksImmediately(ped)
                    table.insert(SellingData.RecentPeds, ped)
                    SellingData.Hotdog = nil
                    break
                end
            end
        else
            SellingData.HasTarget = false
            FreezeEntityPosition(ped, false)
            SetPedKeepTask(ped, false)
            SetEntityAsNoLongerNeeded(ped)
            ClearPedTasksImmediately(ped)
            table.insert(SellingData.RecentPeds, ped)
            SellingData = {
                Enabled = false,
                Target = nil,
                HasTarget = false,
                Hotdog = nil,
            }
            XZCore.Functions.Notify('Youre too far from your stall ...', 'error')
            break
        end
        
        Citizen.Wait(3)
    end
end

function StartHotdogMinigame()
    PrepareAnim()
    TriggerEvent('xz-keyminigame:show')
    TriggerEvent('xz-keyminigame:start', FinishMinigame)
end

function PrepareAnim()
    local ped = PlayerPedId()
    LoadAnim('amb@prop_human_bbq@male@idle_a')
    TaskPlayAnim(ped, 'amb@prop_human_bbq@male@idle_a', 'idle_b', 6.0, -6.0, -1, 47, 0, 0, 0, 0)
    SpatelObject = CreateObject(GetHashKey("prop_fish_slice_01"), 0, 0, 0, true, true, true)
    AttachEntityToEntity(SpatelObject, ped, GetPedBoneIndex(ped, 57005), 0.08, 0.0, -0.02, 0.0, -25.0, 130.0, true, true, false, true, 1, true)
    PreparingAnimCheck()
end

function PreparingAnimCheck()
    PreparingFood = true
    Citizen.CreateThread(function()
        while true do
            local ped = PlayerPedId()

            if PreparingFood then
                if not IsEntityPlayingAnim(ped, 'amb@prop_human_bbq@male@idle_a', 'idle_b', 3) then
                    LoadAnim('amb@prop_human_bbq@male@idle_a')
                    TaskPlayAnim(ped, 'amb@prop_human_bbq@male@idle_a', 'idle_b', 6.0, -6.0, -1, 49, 0, 0, 0, 0)
                end
            else
                DetachEntity(SpatelObject)
                DeleteEntity(SpatelObject)
                ClearPedTasksImmediately(ped)
                break
            end

            Citizen.Wait(200)
        end
    end)
end

function FinishMinigame(faults)
    local Quality = "common"
    if faults == 0 then
        Quality = "exotic"
    elseif faults == 1 then
        Quality = "rare"
    end
    if Config.Stock[Quality].Current + 1 <= Config.Stock[Quality].Max[Config.MyLevel] then
        TriggerServerEvent('xz-hotdogjob:server:UpdateReputation', Quality)
        if Config.MyLevel == 1 then
            XZCore.Functions.Notify('You have made '..Config.Stock[Quality].Label..' Hotdog!')
			TriggerServerEvent('XZCore:Server:AddItem', "hotdog", 1)
			TriggerEvent('inventory:client:ItemBox', XZCore.Shared.Items["hotdog"], "add")
			TriggerServerEvent("hotdog:cash")
            Config.Stock[Quality].Current = Config.Stock[Quality].Current + 1
        else
            local Luck = math.random(1, 2)
            local LuckyNumber = math.random(1, 2)
            local LuckyAmount = math.random(1, Config.MyLevel)
            if Luck == LuckyNumber then
                XZCore.Functions.Notify('You have made '..LuckyAmount..' '..Config.Stock[Quality].Label..' Hotdog!')
                Config.Stock[Quality].Current = Config.Stock[Quality].Current + LuckyAmount
            else
                XZCore.Functions.Notify('You have made '..Config.Stock[Quality].Label..' Hotdog!')
                Config.Stock[Quality].Current = Config.Stock[Quality].Current + 1
            end
        end
    else
        XZCore.Functions.Notify('You do not have ('..Config.Stock[Quality].Label..') stock more about it..')
    end
    PreparingFood = false
end

function TakeHotdogStand()
    local PlayerPed = PlayerPedId()
    IsPushing = true
    NetworkRequestControlOfEntity(StandObject)
    LoadAnim(AnimationData.lib)
    TaskPlayAnim(PlayerPed, AnimationData.lib, AnimationData.anim, 8.0, 8.0, -1, 50, 0, false, false, false)
    SetTimeout(150, function()
        AttachEntityToEntity(StandObject, PlayerPed, GetPedBoneIndex(PlayerPed, 28422), -0.45, -1.2, -0.82, 180.0, 180.0, 270.0, false, false, false, false, 1, true)
    end)
    FreezeEntityPosition(StandObject, false)
    AnimLoop()
end

function LetKraamLose()
    local PlayerPed = PlayerPedId()
    DetachEntity(StandObject)
    SetEntityCollision(StandObject, true, true)
    ClearPedTasks(PlayerPed)
    IsPushing = false
end

function AnimLoop()
    Citizen.CreateThread(function()
        while true do
            if IsPushing then
                local PlayerPed = PlayerPedId()
                if not IsEntityPlayingAnim(PlayerPed, AnimationData.lib, AnimationData.anim, 3) then
                    LoadAnim(AnimationData.lib)
                    TaskPlayAnim(PlayerPed, AnimationData.lib, AnimationData.anim, 8.0, 8.0, -1, 50, 0, false, false, false)
                end
            else
                break
            end
            Citizen.Wait(1000)
        end
    end)
end

function StopWorking()
    if DoesEntityExist(StandObject) then
        XZCore.Functions.TriggerCallback('xz-hotdogjob:server:BringBack', function(DidBail)
            if DidBail then
                DeleteObject(StandObject)
                ClearPedTasksImmediately(PlayerPedId())
                IsWorking = false
                StandObject = nil
                IsPushing = false
                IsSelling = false
                IsUIActive = false
        
                for _, v in pairs(Config.Stock) do
                    v.Current = 0
                end
                XZCore.Functions.Notify('You have received your deposit back!', 'success')
            else
                XZCore.Functions.Notify('Failed', 'error')
            end
        end)
    else
        XZCore.Functions.Notify('Your hot dog stall was nowhere to be seen, you did NOT receive your deposit back!', 'error')
        IsWorking = false
        StandObject = nil
        IsPushing = false
        IsSelling = false
        IsUIActive = false

        for _, v in pairs(Config.Stock) do
            v.Current = 0
        end
    end
end

local DetachKeys = {157, 158, 160, 164, 165, 73, 36, 44}
function CheckLoop()
    Citizen.CreateThread(function()
        while true do
            if IsWorking then
                if IsPushing then
                    for _, PressedKey in pairs(DetachKeys) do
                        if IsControlJustPressed(0, PressedKey) or IsDisabledControlJustPressed(0, PressedKey) then
                            LetKraamLose()
                        end
                    end

                    if IsPedShooting(PlayerPedId()) or IsPlayerFreeAiming(PlayerId()) or IsPedInMeleeCombat(PlayerPedId()) then
                        LetKraamLose()
                    end

                    if IsPedDeadOrDying(PlayerPedId(), false) then
                        LetKraamLose()
                    end

                    if IsPedRagdoll(PlayerPedId()) then
                        LetKraamLose()
                    end
                else
                    Citizen.Wait(1000)
                end
            else
                break
            end
            Citizen.Wait(5)
        end
    end)
end

RegisterNetEvent('xz-hotdogjob:staff:DeletStand', function()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local Object = GetClosestObjectOfType(pos.x, pos.y, pos.z, 10.0, GetHashKey('prop_hotdogstand_01'), true, false, false)
    
    if Object ~= nil then
        local ObjectCoords = GetEntityCoords(Object)
        local ObjectDistance = GetDistanceBetweenCoords(pos, ObjectCoords.x, ObjectCoords.y, ObjectCoords.z, true)

        if ObjectDistance <= 5 then
            NetworkRegisterEntityAsNetworked(Object)
            Citizen.Wait(100)           
            NetworkRequestControlOfEntity(Object)            
            if not IsEntityAMissionEntity(Object) then
                SetEntityAsMissionEntity(Object)        
            end
            Citizen.Wait(100)            
            DeleteEntity(Object)
            XZCore.Functions.Notify('Hot dog stand removed!')
        end
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if StandObject ~= nil then
            DeleteObject(StandObject)
            ClearPedTasksImmediately(PlayerPedId())
        end
    end
end)

function LoadAnim(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(1)
    end
end

function LoadModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(1)
    end
end

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        Wait(100)
        isLoggedIn = true
        PlayerData = XZCore.Functions.GetPlayerData()
        PlayerJob = PlayerData.job
        UpdateLevel()
        UpdateBlip()
    end
end)
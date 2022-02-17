local CurrentCops = 0
local Timeout = 0
local isLoggedIn = false
local Start = false
local Attempts = 0
local isBusy = false
local onTimeout = false
local Config, PlayerData = load(LoadResourceFile(GetCurrentResourceName(), 'config.lua'))()

Citizen.CreateThread(function()
    exports['xz-interact']:AddTargetModel(Config.ATMModels, {
        options = {
            {
                type = "client",
                event = "xz-atmrobbery:client:doRobbery",
                icon = Config.TargetIcon,
                label = Config.TargetLabel,
                canInteract = function()
                    local Weapon = type(Config.NeededHoldingWeapon) == 'number' and Config.NeededHoldingWeapon or GetHashKey(Config.NeededHoldingWeapon:upper())
                    if Config.OnlyNight then
                        if GetClockHours() > 22 and GetClockHours() < 5 then
                            if Config.UseItems then
                                local hasitem = nil
                                XZCore.Functions.TriggerCallback('XZCore:HasItem', function(result)
                                    if result then hasitem = result end
                                end, Config.NeededItem)
                                while hasitem == nil do
                                    Wait(1)
                                end
                                if (hasitem and not Config.UseWeapons) or (hasitem and Config.UseWeapons and GetSelectedPedWeapon(PlayerPedId()) == Weapon) then
                                    return true
                                else
                                    return false
                                end
                            else
                                return true
                            end
                        else
                            return false
                        end
                    else
                        if Config.UseItems then
                            local hasitem = nil
                            XZCore.Functions.TriggerCallback('XZCore:HasItem', function(result)
                                if result then hasitem = result end
                            end, Config.NeededItem)
                            while hasitem == nil do
                                Wait(1)
                            end
                            if (hasitem and not Config.UseWeapons) or (hasitem and Config.UseWeapons and GetSelectedPedWeapon(PlayerPedId()) == Weapon) then
                                return true
                            else
                                return false
                            end
                        else
                            return true
                        end
                    end
                end,
            }
        }
    })
end)

RegisterNetEvent('XZCore:Client:OnPlayerLoaded')
AddEventHandler('XZCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerData = XZCore.Functions.GetPlayerData()
    XZCore.Functions.TriggerCallback('xz-atmrobbery:server:checkCopCount', function(result, res2)
        if result then
            CurrentCops = result
        end
        if res2 then
            Timeout = res2
        end
    end)
end)

RegisterNetEvent('XZCore:Client:OnPlayerUnload')
AddEventHandler('XZCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
    PlayerData = {}
    isBusy = false
    XZCore.Functions.TriggerCallback('xz-atmrobbery:server:checkCopCount', function(result, res2)
        if result then
            CurrentCops = result
        end
        if res2 then
            Timeout = res2
        end
    end)
end)

RegisterNetEvent('XZCore:Client:OnJobUpdate')
AddEventHandler('XZCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
    XZCore.Functions.TriggerCallback('xz-atmrobbery:server:checkCopCount', function(result, res2)
        if result then
            CurrentCops = result
        end
        if res2 then
            Timeout = res2
        end
    end)
end)

RegisterNetEvent('XZCore:Player:SetPlayerData')
AddEventHandler('XZCore:Player:SetPlayerData', function(val)
    PlayerData = val
end)

RegisterNetEvent('xz-atmrobbery:client:setSync')
AddEventHandler('xz-atmrobbery:client:setSync', function(val, val2)
    Timeout = val
    isBusy = val2
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        Wait(100)
        isBusy = false
        PlayerData = XZCore.Functions.GetPlayerData()
        XZCore.Functions.TriggerCallback('xz-atmrobbery:server:checkCopCount', function(result, res2)
            if result then
                CurrentCops = result
            end
            if res2 then
                Timeout = res2
            end
        end)
    end
end)

local GetStreetAndZone = function()
    local plyPos = GetEntityCoords(PlayerPedId(), true)
    local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local zone = GetLabelText(GetNameOfZone(plyPos.x, plyPos.y, plyPos.z))
    local street = street1 .. ", " .. zone
    return street
end

local uuid = function()
    math.randomseed(GetCloudTimeAsInt())
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function(c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)
end

local IsWearingHandshoes = function()
    local ped = PlayerPedId()
    local armIndex = GetPedDrawableVariation(ped, 3)
    local model = GetEntityModel(ped)
    local retval = true
    if model == `mp_m_freemode_01` then
        if Config.MaleNoHandshoes[armIndex] ~= nil and Config.MaleNoHandshoes[armIndex] then
            retval = false
        end
    else
        if Config.FemaleNoHandshoes[armIndex] ~= nil and Config.FemaleNoHandshoes[armIndex] then
            retval = false
        end
    end
    return retval
end

RegisterNetEvent('xz-atmrobbery:client:doRobbery')
AddEventHandler('xz-atmrobbery:client:doRobbery', function()
    if not onTimeout then
        Start = true
    end
    Attempts = Attempts + 1
    if Attempts >= 7 then
        XZCore.Functions.Notify("You have failed too many times, you're now on a cooldown", 'error')
        TriggerServerEvent('xz-atmrobbery:server:onRobberyFinish', false, false, false, false, false, false, false, true)
    else
        if Timeout ~= nil and Timeout > 0 then
            XZCore.Functions.Notify('The robbery is on timeout for '..Timeout..' minutes', 'error')
        else
            if Config.NeededCops <= CurrentCops then
                if not PlayerData.metadata['isdead'] and not PlayerData.metadata['inlaststand'] and not exports['xz-interact']:IsTargetActive() and not isBusy then
                    isBusy = true
                    local ped = PlayerPedId()
                    if Attempts == 1 then
                        TriggerServerEvent('dispatch:svNotify', {
                            dispatchCode = "10-41A",
                            firstStreet = GetStreetAndZone(),
                            gender = IsPedMale(ped),
                            eventId = uuid(),
                            origin = GetEntityCoords(ped)
                        })
                    end
                    if exports["xz-taskbarskill"]:taskBar(Config.TaskBarSkillDifficulty, Config.TaskBarSkillCount) ~= 100 then
                        XZCore.Functions.Notify(Config.FailMessage, 'error')
                        isBusy = false
                    else
                        XZCore.Functions.Progressbar('rob_atm', Config.ProgressLabel, Config.ProgressDuration, false, true, {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        }, {
                            animDict = Config.ProgressAnimDict,
                            anim = Config.ProgressAnim,
                            flag = Config.ProgressAnimFlag
                        }, {}, {}, function() -- Finish
                            ClearPedTasks(ped)
                            if math.random(1, 100) <= 85 and not IsWearingHandshoes() then
                                TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
                            end
                            TriggerServerEvent('xz-atmrobbery:server:onRobberyFinish', Config.UseLootTable, Config.MoneyReward, Config.MoneyRewardMessage, Config.ItemRewardMessage, Config.LootTable, Config.FullInventoryMessage, Config.RobberyTimeout, false)
                        end, function() -- Cancel
                            if math.random(1, 100) <= 85 and not IsWearingHandshoes() then
                                TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
                            end
                            ClearPedTasks(ped)
                            isBusy = false
                        end)
                    end
                else
                    XZCore.Functions.Notify(Config.BusyMessage, 'error')
                end
            else
                XZCore.Functions.Notify(Config.NoCopsMessage, 'error')
            end
        end
    end
end)

local StartTimeout = function()
    onTimeout = true
    Wait(3 * (60 * 1000))
    Attempts = 0
    onTimeout = false
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if Start and isLoggedIn then
            StartTimeout()
            Start = false
        end
    end
end)
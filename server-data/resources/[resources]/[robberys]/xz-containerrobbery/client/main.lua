local CurrentCops = 0
local Timeout = 0
local isLoggedIn = false
local isBusy = false
local onTimeout = false
local Config, PlayerData = load(LoadResourceFile(GetCurrentResourceName(), 'config.lua'))()

Citizen.CreateThread(function()
    exports['xz-interact']:AddBoxZone("truck1", vector3(-468.86, -2822.38, 7.3), 1.0, 2.0, {
        name = "truck1",
        heading = 44.0,
        debugPoly = false,
        minZ = 6.5,
        maxZ = 9.0,
    }, {
        options = {
            {
                event = "xz-containerrobbery:client:doRobbery",
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
        },
        distance = 2.5
    })
    exports['xz-interact']:AddBoxZone("truck2", vector3(-485.91, -2839.83, 7.3), 1.0, 2.0, {
        name = "truck2",
        heading = 49.0,
        debugPoly = false,
        minZ = 6.5,
        maxZ = 9.0,
    }, {
        options = {
            {
                event = "xz-containerrobbery:client:doRobbery",
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
        },
        distance = 2.5
    })
    exports['xz-interact']:AddBoxZone("truck3", vector3(-513.08, -2866.55, 7.3), 1.0, 2.0, {
        name = "truck3",
        heading = 43.0,
        debugPoly = false,
        minZ = 6.5,
        maxZ = 9.0,
    }, {
        options = {
            {
                event = "xz-containerrobbery:client:doRobbery",
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
        },
        distance = 2.5
    })
    exports['xz-interact']:AddBoxZone("container1", vector3(-433.89, -2742.66, 6.0), 1.0, 2.0, {
        name = "container1",
        heading = 178.69,
        debugPoly = false,
        minZ = 5.5,
        maxZ = 7.5,
    }, {
        options = {
            {
                event = "xz-containerrobbery:client:doRobbery",
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
        },
        distance = 2.5
    })
    exports['xz-interact']:AddBoxZone("container2", vector3(-438.58, -2742.56, 6.0), 1.0, 2.0, {
        name = "container2",
        heading = 177.04,
        debugPoly = false,
        minZ = 5.5,
        maxZ = 7.5,
    }, {
        options = {
            {
                event = "xz-containerrobbery:client:doRobbery",
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
        },
        distance = 2.5
    })
    exports['xz-interact']:AddBoxZone("container3", vector3(-419.97, -2742.65, 6.0), 1.0, 2.0, {
        name = "container3",
        heading = 181.76,
        debugPoly = false,
        minZ = 5.5,
        maxZ = 7.5,
    }, {
        options = {
            {
                event = "xz-containerrobbery:client:doRobbery",
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
        },
        distance = 2.5
    })
    exports['xz-interact']:AddBoxZone("container4", vector3(-73.09, -2213.74, 7.81), 1.0, 2.0, {
        name = "container4",
        heading = 269.0,
        debugPoly = false,
        minZ = 7.5,
        maxZ = 9.5,
    }, {
        options = {
            {
                event = "xz-containerrobbery:client:doRobbery",
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
        },
        distance = 2.5
    })
    exports['xz-interact']:AddBoxZone("container5", vector3(-70.42, -2210.01, 7.81), 1.0, 2.0, {
        name = "container5",
        heading = 269.85,
        debugPoly = false,
        minZ = 7.5,
        maxZ = 9.5,
    }, {
        options = {
            {
                event = "xz-containerrobbery:client:doRobbery",
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
        },
        distance = 2.5
    })
    exports['xz-interact']:AddBoxZone("container6", vector3(-65.43, -2194.22, 7.82), 1.0, 2.0, {
        name = "container6",
        heading = 269.83,
        debugPoly = false,
        minZ = 7.5,
        maxZ = 9.5,
    }, {
        options = {
            {
                event = "xz-containerrobbery:client:doRobbery",
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
        },
        distance = 2.5
    })
    exports['xz-interact']:AddBoxZone("container7", vector3(1737.47, -1690.92, 112.72), 1.0, 2.0, {
        name = "container7",
        heading = 303.91,
        debugPoly = false,
        minZ = 112.5,
        maxZ = 114.5,
    }, {
        options = {
            {
                event = "xz-containerrobbery:client:doRobbery",
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
        },
        distance = 2.5
    })
    exports['xz-interact']:AddBoxZone("container8", vector3(1739.83, -1621.4, 112.42), 1.0, 2.0, {
        name = "container8",
        heading = 13.38,
        debugPoly = false,
        minZ = 112.0,
        maxZ = 114.0,
    }, {
        options = {
            {
                event = "xz-containerrobbery:client:doRobbery",
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
        },
        distance = 2.5
    })
    exports['xz-interact']:AddBoxZone("container9", vector3(1412.78, -736.21, 67.49), 1.0, 2.0, {
        name = "container9",
        heading = 359.0,
        debugPoly = false,
        minZ = 67.0,
        maxZ = 69.0,
    }, {
        options = {
            {
                event = "xz-containerrobbery:client:doRobbery",
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
        },
        distance = 2.5
    })
    exports['xz-interact']:AddBoxZone("container10", vector3(1401.89, -706.74, 67.51), 1.0, 2.0, {
        name = "container10",
        heading = 48.88,
        debugPoly = false,
        minZ = 67.0,
        maxZ = 69.0,
    }, {
        options = {
            {
                event = "xz-containerrobbery:client:doRobbery",
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
        },
        distance = 2.5
    })
    exports['xz-interact']:AddBoxZone("container11", vector3(578.43, -504.54, 24.75), 1.0, 2.0, {
        name = "container11",
        heading = 206.65,
        debugPoly = false,
        minZ = 24.2,
        maxZ = 26.2,
    }, {
        options = {
            {
                event = "xz-containerrobbery:client:doRobbery",
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
        },
        distance = 2.5
    })
    exports['xz-interact']:AddBoxZone("container12", vector3(432.75, -572.7, 28.53), 1.0, 2.0, {
        name = "container12",
        heading = 322.12,
        debugPoly = false,
        minZ = 28.0,
        maxZ = 30.0,
    }, {
        options = {
            {
                event = "xz-containerrobbery:client:doRobbery",
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
        },
        distance = 2.5
    })
    exports['xz-interact']:AddBoxZone("container13", vector3(1008.97, -1921.23, 31.14), 1.0, 2.0, {
        name = "container13",
        heading = 347.53,
        debugPoly = false,
        minZ = 30.5,
        maxZ = 32.5,
    }, {
        options = {
            {
                event = "xz-containerrobbery:client:doRobbery",
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
        },
        distance = 2.5
    })
    exports['xz-interact']:AddBoxZone("container14", vector3(993.05, -1969.33, 30.71), 1.0, 2.0, {
        name = "container14",
        heading = 88.68,
        debugPoly = false,
        minZ = 30.5,
        maxZ = 32.5,
    }, {
        options = {
            {
                event = "xz-containerrobbery:client:doRobbery",
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
        },
        distance = 2.5
    })
    exports['xz-interact']:AddBoxZone("container15", vector3(993.33, -1965.75, 30.73), 1.0, 2.0, {
        name = "container15",
        heading = 97.82,
        debugPoly = false,
        minZ = 30.5,
        maxZ = 32.5,
    }, {
        options = {
            {
                event = "xz-containerrobbery:client:doRobbery",
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
        },
        distance = 2.5
    })
    exports['xz-interact']:AddBoxZone("container16", vector3(970.09, -1949.76, 30.87), 1.0, 2.0, {
        name = "container16",
        heading = 86.36,
        debugPoly = false,
        minZ = 30.5,
        maxZ = 32.5,
    }, {
        options = {
            {
                event = "xz-containerrobbery:client:doRobbery",
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
        },
        distance = 2.5
    })
    exports['xz-interact']:AddBoxZone("container17", vector3(969.41, -1947.02, 30.92), 1.0, 2.0, {
        name = "container17",
        heading = 85.66,
        debugPoly = false,
        minZ = 30.5,
        maxZ = 32.5,
    }, {
        options = {
            {
                event = "xz-containerrobbery:client:doRobbery",
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
        },
        distance = 2.5
    })
    exports['xz-interact']:AddBoxZone("container18", vector3(969.5, -1944.18, 31.01), 1.0, 2.0, {
        name = "container18",
        heading = 87.02,
        debugPoly = false,
        minZ = 30.5,
        maxZ = 32.5,
    }, {
        options = {
            {
                event = "xz-containerrobbery:client:doRobbery",
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
        },
        distance = 2.5
    })
    exports['xz-interact']:AddBoxZone("container19", vector3(969.81, -1941.53, 31.1), 1.0, 2.0, {
        name = "container19",
        heading = 87.61,
        debugPoly = false,
        minZ = 30.5,
        maxZ = 32.5,
    }, {
        options = {
            {
                event = "xz-containerrobbery:client:doRobbery",
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
        },
        distance = 2.5
    })
    exports['xz-interact']:AddBoxZone("container20", vector3(52.43, -1637.24, 29.29), 1.0, 2.0, {
        name = "container20",
        heading = 48.44,
        debugPoly = false,
        minZ = 28.8,
        maxZ = 30.8,
    }, {
        options = {
            {
                event = "xz-containerrobbery:client:doRobbery",
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
        },
        distance = 2.5
    })
    exports['xz-interact']:AddBoxZone("container21", vector3(54.44, -1633.81, 29.35), 1.0, 2.0, {
        name = "container21",
        heading = 50.69,
        debugPoly = false,
        minZ = 28.8,
        maxZ = 30.8,
    }, {
        options = {
            {
                event = "xz-containerrobbery:client:doRobbery",
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
        },
        distance = 2.5
    })
    exports['xz-interact']:AddBoxZone("truck4", vector3(932.98, -1732.98, 31.73), 1.0, 2.0, {
        name = "truck4",
        heading = 94.9,
        debugPoly = false,
        minZ = 31.5,
        maxZ = 33.5,
    }, {
        options = {
            {
                event = "xz-containerrobbery:client:doRobbery",
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
        },
        distance = 2.5
    })
    exports['xz-interact']:AddBoxZone("truck5", vector3(803.81, -1686.35, 30.89), 1.0, 2.0, {
        name = "truck5",
        heading = 284.03,
        debugPoly = false,
        minZ = 30.5,
        maxZ = 32.5,
    }, {
        options = {
            {
                event = "xz-containerrobbery:client:doRobbery",
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
        },
        distance = 2.5
    })
    exports['xz-interact']:AddBoxZone("truck6", vector3(804.28, -1681.65, 30.89), 1.0, 2.0, {
        name = "truck6",
        heading = 283.09,
        debugPoly = false,
        minZ = 30.5,
        maxZ = 32.5,
    }, {
        options = {
            {
                event = "xz-containerrobbery:client:doRobbery",
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
        },
        distance = 2.5
    })
    exports['xz-interact']:AddBoxZone("truck7", vector3(804.84, -1675.07, 30.89), 1.0, 2.0, {
        name = "truck7",
        heading = 282.59,
        debugPoly = false,
        minZ = 30.5,
        maxZ = 32.5,
    }, {
        options = {
            {
                event = "xz-containerrobbery:client:doRobbery",
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
        },
        distance = 2.5
    })
    exports['xz-interact']:AddBoxZone("truck8", vector3(806.39, -1659.72, 30.89), 1.0, 2.0, {
        name = "truck8",
        heading = 286.9,
        debugPoly = false,
        minZ = 30.5,
        maxZ = 32.5,
    }, {
        options = {
            {
                event = "xz-containerrobbery:client:doRobbery",
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
        },
        distance = 2.5
    })
    exports['xz-interact']:AddBoxZone("container22", vector3(1153.52, -1336.07, 34.69), 1.0, 2.0, {
        name = "container22",
        heading = 267.76,
        debugPoly = false,
        minZ = 34.0,
        maxZ = 36.0,
    }, {
        options = {
            {
                event = "xz-containerrobbery:client:doRobbery",
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
        },
        distance = 2.5
    })
end)

RegisterNetEvent('XZCore:Client:OnPlayerLoaded')
AddEventHandler('XZCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerData = XZCore.Functions.GetPlayerData()
    XZCore.Functions.TriggerCallback('xz-containerrobbery:server:checkCopCount', function(result, res2)
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
    XZCore.Functions.TriggerCallback('xz-containerrobbery:server:checkCopCount', function(result, res2)
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
    XZCore.Functions.TriggerCallback('xz-containerrobbery:server:checkCopCount', function(result, res2)
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

RegisterNetEvent('xz-containerrobbery:client:setSync')
AddEventHandler('xz-containerrobbery:client:setSync', function(val)
    Timeout = val
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        Wait(100)
        isLoggedIn = true
        PlayerData = XZCore.Functions.GetPlayerData()
        XZCore.Functions.TriggerCallback('xz-containerrobbery:server:checkCopCount', function(result, res2)
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

RegisterNetEvent('xz-containerrobbery:client:doRobbery')
AddEventHandler('xz-containerrobbery:client:doRobbery', function()
    if not onTimeout then
        Start = true
    end
    Attempts = Attempts + 1
    if Attempts >= 5 then
        TriggerServerEvent('xz-containerrobbery:server:onRobberyFinish', false, false, false, false, false, false, false, true)
    else
        if Timeout ~= nil and Timeout > 0 then
            XZCore.Functions.Notify('The robbery is on timeout for '..Timeout..' minutes', 'error')
        else
            if Config.NeededCops <= CurrentCops then
                if not PlayerData.metadata['isdead'] and not PlayerData.metadata['inlaststand'] and not isBusy then
                    isBusy = true
                    local ped = PlayerPedId()
                    if exports["xz-taskbarskill"]:taskBar(Config.TaskBarSkillDifficulty, Config.TaskBarSkillCount) ~= 100 then
                        XZCore.Functions.Notify(Config.FailMessage, 'error')
                        isBusy = false
                    else
                        TriggerServerEvent('dispatch:svNotify', {
                            dispatchCode = "10-42B",
                            firstStreet = GetStreetAndZone(),
                            gender = IsPedMale(ped),
                            eventId = uuid(),
                            origin = GetEntityCoords(ped)
                        })
                        XZCore.Functions.Progressbar('rob_container', Config.ProgressLabel, Config.ProgressDuration, false, true, {
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
                            TriggerServerEvent('xz-containerrobbery:server:onRobberyFinish', Config.UseLootTable, Config.MoneyReward, Config.MoneyRewardMessage, Config.ItemRewardMessage, Config.LootTable, Config.FullInventoryMessage, Config.RobberyTimeout, false)
                            isBusy = false
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
    onTimeout = false
    Attempts = 0
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
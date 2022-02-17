function DrawText3D(x, y, z, text)
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

local menuItem = {}

Citizen.CreateThread(function()

    for k, v in pairs(Config.Vehicles) do
        menuItem[#menuItem + 1] = {
            title = v,
            description= "Take out " .. v,
            event = "xz-police:client:takeOutVehicle",
            eventType = "client",
            args = {
                ["model"] = k
            },
            close = true,
        }
    end

end)

RegisterNetEvent('xz-police:client:toggleDuty', function()
    onDuty = not onDuty
    TriggerServerEvent("police:server:UpdateCurrentCops")
    TriggerServerEvent("XZCore:ToggleDuty")
    TriggerServerEvent("police:server:UpdateBlips")
    TriggerEvent('xz-policealerts:ToggleDuty', onDuty)
end)

RegisterNetEvent('xz-police:client:openArmory', function()
    if onDuty then
        TriggerServerEvent("inventory:server:OpenInventory", "shop", "police", GenerateItemsForGrade(PlayerJob.grade.level))
    end
end)

RegisterNetEvent('xz-police:client:putVestOn', function()
    if onDuty then
        TriggerEvent('animations:client:EmoteCommandStart', {"adjusttie"})
        Progressbar(5000,"Armor")
        SetPedArmour(PlayerPedId(), 100)
        XZCore.Functions.Notify("Done!", "success")
    end
end)

RegisterNetEvent('xz-police:client:openEvidence1', function()
    if onDuty then
        TriggerServerEvent("inventory:server:OpenInventory", "stash", "policeevidence", {
            maxweight = 4000000,
            slots = 500,
        })
        TriggerEvent("inventory:client:SetCurrentStash", "policeevidence")
    end
end)

RegisterNetEvent('xz-police:client:openEvidence2', function()
    if onDuty then
        TriggerServerEvent("inventory:server:OpenInventory", "stash", "policeevidence2", {
            maxweight = 4000000,
            slots = 500,
        })
        TriggerEvent("inventory:client:SetCurrentStash", "policeevidence2")
    end
end)

RegisterNetEvent('xz-police:client:openEvidence3', function()
    if onDuty then
        TriggerServerEvent("inventory:server:OpenInventory", "stash", "policeevidence3", {
            maxweight = 4000000,
            slots = 500,
        })
        TriggerEvent("inventory:client:SetCurrentStash", "policeevidence3")
    end
end)

RegisterNetEvent('xz-police:client:openEvidence4', function()
    if onDuty then
        TriggerServerEvent("inventory:server:OpenInventory", "stash", "policeevidence4", {
            maxweight = 4000000,
            slots = 500,
        })
        TriggerEvent("inventory:client:SetCurrentStash", "policeevidence4")
    end
end)

RegisterNetEvent('xz-police:client:openEvidence5', function()
    if onDuty then
        TriggerServerEvent("inventory:server:OpenInventory", "stash", "policeevidence5", {
            maxweight = 4000000,
            slots = 500,
        })
        TriggerEvent("inventory:client:SetCurrentStash", "policeevidence5")
    end
end)

RegisterNetEvent('xz-police:client:openEvidence6', function()
    if onDuty then
        TriggerServerEvent("inventory:server:OpenInventory", "stash", "policeevidence6", {
            maxweight = 4000000,
            slots = 500,
        })
        TriggerEvent("inventory:client:SetCurrentStash", "policeevidence6")
    end
end)

RegisterNetEvent('xz-police:client:openStash', function()
    if onDuty then
        TriggerEvent("InteractSound_CL:PlayOnOne","zipper",0.5)
        TriggerServerEvent("inventory:server:OpenInventory", "stash", "policestash_"..XZCore.Functions.GetPlayerData().citizenid)
        TriggerEvent("inventory:client:SetCurrentStash", "policestash_"..XZCore.Functions.GetPlayerData().citizenid)
    end
end)

RegisterNetEvent('xz-police:client:openTrash', function()
    if onDuty then
        TriggerServerEvent("inventory:server:OpenInventory", "stash", "policetrash", {
            maxweight = 4000000,
            slots = 300,
        })
        TriggerEvent("inventory:client:SetCurrentStash", "policetrash")
    end
end)

RegisterNetEvent('xz-police:client:openJailArmory', function()
    if onDuty then
        local items = GenerateItemsForGradeJail(PlayerJob.grade.level)
        TriggerServerEvent("inventory:server:OpenInventory", "shop", "police", items)
    end
end)

RegisterNetEvent('xz-police:client:openBossMenu', function()
    if onDuty then
        TriggerServerEvent("xz-bossmenu:server:openMenu")
    end
end)

local currentGarage = 1
Citizen.CreateThread(function()
    for k, v in pairs(Config.Locations["duty"]) do
        exports['xz-interact']:AddBoxZone("pdduty"..k, vector3(v.x, v.y, v.z), v.l, v.w, {
            name = "pdduty"..k,
            heading = v.h,
            debugPoly = false,
            minZ = v.minZ,
            maxZ = v.maxZ,
        }, {
            options = {
                {
                    event = 'xz-police:client:toggleDuty',
                    icon = 'far fa-clipboard',
                    label = 'Toggle Duty',
                    job = 'police'
                }
            },
            distance = 2.0
        })
    end

    for k, v in pairs(Config.Locations["armory"]) do
        exports['xz-interact']:AddBoxZone("pdarmory"..k, vector3(v.x, v.y, v.z), v.l, v.w, {
            name = "pdarmory"..k,
            heading = v.h,
            debugPoly = false,
            minZ = v.minZ,
            maxZ = v.maxZ,
        }, {
            options = {
                {
                    event = 'xz-police:client:openArmory',
                    icon = 'far fa-clipboard',
                    label = 'PD Armory',
                    job = 'police'
                },
                {
                    event = 'xz-police:client:putVestOn',
                    icon = 'fas fa-shield-alt',
                    label = 'PD Vest',
                    job = 'police'
                }
            },
            distance = 2.0
        })
    end

    for k, v in pairs(Config.Locations["evidence"]) do
        exports['xz-interact']:AddBoxZone("pdevidence1"..k, vector3(v.x, v.y, v.z), v.l, v.w, {
            name = "pdevidence1"..k,
            heading = v.h,
            debugPoly = false,
            minZ = v.minZ,
            maxZ = v.maxZ,
        }, {
            options = {
                {
                    event = 'xz-police:client:openEvidence1',
                    icon = 'far fa-clipboard',
                    label = 'Evidence Locker',
                    job = 'police'
                }
            },
            distance = 2.0
        })
    end

    for k, v in pairs(Config.Locations["evidence2"]) do
        exports['xz-interact']:AddBoxZone("pdevidence2"..k, vector3(v.x, v.y, v.z), v.l, v.w, {
            name = "pdevidence2"..k,
            heading = v.h,
            debugPoly = false,
            minZ = v.minZ,
            maxZ = v.maxZ,
        }, {
            options = {
                {
                    event = 'xz-police:client:openEvidence2',
                    icon = 'far fa-clipboard',
                    label = 'Evidence Locker',
                    job = 'police'
                }
            },
            distance = 2.0
        })
    end

    for k, v in pairs(Config.Locations["evidence3"]) do
        exports['xz-interact']:AddBoxZone("pdevidence3"..k, vector3(v.x, v.y, v.z), v.l, v.w, {
            name = "pdevidence3"..k,
            heading = v.h,
            debugPoly = false,
            minZ = v.minZ,
            maxZ = v.maxZ,
        }, {
            options = {
                {
                    event = 'xz-police:client:openEvidence3',
                    icon = 'far fa-clipboard',
                    label = 'Evidence Locker',
                    job = 'police'
                }
            },
            distance = 2.0
        })
    end

    for k, v in pairs(Config.Locations["evidence4"]) do
        exports['xz-interact']:AddBoxZone("pdevidence4"..k, vector3(v.x, v.y, v.z), v.l, v.w, {
            name = "pdevidence4"..k,
            heading = v.h,
            debugPoly = false,
            minZ = v.minZ,
            maxZ = v.maxZ,
        }, {
            options = {
                {
                    event = 'xz-police:client:openEvidence4',
                    icon = 'far fa-clipboard',
                    label = 'Evidence Locker',
                    job = 'police'
                }
            },
            distance = 2.0
        })
    end

    for k, v in pairs(Config.Locations["evidence5"]) do
        exports['xz-interact']:AddBoxZone("pdevidence5"..k, vector3(v.x, v.y, v.z), v.l, v.w, {
            name = "pdevidence5"..k,
            heading = v.h,
            debugPoly = false,
            minZ = v.minZ,
            maxZ = v.maxZ,
        }, {
            options = {
                {
                    event = 'xz-police:client:openEvidence5',
                    icon = 'far fa-clipboard',
                    label = 'Evidence Locker',
                    job = 'police'
                }
            },
            distance = 2.0
        })
    end

    for k, v in pairs(Config.Locations["evidence6"]) do
        exports['xz-interact']:AddBoxZone("pdevidence6"..k, vector3(v.x, v.y, v.z), v.l, v.w, {
            name = "pdevidence6"..k,
            heading = v.h,
            debugPoly = false,
            minZ = v.minZ,
            maxZ = v.maxZ,
        }, {
            options = {
                {
                    event = 'xz-police:client:openEvidence6',
                    icon = 'far fa-clipboard',
                    label = 'Evidence Locker',
                    job = 'police'
                }
            },
            distance = 2.0
        })
    end

    for k, v in pairs(Config.Locations["stash"]) do
        exports['xz-interact']:AddBoxZone("pdstash"..k, vector3(v.x, v.y, v.z), v.l, v.w, {
            name = "pdstash"..k,
            heading = v.h,
            debugPoly = false,
            minZ = v.minZ,
            maxZ = v.maxZ,
        }, {
            options = {
                {
                    event = 'xz-police:client:openStash',
                    icon = 'fas fa-box',
                    label = 'Personal Locker',
                    job = 'police'
                }
            },
            distance = 2.0
        })
    end

    for k, v in pairs(Config.Locations["trash"]) do
        exports['xz-interact']:AddBoxZone("pdtrash"..k, vector3(v.x, v.y, v.z), v.l, v.w, {
            name = "pdtrash"..k,
            heading = v.h,
            debugPoly = false,
            minZ = v.minZ,
            maxZ = v.maxZ,
        }, {
            options = {
                {
                    event = 'xz-police:client:openTrash',
                    icon = 'far fa-clipboard',
                    label = 'Trash Locker',
                    job = 'police'
                }
            },
            distance = 2.0
        })
    end

    for k, v in pairs(Config.Locations["jail"]) do
        exports['xz-interact']:AddBoxZone("pdjailarmory"..k, vector3(v.x, v.y, v.z), v.l, v.w, {
            name = "pdjailarmory"..k,
            heading = v.h,
            debugPoly = false,
            minZ = v.minZ,
            maxZ = v.maxZ,
        }, {
            options = {
                {
                    event = 'xz-police:client:openJailArmory',
                    icon = 'far fa-clipboard',
                    label = 'Jail Armory',
                    job = 'police'
                }
            },
            distance = 2.0
        })
    end

    for k, v in pairs(Config.Locations["boss"]) do
        exports['xz-interact']:AddBoxZone("pdbossmenu"..k, vector3(v.x, v.y, v.z), v.l, v.w, {
            name = "pdbossmenu"..k,
            heading = v.h,
            debugPoly = false,
            minZ = v.minZ,
            maxZ = v.maxZ,
        }, {
            options = {
                {
                    event = 'xz-police:client:openBossMenu',
                    icon = 'fas fa-user-tie',
                    label = 'Boss Menu',
                    job = 'police',
                    canInteract = function()
                        if PlayerJob.isboss then
                            return true
                        else
                            return false
                        end
                    end,
                }
            },
            distance = 2.0
        })
    end

    exports['xz-interact']:AddBoxZone('pdclothingoutfits', vector3(461.411, -997.7574, 30.68957), 1.3, 4.2, {
        name = 'pdclothingoutfits',
        heading = 180.0,
        debugPoly = false,
        minZ = 29.6,
        maxZ = 31.8
    }, {
        options = {
            {
                action = function()
                    TriggerServerEvent("clothing:checkMoney", "clothesmenu")
                end,
                icon = 'fas fa-tshirt',
                label = 'Change Clothes',
                job = 'police'
            },
            {
                type = "xzcommand",
                event = 'outfits',
                icon = 'fas fa-clipboard-list',
                label = 'Manage Outfits',
                job = 'police'
            }
        },
        distance = 2.5
    })

    while true do
        Citizen.Wait(1)
        if isLoggedIn then
            if PlayerJob.name == "police" then
                local pos = GetEntityCoords(PlayerPedId())

                for k, v in pairs(Config.Locations["property"]) do
                    if (GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 2) then
                        if (GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 2) then
                            DrawText3D(v.x, v.y, v.z, "~g~E~w~ - Property Locker")
                            if IsControlJustReleased(0, Keys["E"]) then
                                TriggerServerEvent("inventory:server:OpenInventory", "stash", "propertylocker", {
                                    maxweight = 4000000,
                                    slots = 500,
                                })
                                TriggerEvent("inventory:client:SetCurrentStash", "propertylocker")
                            end
                        end
                    end
                end

                for k, v in pairs(Config.Locations["vehicle"]) do
                    if (GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 7.5) then
                         if onDuty then
                             DrawMarker(2, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                             if (GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 1.5) then
                                 if IsPedInAnyVehicle(PlayerPedId(), false) then
                                     DrawText3D(v.x, v.y, v.z, "~g~E~w~ - Store the vehicle")
                                 else
                                     DrawText3D(v.x, v.y, v.z, "~g~E~w~ - Vehicles")
                                 end
                                 if IsControlJustReleased(0, Keys["E"]) then
                                     if IsPedInAnyVehicle(PlayerPedId(), false) then
                                         XZCore.Functions.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
                                     else
                                         currentGarage = k
                                         exports["xz-menu"]:openMenu(menuItem)
                                     end
                                 end
                                 Menu.renderGUI()
                             end  
                         end
                     end
                end

                for k, v in pairs(Config.Locations["impound"]) do
                    if (GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 7.5) then
                        if onDuty then
                            DrawMarker(2, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                            if (GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 1.5) then
                                if IsPedInAnyVehicle(PlayerPedId(), false) then
                                    DrawText3D(v.x, v.y, v.z, "~g~E~w~ - Store the vehicle")
                                else
                                    DrawText3D(v.x, v.y, v.z, "~g~E~w~ - Vehicles")
                                end
                                if IsControlJustReleased(0, Keys["E"]) then
                                    if IsPedInAnyVehicle(PlayerPedId(), false) then
                                        XZCore.Functions.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
                                    else
                                        MenuImpound()
                                        currentGarage = k
                                        Menu.hidden = not Menu.hidden
                                    end
                                end
                                Menu.renderGUI()
                            end  
                        end
                    end
                end

                for k, v in pairs(Config.Locations["helicopter"]) do
                    if (GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 7.5) then
                        if onDuty then
                            DrawMarker(2, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                            if (GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 1.5) then
                                if IsPedInAnyVehicle(PlayerPedId(), false) then
                                    DrawText3D(v.x, v.y, v.z, "~g~E~w~ - Store the helicopter")
                                else
                                    DrawText3D(v.x, v.y, v.z, "~g~E~w~ - Spawn Helicopter")
                                end
                                if IsControlJustReleased(0, Keys["E"]) then
                                    if IsPedInAnyVehicle(PlayerPedId(), false) then
                                        XZCore.Functions.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
                                    else
                                        local coords = Config.Locations["helicopter"][k]
                                        if not IsModelValid(Config.Helicopter) then
                                            XZCore.Functions.Notify("Invaild Vehicle Model", "error")
                                            return false
                                        end

                                        XZCore.Functions.SpawnVehicle(Config.Helicopter, function(veh)
                                            SetVehicleNumberPlateText(veh, "ZULU"..tostring(math.random(1000, 9999)))
                                            SetEntityHeading(veh, coords.h)
                                            exports['LegacyFuel']:SetFuel(veh, 100)
                                            closeMenuFull()
                                            TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                                            TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh), veh)
                                            SetVehicleEngineOn(veh, true, true)
                                        end, coords, true)
                                    end
                                end
                            end  
                        end
                    end
                end

                for k, v in pairs(Config.Locations["boat"]) do
                    if (GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 7.5) then
                        if onDuty then
                            DrawMarker(2, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                            if (GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 1.5) then
                                if IsPedInAnyVehicle(PlayerPedId(), false) then
                                    DrawText3D(v.x, v.y, v.z, "~g~E~w~ - Store the boat")
                                else
                                    DrawText3D(v.x, v.y, v.z, "~g~E~w~ - Spawn Boat")
                                end
                                if IsControlJustReleased(0, Keys["E"]) then
                                    if IsPedInAnyVehicle(PlayerPedId(), false) then
                                        XZCore.Functions.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
                                    else
                                        local coords = Config.Locations["boat"][k]
                                        if not IsModelValid(Config.Boat) then
                                            XZCore.Functions.Notify("Invaild Vehicle Model", "error")
                                            return false
                                        end

                                        XZCore.Functions.SpawnVehicle(Config.Boat, function(veh)
                                            SetVehicleNumberPlateText(veh, "BOAT"..tostring(math.random(1000, 9999)))
                                            SetEntityHeading(veh, coords.h)
                                            exports['LegacyFuel']:SetFuel(veh, 100)
                                            closeMenuFull()
                                            TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                                            TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh), veh)
                                            SetVehicleEngineOn(veh, true, true)
                                        end, coords, true)
                                    end
                                end
                            end  
                        end
                    end
                end

                for k, v in pairs(Config.Locations["fingerprint"]) do
                    if (GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 4.5) then
                        if onDuty then
                            if (GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 2) then
                                DrawText3D(v.x, v.y, v.z, "~g~E~w~ - Scan fingerprint")
                                if IsControlJustReleased(0, Keys["E"]) then
                                    local player, distance = GetClosestPlayer()
                                    if player ~= -1 and distance < 2.5 then
                                        local playerId = GetPlayerServerId(player)
                                        TriggerServerEvent("police:server:showFingerprint", playerId)
                                    else
                                        XZCore.Functions.Notify("No one around!", "error")
                                    end
                                end
                            end  
                        end
                    end
                end
            else
                Citizen.Wait(2000)
            end
        end
    end
end)

function WeaponAlreadyInArmory(items, nna)
    for k, v in pairs(items) do
        if v.name == nna then
            return true
        end
    end
    return false
end

function GenerateItemsForGrade(grade)
    local playerArmoryItems = Config.Items
    local grade = tonumber(grade) ~= nil and tonumber(grade) or 1
    --[[if grade > 1 then
        if not WeaponAlreadyInArmory(playerArmoryItems.items, "weapon_smg") then
            playerArmoryItems.items[#playerArmoryItems.items + 1] = {
                name = "weapon_smg",
                price = 0,
                amount = 1,
                info = {
                    serie = "",                
                    attachments = {
                        {component = "COMPONENT_AT_SCOPE_MACRO_02", label = "1x Scope"},
                        {component = "COMPONENT_AT_AR_FLSH", label = "Flashlight"},
                    }
                },
                type = "weapon",
                slot = #playerArmoryItems.items + 1,
            }

            playerArmoryItems.items[#playerArmoryItems.items + 1] = {
                name = "smg_ammo",
                price = 0,
                amount = 5,
                info = {},
                type = "item",
                slot = #playerArmoryItems.items + 1,
            }
        end
    end--]]

    if grade > 4 then
        if not WeaponAlreadyInArmory(playerArmoryItems.items, "weapon_carbinerifle") then
            playerArmoryItems.items[#playerArmoryItems.items + 1] = {
                name = "weapon_carbinerifle",
                price = 0,
                amount = 1,
                info = {
                    serie = "",
                    attachments = {
                        {component = "COMPONENT_AT_AR_FLSH", label = "Flashlight"},
                        {component = "COMPONENT_AT_SCOPE_MEDIUM", label = "3x Scope"},
                    }
                },
                type = "weapon",
                slot = #playerArmoryItems.items + 1,
            }

            playerArmoryItems.items[#playerArmoryItems.items + 1] = {
                name = "rifle_ammo",
                price = 0,
                amount = 5,
                info = {},
                type = "item",
                slot = #playerArmoryItems.items + 1,
            }
        end
    end

    playerArmoryItems.slots = #playerArmoryItems.items

    for k, v in pairs(playerArmoryItems.items) do
        if v.type == 'weapon' then
            playerArmoryItems.items[k].info.serie = tostring(Config.RandomInt(2) .. Config.RandomStr(3) .. Config.RandomInt(1) .. Config.RandomStr(2) .. Config.RandomInt(3) .. Config.RandomStr(4))
        end
    end

    return playerArmoryItems
end

function GenerateItemsForGradeJail(grade)
    local playerArmoryItems = Config.JailItems
    local grade = tonumber(grade) ~= nil and tonumber(grade) or 1
    if grade > 1 then
        if not WeaponAlreadyInArmory(playerArmoryItems.items, "weapon_pumpshotgun") then
            playerArmoryItems.items[#playerArmoryItems.items + 1] = {
                name = "shotgun_ammo",
                price = 0,
                amount = 5,
                info = {},
                type = "item",
                slot = #playerArmoryItems.items + 1,
            }

            playerArmoryItems.items[#playerArmoryItems.items + 1] = {
                name = "medkit",
                price = 10,
                amount = 5,
                info = {},
                type = "item",
                slot = #playerArmoryItems.items + 1,
            }
        end
    end

    playerArmoryItems.slots = #playerArmoryItems.items

    for k, v in pairs(playerArmoryItems.items) do
        if v.type == 'weapon' then
            playerArmoryItems.items[k].info.serie = tostring(Config.RandomInt(2) .. Config.RandomStr(3) .. Config.RandomInt(1) .. Config.RandomStr(2) .. Config.RandomInt(3) .. Config.RandomStr(4))
        end
    end

    return playerArmoryItems
end

local inFingerprint = false
local FingerPrintSessionId = nil

RegisterNetEvent('police:client:showFingerprint')
AddEventHandler('police:client:showFingerprint', function(playerId)
    openFingerprintUI()
    FingerPrintSessionId = playerId
end)

RegisterNetEvent('police:client:showFingerprintId')
AddEventHandler('police:client:showFingerprintId', function(fid, name)
    SendNUIMessage({
        type = "updateFingerprintId",
        fingerprintId = fid,
        name = name
    })
    PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
end)

RegisterNUICallback('doFingerScan', function(data)
    TriggerServerEvent('police:server:showFingerprintId', FingerPrintSessionId)
end)

function openFingerprintUI()
    SendNUIMessage({
        type = "fingerprintOpen"
    })
    inFingerprint = true
    SetNuiFocus(true, true)
end

RegisterNUICallback('closeFingerprint', function()
    SetNuiFocus(false, false)
    inFingerprint = false
end)

RegisterNetEvent('police:client:SendEmergencyMessage')
AddEventHandler('police:client:SendEmergencyMessage', function(message)
    local coords = GetEntityCoords(PlayerPedId())
    
    TriggerServerEvent("police:server:SendEmergencyMessage", coords, message)
    TriggerEvent("police:client:CallAnim")
end)

RegisterNetEvent('police:client:EmergencySound')
AddEventHandler('police:client:EmergencySound', function()
    PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
end)

RegisterNetEvent('police:client:CallAnim')
AddEventHandler('police:client:CallAnim', function()
    local isCalling = true
    local callCount = 5
    loadAnimDict("cellphone@")   
    TaskPlayAnim(PlayerPedId(), 'cellphone@', 'cellphone_call_listen_base', 3.0, -1, -1, 49, 0, false, false, false)
    Citizen.Wait(1000)
    Citizen.CreateThread(function()
        while isCalling do
            Citizen.Wait(1000)
            callCount = callCount - 1
            if callCount <= 0 then
                isCalling = false
                StopAnimTask(PlayerPedId(), 'cellphone@', 'cellphone_call_listen_base', 1.0)
            end
        end
    end)
end)

RegisterNetEvent('police:client:ImpoundVehicle')
AddEventHandler('police:client:ImpoundVehicle', function(fullImpound, price)
    local vehicle = XZCore.Functions.GetClosestVehicle()
    if vehicle ~= 0 and vehicle ~= nil then
        local pos = GetEntityCoords(PlayerPedId())
        local vehpos = GetEntityCoords(vehicle)
        if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, vehpos.x, vehpos.y, vehpos.z, true) < 5.0) and not IsPedInAnyVehicle(PlayerPedId()) then
            local plate = GetVehicleNumberPlateText(vehicle)
			local ped = PlayerPedId()
			TaskStartScenarioInPlace(ped, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
			Progressbar(5000,"Impounding")
            TriggerServerEvent("police:server:Impound", plate, fullImpound, price)
            XZCore.Functions.DeleteVehicle(vehicle)
        end
    end
end)

function Progressbar(duration, label)
	local retval = nil
	XZCore.Functions.Progressbar("drugs", label, duration, false, false, {
		disableMovement = false,
		disableCarMovement = false,
		disableMouse = false,
		disableCombat = false,
	}, {}, {}, {}, function()
		retval = true
	end, function()
		retval = false
	end)

	while retval == nil do
		Wait(1)
	end

	return retval
end

RegisterNetEvent('police:client:CheckStatus')
AddEventHandler('police:client:CheckStatus', function()
    XZCore.Functions.GetPlayerData(function(PlayerData)
        if PlayerData.job.name == "police" then
            local player, distance = GetClosestPlayer()
            if player ~= -1 and distance < 5.0 then
                local playerId = GetPlayerServerId(player)
                XZCore.Functions.TriggerCallback('police:GetPlayerStatus', function(result)
                    if result ~= nil then
                        for k, v in pairs(result) do
                            TriggerEvent("chatMessage", "STATUS", "warning", v)
                        end
                    end
                end, playerId)
            end
        end
    end)
end)

function MenuImpound()
    ped = PlayerPedId();
    MenuTitle = "Impound"
    ClearMenu()
    Menu.addButton("Vehicles", "ImpoundVehicleList", nil)
    Menu.addButton("Close Menu", "closeMenuFull", nil) 
end

function ImpoundVehicleList()
    XZCore.Functions.TriggerCallback("police:GetImpoundedVehicles", function(result)
        ped = PlayerPedId();
        MenuTitle = "Vehicles:"
        ClearMenu()

        if result == nil then
            XZCore.Functions.Notify("There are no seized vehicles", "error", 5000)
            closeMenuFull()
        else
            for k, v in pairs(result) do
                enginePercent = round(v.engine / 10, 0)
                bodyPercent = round(v.body / 10, 0)
                currentFuel = v.fuel

                Menu.addButton(XZCore.Shared.Vehicles[v.vehicle]["name"], "TakeOutImpound", v, "Confiscated", " Motor: " .. enginePercent .. "%", " Body: " .. bodyPercent.. "%", " Fuel: "..currentFuel.. "%")
            end
        end
            
        Menu.addButton("Back", "MenuImpound",nil)
    end)
end

function TakeOutImpound(vehicle)
    enginePercent = round(vehicle.engine / 10, 0)
    bodyPercent = round(vehicle.body / 10, 0)
    currentFuel = vehicle.fuel
    local coords = Config.Locations["impound"][currentGarage]
    XZCore.Functions.SpawnVehicle(vehicle.vehicle, function(veh)
        XZCore.Functions.TriggerCallback('xz-garage:server:GetVehicleProperties', function(properties)
            XZCore.Functions.SetVehicleProperties(veh, properties)
            SetVehicleNumberPlateText(veh, vehicle.plate)
            SetEntityHeading(veh, coords.h)
            exports['xz-hud']:SetFuel(veh, vehicle.fuel)
            doCarDamage(veh, vehicle)
            closeMenuFull()
            TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
            TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh), veh)
            SetVehicleEngineOn(veh, true, true)
        end, vehicle.plate)
    end, coords, true)
end

function MenuOutfits()
    ped = PlayerPedId();
    MenuTitle = "Outfits"
    ClearMenu()
    Menu.addButton("My Outfits", "OutfitsLijst", nil)
    Menu.addButton("Close Menu", "closeMenuFull", nil) 
end

function changeOutfit()
    Wait(200)
    loadAnimDict("clothingshirt")       
    TaskPlayAnim(PlayerPedId(), "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    Wait(3100)
    TaskPlayAnim(PlayerPedId(), "clothingshirt", "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
end

function OutfitsLijst()
    XZCore.Functions.TriggerCallback('apartments:GetOutfits', function(outfits)
        ped = PlayerPedId();
        MenuTitle = "My Outfits :"
        ClearMenu()

        if outfits == nil then
            XZCore.Functions.Notify("You have no outfits saved...", "error", 3500)
            closeMenuFull()
        else
            for k, v in pairs(outfits) do
                Menu.addButton(outfits[k].outfitname, "optionMenu", outfits[k]) 
            end
        end
        Menu.addButton("Back", "MenuOutfits",nil)
    end)
end

function optionMenu(outfitData)
    ped = PlayerPedId();
    MenuTitle = "What now?"
    ClearMenu()

    Menu.addButton("Choose Outfit", "selectOutfit", outfitData) 
    Menu.addButton("Remove Outfit", "removeOutfit", outfitData) 
    Menu.addButton("Back", "OutfitsLijst",nil)
end

function selectOutfit(oData)
    TriggerServerEvent('clothes:selectOutfit', oData.model, oData.skin)
    XZCore.Functions.Notify(oData.outfitname.." chosen", "success", 2500)
    closeMenuFull()
    changeOutfit()
end

function removeOutfit(oData)
    TriggerServerEvent('clothes:removeOutfit', oData.outfitname)
    XZCore.Functions.Notify(oData.outfitname.." is removed", "success", 2500)
    closeMenuFull()
end

function MenuGarage()
    ped = PlayerPedId();
    MenuTitle = "Garage"
    ClearMenu()
    Menu.addButton("Vehicles", "VehicleList", nil)
    Menu.addButton("Close Menu", "closeMenuFull", nil) 
end

function VehicleList(isDown)
    ped = PlayerPedId();
    MenuTitle = "Vehicles:"
    ClearMenu()
    for k, v in pairs(Config.Vehicles) do
        Menu.addButton(Config.Vehicles[k], "TakeOutVehicle", k, "Garage", " Motor: 100%", " Body: 100%", " Fuel: 100%")
    end
    if IsArmoryWhitelist() then
        for veh, label in pairs(Config.WhitelistedVehicles) do
            Menu.addButton(label, "TakeOutVehicle", veh, "Garage", " Motor: 100%", " Body: 100%", " Fuel: 100%")
        end
    end
        
    Menu.addButton("Back", "MenuGarage",nil)
end

RegisterNetEvent("xz-police:client:takeOutVehicle", function(data)
    local coords = Config.Locations["vehicle"][currentGarage]

    if not IsModelValid(data.model) then
        XZCore.Functions.Notify("Invaild Vehicle Model", "error")
        return false
    end

    XZCore.Functions.SpawnVehicle(data.model, function(veh)
        SetVehicleNumberPlateText(veh, "PLZI"..tostring(math.random(1000, 9999)))
        SetEntityHeading(veh, coords.h)
        closeMenuFull()
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh), veh)
        TriggerServerEvent("inventory:server:addTrunkItems", GetVehicleNumberPlateText(veh), Config.CarItems)
        SetVehicleEngineOn(veh, true, true)
    end, coords, true)
end)

function TakeOutVehicle(vehicleInfo)
    local coords = Config.Locations["vehicle"][currentGarage]

    if not IsModelValid(vehicleInfo) then
        XZCore.Functions.Notify("Invaild Vehicle Model", "error")
        return false
    end

    XZCore.Functions.SpawnVehicle(vehicleInfo, function(veh)
        SetVehicleNumberPlateText(veh, "PLZI"..tostring(math.random(1000, 9999)))
        SetEntityHeading(veh, coords.h)
        closeMenuFull()
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh), veh)
        TriggerServerEvent("inventory:server:addTrunkItems", GetVehicleNumberPlateText(veh), Config.CarItems)
        SetVehicleEngineOn(veh, true, true)
    end, coords, true)
    return true
end

function closeMenuFull()
    Menu.hidden = true
    ClearMenu()
end

function doCarDamage(currentVehicle, veh)
    smash = false
    damageOutside = false
    damageOutside2 = false 
    local engine = veh.engine + 0.0
    local body = veh.body + 0.0
    if engine < 200.0 then
        engine = 200.0
    end
    
    if engine  > 1000.0 then
        engine = 950.0
    end

    if body < 150.0 then
        body = 150.0
    end
    if body < 950.0 then
        smash = true
    end

    if body < 920.0 then
        damageOutside = true
    end

    if body < 920.0 then
        damageOutside2 = true
    end

    Citizen.Wait(100)
    SetVehicleEngineHealth(currentVehicle, engine)
    if smash then
        SmashVehicleWindow(currentVehicle, 0)
        SmashVehicleWindow(currentVehicle, 1)
        SmashVehicleWindow(currentVehicle, 2)
        SmashVehicleWindow(currentVehicle, 3)
        SmashVehicleWindow(currentVehicle, 4)
    end
    if damageOutside then
        SetVehicleDoorBroken(currentVehicle, 1, true)
        SetVehicleDoorBroken(currentVehicle, 6, true)
        SetVehicleDoorBroken(currentVehicle, 4, true)
    end
    if damageOutside2 then
        SetVehicleTyreBurst(currentVehicle, 1, false, 990.0)
        SetVehicleTyreBurst(currentVehicle, 2, false, 990.0)
        SetVehicleTyreBurst(currentVehicle, 3, false, 990.0)
        SetVehicleTyreBurst(currentVehicle, 4, false, 990.0)
    end
    if body < 1000 then
        SetVehicleBodyHealth(currentVehicle, 985.1)
    end
end

function SetCarItemsInfo()
    local items = {}
    for k, item in pairs(Config.CarItems) do
        local itemInfo = XZCore.Shared.Items[item.name:lower()]
        items[item.slot] = {
            name = itemInfo["name"],
            amount = tonumber(item.amount),
            info = item.info,
            label = itemInfo["label"],
            description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
            weight = itemInfo["weight"], 
            type = itemInfo["type"], 
            unique = itemInfo["unique"], 
            useable = itemInfo["useable"], 
            image = itemInfo["image"],
            slot = item.slot,
        }
    end
    Config.CarItems = items
end

function IsArmoryWhitelist()
    local playerData = XZCore.Functions.GetPlayerData().job
    if playerData.isowner == true then
        return true
    end
    
    return false
end

function round(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end
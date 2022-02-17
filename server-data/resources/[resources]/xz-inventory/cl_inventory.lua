XZCore = nil

inInventory = false
hotbarOpen = false

local inventoryTest = {}
local currentWeapon = nil
local CurrentWeaponData = {}
local currentOtherInventory = nil

local Drops = {}
local CurrentDrop = 0
local DropsNear = {}

local CurrentVehicle = nil
local CurrentGlovebox = nil
local CurrentStash = nil
local isCrafting = false

local showTrunkPos = false
local resourceName = GetCurrentResourceName();

Citizen.CreateThread(function() 
    while not XZCore do
        TriggerEvent("XZCore:GetObject", function(obj) XZCore = obj end)    
        Citizen.Wait(200)
    end
end)

function IsControlsFree()
    local PlayerData = XZCore.Functions.GetPlayerData();
    return not isCrafting and not PlayerData.metadata["isdead"] and not PlayerData.metadata["inlaststand"] and not PlayerData.metadata["ishandcuffed"];
end

RegisterNetEvent("xz:interact:init:" .. resourceName, function(Nevo)
    Nevo.Mapping:Listen("inventory", "(Inventory) Open", "keyboard", "F2", function(state)
        if state and IsControlsFree() then
            local curVeh = nil
            if IsPedInAnyVehicle(PlayerPedId()) then
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                CurrentGlovebox = GetVehicleNumberPlateText(vehicle):gsub(" ", "")
                curVeh = vehicle
                CurrentVehicle = nil
            else
                local vehicle = XZCore.Functions.GetClosestVehicle()
                if vehicle ~= 0 and vehicle ~= nil then
                    local pos = GetEntityCoords(PlayerPedId())
                    local trunkpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -2.5, 0)
                    if (IsBackEngine(GetEntityModel(vehicle))) then
                        trunkpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, 2.5, 0)
                    end
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, trunkpos) < 2.0) and not IsPedInAnyVehicle(PlayerPedId()) then
                        if GetVehicleDoorLockStatus(vehicle) < 2 then
                            CurrentVehicle = GetVehicleNumberPlateText(vehicle):gsub(" ", "")
                            curVeh = vehicle
                            CurrentGlovebox = nil
                        else
                            XZCore.Functions.Notify("Vehicle is locked", "error")
                            return
                        end
                    else
                        CurrentVehicle = nil
                    end
                else
                    CurrentVehicle = nil
                end
            end

            if CurrentVehicle ~= nil then
                local maxweight = 0
                local slots = 0
                if GetVehicleClass(curVeh) == 0 then
                    maxweight = 650000
                    slots = 48
                elseif GetVehicleClass(curVeh) == 1 then
                    maxweight = 650000
                    slots = 48
                elseif GetVehicleClass(curVeh) == 2 then
                    maxweight = 650000
                    slots = 48
                elseif GetVehicleClass(curVeh) == 3 then
                    maxweight = 650000
                    slots = 48
                elseif GetVehicleClass(curVeh) == 4 then
                    maxweight = 650000
                    slots = 48
                elseif GetVehicleClass(curVeh) == 5 then
                    maxweight = 650000
                    slots = 48
                elseif GetVehicleClass(curVeh) == 6 then
                    maxweight = 650000
                    slots = 48
                elseif GetVehicleClass(curVeh) == 7 then
                    maxweight = 650000
                    slots = 48
                elseif GetVehicleClass(curVeh) == 8 then
                    maxweight = 650000
                    slots = 48
                elseif GetVehicleClass(curVeh) == 9 then
                    maxweight = 650000
                    slots = 48
                elseif GetVehicleClass(curVeh) == 12 then
                    maxweight = 650000
                    slots = 48
                else
                    maxweight = 650000
                    slots = 48
                end
                local other = {
                    maxweight = maxweight,
                    slots = slots,
                }
                TriggerServerEvent("inventory:server:OpenInventory", "trunk", CurrentVehicle, other)
                TriggerEvent("debug", 'Inventory: Current Vehicle ' .. CurrentVehicle, 'success')
                OpenTrunk()
            elseif CurrentGlovebox ~= nil then
                TriggerServerEvent("inventory:server:OpenInventory", "glovebox", CurrentGlovebox)
                TriggerEvent("debug", 'Inventory: Current Glovebox ' .. CurrentGlovebox, 'success')
            elseif CurrentDrop and CurrentDrop ~= 0 then
                TriggerServerEvent("inventory:server:OpenInventory", "drop", CurrentDrop)
            else
                TriggerServerEvent("inventory:server:OpenInventory")
            end

            TriggerEvent("debug", 'Inventory: Open UI', 'success')
        end
    end)

    for i=1, 4 do
        Nevo.Mapping:Listen("quick_slot_" .. i, "(Inventory) Quick Use - Slot #" .. i, "keyboard", i, function(state)
            if state and IsControlsFree() then
                TriggerServerEvent("inventory:server:UseItemSlot", i)
            end
        end)
    end

    Nevo.Mapping:Listen("inventory_tab", "(Inventory) Tab", "keyboard", "TAB", function(state)
        if not state or IsControlsFree() then
            ToggleHotbar(state);
        end
    end)
end);

RegisterNetEvent('inventory:client:CheckOpenState')
AddEventHandler('inventory:client:CheckOpenState', function(type, id, label)
    local name = XZCore.Shared.SplitStr(label, "-")[2]
    if type == "stash" then
        if name ~= CurrentStash or CurrentStash == nil then
            TriggerServerEvent('inventory:server:SetIsOpenState', false, type, id)
        end
    elseif type == "trunk" then
        if name ~= CurrentVehicle or CurrentVehicle == nil then
            TriggerServerEvent('inventory:server:SetIsOpenState', false, type, id)
        end
    elseif type == "glovebox" then
        if name ~= CurrentGlovebox or CurrentGlovebox == nil then
            TriggerServerEvent('inventory:server:SetIsOpenState', false, type, id)
        end
    end
end)

RegisterNetEvent('weapons:client:SetCurrentWeapon')
AddEventHandler('weapons:client:SetCurrentWeapon', function(data, bool)
    if data ~= false then
        CurrentWeaponData = data
    else
        CurrentWeaponData = {}
    end
end)

function tprint(a,b)for c,d in pairs(a)do local e='["'..tostring(c)..'"]'if type(c)~='string'then e='['..c..']'end;local f='"'..tostring(d)..'"'if type(d)=='table'then tprint(d,(b or'')..e)else if type(d)~='string'then f=tostring(d)end;print(type(a)..(b or'')..e..' = '..f)end end end

function DrawText3Ds(x, y, z, text)
	local onScreen, _x,_y = World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	local scale = 0.30
	if onScreen then
		SetTextScale(scale, scale)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
		SetTextOutline()
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
        DrawText(_x,_y)
	end
end

RegisterNetEvent('xz-inventory:client:openVending', function(data)
    local typ
    local found = false
    for k, v in pairs(Config.VendingObjects) do
        if GetHashKey(v[1]) == GetEntityModel(data.entity) then
            typ = v
            found = true
            break
        end
    end
    if found then
        local ShopItems = {}
        ShopItems.label = typ[3]
        ShopItems.items = typ[2]
        ShopItems.slots = #typ[2]
        TriggerServerEvent("inventory:server:OpenInventory", "dede", "Vendingshop_"..math.random(1, 99), ShopItems)
    end
end)

Citizen.CreateThread(function()
    for k, v in pairs(Config.VendingObjects) do
        exports['xz-interact']:AddTargetModel(v[1], {
            options = {
                {
                    event = 'xz-inventory:client:openVending',
                    icon = 'fas fa-shopping-basket',
                    label = 'Vending Machine'
                }
            },
            distance = 1.5
        })
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(7)
        if showTrunkPos and not inInventory then
            local vehicle = XZCore.Functions.GetClosestVehicle()
            if vehicle ~= 0 and vehicle ~= nil then
                local pos = GetEntityCoords(PlayerPedId())
                local vehpos = GetEntityCoords(vehicle)
                if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, vehpos.x, vehpos.y, vehpos.z, true) < 0.7) and not IsPedInAnyVehicle(PlayerPedId()) then
                    local drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -2.5, 0)
                    if (IsBackEngine(GetEntityModel(vehicle))) then
                        drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, 2.5, 0)
                    end
                    XZCore.Functions.DrawText3D(drawpos.x, drawpos.y, drawpos.z, "Trunk")
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, drawpos) < 0.7) and not IsPedInAnyVehicle(PlayerPedId()) then
                        CurrentVehicle = GetVehicleNumberPlateText(vehicle):gsub(" ", "")
                        showTrunkPos = false
                    end
                else
                    showTrunkPos = false
                end
            end
        elseif inInventory then
            DisablePlayerFiring(PlayerId(), true)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(7)
        DisableControlAction(0, Keys["TAB"], true)
        DisableControlAction(0, Keys["1"], true)
        DisableControlAction(0, Keys["2"], true)
        DisableControlAction(0, Keys["3"], true)
        DisableControlAction(0, Keys["4"], true)
    end
end)

RegisterNetEvent('inventory:client:ItemBox')
AddEventHandler('inventory:client:ItemBox', function(itemData, type)
    SendNUIMessage({
        action = "itemBox",
        item = itemData,
        type = type
    })
end)

RegisterNetEvent('inventory:client:requiredItems')
AddEventHandler('inventory:client:requiredItems', function(items, bool)
    local itemTable = {}
    if bool then
        for k, v in pairs(items) do
            table.insert(itemTable, {
                item = items[k].name,
                label = XZCore.Shared.Items[items[k].name]["label"],
                image = items[k].image,
            })
        end
    end

    TriggerEvent("debug", 'Inventory: Required Items (' .. json.encode(itemTable) .. ')', 'success')
    
    SendNUIMessage({
        action = "requiredItem",
        items = itemTable,
        toggle = bool
    })

end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if DropsNear ~= nil then
            for k, v in pairs(DropsNear) do
                if DropsNear[k] ~= nil then
                    DrawMarker(20,v.coords.x, v.coords.y, v.coords.z,0,0,0,0,0,0,0.35,0.5,0.15,252,255,255,91,0,0,0,0)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if Drops ~= nil and next(Drops) ~= nil then
            local pos = GetEntityCoords(PlayerPedId(), true)
            for k, v in pairs(Drops) do
                if Drops[k] ~= nil then 
                    if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, v.coords.x, v.coords.y, v.coords.z, true) < 7.5 then
                        DropsNear[k] = v
                        if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, v.coords.x, v.coords.y, v.coords.z, true) < 2 then
                            CurrentDrop = k
                        else
                            CurrentDrop = nil
                        end
                    else
                        DropsNear[k] = nil
                    end
                end
            end
        else
            DropsNear = {}
        end
        Citizen.Wait(500)
    end
end)

RegisterNetEvent("XZCore:Client:OnPlayerLoaded")
AddEventHandler("XZCore:Client:OnPlayerLoaded", function()
    --TriggerServerEvent("inventory:server:LoadDrops")
end)

RegisterNetEvent('inventory:server:RobPlayer')
AddEventHandler('inventory:server:RobPlayer', function(TargetId)
    SendNUIMessage({
        action = "RobMoney",
        TargetId = TargetId,
    })
end)

RegisterNUICallback('RobMoney', function(data, cb)
    TriggerServerEvent("police:server:RobPlayer", data.TargetId)
    TriggerEvent("debug", 'Inventory: Rob Money', 'success')
end)

RegisterNUICallback('Notify', function(data, cb)
    XZCore.Functions.Notify(data.message, data.type)
end)

RegisterNetEvent("inventory:client:OpenInventory")
AddEventHandler("inventory:client:OpenInventory", function(PlayerAmmo, inventory, other)

    if not IsEntityDead(PlayerPedId()) then
        ToggleHotbar(false)
        SetNuiFocus(true, true)
        if other ~= nil then
            currentOtherInventory = other.name
        end

        TriggerScreenblurFadeIn(0)
        
        SendNUIMessage({
            action = "open",
            inventory = inventory,
            slots = MaxInventorySlots,
            other = other,
            maxweight = XZCore.Config.Player.MaxWeight,
            Ammo = PlayerAmmo,
            maxammo = Config.MaximumAmmoValues,
        })

        inInventory = true
        TriggerEvent("xz:randPickupAnim")
    end
end)


RegisterNetEvent("inventory:client:ShowTrunkPos")
AddEventHandler("inventory:client:ShowTrunkPos", function()
    showTrunkPos = true
end)

RegisterNetEvent("inventory:client:UpdatePlayerInventory")
AddEventHandler("inventory:client:UpdatePlayerInventory", function(isError)
    SendNUIMessage({
        action = "update",
        inventory = XZCore.Functions.GetPlayerData().items,
        maxweight = XZCore.Config.Player.MaxWeight,
        slots = MaxInventorySlots,
        error = isError,
    })

    TriggerEvent("debug", 'Inventory: Update Player Inventory', 'success')
end)

RegisterNetEvent("inventory:client:CraftItems")
AddEventHandler("inventory:client:CraftItems", function(itemName, itemCosts, amount, toSlot, points)
    SendNUIMessage({
        action = "close",
    })
    isCrafting = true
    XZCore.Functions.Progressbar("repair_vehicle", "Crafting", (math.random(2000, 5000) * amount), false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {
		animDict = "mini@repair",
		anim = "fixing_a_player",
		flags = 16,
	}, {}, {}, function() -- Done
		StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
        TriggerServerEvent("inventory:server:CraftItems", itemName, itemCosts, amount, toSlot, points)
        TriggerEvent('inventory:client:ItemBox', XZCore.Shared.Items[itemName], 'add')
        isCrafting = false
        TriggerEvent("debug", 'Inventory: Craft ' .. XZCore.Shared.Items[itemName].name, 'success')
	end, function() -- Cancel
		StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
        XZCore.Functions.Notify("Failed!", "error")
        isCrafting = false
	end)
end)

RegisterNetEvent('inventory:client:CraftAttachment')
AddEventHandler('inventory:client:CraftAttachment', function(itemName, itemCosts, amount, toSlot, points)
    SendNUIMessage({
        action = "close",
    })
    isCrafting = true
    XZCore.Functions.Progressbar("repair_vehicle", "Crafting", (math.random(2000, 5000) * amount), false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {
		animDict = "mini@repair",
		anim = "fixing_a_player",
		flags = 16,
	}, {}, {}, function() -- Done
		StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
        TriggerServerEvent("inventory:server:CraftAttachment", itemName, itemCosts, amount, toSlot, points)
        TriggerEvent('inventory:client:ItemBox', XZCore.Shared.Items[itemName], 'add')
        isCrafting = false
        TriggerEvent("debug", 'Inventory: Craft ' .. XZCore.Shared.Items[itemName].name, 'success')
	end, function() -- Cancel
		StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
        XZCore.Functions.Notify("Failed!", "error")
        isCrafting = false
	end)
end)

RegisterNetEvent("inventory:client:PickupSnowballs")
AddEventHandler("inventory:client:PickupSnowballs", function()
    LoadAnimDict('anim@mp_snowball')
    TaskPlayAnim(PlayerPedId(), 'anim@mp_snowball', 'pickup_snowball', 3.0, 3.0, -1, 0, 1, 0, 0, 0)
    XZCore.Functions.Progressbar("pickupsnowball", "Picking up snowball", 1500, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        ClearPedTasks(PlayerPedId())
        TriggerServerEvent('XZCore:Server:AddItem', "snowball", 1)
        TriggerEvent('inventory:client:ItemBox', XZCore.Shared.Items["snowball"], "add")
        TriggerEvent("debug", 'Inventory: Pick up snowballs', 'success')
    end, function() -- Cancel
        ClearPedTasks(PlayerPedId())
        XZCore.Functions.Notify("Canceled", "error")
    end)
end)

RegisterNetEvent("inventory:client:UseSnowball")
AddEventHandler("inventory:client:UseSnowball", function(amount)
    GiveWeaponToPed(PlayerPedId(), GetHashKey("weapon_snowball"), amount, false, false)
    SetPedAmmo(PlayerPedId(), GetHashKey("weapon_snowball"), amount)
    SetCurrentPedWeapon(PlayerPedId(), GetHashKey("weapon_snowball"), true)
    TriggerEvent("debug", 'Inventory: Use Snowball', 'success')
end)

RegisterNetEvent("inventory:client:UseWeapon")
AddEventHandler("inventory:client:UseWeapon", function(weaponData, shootbool)
    local weaponName = tostring(weaponData.name)
    if currentWeapon == weaponName then
        SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
        RemoveAllPedWeapons(PlayerPedId(), true)
        TriggerEvent('weapons:client:SetCurrentWeapon', nil, shootbool)
        currentWeapon = nil
    elseif weaponName == "weapon_stickybomb" then
        GiveWeaponToPed(PlayerPedId(), GetHashKey(weaponName), ammo, false, false)
        SetPedAmmo(PlayerPedId(), GetHashKey(weaponName), 2)
        SetCurrentPedWeapon(PlayerPedId(), GetHashKey(weaponName), true)
        TriggerServerEvent('XZCore:Server:RemoveItem', weaponName, 1)
        TriggerEvent('weapons:client:SetCurrentWeapon', weaponData, shootbool)
        currentWeapon = weaponName
    elseif weaponName == "weapon_molotov" then
        GiveWeaponToPed(PlayerPedId(), GetHashKey(weaponName), ammo, false, false)
        SetPedAmmo(PlayerPedId(), GetHashKey(weaponName), 2)
        SetCurrentPedWeapon(PlayerPedId(), GetHashKey(weaponName), true)
        TriggerServerEvent('XZCore:Server:RemoveItem', weaponName, 1)
        TriggerEvent('weapons:client:SetCurrentWeapon', weaponData, shootbool)
        currentWeapon = weaponName
    elseif weaponName == "weapon_snowball" then
        GiveWeaponToPed(PlayerPedId(), GetHashKey(weaponName), ammo, false, false)
        SetPedAmmo(PlayerPedId(), GetHashKey(weaponName), 2)
        SetCurrentPedWeapon(PlayerPedId(), GetHashKey(weaponName), true)
        TriggerServerEvent('XZCore:Server:RemoveItem', weaponName, 1)
        TriggerEvent('weapons:client:SetCurrentWeapon', weaponData, shootbool)
        currentWeapon = weaponName
    else
        TriggerEvent('weapons:client:SetCurrentWeapon', weaponData, shootbool)
        XZCore.Functions.TriggerCallback("weapon:server:GetWeaponAmmo", function(result)
            local ammo = tonumber(result)
            if weaponName == "weapon_petrolcan" or weaponName == "weapon_fireextinguisher" then 
                ammo = 4000 
            end
            GiveWeaponToPed(PlayerPedId(), GetHashKey(weaponName), ammo, false, false)
            SetPedAmmo(PlayerPedId(), GetHashKey(weaponName), ammo)
            SetCurrentPedWeapon(PlayerPedId(), GetHashKey(weaponName), true)
            if weaponData.info.attachments ~= nil then
                for _, attachment in pairs(weaponData.info.attachments) do
                    GiveWeaponComponentToPed(PlayerPedId(), GetHashKey(weaponName), GetHashKey(attachment.component))
                end
            end
            currentWeapon = weaponName
        end, CurrentWeaponData)
    end
end)

WeaponAttachments = {
    ["WEAPON_SNSPISTOL"] = {
        ["extendedclip"] = {
            component = "COMPONENT_SNSPISTOL_CLIP_02",
            label = "Extended Clip",
            item = "pistol_extendedclip",
        },
    },
    ["WEAPON_COMBATPISTOL"] = {
        ["extendedclip"] = {
            component = "COMPONENT_COMBATPISTOL_CLIP_02",
            label = "Extended Clip",
            item = "pistol_extendedclip",
        },
        ["flashlight"] = {
            component = "COMPONENT_AT_PI_FLSH",
            label = "Flashlight",
            item = "smg_flashlight",
        },
        ["suppressor"] = {
            component = "COMPONENT_AT_PI_SUPP",
            label = "Suppressor",
            item = "pistol_suppressor",
        },
    },
    ["WEAPON_HEAVYPISTOL"] = {
        ["extendedclip"] = {
            component = "COMPONENT_HEAVYPISTOL_CLIP_02",
            label = "Extended Clip",
            item = "pistol_extendedclip",
        },
        ["flashlight"] = {
            component = "COMPONENT_AT_PI_FLSH",
            label = "Flashlight",
            item = "smg_flashlight",
        },
        ["suppressor"] = {
            component = "COMPONENT_AT_PI_SUPP",
            label = "Suppressor",
            item = "pistol_suppressor",
        },
    },
    ["WEAPON_PISTOL50"] = {
        ["extendedclip"] = {
            component = "COMPONENT_PISTOL50_CLIP_02",
            label = "Extended Clip",
            item = "pistol_extendedclip",
        },
        ["flashlight"] = {
            component = "COMPONENT_AT_PI_FLSH",
            label = "Flashlight",
            item = "smg_flashlight",
        }, 
        ["suppressor"] = {
            component = "COMPONENT_AT_AR_SUPP_02",
            label = "Suppressor",
            item = "pistol_suppressor",
        },
    },
    ["WEAPON_REVOLVER_MK2"] = {
        ["flashlight"] = {
            component = "COMPONENT_AT_PI_FLSH",
            label = "Flashlight",
            item = "smg_flashlight",
        }, 
        ["scope"] = {
            component = "COMPONENT_AT_SIGHTS",
            label = "Scope",
            item = "smg_scope",
        },
    },
    ["WEAPON_APPISTOL"] = {
        ["extendedclip"] = {
            component = "COMPONENT_APPISTOL_CLIP_02",
            label = "Extended Clip",
            item = "pistol_extendedclip",
        },
        ["flashlight"] = {
            component = "COMPONENT_AT_PI_FLSH",
            label = "Flashlight",
            item = "smg_flashlight",
        }, 
        ["suppressor"] = {
            component = "COMPONENT_AT_PI_SUPP",
            label = "Suppressor",
            item = "pistol_suppressor",
        },
    },
    ["WEAPON_VINTAGEPISTOL"] = {
        ["suppressor"] = {
            component = "COMPONENT_AT_PI_SUPP",
            label = "Suppressor",
            item = "pistol_suppressor",
        },
        ["extendedclip"] = {
            component = "COMPONENT_VINTAGEPISTOL_CLIP_02",
            label = "Extended Clip",
            item = "pistol_extendedclip",
        },
    },
    ["WEAPON_PISTOL"] = {
        ["suppressor"] = {
            component = "COMPONENT_AT_PI_SUPP_02",
            label = "Suppressor",
            item = "pistol_suppressor",
        },   
        ["flashlight"] = {
            component = "COMPONENT_AT_PI_FLSH",
            label = "Flashlight",
            item = "smg_flashlight",
        },
        ["extendedclip"] = {
            component = "COMPONENT_PISTOL_CLIP_02",
            label = "Extended Clip",
            item = "pistol_extendedclip",
        }, 
     },   
    ["WEAPON_MACHINEPISTOL"] = {
        ["suppressor"] = {
            component = "COMPONENT_AT_PI_SUPP",
            label = "Suppressor",
            item = "smg_suppressor",
        },  
            ["extendedclip"] = {
            component = "COMPONENT_MACHINEPISTOL_CLIP_02",
            label = "Extended Clip",
            item = "smg_extendedclip",
        }, 
        ["drummag"] = {
            component = "COMPONENT_MACHINEPISTOL_CLIP_03",
            label = "Drum Mag",
            item = "rifle_drummag",
        },   
    },                                               
    ["WEAPON_MICROSMG"] = {
        ["suppressor"] = {
            component = "COMPONENT_AT_AR_SUPP_02",
            label = "Suppressor",
            item = "smg_suppressor",
        },
        ["extendedclip"] = {
            component = "COMPONENT_MICROSMG_CLIP_02",
            label = "Extended Clip",
            item = "smg_extendedclip",
        },
        ["flashlight"] = {
            component = "COMPONENT_AT_PI_FLSH",
            label = "Flashlight",
            item = "smg_flashlight",
        },
        ["scope"] = {
            component = "COMPONENT_AT_SCOPE_MACRO",
            label = "Scope",
            item = "smg_scope",
        },
    },
    ["WEAPON_ASSAULTSMG"] = {
        ["suppressor"] = {
            component = "COMPONENT_AT_AR_SUPP_02",
            label = "Suppressor",
            item = "smg_suppressor",
        },
        ["extendedclip"] = {
            component = "COMPONENT_ASSAULTSMG_CLIP_02",
            label = "Extended Clip",
            item = "smg_extendedclip",
        },
        ["flashlight"] = {
            component = "COMPONENT_AT_AR_FLSH",
            label = "Flashlight",
            item = "smg_flashlight",
        },
        ["scope"] = {
            component = "COMPONENT_AT_SCOPE_MACRO",
            label = "Scope",
            item = "smg_scope",
        },
    },
    ["WEAPON_MINISMG"] = {
        ["extendedclip"] = {
            component = "COMPONENT_MINISMG_CLIP_02",
            label = "Extended Clip",
            item = "smg_extendedclip",
        },
    },
    ["WEAPON_MG"] = {
        ["extendedclip"] = {
            component = "COMPONENT_MG_CLIP_02",
            label = "Extended Clip",
            item = "smg_extendedclip",
        },
        ["scope"] = {
            component = "COMPONENT_AT_SCOPE_SMALL_02",
            label = "Scope",
            item = "smg_scope",
        },
    },
    ["WEAPON_COMBATMG"] = {
        ["extendedclip"] = {
            component = "COMPONENT_COMBATMG_CLIP_02",
            label = "Extended Clip",
            item = "smg_extendedclip",
        },
        ["scope"] = {
            component = "COMPONENT_AT_SCOPE_MEDIUM",
            label = "Scope",
            item = "smg_scope",
        },
    },
    ["WEAPON_GUSENBERG"] = {
        ["extendedclip"] = {
            component = "COMPONENT_GUSENBERG_CLIP_02",
            label = "Extended Clip",
            item = "smg_extendedclip",
        },
    },
    ["WEAPON_ASSAULTRIFLE"] = {
        ["extendedclip"] = {
            component = "COMPONENT_ASSAULTRIFLE_CLIP_02",
            label = "Extended Clip",
            item = "rifle_extendedclip",
        },
        ["suppressor"] = {
            component = "COMPONENT_AT_AR_SUPP_02",
            label = "Suppressor",
            item = "rifle_suppressor",
        },
        ["flashlight"] = {
            component = "COMPONENT_AT_AR_FLSH",
            label = "Flashlight",
            item = "smg_flashlight",
        },
        ["scope"] = {
            component = "COMPONENT_AT_SCOPE_MACRO",
            label = "Scope",
            item = "smg_scope",
        },
        ["drummag"] = {
            component = "COMPONENT_ASSAULTRIFLE_CLIP_03",
            label = "Drum Mag",
            item = "rifle_drummag",
        },
    },
    ["WEAPON_ASSAULTRIFLE_MK2"] = {
        ["extendedclip"] = {
            component = "COMPONENT_ASSAULTRIFLE_MK2_CLIP_02",
            label = "Extended Clip",
            item = "rifle_extendedclip",
        },
        ["scope"] = {
            component = "COMPONENT_AT_SIGHTS",
            label = "Scope",
            item = "smg_scope",
        },
        ["flashlight"] = {
            component = "COMPONENT_AT_AR_FLSH",
            label = "Flashlight",
            item = "smg_flashlight",
        },
        ["suppressor"] = {
            component = "COMPONENT_AT_AR_SUPP_02",
            label = "Suppressor",
            item = "rifle_suppressor",
        },
    },
    ["WEAPON_BULLPUPRIFLE"] = {
        ["extendedclip"] = {
            component = "COMPONENT_BULLPUPRIFLE_CLIP_02",
            label = "Extended Clip",
            item = "rifle_extendedclip",
        },
        ["suppressor"] = {
            component = "COMPONENT_AT_AR_SUPP",
            label = "Suppressor",
            item = "rifle_suppressor",
        },
        ["flashlight"] = {
            component = "COMPONENT_AT_AR_FLSH",
            label = "Flashlight",
            item = "smg_flashlight",
        },
        ["scope"] = {
            component = "COMPONENT_AT_SCOPE_SMALL",
            label = "Scope",
            item = "smg_scope",
        },
    },
    ["WEAPON_PUMPSHOTGUN"] = {
        ["suppressor"] = {
            component = "COMPONENT_AT_SR_SUPP",
            label = "Suppressor",
            item = "rifle_suppressor",
        },
        ["flashlight"] = {
            component = "COMPONENT_AT_AR_FLSH",
            label = "Flashlight",
            item = "smg_flashlight",
        },
    },
    ["WEAPON_COMPACTRIFLE"] = {
        ["extendedclip"] = {
            component = "COMPONENT_COMPACTRIFLE_CLIP_02",
            label = "Extended Clip",
            item = "rifle_extendedclip",
        },
        ["drummag"] = {
            component = "COMPONENT_COMPACTRIFLE_CLIP_03",
            label = "Drum Mag",
            item = "rifle_drummag",
        },
    },
}

function FormatWeaponAttachments(itemdata)
    local attachments = {}
    itemdata.name = itemdata.name:upper()
    if itemdata.info.attachments ~= nil and next(itemdata.info.attachments) ~= nil then
        for k, v in pairs(itemdata.info.attachments) do
            if WeaponAttachments[itemdata.name] ~= nil then
                for key, value in pairs(WeaponAttachments[itemdata.name]) do
                    if value.component == v.component then
                        table.insert(attachments, {
                            attachment = key,
                            label = value.label
                        })
                    end
                end
            end
        end
    end
    return attachments
end

RegisterNUICallback('GetWeaponData', function(data, cb)
    local data = {
        WeaponData = XZCore.Shared.Items[data.weapon],
        AttachmentData = FormatWeaponAttachments(data.ItemData)
    }
    cb(data)
end)

RegisterNUICallback('RemoveAttachment', function(data, cb)
    local WeaponData = XZCore.Shared.Items[data.WeaponData.name]
    local Attachment = WeaponAttachments[WeaponData.name:upper()][data.AttachmentData.attachment]
    
    XZCore.Functions.TriggerCallback('weapons:server:RemoveAttachment', function(NewAttachments)
        if NewAttachments ~= false then
            local Attachies = {}
            RemoveWeaponComponentFromPed(PlayerPedId(), GetHashKey(data.WeaponData.name), GetHashKey(Attachment.component))
            for k, v in pairs(NewAttachments) do
                for wep, pew in pairs(WeaponAttachments[WeaponData.name:upper()]) do
                    if v.component == pew.component then
                        table.insert(Attachies, {
                            attachment = pew.item,
                            label = pew.label,
                        })
                    end
                end
            end
            local DJATA = {
                Attachments = Attachies,
                WeaponData = WeaponData,
            }
            cb(DJATA)
        else
            RemoveWeaponComponentFromPed(PlayerPedId(), GetHashKey(data.WeaponData.name), GetHashKey(Attachment.component))
            cb({})
        end
    end, data.AttachmentData, data.WeaponData)
end)

RegisterNetEvent("inventory:client:CheckWeapon")
AddEventHandler("inventory:client:CheckWeapon", function(weaponName)
    if currentWeapon == weaponName then 
        TriggerEvent('weapons:ResetHolster')
        SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
        RemoveAllPedWeapons(PlayerPedId(), true)
        currentWeapon = nil
    end
end)

RegisterNetEvent("inventory:client:AddDropItem")
AddEventHandler("inventory:client:AddDropItem", function(dropId, player)

    local coords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(player)))
    local forward = GetEntityForwardVector(GetPlayerPed(GetPlayerFromServerId(player)))
	local x, y, z = table.unpack(coords + forward * 0.5)

    Drops[dropId] = {

        id = dropId,

        coords = {

            x = x,
            y = y,
            z = z - 0.3,

        },
    }

    TriggerEvent("debug", 'Inventory: Received Drops', 'success')
end)

RegisterNetEvent("inventory:client:RemoveDropItem")
AddEventHandler("inventory:client:RemoveDropItem", function(dropId)
    Drops[dropId] = nil
    TriggerEvent("debug", 'Inventory: Received Drops', 'success')
end)

RegisterNetEvent("inventory:client:ShowId")
AddEventHandler("inventory:client:ShowId", function(sourceId, citizenid, character)

    local targ = GetPlayerFromServerId(sourceId)
    if targ ~= nil and targ ~= -1 then
    local sourcePos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(sourceId)), false)
    local pos = GetEntityCoords(PlayerPedId(), false)
    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, sourcePos.x, sourcePos.y, sourcePos.z, true) < 2.0) then

        local gender = "Man"
        if character.gender == 1 then
            gender = "Woman"
        end

        TriggerEvent('chat:addMessage', {
            template = '<div class="chat-message advert"><div class="chat-message-body"><strong>{0}:</strong><br><br> <strong>BSN:</strong> {1} <br><strong>First Name:</strong> {2} <br><strong>Last name:</strong> {3} <br><strong>Birthday:</strong> {4} <br><strong>Sex:</strong> {5} <br><strong>Nationality:</strong> {6}</div></div>',
            args = {'ID card', character.citizenid, character.firstname, character.lastname, character.birthdate, gender, character.nationality}
        })
        end
    end
end)

RegisterNetEvent("inventory:client:ShowDriverLicense")
AddEventHandler("inventory:client:ShowDriverLicense", function(sourceId, citizenid, character)
    local targ = GetPlayerFromServerId(sourceId)
    if targ ~= nil and targ ~= -1 then
    local sourcePos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(sourceId)), false)
    local pos = GetEntityCoords(PlayerPedId(), false)
    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, sourcePos.x, sourcePos.y, sourcePos.z, true) < 2.0) then
        TriggerEvent('chat:addMessage', {
            template = '<div class="chat-message advert"><div class="chat-message-body"><strong>{0}:</strong><br><br> <strong>First Name:</strong> {1} <br><strong>Last name:</strong> {2} <br><strong>Birthday:</strong> {3} <br><strong>Driving licenses:</strong> {4}</div></div>',
            args = {'Drivers license', character.firstname, character.lastname, character.birthdate, character.type}
        })
        
        TriggerEvent("debug", 'Licenses: Show Driver', 'success')
    end
    end
end)

RegisterNetEvent("inventory:client:SetCurrentStash")
AddEventHandler("inventory:client:SetCurrentStash", function(stash)
    CurrentStash = stash
    TriggerEvent("debug", 'Inventory: Current Stash (' .. stash .. ')', 'success')
end)

RegisterNUICallback('getCombineItem', function(data, cb)
    cb(XZCore.Shared.Items[data.item])
end)

RegisterNUICallback("CloseInventory", function(data, cb)

    if currentOtherInventory == "none-inv" then

        CurrentDrop = 0
        CurrentVehicle = nil
        CurrentGlovebox = nil
        CurrentStash = nil
        SetNuiFocus(false, false)
        inInventory = false
        ClearPedTasks(PlayerPedId())
        return
    end

    if CurrentVehicle ~= nil then
        CloseTrunk()
        TriggerServerEvent("inventory:server:SaveInventory", "trunk", CurrentVehicle)
        CurrentVehicle = nil
    elseif CurrentGlovebox ~= nil then
        TriggerServerEvent("inventory:server:SaveInventory", "glovebox", CurrentGlovebox)
        CurrentGlovebox = nil
    elseif CurrentStash ~= nil then
        TriggerServerEvent("inventory:server:SaveInventory", "stash", CurrentStash)
        CurrentStash = nil
    else
        TriggerServerEvent("inventory:server:SaveInventory", "drop", CurrentDrop)
        CurrentDrop = 0
    end

    SetNuiFocus(false, false)
    inInventory = false
    TriggerScreenblurFadeOut(0)
    TriggerEvent("debug", 'Inventory: Close', 'error')
    TriggerEvent("xz:randPickupAnim")
end)
RegisterNUICallback("UseItem", function(data, cb)
    TriggerServerEvent("inventory:server:UseItem", data.inventory, data.item)
end)

RegisterNUICallback("combineItem", function(data)
    Citizen.Wait(150)
    TriggerServerEvent('inventory:server:combineItem', data.reward, data.fromItem, data.toItem)
    TriggerEvent('inventory:client:ItemBox', XZCore.Shared.Items[data.reward], 'add')
end)

RegisterNUICallback('combineWithAnim', function(data)
    local combineData = data.combineData
    local aDict = combineData.anim.dict
    local aLib = combineData.anim.lib
    local animText = combineData.anim.text
    local animTimeout = combineData.anim.timeOut

    XZCore.Functions.Progressbar("combine_anim", animText, animTimeout, false, true, {
        disableMovement = false,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = aDict,
        anim = aLib,
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(PlayerPedId(), aDict, aLib, 1.0)
        TriggerServerEvent('inventory:server:combineItem', combineData.reward, data.requiredItem, data.usedItem, data.fromInv)
        TriggerEvent('inventory:client:ItemBox', XZCore.Shared.Items[combineData.reward], 'add')
    end, function() -- Cancel
        StopAnimTask(PlayerPedId(), aDict, aLib, 1.0)
        XZCore.Functions.Notify("Failed!", "error")
    end)
end)

RegisterNUICallback("SetInventoryData", function(data, cb)
    if(exports["progressbar"].isDoingSomething()) then
        XZCore.Functions.Notify("You already doing something", "error")
        return
    end

    TriggerServerEvent("inventory:server:SetInventoryData", data.fromInventory, data.toInventory, data.fromSlot, data.toSlot, data.fromAmount, data.toAmount)
end)


RegisterNUICallback("PlayDropSound", function(data, cb)
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
end)

RegisterNUICallback("PlayDropFail", function(data, cb)
    PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
end)

function OpenTrunk()
    local vehicle = XZCore.Functions.GetClosestVehicle()
    while (not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b")) do
        RequestAnimDict("amb@prop_human_bum_bin@idle_b")
        Citizen.Wait(100)
    end
    TaskPlayAnim(PlayerPedId(), "amb@prop_human_bum_bin@idle_b", "idle_d", 4.0, 4.0, -1, 50, 0, false, false, false)
    if (IsBackEngine(GetEntityModel(vehicle))) then
        SetVehicleDoorOpen(vehicle, 4, false, false)
    else
        SetVehicleDoorOpen(vehicle, 5, false, false)
    end
end

function CloseTrunk()
    local vehicle = XZCore.Functions.GetClosestVehicle()
    while (not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b")) do
        RequestAnimDict("amb@prop_human_bum_bin@idle_b")
        Citizen.Wait(100)
    end
    TaskPlayAnim(PlayerPedId(), "amb@prop_human_bum_bin@idle_b", "exit", 4.0, 4.0, -1, 50, 0, false, false, false)
    if (IsBackEngine(GetEntityModel(vehicle))) then
        SetVehicleDoorShut(vehicle, 4, false)
    else
        SetVehicleDoorShut(vehicle, 5, false)
    end
end

function IsBackEngine(vehModel)
    for _, model in pairs(BackEngineVehicles) do
        if GetHashKey(model) == vehModel then
            return true
        end
    end
    return false
end

function ToggleHotbar(toggle)
    local HotbarItems = {
        [1] = XZCore.Functions.GetPlayerData().items[1],
        [2] = XZCore.Functions.GetPlayerData().items[2],
        [3] = XZCore.Functions.GetPlayerData().items[3],
        [4] = XZCore.Functions.GetPlayerData().items[4],
        [5] = XZCore.Functions.GetPlayerData().items[5],
        [41] = XZCore.Functions.GetPlayerData().items[41],
    } 

    if toggle then
        SendNUIMessage({
            action = "toggleHotbar",
            open = true,
            items = HotbarItems
        })
    else
        SendNUIMessage({
            action = "toggleHotbar",
            open = false,
        })
    end
end

function LoadAnimDict( dict )

    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

RegisterCommand('fixblur', function(source, args)
    TriggerScreenblurFadeIn(500)
    Wait(750)
    TriggerScreenblurFadeOut(500)
    print("blur cleared")
end)

local taskRand = false
RegisterNetEvent('xz:randPickupAnim')
AddEventHandler('xz:randPickupAnim', function()
    if not taskRand then
        taskRand = true
        LoadAnimDict('pickup_object')
        TaskPlayAnim(PlayerPedId(),'pickup_object', 'putdown_low',5.0, 1.5, 1.0, 48, 0.0, 0, 0, 0)
        Wait(1000)
        ClearPedSecondaryTask(PlayerPedId())
        taskRand = false
    end
end)

CreateThread(function()
    TriggerEvent("xz:interact:init", resourceName, "Mapping");
end)

RegisterNetEvent("xz:interact:ready", function()
    TriggerEvent("xz:interact:init", resourceName, "Mapping");
end)
local BackEngineVehicles = { -- Used from xz-vehicle failure <3
'ninef',
'adder',
'vagner',
't20',
'infernus',
'zentorno',
'reaper',
'comet2',
'comet3',
'jester',
'jester2',
'cheetah',
'cheetah2',
'prototipo',
'turismor',
'pfister811',
'ardent',
'nero',
'nero2',
'tempesta',
'vacca',
'bullet',
'osiris',
'entityxf',
'turismo2',
'fmj',
're7b',
'tyrus',
'italigtb',
'penetrator',
'monroe',
'ninef2',
'stingergt',
'surfer',
'surfer2',
'comet3',
}

isLoggedIn = true
PlayerJob = {}

local onDuty = false

RegisterNetEvent('XZCore:Client:OnPlayerLoaded', function()
    XZCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
        if PlayerData.job.onduty then
            if PlayerData.job.name == Config.Job then
                TriggerServerEvent("XZCore:ToggleDuty")
            end
        end
    end)
end)

RegisterNetEvent('XZCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    onDuty = PlayerJob.onduty
end)

RegisterNetEvent('XZCore:Client:SetDuty', function(duty)
    onDuty = duty
end)


local function saveVehicle()
    local plyPed = PlayerPedId()
    local veh = XZCore.Functions.GetClosestVehicle()
    local vehicleMods = {
        mods = {},
    }
    vehicleMods.mods[11] = GetVehicleMod(veh,11)
    vehicleMods.mods[12] = GetVehicleMod(veh,12)
    vehicleMods.mods[13] = GetVehicleMod(veh,13)
    vehicleMods.mods[15] = GetVehicleMod(veh,15)
    vehicleMods.mods[18] = IsToggleModOn(veh, 18)

local myCar = XZCore.Functions.GetVehicleProperties(veh)
local myPlate = GetVehicleNumberPlateText(veh)
    TriggerServerEvent('updateVehicle', myPlate, myCar)
end

function IsBackEngine(vehModel)
    for _, model in pairs(BackEngineVehicles) do
        if GetHashKey(model) == vehModel then
            return true
        end
    end
    return false
end


--Parts Install 

--Engine

RegisterNetEvent('xz-mechanicparts:E0', function()
    local vehicle = XZCore.Functions.GetClosestVehicle()
    local PlayerJob = XZCore.Functions.GetPlayerData().job
--     local trunkpos = false
    engine = GetVehicleMod(veh, 11)
        if PlayerJob.name == Config.Job then
            if onDuty then
                  if engine ~= -1 then 
                    if vehicle ~= nil and vehicle ~= 0 then
                        if (IsBackEngine(GetEntityModel(vehicle))) then
                            SetVehicleDoorOpen(vehicle, 5, false, false)
-- 			    trunkpos = true
                        else
                            SetVehicleDoorOpen(vehicle, 4, false, false)
                        end
                        local ped = PlayerPedId()
                        local pos = GetEntityCoords(ped)
                        local vehpos = GetEntityCoords(vehicle)
                        if #(pos - vehpos) < 4.0 and not IsPedInAnyVehicle(ped) then
                            local drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, 2.5, 0)
                            if (IsBackEngine(GetEntityModel(vehicle))) then
                                drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -2.5, 0)
                            end
                            if #(pos - drawpos) < 2.0 and not IsPedInAnyVehicle(ped) then
                                XZCore.Functions.Progressbar("Gas_Engine", "Installing Engine", 10000, false, true, {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {
                                    animDict = "mini@repair",
                                    anim = "fixing_a_player",
                                    flags = 16,
                                }, {}, {}, function() -- Done
                                    ClearPedTasksImmediately(PlayerPedId())
                                    SetVehicleModKit(vehicle, 0)
                                    SetVehicleMod(vehicle, 11, -1, true)
                                    local vehicle = XZCore.Functions.GetVehicleProperties(vehicle)
                                    saveVehicle()  
                                    TriggerServerEvent("XZCore:Server:RemoveItem", "engine0", 1)
                                    TriggerEvent('inventory:client:ItemBox', XZCore.Shared.Items["engine0"], "remove")
                                    XZCore.Functions.Notify("Stock Engine Successfully installed", "Success", 5000)
                                end)
-- 				if trunkpos then
-- 					SetVehicleDoorShut(vehicle, 5, false)
-- 				else
-- 					SetVehicleDoorShut(vehicle, 4, false)
-- 				end
                            end
                        end
                    end
                else
                    XZCore.Functions.Notify("Stock Engine Already Installed", "Error", 5000)
                end
            else
                XZCore.Functions.Notify("You need to sign on duty!!", "Error", 5000)
            end
        else
            XZCore.Functions.Notify("You are not allowed to complete this action", "error", 4000)
        end
end)

RegisterNetEvent('xz-mechanicparts:E1', function()
    local vehicle = XZCore.Functions.GetClosestVehicle()
    local PlayerJob = XZCore.Functions.GetPlayerData().job
    engine = GetVehicleMod(veh, 11)
        if PlayerJob.name == Config.Job then
            if onDuty then
                if engine ~= 0 then
                    if vehicle ~= nil and vehicle ~= 0 then
                        if (IsBackEngine(GetEntityModel(vehicle))) then
                            SetVehicleDoorOpen(vehicle, 5, false, false)
                        else
                            SetVehicleDoorOpen(vehicle, 4, false, false)
                        end
                        local ped = PlayerPedId()
                        local pos = GetEntityCoords(ped)
                        local vehpos = GetEntityCoords(vehicle)
                        if #(pos - vehpos) < 4.0 and not IsPedInAnyVehicle(ped) then
                            local drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, 2.5, 0)
                            if (IsBackEngine(GetEntityModel(vehicle))) then
                                drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -2.5, 0)
                            end
                            if #(pos - drawpos) < 2.0 and not IsPedInAnyVehicle(ped) then
                            
                                XZCore.Functions.Progressbar("Gas_Engine", "Installing Engine", 10000, false, true, {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {
                                    animDict = "mini@repair",
                                    anim = "fixing_a_player",
                                    flags = 16,
                                }, {}, {}, function() -- Done
                                    ClearPedTasksImmediately(PlayerPedId())
                                    SetVehicleModKit(vehicle, 0)
                                    SetVehicleMod(vehicle, 11, 0, true)
                                    local vehicle = XZCore.Functions.GetVehicleProperties(vehicle)
                                    saveVehicle()  
                                    TriggerServerEvent("XZCore:Server:RemoveItem", "engine1", 1)
                                    TriggerEvent('inventory:client:ItemBox', XZCore.Shared.Items["engine1"], "remove")
                                    XZCore.Functions.Notify("Engine Upgrade B Successfully installed", "Success", 5000)

                                end)
                            end
                        end
                    end
                else
                    XZCore.Functions.Notify("Engine Upgrade B Already Installed", "Error", 5000)
                end
            else
                XZCore.Functions.Notify("You need to sign on duty!!", "Error", 5000)
            end
        else
            XZCore.Functions.Notify("You are not allowed to complete this action", "error", 4000)
        end
end)

RegisterNetEvent('xz-mechanicparts:E2', function()
    local vehicle = XZCore.Functions.GetClosestVehicle()
    local PlayerJob = XZCore.Functions.GetPlayerData().job
    engine = GetVehicleMod(veh, 11)
        if PlayerJob.name == Config.Job then
            if onDuty then
                if engine ~= 1 then 
                    if vehicle ~= nil and vehicle ~= 0 then
                        if (IsBackEngine(GetEntityModel(vehicle))) then
                            SetVehicleDoorOpen(vehicle, 5, false, false)
                        else
                            SetVehicleDoorOpen(vehicle, 4, false, false)
                        end
                        local ped = PlayerPedId()
                        local pos = GetEntityCoords(ped)
                        local vehpos = GetEntityCoords(vehicle)
                        if #(pos - vehpos) < 4.0 and not IsPedInAnyVehicle(ped) then
                            local drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, 2.5, 0)
                            if (IsBackEngine(GetEntityModel(vehicle))) then
                                drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -2.5, 0)
                            end
                            if #(pos - drawpos) < 2.0 and not IsPedInAnyVehicle(ped) then
                            
                                XZCore.Functions.Progressbar("Gas_Engine", "Installing Engine", 10000, false, true, {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {
                                    animDict = "mini@repair",
                                    anim = "fixing_a_player",
                                    flags = 16,
                                }, {}, {}, function() -- Done
                                    ClearPedTasksImmediately(PlayerPedId())
                                    SetVehicleModKit(vehicle, 0)
                                    SetVehicleMod(vehicle, 11, 1, true)
                                    local vehicle = XZCore.Functions.GetVehicleProperties(vehicle)
                                    saveVehicle()  
                                    TriggerServerEvent("XZCore:Server:RemoveItem", "engine2", 1)
                                    TriggerEvent('inventory:client:ItemBox', XZCore.Shared.Items["engine2"], "remove")
                                    XZCore.Functions.Notify("Engine Upgrade C Successfully installed", "Success", 5000)

                                end)
                            end
                        end
                    end
                else
                    XZCore.Functions.Notify("Engine Upgrade C Already Installed", "Error", 5000)
                end
            else
                XZCore.Functions.Notify("You need to sign on duty!!", "Error", 5000)
            end
        else
            XZCore.Functions.Notify("You are not allowed to complete this action", "error", 4000)
        end
end)

RegisterNetEvent('xz-mechanicparts:E3', function()
    local vehicle = XZCore.Functions.GetClosestVehicle()
    local PlayerJob = XZCore.Functions.GetPlayerData().job
    engine = GetVehicleMod(veh, 11)
        if PlayerJob.name == Config.Job then
            if onDuty then
                if engine ~= 2 then 
                    if vehicle ~= nil and vehicle ~= 0 then
                        if (IsBackEngine(GetEntityModel(vehicle))) then
                            SetVehicleDoorOpen(vehicle, 5, false, false)
                        else
                            SetVehicleDoorOpen(vehicle, 4, false, false)
                        end
                        local ped = PlayerPedId()
                        local pos = GetEntityCoords(ped)
                        local vehpos = GetEntityCoords(vehicle)
                        if #(pos - vehpos) < 4.0 and not IsPedInAnyVehicle(ped) then
                            local drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, 2.5, 0)
                            if (IsBackEngine(GetEntityModel(vehicle))) then
                                drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -2.5, 0)
                            end
                            if #(pos - drawpos) < 2.0 and not IsPedInAnyVehicle(ped) then
                            
                                XZCore.Functions.Progressbar("Gas_Engine", "Installing Engine", 10000, false, true, {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {
                                    animDict = "mini@repair",
                                    anim = "fixing_a_player",
                                    flags = 16,
                                }, {}, {}, function() -- Done
                                    ClearPedTasksImmediately(PlayerPedId())
                                    SetVehicleModKit(vehicle, 0)
                                    SetVehicleMod(vehicle, 11, 2, true)
                                    local vehicle = XZCore.Functions.GetVehicleProperties(vehicle)
                                    saveVehicle()  
                                    TriggerServerEvent("XZCore:Server:RemoveItem", "engine3", 1)
                                    TriggerEvent('inventory:client:ItemBox', XZCore.Shared.Items["engine3"], "remove")
                                    XZCore.Functions.Notify("Engine Upgrade D Successfully installed", "Success", 5000)

                                end)
                            end
                        end
                    end
                else
                    XZCore.Functions.Notify("Engine Upgrade D Already Installed", "Error", 5000)
                end
            else
                XZCore.Functions.Notify("You need to sign on duty!!", "Error", 5000)
            end
        else
            XZCore.Functions.Notify("You are not allowed to complete this action", "error", 4000)
        end
end)


RegisterNetEvent('xz-mechanicparts:E4', function()
    local vehicle = XZCore.Functions.GetClosestVehicle()
    local PlayerJob = XZCore.Functions.GetPlayerData().job
    engine = GetVehicleMod(veh, 11)
        if PlayerJob.name == Config.Job then
            if onDuty then
                if engine ~= 3 then 
                    if vehicle ~= nil and vehicle ~= 0 then
                        if (IsBackEngine(GetEntityModel(vehicle))) then
                            SetVehicleDoorOpen(vehicle, 5, false, false)
                        else
                            SetVehicleDoorOpen(vehicle, 4, false, false)
                        end
                        local ped = PlayerPedId()
                        local pos = GetEntityCoords(ped)
                        local vehpos = GetEntityCoords(vehicle)
                        if #(pos - vehpos) < 4.0 and not IsPedInAnyVehicle(ped) then
                            local drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, 2.5, 0)
                            if (IsBackEngine(GetEntityModel(vehicle))) then
                                drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -2.5, 0)
                            end
                            if #(pos - drawpos) < 2.0 and not IsPedInAnyVehicle(ped) then
                            
                                XZCore.Functions.Progressbar("Gas_Engine", "Installing Engine", 10000, false, true, {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {
                                    animDict = "mini@repair",
                                    anim = "fixing_a_player",
                                    flags = 16,
                                }, {}, {}, function() -- Done
                                    ClearPedTasksImmediately(PlayerPedId())
                                    SetVehicleModKit(vehicle, 0)
                                    SetVehicleMod(vehicle, 11, 3, true)
                                    local vehicle = XZCore.Functions.GetVehicleProperties(vehicle)
                                    saveVehicle()  
                                    TriggerServerEvent("XZCore:Server:RemoveItem", "engine4", 1)
                                    TriggerEvent('inventory:client:ItemBox', XZCore.Shared.Items["engine4"], "remove")
                                    XZCore.Functions.Notify("Engine Upgrade S Successfully installed", "Success", 5000)

                                end)
                            end
                        end
                    end
                else
                    XZCore.Functions.Notify("Engine Upgrade S Already Installed", "Error", 5000)
                end
            else
                XZCore.Functions.Notify("You need to sign on duty!!", "Error", 5000)
            end
        else
            XZCore.Functions.Notify("You are not allowed to complete this action", "error", 4000)
        end
end)

--brakes
RegisterNetEvent('xz-mechanicparts:B0', function()
    local vehicle = XZCore.Functions.GetClosestVehicle()
    local PlayerJob = XZCore.Functions.GetPlayerData().job
    brake = GetVehicleMod(veh, 12)
        if PlayerJob.name == Config.Job then
            if onDuty then
                if brake ~= -1 then
                    if vehicle ~= nil and vehicle ~= 0 then
                        if (IsBackEngine(GetEntityModel(vehicle))) then
                            SetVehicleDoorOpen(vehicle, 5, false, false)
                        else
                            SetVehicleDoorOpen(vehicle, 4, false, false)
                        end
                        local ped = PlayerPedId()
                        local pos = GetEntityCoords(ped)
                        local vehpos = GetEntityCoords(vehicle)
                        if #(pos - vehpos) < 4.0 and not IsPedInAnyVehicle(ped) then
                            local drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, 2.5, 0)
                            if (IsBackEngine(GetEntityModel(vehicle))) then
                                drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -2.5, 0)
                            end
                            if #(pos - drawpos) < 2.0 and not IsPedInAnyVehicle(ped) then
                            
                                XZCore.Functions.Progressbar("Brakes", "Installing Stock Brakes", 10000, false, true, {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {
                                    animDict = "mini@repair",
                                    anim = "fixing_a_player",
                                    flags = 16,
                                }, {}, {}, function() -- Done
                                    ClearPedTasksImmediately(PlayerPedId())
                                    SetVehicleModKit(vehicle, 0)
                                    SetVehicleMod(vehicle, 12, -1, true)
                                    local vehicle = XZCore.Functions.GetVehicleProperties(vehicle)
                                    saveVehicle()  
                                    TriggerServerEvent("XZCore:Server:RemoveItem", "brake0", 1)
                                    TriggerEvent('inventory:client:ItemBox', XZCore.Shared.Items["brake0"], "remove")
                                    XZCore.Functions.Notify("Stock Brakes Successfully installed", "Success", 5000)

                                end)
                            end
                        end
                    end
                else
                    XZCore.Functions.Notify("Stock Brakes Already Installed", "Error", 5000)
                end
            else
                XZCore.Functions.Notify("You need to sign on duty!!", "Error", 5000)
            end
        else
            XZCore.Functions.Notify("You are not allowed to complete this action", "error", 4000)
        end
end)

RegisterNetEvent('xz-mechanicparts:B1', function()
    local vehicle = XZCore.Functions.GetClosestVehicle()
    local PlayerJob = XZCore.Functions.GetPlayerData().job
    brake = GetVehicleMod(veh, 12)
        if PlayerJob.name == Config.Job then
            if onDuty then
                if brake ~= 0 then
                    if vehicle ~= nil and vehicle ~= 0 then
                        if (IsBackEngine(GetEntityModel(vehicle))) then
                            SetVehicleDoorOpen(vehicle, 5, false, false)
                        else
                            SetVehicleDoorOpen(vehicle, 4, false, false)
                        end
                        local ped = PlayerPedId()
                        local pos = GetEntityCoords(ped)
                        local vehpos = GetEntityCoords(vehicle)
                        if #(pos - vehpos) < 4.0 and not IsPedInAnyVehicle(ped) then
                            local drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, 2.5, 0)
                            if (IsBackEngine(GetEntityModel(vehicle))) then
                                drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -2.5, 0)
                            end
                            if #(pos - drawpos) < 2.0 and not IsPedInAnyVehicle(ped) then
                            
                                XZCore.Functions.Progressbar("Brakes", "Installing Brakes", 10000, false, true, {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {
                                    animDict = "mini@repair",
                                    anim = "fixing_a_player",
                                    flags = 16,
                                }, {}, {}, function() -- Done
                                    ClearPedTasksImmediately(PlayerPedId())
                                    SetVehicleModKit(vehicle, 0)
                                    SetVehicleMod(vehicle, 12, 0, true)
                                    local vehicle = XZCore.Functions.GetVehicleProperties(vehicle)
                                    saveVehicle()  
                                    TriggerServerEvent("XZCore:Server:RemoveItem", "brake1", 1)
                                    TriggerEvent('inventory:client:ItemBox', XZCore.Shared.Items["brake1"], "remove")
                                    XZCore.Functions.Notify("Brake Upgrade B Successfully installed", "Success", 5000)

                                end)
                            end
                        end
                    end
                else
                    XZCore.Functions.Notify("Brakes Upgrade B Already Installed", "Error", 5000)
                end
            else
                XZCore.Functions.Notify("You need to sign on duty!!", "Error", 5000)
            end
        else
            XZCore.Functions.Notify("You are not allowed to complete this action", "error", 4000)
        end
end)

RegisterNetEvent('xz-mechanicparts:B2', function()
    local vehicle = XZCore.Functions.GetClosestVehicle()
    local PlayerJob = XZCore.Functions.GetPlayerData().job
    brake = GetVehicleMod(veh, 12)
        if PlayerJob.name == Config.Job then
            if onDuty then
                if brake ~= 1 then
                    if vehicle ~= nil and vehicle ~= 0 then
                        if (IsBackEngine(GetEntityModel(vehicle))) then
                            SetVehicleDoorOpen(vehicle, 5, false, false)
                        else
                            SetVehicleDoorOpen(vehicle, 4, false, false)
                        end
                        local ped = PlayerPedId()
                        local pos = GetEntityCoords(ped)
                        local vehpos = GetEntityCoords(vehicle)
                        if #(pos - vehpos) < 4.0 and not IsPedInAnyVehicle(ped) then
                            local drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, 2.5, 0)
                            if (IsBackEngine(GetEntityModel(vehicle))) then
                                drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -2.5, 0)
                            end
                            if #(pos - drawpos) < 2.0 and not IsPedInAnyVehicle(ped) then
                            
                                XZCore.Functions.Progressbar("Brakes", "Installing Brakes", 10000, false, true, {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {
                                    animDict = "mini@repair",
                                    anim = "fixing_a_player",
                                    flags = 16,
                                }, {}, {}, function() -- Done
                                    ClearPedTasksImmediately(PlayerPedId())
                                    SetVehicleModKit(vehicle, 0)
                                    SetVehicleMod(vehicle, 12, 1, true)
                                    local vehicle = XZCore.Functions.GetVehicleProperties(vehicle)
                                    saveVehicle()  
                                    TriggerServerEvent("XZCore:Server:RemoveItem", "brake2", 1)
                                    TriggerEvent('inventory:client:ItemBox', XZCore.Shared.Items["brake2"], "remove")
                                    XZCore.Functions.Notify("Brakes Upgrade C Successfully installed", "Success", 5000)

                                end)
                            end
                        end
                    end
                else
                    XZCore.Functions.Notify("Brakes Upgrade C Already Installed", "Error", 5000)
                end
            else
                XZCore.Functions.Notify("You need to sign on duty!!", "Error", 5000)
            end
        else
            XZCore.Functions.Notify("You are not allowed to complete this action", "error", 4000)
        end
end)

RegisterNetEvent('xz-mechanicparts:B3', function()
    local vehicle = XZCore.Functions.GetClosestVehicle()
    local PlayerJob = XZCore.Functions.GetPlayerData().job
    brake = GetVehicleMod(veh, 12)
        if PlayerJob.name == Config.Job then
            if onDuty then
                if brake ~= 2 then
                    if vehicle ~= nil and vehicle ~= 0 then
                        if (IsBackEngine(GetEntityModel(vehicle))) then
                            SetVehicleDoorOpen(vehicle, 5, false, false)
                        else
                            SetVehicleDoorOpen(vehicle, 4, false, false)
                        end
                        local ped = PlayerPedId()
                        local pos = GetEntityCoords(ped)
                        local vehpos = GetEntityCoords(vehicle)
                        if #(pos - vehpos) < 4.0 and not IsPedInAnyVehicle(ped) then
                            local drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, 2.5, 0)
                            if (IsBackEngine(GetEntityModel(vehicle))) then
                                drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -2.5, 0)
                            end
                            if #(pos - drawpos) < 2.0 and not IsPedInAnyVehicle(ped) then
                            
                                XZCore.Functions.Progressbar("Brakes", "Installing Brakes", 10000, false, true, {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {
                                    animDict = "mini@repair",
                                    anim = "fixing_a_player",
                                    flags = 16,
                                }, {}, {}, function() -- Done
                                    ClearPedTasksImmediately(PlayerPedId())
                                    SetVehicleModKit(vehicle, 0)
                                    SetVehicleMod(vehicle, 12, 2, true)
                                    local vehicle = XZCore.Functions.GetVehicleProperties(vehicle)
                                    saveVehicle()  
                                    TriggerServerEvent("XZCore:Server:RemoveItem", "brake3", 1)
                                    TriggerEvent('inventory:client:ItemBox', XZCore.Shared.Items["brake3"], "remove")
                                    XZCore.Functions.Notify("Brakes Upgrade S Successfully installed", "Success", 5000)

                                end)
                            end
                        end
                    end
                else
                    XZCore.Functions.Notify("Brakes Upgrade S Already Installed", "Error", 5000)
                end
            else
                XZCore.Functions.Notify("You need to sign on duty!!", "Error", 5000)
            end
        else
            XZCore.Functions.Notify("You are not allowed to complete this action", "error", 4000)
        end
end)

-- --Transmission
RegisterNetEvent('xz-mechanicparts:T0', function()
    local vehicle = XZCore.Functions.GetClosestVehicle()
    local PlayerJob = XZCore.Functions.GetPlayerData().job
    transmission = GetVehicleMod(veh, 13)
        if PlayerJob.name == Config.Job then
            if onDuty then
                if transmission ~= -1 then
                    if vehicle ~= nil and vehicle ~= 0 then
                        if (IsBackEngine(GetEntityModel(vehicle))) then
                            SetVehicleDoorOpen(vehicle, 5, false, false)
                        else
                            SetVehicleDoorOpen(vehicle, 4, false, false)
                        end
                        local ped = PlayerPedId()
                        local pos = GetEntityCoords(ped)
                        local vehpos = GetEntityCoords(vehicle)
                        if #(pos - vehpos) < 4.0 and not IsPedInAnyVehicle(ped) then
                            local drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, 2.5, 0)
                            if (IsBackEngine(GetEntityModel(vehicle))) then
                                drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -2.5, 0)
                            end
                            if #(pos - drawpos) < 2.0 and not IsPedInAnyVehicle(ped) then
                            
                                XZCore.Functions.Progressbar("Transmission", "Installing Stock Transmission", 10000, false, true, {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {
                                    animDict = "mini@repair",
                                    anim = "fixing_a_player",
                                    flags = 16,
                                }, {}, {}, function() -- Done
                                    ClearPedTasksImmediately(PlayerPedId())
                                    SetVehicleModKit(vehicle, 0)
                                    SetVehicleMod(vehicle, 13, -1, true)
                                    local vehicle = XZCore.Functions.GetVehicleProperties(vehicle)
                                    saveVehicle()  
                                    TriggerServerEvent("XZCore:Server:RemoveItem", "transmission0", 1)
                                    TriggerEvent('inventory:client:ItemBox', XZCore.Shared.Items["transmission0"], "remove")
                                    XZCore.Functions.Notify("Stock Transmission Successfully installed", "Success", 5000)

                                end)
                            end
                        end
                    end
                else
                    XZCore.Functions.Notify("Stock Transmission Already Installed", "Error", 5000)
                end
            else
                XZCore.Functions.Notify("You need to sign on duty!!", "Error", 5000)
            end
        else
            XZCore.Functions.Notify("You are not allowed to complete this action", "error", 4000)
        end
end)

RegisterNetEvent('xz-mechanicparts:T1', function()
    local vehicle = XZCore.Functions.GetClosestVehicle()
    local PlayerJob = XZCore.Functions.GetPlayerData().job
    transmission = GetVehicleMod(veh, 13)
        if PlayerJob.name == Config.Job then
            if onDuty then
                if transmission ~= 0 then
                    if vehicle ~= nil and vehicle ~= 0 then
                        if (IsBackEngine(GetEntityModel(vehicle))) then
                            SetVehicleDoorOpen(vehicle, 5, false, false)
                        else
                            SetVehicleDoorOpen(vehicle, 4, false, false)
                        end
                        local ped = PlayerPedId()
                        local pos = GetEntityCoords(ped)
                        local vehpos = GetEntityCoords(vehicle)
                        if #(pos - vehpos) < 4.0 and not IsPedInAnyVehicle(ped) then
                            local drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, 2.5, 0)
                            if (IsBackEngine(GetEntityModel(vehicle))) then
                                drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -2.5, 0)
                            end
                            if #(pos - drawpos) < 2.0 and not IsPedInAnyVehicle(ped) then
                            
                                XZCore.Functions.Progressbar("Transmission", "Installing Transmission", 10000, false, true, {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {
                                    animDict = "mini@repair",
                                    anim = "fixing_a_player",
                                    flags = 16,
                                }, {}, {}, function() -- Done
                                    ClearPedTasksImmediately(PlayerPedId())
                                    SetVehicleModKit(vehicle, 0)
                                    SetVehicleMod(vehicle, 13, 0, true)
                                    local vehicle = XZCore.Functions.GetVehicleProperties(vehicle)
                                    saveVehicle()  
                                    TriggerServerEvent("XZCore:Server:RemoveItem", "transmission1", 1)
                                    TriggerEvent('inventory:client:ItemBox', XZCore.Shared.Items["transmission1"], "remove")
                                    XZCore.Functions.Notify("Transmission Upgrade B Successfully installed", "Success", 5000)

                                end)
                            end
                        end
                    end
                else
                    XZCore.Functions.Notify("Transmission Upgrade B Already Installed", "Error", 5000)
                end
            else
                XZCore.Functions.Notify("You need to sign on duty!!", "Error", 5000)
            end
        else
            XZCore.Functions.Notify("You are not allowed to complete this action", "error", 4000)
        end
end)

RegisterNetEvent('xz-mechanicparts:T2', function()
    local vehicle = XZCore.Functions.GetClosestVehicle()
    local PlayerJob = XZCore.Functions.GetPlayerData().job
    transmission = GetVehicleMod(veh, 13)
        if PlayerJob.name == Config.Job then
            if onDuty then
                if transmission ~= 1 then
                    if vehicle ~= nil and vehicle ~= 0 then
                        if (IsBackEngine(GetEntityModel(vehicle))) then
                            SetVehicleDoorOpen(vehicle, 5, false, false)
                        else
                            SetVehicleDoorOpen(vehicle, 4, false, false)
                        end
                        local ped = PlayerPedId()
                        local pos = GetEntityCoords(ped)
                        local vehpos = GetEntityCoords(vehicle)
                        if #(pos - vehpos) < 4.0 and not IsPedInAnyVehicle(ped) then
                            local drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, 2.5, 0)
                            if (IsBackEngine(GetEntityModel(vehicle))) then
                                drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -2.5, 0)
                            end
                            if #(pos - drawpos) < 2.0 and not IsPedInAnyVehicle(ped) then
                            
                                XZCore.Functions.Progressbar("Transmission", "Installing Transmission", 10000, false, true, {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {
                                    animDict = "mini@repair",
                                    anim = "fixing_a_player",
                                    flags = 16,
                                }, {}, {}, function() -- Done
                                    ClearPedTasksImmediately(PlayerPedId())
                                    SetVehicleModKit(vehicle, 0)
                                    SetVehicleMod(vehicle, 13, 1, true)
                                    local vehicle = XZCore.Functions.GetVehicleProperties(vehicle)
                                    saveVehicle()  
                                    TriggerServerEvent("XZCore:Server:RemoveItem", "transmission2", 1)
                                    TriggerEvent('inventory:client:ItemBox', XZCore.Shared.Items["transmission2"], "remove")
                                    XZCore.Functions.Notify("Transmission Upgrade C Successfully installed", "Success", 5000)

                                end)
                            end
                        end
                    end
                else
                    XZCore.Functions.Notify("Transmission Upgrade C Already Installed", "Error", 5000)
                end
            else
                XZCore.Functions.Notify("You need to sign on duty!!", "Error", 5000)
            end
        else
            XZCore.Functions.Notify("You are not allowed to complete this action", "error", 4000)
        end
end)

RegisterNetEvent('xz-mechanicparts:T3', function()
    local vehicle = XZCore.Functions.GetClosestVehicle()
    local PlayerJob = XZCore.Functions.GetPlayerData().job
    transmission = GetVehicleMod(veh, 13)
        if PlayerJob.name == Config.Job then
            if onDuty then
                if transmission ~= 2 then
                    if vehicle ~= nil and vehicle ~= 0 then
                        if (IsBackEngine(GetEntityModel(vehicle))) then
                            SetVehicleDoorOpen(vehicle, 5, false, false)
                        else
                            SetVehicleDoorOpen(vehicle, 4, false, false)
                        end
                        local ped = PlayerPedId()
                        local pos = GetEntityCoords(ped)
                        local vehpos = GetEntityCoords(vehicle)
                        if #(pos - vehpos) < 4.0 and not IsPedInAnyVehicle(ped) then
                            local drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, 2.5, 0)
                            if (IsBackEngine(GetEntityModel(vehicle))) then
                                drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -2.5, 0)
                            end
                            if #(pos - drawpos) < 2.0 and not IsPedInAnyVehicle(ped) then
                            
                                XZCore.Functions.Progressbar("Transmission", "Installing Transmission", 10000, false, true, {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {
                                    animDict = "mini@repair",
                                    anim = "fixing_a_player",
                                    flags = 16,
                                }, {}, {}, function() -- Done
                                    ClearPedTasksImmediately(PlayerPedId())
                                    SetVehicleModKit(vehicle, 0)
                                    SetVehicleMod(vehicle, 13, 2, true)
                                    local vehicle = XZCore.Functions.GetVehicleProperties(vehicle)
                                    saveVehicle()  
                                    TriggerServerEvent("XZCore:Server:RemoveItem", "transmission3", 1)
                                    TriggerEvent('inventory:client:ItemBox', XZCore.Shared.Items["transmission3"], "remove")
                                    XZCore.Functions.Notify("Transmission Upgrade S Successfully installed", "Success", 5000)

                                end)
                            end
                        end
                    end
                else
                    XZCore.Functions.Notify("Transmission Upgrade S Already Installed", "Error", 5000)
                end
            else
                XZCore.Functions.Notify("You need to sign on duty!!", "Error", 5000)
            end
        else
            XZCore.Functions.Notify("You are not allowed to complete this action", "error", 4000)
        end
end)

-- --Suspension
RegisterNetEvent('xz-mechanicparts:S0', function()
    local vehicle = XZCore.Functions.GetClosestVehicle()
    local PlayerJob = XZCore.Functions.GetPlayerData().job
    suspension = GetVehicleMod(veh, 15)
        if PlayerJob.name == Config.Job then
            if onDuty then
                if suspension ~= -1 then
                    if vehicle ~= nil and vehicle ~= 0 then
                        if (IsBackEngine(GetEntityModel(vehicle))) then
                            SetVehicleDoorOpen(vehicle, 5, false, false)
                        else
                            SetVehicleDoorOpen(vehicle, 4, false, false)
                        end
                        local ped = PlayerPedId()
                        local pos = GetEntityCoords(ped)
                        local vehpos = GetEntityCoords(vehicle)
                        if #(pos - vehpos) < 4.0 and not IsPedInAnyVehicle(ped) then
                            local drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, 2.5, 0)
                            if (IsBackEngine(GetEntityModel(vehicle))) then
                                drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -2.5, 0)
                            end
                            if #(pos - drawpos) < 2.0 and not IsPedInAnyVehicle(ped) then
                            
                                XZCore.Functions.Progressbar("Suspension", "Installing Stock Suspension", 10000, false, true, {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {
                                    animDict = "mini@repair",
                                    anim = "fixing_a_player",
                                    flags = 16,
                                }, {}, {}, function() -- Done
                                    ClearPedTasksImmediately(PlayerPedId())
                                    SetVehicleModKit(vehicle, 0)
                                    SetVehicleMod(vehicle, 15, -1, true)
                                    local vehicle = XZCore.Functions.GetVehicleProperties(vehicle)
                                    saveVehicle()  
                                    TriggerServerEvent("XZCore:Server:RemoveItem", "suspension0", 1)
                                    TriggerEvent('inventory:client:ItemBox', XZCore.Shared.Items["suspension0"], "remove")
                                    XZCore.Functions.Notify("Stock Suspension Successfully installed", "Success", 5000)

                                end)
                            end
                        end
                    end
                else
                    XZCore.Functions.Notify("Stock Suspension Already Installed", "Error", 5000)
                end
            else
                XZCore.Functions.Notify("You need to sign on duty!!", "Error", 5000)
            end
        else
            XZCore.Functions.Notify("You are not allowed to complete this action", "error", 4000)
        end
end)

RegisterNetEvent('xz-mechanicparts:S1', function()
    local vehicle = XZCore.Functions.GetClosestVehicle()
    local PlayerJob = XZCore.Functions.GetPlayerData().job
    suspension = GetVehicleMod(veh, 15)
        if PlayerJob.name == Config.Job then
            if onDuty then
                if suspension ~= 0 then
                    if vehicle ~= nil and vehicle ~= 0 then
                        if (IsBackEngine(GetEntityModel(vehicle))) then
                            SetVehicleDoorOpen(vehicle, 5, false, false)
                        else
                            SetVehicleDoorOpen(vehicle, 4, false, false)
                        end
                        local ped = PlayerPedId()
                        local pos = GetEntityCoords(ped)
                        local vehpos = GetEntityCoords(vehicle)
                        if #(pos - vehpos) < 4.0 and not IsPedInAnyVehicle(ped) then
                            local drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, 2.5, 0)
                            if (IsBackEngine(GetEntityModel(vehicle))) then
                                drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -2.5, 0)
                            end
                            if #(pos - drawpos) < 2.0 and not IsPedInAnyVehicle(ped) then
                            
                                XZCore.Functions.Progressbar("Suspension", "Installing Suspension", 10000, false, true, {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {
                                    animDict = "mini@repair",
                                    anim = "fixing_a_player",
                                    flags = 16,
                                }, {}, {}, function() -- Done
                                    ClearPedTasksImmediately(PlayerPedId())
                                    SetVehicleModKit(vehicle, 0)
                                    SetVehicleMod(vehicle, 15, 0, true)
                                    local vehicle = XZCore.Functions.GetVehicleProperties(vehicle)
                                    saveVehicle()  
                                    TriggerServerEvent("XZCore:Server:RemoveItem", "suspension1", 1)
                                    TriggerEvent('inventory:client:ItemBox', XZCore.Shared.Items["suspension1"], "remove")
                                    XZCore.Functions.Notify("Suspension Upgrade B Successfully installed", "Success", 5000)

                                end)
                            end
                        end
                    end
                else
                    XZCore.Functions.Notify("Suspension Upgrade B Already Installed", "Error", 5000)
                end
            else
                XZCore.Functions.Notify("You need to sign on duty!!", "Error", 5000)
            end
        else
            XZCore.Functions.Notify("You are not allowed to complete this action", "error", 4000)
        end
end)

RegisterNetEvent('xz-mechanicparts:S2', function()
    local vehicle = XZCore.Functions.GetClosestVehicle()
    local PlayerJob = XZCore.Functions.GetPlayerData().job
    suspension = GetVehicleMod(veh, 15)
        if PlayerJob.name == Config.Job then
            if onDuty then
                if suspension ~= 1 then
                    if vehicle ~= nil and vehicle ~= 0 then
                        if (IsBackEngine(GetEntityModel(vehicle))) then
                            SetVehicleDoorOpen(vehicle, 5, false, false)
                        else
                            SetVehicleDoorOpen(vehicle, 4, false, false)
                        end
                        local ped = PlayerPedId()
                        local pos = GetEntityCoords(ped)
                        local vehpos = GetEntityCoords(vehicle)
                        if #(pos - vehpos) < 4.0 and not IsPedInAnyVehicle(ped) then
                            local drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, 2.5, 0)
                            if (IsBackEngine(GetEntityModel(vehicle))) then
                                drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -2.5, 0)
                            end
                            if #(pos - drawpos) < 2.0 and not IsPedInAnyVehicle(ped) then
                            
                                XZCore.Functions.Progressbar("Suspension", "Installing Suspension", 10000, false, true, {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {
                                    animDict = "mini@repair",
                                    anim = "fixing_a_player",
                                    flags = 16,
                                }, {}, {}, function() -- Done
                                    ClearPedTasksImmediately(PlayerPedId())
                                    SetVehicleModKit(vehicle, 0)
                                    SetVehicleMod(vehicle, 15, 1, true)
                                    local vehicle = XZCore.Functions.GetVehicleProperties(vehicle)
                                    saveVehicle()  
                                    TriggerServerEvent("XZCore:Server:RemoveItem", "suspension2", 1)
                                    TriggerEvent('inventory:client:ItemBox', XZCore.Shared.Items["suspension2"], "remove")
                                    XZCore.Functions.Notify("Suspension Upgrade C Successfully installed", "Success", 5000)

                                end)
                            end
                        end
                    end
                else
                    XZCore.Functions.Notify("Suspension Upgrade C Already Installed", "Error", 5000)
                end
            else
                XZCore.Functions.Notify("You need to sign on duty!!", "Error", 5000)
            end
        else
            XZCore.Functions.Notify("You are not allowed to complete this action", "error", 4000)
        end
end)

RegisterNetEvent('xz-mechanicparts:S3', function()
    local vehicle = XZCore.Functions.GetClosestVehicle()
    local PlayerJob = XZCore.Functions.GetPlayerData().job
    suspension = GetVehicleMod(veh, 15)
        if PlayerJob.name == Config.Job then
            if onDuty then
                if suspension ~= 2 then
                    if vehicle ~= nil and vehicle ~= 0 then
                        if (IsBackEngine(GetEntityModel(vehicle))) then
                            SetVehicleDoorOpen(vehicle, 5, false, false)
                        else
                            SetVehicleDoorOpen(vehicle, 4, false, false)
                        end
                        local ped = PlayerPedId()
                        local pos = GetEntityCoords(ped)
                        local vehpos = GetEntityCoords(vehicle)
                        if #(pos - vehpos) < 4.0 and not IsPedInAnyVehicle(ped) then
                            local drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, 2.5, 0)
                            if (IsBackEngine(GetEntityModel(vehicle))) then
                                drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -2.5, 0)
                            end
                            if #(pos - drawpos) < 2.0 and not IsPedInAnyVehicle(ped) then
                            
                                XZCore.Functions.Progressbar("Suspension", "Installing Suspension", 10000, false, true, {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {
                                    animDict = "mini@repair",
                                    anim = "fixing_a_player",
                                    flags = 16,
                                }, {}, {}, function() -- Done
                                    ClearPedTasksImmediately(PlayerPedId())
                                    SetVehicleModKit(vehicle, 0)
                                    SetVehicleMod(vehicle, 15, 2, true)
                                    local vehicle = XZCore.Functions.GetVehicleProperties(vehicle)
                                    saveVehicle()  
                                    TriggerServerEvent("XZCore:Server:RemoveItem", "suspension3", 1)
                                    TriggerEvent('inventory:client:ItemBox', XZCore.Shared.Items["suspension3"], "remove")
                                    XZCore.Functions.Notify("Suspension Upgrade D Successfully installed", "Success", 5000)

                                end)
                            end
                        end
                    end
                else
                    XZCore.Functions.Notify("Suspension Upgrade D Already Installed", "Error", 5000)
                end
            else
                XZCore.Functions.Notify("You need to sign on duty!!", "Error", 5000)
            end
        else
            XZCore.Functions.Notify("You are not allowed to complete this action", "error", 4000)
        end
end)

RegisterNetEvent('xz-mechanicparts:S4', function()
    local vehicle = XZCore.Functions.GetClosestVehicle()
    local PlayerJob = XZCore.Functions.GetPlayerData().job
    suspension = GetVehicleMod(veh, 15)
        if PlayerJob.name == Config.Job then
            if onDuty then
                if suspension ~= 3 then
                    if vehicle ~= nil and vehicle ~= 0 then
                        if (IsBackEngine(GetEntityModel(vehicle))) then
                            SetVehicleDoorOpen(vehicle, 5, false, false)
                        else
                            SetVehicleDoorOpen(vehicle, 4, false, false)
                        end
                        local ped = PlayerPedId()
                        local pos = GetEntityCoords(ped)
                        local vehpos = GetEntityCoords(vehicle)
                        if #(pos - vehpos) < 4.0 and not IsPedInAnyVehicle(ped) then
                            local drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, 2.5, 0)
                            if (IsBackEngine(GetEntityModel(vehicle))) then
                                drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -2.5, 0)
                            end
                            if #(pos - drawpos) < 2.0 and not IsPedInAnyVehicle(ped) then
                            
                                XZCore.Functions.Progressbar("Suspension", "Installing Suspension", 10000, false, true, {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {
                                    animDict = "mini@repair",
                                    anim = "fixing_a_player",
                                    flags = 16,
                                }, {}, {}, function() -- Done
                                    ClearPedTasksImmediately(PlayerPedId())
                                    SetVehicleModKit(vehicle, 0)
                                    SetVehicleMod(vehicle, 15, 3, true)
                                    local vehicle = XZCore.Functions.GetVehicleProperties(vehicle)
                                    saveVehicle()  
                                    TriggerServerEvent("XZCore:Server:RemoveItem", "suspension4", 1)
                                    TriggerEvent('inventory:client:ItemBox', XZCore.Shared.Items["suspension4"], "remove")
                                    XZCore.Functions.Notify("Suspension Upgrade S Successfully installed", "Success", 5000)

                                end)
                            end
                        end
                    end
                else
                    XZCore.Functions.Notify("Suspension Upgrade S Already Installed", "Error", 5000)
                end
            else
                XZCore.Functions.Notify("You need to sign on duty!!", "Error", 5000)
            end
        else
            XZCore.Functions.Notify("You are not allowed to complete this action", "error", 4000)
        end
end)

-- --Suspension
RegisterNetEvent('xz-mechanicparts:Turbo0', function()
    local vehicle = XZCore.Functions.GetClosestVehicle()
    local PlayerJob = XZCore.Functions.GetPlayerData().job
    turbo = IsToggleModOn(veh, 18)
    print(turbo)
        if PlayerJob.name == Config.Job then
            if onDuty then
                if turbo == 1 then
                    if vehicle ~= nil and vehicle ~= 0 then
                        if (IsBackEngine(GetEntityModel(vehicle))) then
                            SetVehicleDoorOpen(vehicle, 5, false, false)
                        else
                            SetVehicleDoorOpen(vehicle, 4, false, false)
                        end
                        local ped = PlayerPedId()
                        local pos = GetEntityCoords(ped)
                        local vehpos = GetEntityCoords(vehicle)
                        if #(pos - vehpos) < 4.0 and not IsPedInAnyVehicle(ped) then
                            local drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, 2.5, 0)
                            if (IsBackEngine(GetEntityModel(vehicle))) then
                                drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -2.5, 0)
                            end
                            if #(pos - drawpos) < 2.0 and not IsPedInAnyVehicle(ped) then
                            
                                XZCore.Functions.Progressbar("Turbo", "Removing Turbo", 10000, false, true, {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {
                                    animDict = "mini@repair",
                                    anim = "fixing_a_player",
                                    flags = 16,
                                }, {}, {}, function() -- Done
                                    ClearPedTasksImmediately(PlayerPedId())
                                    SetVehicleModKit(vehicle, 0)
                                    ToggleVehicleMod(vehicle, 18, false)
                                    local vehicle = XZCore.Functions.GetVehicleProperties(vehicle)
                                    saveVehicle()  
                                    TriggerServerEvent("XZCore:Server:RemoveItem", "turbo0", 1)
                                    TriggerEvent('inventory:client:ItemBox', XZCore.Shared.Items["turbo0"], "remove")
                                    XZCore.Functions.Notify("Turbo Successfully removed", "Success", 5000)

                                end)
                            end
                        end
                    end
                else
                    XZCore.Functions.Notify("Turbo Already Removed", "Error", 5000)
                end
            else
                XZCore.Functions.Notify("You need to sign on duty!!", "Error", 5000)
            end
        else
            XZCore.Functions.Notify("You are not allowed to complete this action", "error", 4000)
        end
end)

RegisterNetEvent('xz-mechanicparts:Turbo1', function()
    local vehicle = XZCore.Functions.GetClosestVehicle()
    local PlayerJob = XZCore.Functions.GetPlayerData().job
    turbo = IsToggleModOn(veh, 18)
    print(turbo)
        if PlayerJob.name == Config.Job then
            if onDuty then
                if turbo == false then
                    if vehicle ~= nil and vehicle ~= 0 then
                        if (IsBackEngine(GetEntityModel(vehicle))) then
                            SetVehicleDoorOpen(vehicle, 5, false, false)
                        else
                            SetVehicleDoorOpen(vehicle, 4, false, false)
                        end
                        local ped = PlayerPedId()
                        local pos = GetEntityCoords(ped)
                        local vehpos = GetEntityCoords(vehicle)
                        if #(pos - vehpos) < 4.0 and not IsPedInAnyVehicle(ped) then
                            local drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, 2.5, 0)
                            if (IsBackEngine(GetEntityModel(vehicle))) then
                                drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -2.5, 0)
                            end
                            if #(pos - drawpos) < 2.0 and not IsPedInAnyVehicle(ped) then
                            
                                XZCore.Functions.Progressbar("Turbo", "Installing Turbo", 10000, false, true, {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {
                                    animDict = "mini@repair",
                                    anim = "fixing_a_player",
                                    flags = 16,
                                }, {}, {}, function() -- Done
                                    ClearPedTasksImmediately(PlayerPedId())
                                    SetVehicleModKit(vehicle, 0)
                                    ToggleVehicleMod(vehicle, 18, true)
                                    local vehicle = XZCore.Functions.GetVehicleProperties(vehicle)
                                    saveVehicle()  
                                    TriggerServerEvent("XZCore:Server:RemoveItem", "turbo1", 1)
                                    TriggerEvent('inventory:client:ItemBox', XZCore.Shared.Items["turbo1"], "remove")
                                    XZCore.Functions.Notify("Turbo Successfully installed", "Success", 5000)
                                    

                                end)
                            end
                        end
                    end
                else
                    XZCore.Functions.Notify("Turbo Already Installed", "Error", 5000)
                end
            else
                XZCore.Functions.Notify("You need to sign on duty!!", "Error", 5000)
            end
        else
            XZCore.Functions.Notify("You are not allowed to complete this action", "error", 4000)
        end
end)


--Vehicle Menu
RegisterNetEvent('xz-mechanicparts:VehicleMenu', function()
    TriggerEvent('nh-context:sendMenu', {
        {
            id = 1,
            header = "| Vehicle Menu |",
            txt = "",
        },
        {
            id = 2,
            header = "Check Status Of Vehicle",
            txt = "Make sure vehicle is in working condition",
            params = {
                event = "xz-mechanicparts:CheckVehStatus"
            }
        },
        {
            id = 3,
            header = "Check Upgrades Of Vehicle",
            txt = "Fast as Fuckk Boii",
            params = {
                event = "xz-mechanicparts:CheckMods"
            }
        },
    })
end)

--Check Car Health
RegisterNetEvent('xz-mechanicparts:CheckVehStatus', function()
    veh = XZCore.Functions.GetClosestVehicle()
    plate = GetVehicleNumberPlateText(veh)
    engineHealth = GetVehicleEngineHealth(veh)
    vehTemp = GetVehicleEngineTemperature(veh)
    bodyHealth = GetVehicleBodyHealth(veh)
    fuelHealth = exports['LegacyFuel']:GetFuel(veh)
    tankHealth = GetVehiclePetrolTankHealth(veh)
 
    TriggerEvent('nh-context:sendMenu', {
        {
            id = 1,
            header = "<  Go back",
            txt = "",
            params = {
                event = "xz-mechanicparts:VehicleMenu"
            }
        },
        {
            id = 2,
            header = "Fuel Level",
            txt = "Status: " .. math.ceil(fuelHealth) .. ".0% / 100.0%",
        },
        {
            id = 3,
            header = "Engine Health",
            txt = "Status: " .. math.ceil(engineHealth / 10) .. "% / 100.0%",
        },
        {
            id = 4,
            header = "Body Health",
            txt = "Status: " .. math.ceil(bodyHealth / 10) .. "% / 100.0%",
        },
        {
            id = 5,
            header = "Tank Health",
            txt = "Status: " .. math.ceil(tankHealth / 10) .. "% / 100.0%",
        },
        {
            id = 6,
            header = "Engine Temperature",
            txt = "Status: " .. math.ceil(vehTemp) .. "° C",
        },        
    })
    
end)

--Check Mods installed on Car
RegisterNetEvent('xz-mechanicparts:CheckMods', function()

    veh = XZCore.Functions.GetClosestVehicle()
    engine = GetVehicleMod(veh, 11)
    brakes = GetVehicleMod(veh, 12)
    transmission = GetVehicleMod(veh, 13)
    suspension = GetVehicleMod(veh, 15)
    turbo = IsToggleModOn(veh, 18)
    
    if engine == -1 then
        engine = "Standard"
    elseif
    engine == 0 then
        engine = "Upgrade Level B"
    elseif
    engine == 1 then
        engine = "Upgrade Level C"
    elseif
    engine == 2 then
        engine = "Upgrade Level D"
    elseif
    engine == 3 then
        engine = "Upgrade Level S"
    end
    if brakes == -1 then
        brakes = "Standard"
    elseif
    brakes == 0 then
        brakes = "Upgrade Level B"
    elseif
    brakes == 1 then
        brakes = "Upgrade Level C"
    elseif
    brakes == 2 then
        brakes = "Upgrade Level S"
    end
    if transmission == -1 then
        transmission = "Standard"
    elseif
    transmission == 0 then
        transmission = "Upgrade Level B"
    elseif
    transmission == 1 then
        transmission = "Upgrade Level C"
    elseif
    transmission == 2 then
        transmission = "Upgrade Level S"
    end
    if suspension == -1 then
        suspension = "Standard"
    elseif
    suspension == 0 then
        suspension = "Upgrade Level B"
    elseif
    suspension == 1 then
        suspension = "Upgrade Level C"
    elseif
    suspension == 2 then
        suspension = "Upgrade Level D"
    elseif
    suspension == 3 then
        suspension = "Upgrade Level S"
    end
    if turbo == 1  then
        turbo = "You have a Turbo"
    else
        turbo = "No Turbo"
    end
    
    
    TriggerEvent('nh-context:sendMenu', {
        {
            id = 1,
            header = "<  Go back",
            txt = "",
            params = {
                event = "xz-mechanicparts:VehicleMenu"
            }
        },
        {
            id = 2,
            header = "Engine Upgrades",
            txt =  engine,
        },
        {
            id = 3,
            header = "Brakes Upgrade",
            txt = brakes,
        },
        {
            id = 4,
            header = "Transmission Upgrade",
            txt = transmission,
        },
        {
            id = 5,
            header = "Suspension Upgrade",
            txt = suspension,
        },
        {
            id = 6,
            header = "Turbo Upgrade",
            txt = turbo,
        },
              
    })
    
end)







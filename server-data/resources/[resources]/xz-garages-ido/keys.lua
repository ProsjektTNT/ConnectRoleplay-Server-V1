local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}

local HasKey, IsHotwiring, IsRobbing, isLoggedIn, AlertSend = false, false, false, false, false
local LastVehicle = nil
local NeededAttempts, SucceededAttempts, FailedAttemps = 0, 0, 0
local vehicleSearched, vehicleHotwired = {}, {}


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)

        if XZCore ~= nil then
            if IsPedInAnyVehicle(PlayerPedId(), false) and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), true), -1) == PlayerPedId() then
                local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), true))
                if LastVehicle ~= GetVehiclePedIsIn(PlayerPedId(), false) then
                    XZCore.Functions.TriggerCallback('vehiclekeys:CheckHasKey', function(result)
                        if result then
                            HasKey = true
                            SetVehicleEngineOn(veh, true, false, true)
                        else
                            HasKey = false
                            SetVehicleEngineOn(veh, false, false, true)
                        end
                        LastVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                    end, plate)
                end
            else
                if SucceededAttempts ~= 0 then
                    SucceededAttempts = 0
                end
                if NeededAttempts ~= 0 then
                    NeededAttempts = 0
                end
                if FailedAttemps ~= 0 then
                    FailedAttemps = 0
                end
            end
        end

        if not HasKey and IsPedInAnyVehicle(PlayerPedId(), false) and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId() and XZCore ~= nil and not IsHotwiring then
            local veh = GetVehiclePedIsIn(PlayerPedId(), false)
            SetVehicleEngineOn(veh, false, false, true)
            local veh = GetVehiclePedIsIn(PlayerPedId(), false)
            local vehpos = GetOffsetFromEntityInWorldCoords(veh, 0.0, 2.0, 1.0)
            XZCore.Functions.DrawText3D(vehpos.x, vehpos.y, vehpos.z, "[G] Search / [H] Hotwire" )
            SetVehicleEngineOn(veh, false, false, true)

            if IsControlJustPressed(0, Keys["H"]) and not exports["progressbar"]:isDoingSomething() then
                Hotwire()
            end

            if IsControlJustPressed(1, Keys["G"]) and not exports["progressbar"]:isDoingSomething() then
                Search()
            end
        end
    end
end)

local resourceName = GetCurrentResourceName();
RegisterNetEvent("xz:interact:init:" .. resourceName, function(Nevo)

    Nevo.Mapping:Listen("keylock", "(Player) Lock Vehicle", "keyboard", "L", function(state)
        if state then
            LockVehicle()
        end
    end);

end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(7)
        if not IsRobbing and isLoggedIn and XZCore ~= nil then
            if GetVehiclePedIsTryingToEnter(PlayerPedId()) ~= nil and GetVehiclePedIsTryingToEnter(PlayerPedId()) ~= 0 then
                local vehicle = GetVehiclePedIsTryingToEnter(PlayerPedId())
                local driver = GetPedInVehicleSeat(vehicle, -1)
                if driver ~= 0 and not IsPedAPlayer(driver) then
                    if IsEntityDead(driver) then
                        IsRobbing = true
                        XZCore.Functions.Progressbar("rob_keys", "Taking Keys", 3000, false, true, {}, {}, {}, {}, function() -- Done
                            TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(vehicle), vehicle)
                            HasKey = true
                            IsRobbing = false

                            TriggerEvent("debug", 'Keys: Rob', 'success')
                        end)
                    end
                end
            end

        end
    end
end)

RegisterNetEvent('XZCore:Client:OnPlayerLoaded')
AddEventHandler('XZCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
end)

RegisterNetEvent('XZCore:Client:OnPlayerUnload')
AddEventHandler('XZCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

RegisterNetEvent('vehiclekeys:client:SetOwner')
AddEventHandler('vehiclekeys:client:SetOwner', function(plate, vehicle)
    local VehPlate = plate
    if VehPlate == nil then
        VehPlate = GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), true))
    end

    print("Adding keys to " .. VehPlate)
    TriggerServerEvent('vehiclekeys:server:SetVehicleOwner', VehPlate, vehicle)
    if IsPedInAnyVehicle(PlayerPedId()) and VehPlate == GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), true)) then
        print("Turning on engine")
        SetVehicleEngineOn(GetVehiclePedIsIn(PlayerPedId(), true), true, false, true)
    end
    HasKey = true
end)

RegisterNetEvent('vehiclekeys:client:GiveKeys')
AddEventHandler('vehiclekeys:client:GiveKeys', function()
    local coordA = GetEntityCoords(PlayerPedId(), 1)
    local coordB = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 100.0, 0.0)
    local latestveh = getVehicleInDirection(coordA, coordB)
    
    if latestveh == nil or not DoesEntityExist(latestveh) then
        XZCore.Functions.Notify("Vehicle not found!", 'error')
        return
    end
    
    XZCore.Functions.TriggerCallback('vehiclekeys:CheckHasKey', function(hasKey)
        if not hasKey then
            XZCore.Functions.Notify("No keys for target vehicle!", 'error')
            return
        end

        if #(GetEntityCoords(latestveh) - GetEntityCoords(PlayerPedId(), 0)) > 5 then
            XZCore.Functions.Notify("You are too far away from the vehicle!", 'error')
            return
        end
        
        t, distance = XZCore.Functions.GetClosestPlayer()
        if(distance ~= -1 and distance < 5) then
            TriggerServerEvent('vehiclekeys:server:GiveVehicleKeys', GetVehicleNumberPlateText(latestveh), GetPlayerServerId(t))
            TriggerEvent("debug", 'Keys: Give Vehicle Keys', 'success')
        else
            XZCore.Functions.Notify("No player near you!", 'error')
            TriggerEvent("debug", 'Keys: No Player Nearby', 'error')
        end
    end, GetVehicleNumberPlateText(latestveh))
end)

function getVehicleInDirection(coordFrom, coordTo)
    local offset = 0
    local rayHandle
    local vehicle
  
    for i = 0, 100 do
      rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z + offset, 10, PlayerPedId(), 0) 
      a, b, c, d, vehicle = GetRaycastResult(rayHandle)
      
      offset = offset - 1
  
      if vehicle ~= 0 then break end
    end
    
    local distance = Vdist2(coordFrom, GetEntityCoords(vehicle))
    
    if distance > 25 then vehicle = nil end
  
      return vehicle ~= nil and vehicle or 0
  end

RegisterNetEvent('vehiclekeys:client:ToggleEngine')
AddEventHandler('vehiclekeys:client:ToggleEngine', function()
    local EngineOn = IsVehicleEngineOn(GetVehiclePedIsIn(PlayerPedId()))
    local veh = GetVehiclePedIsIn(PlayerPedId(), true)
    if HasKey then
        if EngineOn then
            SetVehicleEngineOn(veh, false, false, true)
        else
            SetVehicleEngineOn(veh, true, false, true)
        end
    end
end)

RegisterNetEvent('lockpicks:UseLockpick')
AddEventHandler('lockpicks:UseLockpick', function(isAdvanced)
    if (IsPedInAnyVehicle(PlayerPedId())) then
        if not HasKey then
            LockpickIgnition(isAdvanced)
        end
    else
        LockpickDoor(isAdvanced)
    end
end)

function RobVehicle(target)
    IsRobbing = true
    Citizen.CreateThread(function()
        while IsRobbing do
            local RandWait = math.random(10000, 15000)
            loadAnimDict("random@mugging3")

            TaskLeaveVehicle(target, GetVehiclePedIsIn(target, true), 256)
            Citizen.Wait(1000)
            ClearPedTasksImmediately(target)

            TaskStandStill(target, RandWait)
            TaskHandsUp(target, RandWait, PlayerPedId(), 0, false)

            Citizen.Wait(RandWait)

            --TaskReactAndFleePed(target, PlayerPedId())
            IsRobbing = false
        end
    end)
end

function LockVehicle()
    local veh = XZCore.Functions.GetClosestVehicle()
    local coordA = GetEntityCoords(PlayerPedId(), true)
    local coordB = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 255.0, 0.0)
    local veh = GetClosestVehicleInDirection(coordA, coordB)
    local pos = GetEntityCoords(PlayerPedId(), true)
    if IsPedInAnyVehicle(PlayerPedId()) then
        veh = GetVehiclePedIsIn(PlayerPedId())
    end
    local plate = GetVehicleNumberPlateText(veh)
    local vehpos = GetEntityCoords(veh, false)
    if veh ~= nil and GetDistanceBetweenCoords(pos.x, pos.y, pos.z, vehpos.x, vehpos.y, vehpos.z, true) < 10.0 then
        XZCore.Functions.TriggerCallback('vehiclekeys:CheckHasKey', function(result)
            if result then
                if HasKey then
                    local vehLockStatus = GetVehicleDoorLockStatus(veh)
                    loadAnimDict("anim@mp_player_intmenu@key_fob@")
                    TaskPlayAnim(PlayerPedId(), 'anim@mp_player_intmenu@key_fob@', 'fob_click' ,3.0, 3.0, -1, 49, 0, false, false, false)
                
                    if vehLockStatus == 1 then
                        Citizen.Wait(750)
                        ClearPedTasks(PlayerPedId())
                        TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "lock", 0.3)
                        SetVehicleDoorsLocked(veh, 2)
                        if(GetVehicleDoorLockStatus(veh) == 2)then
                            XZCore.Functions.Notify("Vehicle Locked.")
                        else
                            XZCore.Functions.Notify("Something is wrong with the locking system...")
                        end
                    else
                        Citizen.Wait(750)
                        ClearPedTasks(PlayerPedId())
                        TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "unlock", 0.3)
                        SetVehicleDoorsLocked(veh, 1)
                        if(GetVehicleDoorLockStatus(veh) == 1)then
                            XZCore.Functions.Notify("Vehicle Unlocked.")
                        else
                            XZCore.Functions.Notify("Something is wrong with the locking system...")
                        end
                    end
                
                    if not IsPedInAnyVehicle(PlayerPedId()) then
                        SetVehicleInteriorlight(veh, true)
                        SetVehicleIndicatorLights(veh, 0, true)
                        SetVehicleIndicatorLights(veh, 1, true)
                        Citizen.Wait(450)
                        SetVehicleIndicatorLights(veh, 0, false)
                        SetVehicleIndicatorLights(veh, 1, false)
                        Citizen.Wait(450)
                        SetVehicleInteriorlight(veh, true)
                        SetVehicleIndicatorLights(veh, 0, true)
                        SetVehicleIndicatorLights(veh, 1, true)
                        Citizen.Wait(450)
                        SetVehicleInteriorlight(veh, false)
                        SetVehicleIndicatorLights(veh, 0, false)
                        SetVehicleIndicatorLights(veh, 1, false)
                    end
                end
            else
                XZCore.Functions.Notify("No keys for target vehicle!", 'error')
            end
        end, plate, veh)
    end
end

local openingDoor = false
function LockpickDoor(isAdvanced)
    local vehicle = XZCore.Functions.GetClosestVehicle()
    if vehicle ~= nil and vehicle ~= 0 then
        local vehpos = GetEntityCoords(vehicle)
        local pos = GetEntityCoords(PlayerPedId())
        if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, vehpos.x, vehpos.y, vehpos.z, true) < 1.5 then
            local vehLockStatus = GetVehicleDoorLockStatus(vehicle)
            if (vehLockStatus > 1) then
                local lockpickTime = math.random(15000, 30000)
                if isAdvanced then
                    lockpickTime = math.ceil(lockpickTime*0.5)
                end
                LockpickDoorAnim(lockpickTime)
                IsHotwiring = true
                SetVehicleAlarm(vehicle, true)
                SetVehicleAlarmTimeLeft(vehicle, lockpickTime)
                XZCore.Functions.Progressbar("lockpick_vehicledoor", "Lockpicking...", lockpickTime, false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {}, {}, {}, function() -- Done
                    openingDoor = false
                    StopAnimTask(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0)
                    IsHotwiring = false
                        TriggerEvent("debug", 'Lockpick: Success', 'success')
                        TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "unlock", 0.3)
                        SetVehicleDoorsLocked(vehicle, 0)
                        SetVehicleDoorsLockedForAllPlayers(vehicle, false)
                   
                    
                end, function() -- Cancel
                    openingDoor = false
                    StopAnimTask(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0)
                    XZCore.Functions.Notify("Failed!", "error")
                    TriggerEvent("debug", 'Lockpick: Canceled', 'error')
                    IsHotwiring = false
                end)
            end
        end
    else
        XZCore.Functions.Notify('You can\'t use lockpick on parked vehicles.', 'error')
    end
end

function LockpickDoorAnim(time)
    time = time / 1000
    loadAnimDict("veh@break_in@0h@p_m_one@")
    TaskPlayAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds" ,3.0, 3.0, -1, 16, 0, false, false, false)
    openingDoor = true
    Citizen.CreateThread(function()
        while openingDoor do
            TaskPlayAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
            Citizen.Wait(1000)
            time = time - 1
            if time <= 0 then
                openingDoor = false
                StopAnimTask(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0)
            end
        end
    end)
end

function LockpickIgnition(isAdvanced)
    if not HasKey then 
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
        if vehicle ~= nil and vehicle ~= 0 then
            if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
                IsHotwiring = true

                local dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
                local anim = "machinic_loop_mechandplayer"
				TaskPlayAnim(PlayerPedId(), 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer' ,1.0, 4.0, -1, 49, 0, false, false, false)

                RequestAnimDict(dict)
                while not HasAnimDictLoaded(dict) do
                    RequestAnimDict(dict)
                    Citizen.Wait(100)
                end

                if exports["xz-taskbarskill"]:taskBar(math.random(5000,25000),math.random(2,3)) ~= 100 then             
					StopAnimTask(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
                    HasKey = false
                    SetVehicleEngineOn(vehicle, false, false, true)
                    XZCore.Functions.Notify("Lockpicking failed!", "error")
                    IsHotwiring = false
                    local c = math.random(2)
                    local o = math.random(2)
                    if c == o then
                        TriggerServerEvent('xz-hud:Server:GainStress', math.random(1, 4))
                    end
                    return
                end
    
                TriggerEvent("debug", 'Hotwire: Success', 'success')
                StopAnimTask(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
                XZCore.Functions.Notify("Ignition Working.")
                HasKey = true
                TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(vehicle))
                IsHotwiring = false
                TriggerServerEvent('xz-hud:Server:GainStress', math.random(2, 4))

            end
        end
    end
end

function Search()
    if not HasKey then 
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)

        if vehicleSearched[GetVehicleNumberPlateText(vehicle)] then
            XZCore.Functions.Notify('You have already searched this vehicle.', "error")
            return
        end

        vehicleSearched[GetVehicleNumberPlateText(vehicle)] = true
        IsHotwiring = true
        local searchTime = 5000
        XZCore.Functions.Progressbar("searching_vehicle", "Searching", searchTime, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
            anim = "machinic_loop_mechandplayer",
            flags = 16,
        }, {}, {}, function() -- Done
            StopAnimTask(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
            if (math.random(0, 100) < 10) then
                HasKey = true
                TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(vehicle))
                XZCore.Functions.Notify("You have found the keys to the vehicle!")
                TriggerEvent("debug", 'Keys: Found', 'success')
            else
                HasKey = false
                SetVehicleEngineOn(veh, false, false, true)
            end
            IsHotwiring = false
        end, function() -- Cancel
            TriggerEvent("debug", 'Keys: Canceled', 'error')
            StopAnimTask(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
            HasKey = false
            SetVehicleEngineOn(veh, false, false, true)
            IsHotwiring = false
        end)
    end
end

function Hotwire()
    if not HasKey then 
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
            if vehicleHotwired[GetVehicleNumberPlateText(vehicle)] then
                XZCore.Functions.Notify("You can not work out this hotwire.", "error")
                return
            end

            vehicleHotwired[GetVehicleNumberPlateText(vehicle)] = true
            IsHotwiring = true
            local hotwireTime = math.random(20000, 40000)
            SetVehicleAlarm(vehicle, true)
            SetVehicleAlarmTimeLeft(vehicle, hotwireTime)

            XZCore.Functions.Progressbar("hotwire_vehicle", "Attempting Hotwire", hotwireTime, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                anim = "machinic_loop_mechandplayer",
                flags = 16,
            }, {}, {}, function() -- Done
                StopAnimTask(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
                if (math.random(0, 100) < 20) then
                    HasKey = true
                    TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(vehicle))
                    XZCore.Functions.Notify("Ignition Working.")
                    TriggerEvent("debug", 'Hotwire: Success', 'success')
                else
                    TriggerEvent('dispatch:lockpick', vehicle)
                    HasKey = false
                    SetVehicleEngineOn(veh, false, false, true)
                    XZCore.Functions.Notify("You can not work out this hotwire.", "error")
                    TriggerEvent("debug", 'Hotwire: Failed', 'error')
                end
                IsHotwiring = false
            end, function() -- Cancel
                StopAnimTask(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
                HasKey = false
                SetVehicleEngineOn(veh, false, false, true)
                XZCore.Functions.Notify("You can not work out this hotwire.", "error")
                TriggerEvent("debug", 'Hotwire: Failed', 'error')
                IsHotwiring = false
            end)
        end
    end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
   
        if not IsPedInAnyVehicle(PlayerPedId(), false) then
            showText = true
   
            -- Exiting
            local aiming, targetPed = GetEntityPlayerIsFreeAimingAt(PlayerId(-1))
            if aiming then
                if DoesEntityExist(targetPed) and not IsPedAPlayer(targetPed) and IsPedArmed(PlayerPedId(), 7) and IsPedInAnyVehicle(targetPed, false) then
                    local vehicle = GetVehiclePedIsIn(targetPed, false)
                    local plate = GetVehicleNumberPlateText(vehicle)
                    local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId(), true), GetEntityCoords(vehicle, true), false)
                    
                    if distance < 5 and IsPedFacingPed(targetPed, PlayerPedId(), 60.0) then
                        SetVehicleForwardSpeed(vehicle, 0)
                        SetVehicleForwardSpeed(vehicle, 0)
                        TaskLeaveVehicle(targetPed, vehicle, 256)
                        while IsPedInAnyVehicle(targetPed, false) do
                            Citizen.Wait(5)
                        end
                    end
   
                    RequestAnimDict('missfbi5ig_22')
                    RequestAnimDict('mp_common')
   
                    SetPedDropsWeaponsWhenDead(targetPed,false)
                    ClearPedTasks(targetPed)
                    TaskTurnPedToFaceEntity(targetPed, PlayerPedId(), 3.0)
                    TaskSetBlockingOfNonTemporaryEvents(targetPed, true)
                    SetPedFleeAttributes(targetPed, 0, 0)
                    SetPedCombatAttributes(targetPed, 17, 1)
                    SetPedSeeingRange(targetPed, 0.0)
                    SetPedHearingRange(targetPed, 0.0)
                    SetPedAlertness(targetPed, 0)
                    SetPedKeepTask(targetPed, true)
                            
                    TaskPlayAnim(targetPed, "missfbi5ig_22", "hands_up_anxious_scientist", 8.0, -8, -1, 12, 1, 0, 0, 0)
                    Wait(1500)
                    TaskPlayAnim(targetPed, "missfbi5ig_22", "hands_up_anxious_scientist", 8.0, -8, -1, 12, 1, 0, 0, 0)
                    Wait(2500)
   
                    local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId(), true), GetEntityCoords(vehicle, true), false)
                    if not IsEntityDead(targetPed) and distance < 5 then
                        TaskPlayAnim(targetPed, "mp_common", "givetake1_a", 8.0, -8, -1, 12, 1, 0, 0, 0)
                        Wait(750)
                        XZCore.Functions.Notify('You just recieved keys to a vehicle!')
                        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(vehicle), vehicle)
                        Citizen.Wait(500)
                        TaskReactAndFleePed(targetPed, PlayerPedId())
                        SetPedKeepTask(targetPed, true)
                        Wait(2500)
                        TaskReactAndFleePed(targetPed, PlayerPedId())
                        SetPedKeepTask(targetPed, true)
                        Wait(2500)
                        TaskReactAndFleePed(targetPed, PlayerPedId())
                        SetPedKeepTask(targetPed, true)
                        Wait(2500)
                        TaskReactAndFleePed(targetPed, PlayerPedId())
                        SetPedKeepTask(targetPed, true)
                    end
                end
            end
        end
    end
end)

-- functions
function GetClosestVehicleInDirection(coordFrom, coordTo)
	local offset = 0
	local rayHandle
	local vehicle

	for i = 0, 100 do
		rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z + offset, 10, PlayerPedId(), 0)	
		a, b, c, d, vehicle = GetRaycastResult(rayHandle)
		
		offset = offset - 1

		if vehicle ~= 0 then break end
	end
	
	local distance = Vdist2(coordFrom, GetEntityCoords(vehicle))
	
	if distance > 25 then vehicle = nil end

    return vehicle ~= nil and vehicle or 0
end

function GetNearbyPed()
	local retval = nil
	local PlayerPeds = {}
    for _, player in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(player)
        table.insert(PlayerPeds, ped)
    end
    local player = PlayerPedId()
    local coords = GetEntityCoords(player)
	local closestPed, closestDistance = XZCore.Functions.GetClosestPed(coords, PlayerPeds)
	if not IsEntityDead(closestPed) and closestDistance < 5.0 then
		retval = closestPed
	end
	return retval
end

function IsBlacklistedWeapon()
    local weapon = GetSelectedPedWeapon(PlayerPedId())
    if weapon ~= nil then
        for _, v in pairs(BBGarages.Config['settings']['blacklistedWeapons']) do
            if weapon == GetHashKey(v) then
                return true
            end
        end
    end
    return false
end

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 0 )
    end
end

CreateThread(function()
    TriggerEvent("xz:interact:init", resourceName, "Mapping");
end);

RegisterNetEvent("xz:interact:ready", function()
    TriggerEvent("xz:interact:init", resourceName, "Mapping");
end);
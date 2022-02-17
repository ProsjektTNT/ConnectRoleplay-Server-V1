local cruiseOn = false
local cruiseSpeed = 0.0
local lastVehicle = nil
local inVehicle = false
local resourceName = GetCurrentResourceName();

RegisterNetEvent("vehicle:entered")
AddEventHandler("vehicle:entered", function(veh)
    lastVehicle = veh
    inVehicle = true
end);

RegisterNetEvent("vehicle:left")
AddEventHandler("vehicle:left", function()
    if cruiseOn and not inVehicle then
        cruiseOn = false
    end
    inVehicle = false
end);

RegisterNetEvent("xz:interact:init:" .. resourceName, function(Nevo);

Nevo.Mapping:Listen("cruise", "(Player) Cruise Mode", "keyboard", "Z", function(state);
    if state and inVehicle then
        local ped = PlayerPedId()
        if GetPedInVehicleSeat(lastVehicle, -1) == ped then
        cruiseSpeed = GetEntitySpeed(lastVehicle)
        cruiseOn = not cruiseOn
        XZCore.Functions.Notify("Speed Limiter " .. (cruiseOn and "Active." or "Inactive."))
        local maxSpeed = cruiseOn and cruiseSpeed or GetVehicleHandlingFloat(lastVehicle,"CHandlingData","fInitialDriveMaxFlatVel")
        SetEntityMaxSpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false), maxSpeed);
        end
    end
end);

    Nevo.Mapping:Listen("engine", "(Player) Toggle Engine", "keyboard", "K", function(state);
    if state and inVehicle then
        local ped = PlayerPedId()
        if GetPedInVehicleSeat(lastVehicle, -1) == ped then

            if IsVehicleEngineOn(GetVehiclePedIsIn(ped, false)) then
                SetVehicleEngineOn(lastVehicle, false, false, true);
                XZCore.Functions.Notify("Engine Halted");
            else
                SetVehicleEngineOn(lastVehicle, true, false, true);
                XZCore.Functions.Notify("Engine Started");
            end
        end
    end
end);
end);

CreateThread(function()
    TriggerEvent("xz:interact:init", resourceName, "Mapping");
end);

RegisterNetEvent("xz:interact:ready", function()
    TriggerEvent("xz:interact:init", resourceName, "Mapping");
end);
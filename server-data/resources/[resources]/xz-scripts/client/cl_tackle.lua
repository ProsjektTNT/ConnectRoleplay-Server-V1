Citizen.CreateThread(function()
    while true do 
        if XZCore ~= nil then

        end

        Citizen.Wait(1)
    end
end)

local resourceName = GetCurrentResourceName();
RegisterNetEvent("xz:interact:init:" .. resourceName, function(Nevo)

    Nevo.Mapping:Listen("tackle", "(Player) Tackle", "keyboard", "G", function(state)
        local ped = PlayerPedId()
        if not IsPedInAnyVehicle(ped, false) and GetEntitySpeed(ped) > 2.5 then
            Tackle()
        else
            Citizen.Wait(250)
        end
    end);

end)

RegisterNetEvent('tackle:client:GetTackled')
AddEventHandler('tackle:client:GetTackled', function()
	SetPedToRagdoll(PlayerPedId(), math.random(1000, 6000), math.random(1000, 6000), 0, 0, 0, 0) 
	TimerEnabled = true
	Citizen.Wait(1500)
    TimerEnabled = false
    
    TriggerEvent("debug", 'Tackled: Got', 'success')
end)

function Tackle()
    closestPlayer, distance = XZCore.Functions.GetClosestPlayer()
    local closestPlayerPed = GetPlayerPed(closestPlayer)
    if(distance ~= -1 and distance < 2) then
        TriggerServerEvent("tackle:server:TacklePlayer", GetPlayerServerId(closestPlayer))
        TackleAnim()
        TriggerEvent("debug", 'Tackled: Animation', 'success')
    end
end

function TackleAnim()
    if not XZCore.Functions.GetPlayerData().metadata["ishandcuffed"] and not IsPedRagdoll(PlayerPedId()) then
        RequestAnimDict("swimming@first_person@diving")
        while not HasAnimDictLoaded("swimming@first_person@diving") do
            Citizen.Wait(1)
        end
        if IsEntityPlayingAnim(PlayerPedId(), "swimming@first_person@diving", "dive_run_fwd_-45_loop", 3) then
            ClearPedTasksImmediately(PlayerPedId())
        else
            TaskPlayAnim(PlayerPedId(), "swimming@first_person@diving", "dive_run_fwd_-45_loop" ,3.0, 3.0, -1, 49, 0, false, false, false)
            Citizen.Wait(250)
            ClearPedTasksImmediately(PlayerPedId())
            SetPedToRagdoll(PlayerPedId(), 150, 150, 0, 0, 0, 0)
        end
    end
end

CreateThread(function()
    TriggerEvent("xz:interact:init", resourceName, "Mapping");
end);

RegisterNetEvent("xz:interact:ready", function()
    TriggerEvent("xz:interact:init", resourceName, "Mapping");
end);
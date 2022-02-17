XZCore = nil
Citizen.CreateThread(function()
	while XZCore == nil do
		TriggerEvent('XZCore:GetObject', function(obj) XZCore = obj end)
		Citizen.Wait(0)
	end
end)

local washingVehicle = false

function DrawText3Dsss(x, y, z, text)
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
        local PlayerPed = PlayerPedId()
        local PlayerPos = GetEntityCoords(PlayerPed)
        local PedVehicle = GetVehiclePedIsIn(PlayerPed)
        local Driver = GetPedInVehicleSeat(PedVehicle, -1)

        if IsPedInAnyVehicle(PlayerPed) then
            for k, v in pairs(Carwash.Locations) do
                local dist = GetDistanceBetweenCoords(PlayerPos, Carwash.Locations[k]["coords"]["x"], Carwash.Locations[k]["coords"]["y"], Carwash.Locations[k]["coords"]["z"])

                if dist <= 10 then
                    inRange = true
                    
                    if dist <= 7.5 then
                        if Driver == PlayerPed then
                            if not washingVehicle then
                                DrawText3Dsss(Carwash.Locations[k]["coords"]["x"], Carwash.Locations[k]["coords"]["y"], Carwash.Locations[k]["coords"]["z"], '~g~E~w~ - Wash Car')
                                if IsControlJustPressed(0, Keys["E"]) then
                                    TriggerServerEvent('xz-carwash:server:washCar')
                                end
                            else
                                DrawText3Dsss(Carwash.Locations[k]["coords"]["x"], Carwash.Locations[k]["coords"]["y"], Carwash.Locations[k]["coords"]["z"], 'The car wash is not available..')
                            end
                        end
                    end
                end
            end
        end

        if not inRange then
            Citizen.Wait(5000)
        end

        Citizen.Wait(3)
    end
end)

RegisterNetEvent('xz-carwash:client:washCar')
AddEventHandler('xz-carwash:client:washCar', function()
    local PlayerPed = PlayerPedId()
    local PedVehicle = GetVehiclePedIsIn(PlayerPed)
    local Driver = GetPedInVehicleSeat(PedVehicle, -1)

    washingVehicle = true

    XZCore.Functions.Progressbar("search_cabin", "Vehicle is being washed..", math.random(4000, 8000), false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        SetVehicleDirtLevel(PedVehicle)
        SetVehicleUndriveable(PedVehicle, false)
        WashDecalsFromVehicle(PedVehicle, 1.0)
        washingVehicle = false
    end, function() -- Cancel
        XZCore.Functions.Notify("Washing canceled..", "error")
        washingVehicle = false
    end)
end)

RegisterNetEvent('clean:kit')
AddEventHandler('clean:kit', function()
	local ply = PlayerPedId()
	local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local vehicle = nil
		if IsPedInAnyVehicle(ped, false) then vehicle = GetVehiclePedIsIn(ped, false) else vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71) end
			if DoesEntityExist(vehicle) then
			TaskStartScenarioInPlace(ply, 'WORLD_HUMAN_MAID_CLEAN', 0, true)
			Progressbar(10000,"Cleaning")
			SetVehicleDirtLevel(vehicle, 0.2)
	end
end)
			
function Progressbar(duration, label)
	local retval = nil
	XZCore.Functions.Progressbar("clean", label, duration, false, false, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
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

Citizen.CreateThread(function()
    for k, v in pairs(Carwash.Locations) do
        carWash = AddBlipForCoord(Carwash.Locations[k]["coords"]["x"], Carwash.Locations[k]["coords"]["y"], Carwash.Locations[k]["coords"]["z"])

        SetBlipSprite (carWash, 100)
        SetBlipDisplay(carWash, 4)
        SetBlipScale  (carWash, 0.8)
        SetBlipAsShortRange(carWash, true)
        SetBlipColour(carWash, 3)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Carwash.Locations[k]["label"])
        EndTextCommandSetBlipName(carWash)
    end
end)
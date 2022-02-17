XZCore = nil

Citizen.CreateThread(function()
	while XZCore == nil do
		TriggerEvent('XZCore:GetObject', function(obj) XZCore = obj end)
		Citizen.Wait(0)
	end
end)

local closestDoorKey, closestDoorValue = nil, nil
nuiShowingDoors = {}

Citizen.CreateThread(function()
	while true do
		for key, doorID in ipairs(XZConfig.Doors) do
			if doorID.doors then
				for k,v in ipairs(doorID.doors) do
					if not v.object or not DoesEntityExist(v.object) then
						v.object = GetClosestObjectOfType(v.objCoords, 1.0, (type(v.objName) == 'number' and v.objName or GetHashKey(v.objName)), false, false, false)
					end
				end
			else
				if not doorID.object or not DoesEntityExist(doorID.object) then
					doorID.object = GetClosestObjectOfType(doorID.objCoords, 1.0, (type(doorID.objName) == 'number' and doorID.objName or GetHashKey(doorID.objName)), false, false, false)
				end
			end
		end

		Citizen.Wait(2500)
	end
end)

local maxDistance = 3.0
shownDoors = {}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerCoords, awayFromDoors = GetEntityCoords(PlayerPedId()), true

		for k,doorID in ipairs(XZConfig.Doors) do
			local distance

			if doorID.doors then
				distance = #(playerCoords - doorID.doors[1].objCoords)
			else
				distance = #(playerCoords - doorID.objCoords)
			end

			if doorID.distance then
				maxDistance = doorID.distance
			end
			
			if distance < 50 then
				if doorID.doors then
					for _,v in ipairs(doorID.doors) do
						FreezeEntityPosition(v.object, doorID.locked)

						if doorID.locked and v.objYaw and GetEntityRotation(v.object).z ~= v.objYaw then
							SetEntityRotation(v.object, 0.0, 0.0, v.objYaw, 2, true)
						end
					end
				else
					FreezeEntityPosition(doorID.object, doorID.locked)

					if doorID.locked and doorID.objYaw and GetEntityRotation(doorID.object).z ~= doorID.objYaw then
						SetEntityRotation(doorID.object, 0.0, 0.0, doorID.objYaw, 2, true)
					end
				end
			end

			if distance < maxDistance then
				awayFromDoors = false
				if doorID.size then
					size = doorID.size
				end

				local isAuthorized = IsAuthorized(doorID)

				if isAuthorized then
					if doorID.locked then
						displayText = "[E] Locked"
					elseif not doorID.locked then
						displayText = "[E] Unlocked"
					end
				elseif not isAuthorized then
					if doorID.locked then
						displayText = "Locked"
					elseif not doorID.locked then
						displayText = "Unlocked"
					end
				end

				if doorID.locking then
					if doorID.locked then
						displayText = "Unlocking.."
					else
						displayText = "Locking.."
					end
				end

				if doorID.objCoords == nil then
					doorID.objCoords = doorID.textCoords
				end

				--DrawText3Ds(doorID.objCoords.x, doorID.objCoords.y, doorID.objCoords.z, displayText)
				if shownDoors[k] ~= nil then shownDoors[k] = true end
				if(string.match(displayText, "Locked")) then
					showNUI(displayText, "error")
				else
					showNUI(displayText, "success")
				end
				


				if IsControlJustReleased(0, 38) then
					if isAuthorized then
						setDoorLocking(doorID, k)
					end
				end
			end
			
		end

		if awayFromDoors then
			closeNUI()
			Citizen.Wait(1250)
		end
	end
end)


function round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

RegisterNetEvent('lockpicks:UseLockpick')
AddEventHandler('lockpicks:UseLockpick', function()
	local ped = PlayerPedId()
	local pos = GetEntityCoords(ped)
	for k, v in pairs(XZConfig.Doors) do
		local dist = GetDistanceBetweenCoords(pos, XZConfig.Doors[k].textCoords.x, XZConfig.Doors[k].textCoords.y, XZConfig.Doors[k].textCoords.z)
		if dist < 1.5 then
			if XZConfig.Doors[k].pickable then
				if XZConfig.Doors[k].locked then
					closestDoorKey, closestDoorValue = k, v
					TriggerEvent('xz-lockpick:client:openLockpick', lockpickFinish)
					TriggerEvent("debug", 'Doors: Lockpick ' .. closestDoorKey, 'success')
				else
					XZCore.Functions.Notify('Door is already unlocked', 'error', 2500)
				end
			else
				XZCore.Functions.Notify('This door has a stronger lock than you can actually unlock.', 'error', 2500)
			end
		end
	end
end)

function lockpickFinish(success)
	local chance = math.random(1,100)
    if success then
		XZCore.Functions.Notify('Success', 'success', 2500)
		setDoorLocking(closestDoorValue, closestDoorKey)
    elseif chance >= 15 then
        XZCore.Functions.Notify('Lockpick bent out of shape.', 'error', 2500)
		TriggerServerEvent('XZCore:Server:RemoveItem', 'lockpick', 1)
    end
end

function setDoorLocking(doorId, key)
	doorId.locking = true
--	openDoorAnim()
	TriggerEvent("InteractSound_CL:PlayOnOne","keydoors",0.5)
    SetTimeout(400, function()
		doorId.locking = false
		doorId.locked = not doorId.locked
		TriggerServerEvent('xz-doorlock:server:updateState', key, doorId.locked)
	end)
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

function IsAuthorized(doorID)
	local PlayerData = XZCore.Functions.GetPlayerData()

	for _,job in pairs(doorID.authorizedJobs) do
		if job == PlayerData.job.name or job == PlayerData.gang.name then
			return true
		end
	end
	
	return false
end

-- function openDoorAnim()
--     loadAnimDict("anim@heists@keycard@") 
--     TaskPlayAnim( PlayerPedId(), "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0 )
-- 	SetTimeout(400, function()
-- 		ClearPedTasks(PlayerPedId())
-- 	end)
-- end

RegisterNetEvent('xz-doorlock:client:setState')
AddEventHandler('xz-doorlock:client:setState', function(doorID, state)
	XZConfig.Doors[doorID].locked = state
	TriggerEvent("debug", 'Doors: Update ' .. doorID .. ' (' .. (state and 'Locked' or 'Unlocked') .. ')', 'success')
end)

RegisterNetEvent('xz-doorlock:client:setDoors')
AddEventHandler('xz-doorlock:client:setDoors', function(doorList)
	XZConfig.Doors = doorList
	TriggerEvent("debug", 'Doors: Received', 'success')
end)

RegisterNetEvent('XZCore:Client:OnPlayerLoaded')
AddEventHandler('XZCore:Client:OnPlayerLoaded', function()
    TriggerServerEvent("xz-doorlock:server:setupDoors")
end)
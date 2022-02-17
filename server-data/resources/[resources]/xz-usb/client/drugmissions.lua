XZCore = nil
local PlayerData = nil
local CurrentEventNum = nil
local StopMission = false
local DisableControls = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if XZCore == nil then
			TriggerEvent('XZCore:GetObject', function(obj) XZCore = obj end)
			Citizen.Wait(200)
		end
	end
end)

RegisterNetEvent("Drugs:startMission")
AddEventHandler("Drugs:startMission",function(type)
	local num = math.random(1,#Config.MissionPosition)
	local numy = 0
	while Config.MissionPosition[num].InUse and numy < 100 do
		numy = numy+1
		num = math.random(1,#Config.MissionPosition)
	end
	if numy == 100 then
		TriggerEvent('XZCore:Notify', 'No missions are currently available, please try again later.', 'error') 
	else
		CurrentEventNum = num
		TriggerEvent("Drugs:startTheEvent",num,type)
		TriggerEvent('XZCore:Notify', "Follow the location on your map and steal " ..type.. "")
	end
end)

RegisterNetEvent("Drugs:startTheEvent")
AddEventHandler("Drugs:startTheEvent",function(num,typey)
	RequestModel(-459818001)
	while not HasModelLoaded(-459818001) do
		Citizen.Wait(100)
	end
	-- Makes the job unavailable for everyone
	local loc = Config.MissionPosition[num]
	local typed = typey
	Config.MissionPosition[num].InUse = true
	local playerped = PlayerPedId()
	TriggerServerEvent("Drugs:syncMissionData",Config.MissionPosition)
	local taken = false
	local blip = CreateMissionBlip(loc.Location)
	AddRelationshipGroup('DrugsNPC')
	AddRelationshipGroup('PlayerPed')
	for k,v in pairs(loc.GoonSpawns) do
		pedy = CreatePed(7,-459818001,v.x,v.y,v.z,0,true,false)
		SetPedRelationshipGroupHash(pedy, 'DrugsNPC')
		GiveWeaponToPed(pedy,GetHashKey("WEAPON_ASSAULTRIFLE"),250,false,true)
		SetPedArmour(pedy,100)
		SetPedDropsWeaponsWhenDead(pedy, false)
	end
	SetRelationshipBetweenGroups(5,GetPedRelationshipGroupDefaultHash(playerped),'DrugsNPC')
	SetRelationshipBetweenGroups(5,'DrugsNPC',GetPedRelationshipGroupDefaultHash(playerped))
	TaskCombatPed(pedy,playerped, 0, 16)
	while not taken and not StopMission do
		Citizen.Wait(10)
		
		if GetDistanceBetweenCoords(loc.Location, GetEntityCoords(PlayerPedId())) < 2.5 then
			DrawText3Ds(loc.Location[1], loc.Location[2], loc.Location[3],"Press [E] to steal the drugs")
			if IsControlJustPressed(1,38) then					
				Progressbar(15000,"Stealing Drugs")
				if GetDistanceBetweenCoords(loc.Location, GetEntityCoords(PlayerPedId())) < 2.5 then
					TriggerEvent('XZCore:Notify', "You stole the drugs.") 
					if typed == 'meth' or typed == "coke" then
						TriggerServerEvent("Drugs:reward",{ [typed.."brick"] = Config.Reward[typed]})
					else
						TriggerServerEvent("Drugs:reward",{ ['weed_white-widow_seed'] = 2, ['weed_skunk_seed'] = 2, ['weed_purple-haze_seed'] = 2, ['weed_og-kush_seed'] = 2 })
					end
					RemoveBlip(blip)
					Config.MissionPosition[num].InUse = false
					TriggerServerEvent("Drugs:syncMissionData",Config.MissionPosition)	
					taken = true
					break
				else
					TriggerEvent('XZCore:Notify', "You went too far away from the drugs.", 'error') 
					RemoveBlip(blip)
					Config.MissionPosition[num].InUse = false
					TriggerServerEvent("Drugs:syncMissionData",Config.MissionPosition)
					taken = true
					break
				end
			end
		end
		
		if StopMission == true then
			TriggerEvent('XZCore:Notify', "You died, drug mission over.", 'error') 
			Config.MissionPosition[num].InUse = false
		end
	end
	RemoveBlip(blip)
	Config.MissionPosition[num].InUse = false
	TriggerServerEvent("Drugs:syncMissionData",Config.MissionPosition)
end)

function CreateMissionBlip(location)
	local blip = AddBlipForCoord(location.x,location.y,location.z)
	SetBlipSprite(blip, 1)
	SetBlipColour(blip, 5)
	AddTextEntry('MYBLIP', "Drug Mission")
	BeginTextCommandSetBlipName('MYBLIP')
	AddTextComponentSubstringPlayerName(name)
	EndTextCommandSetBlipName(blip)
	SetBlipScale(blip, 0.9) 
	SetBlipAsShortRange(blip, true)
	return blip
end

RegisterNetEvent("Drugs:syncMissionData")
AddEventHandler("Drugs:syncMissionData",function(data)
	Config.MissionPosition = data
end)

RegisterNetEvent("XZCore:client:LastStand")
AddEventHandler("XZCore:client:LastStand", function(bool)
	if bool then
		CancelEvent("Drugs:startMission")
		StopMission = true
		RemoveBlip(blip)
		TriggerServerEvent("Drugs:syncMissionData",Config.MissionPosition)
		Citizen.Wait(5000)
		StopMission = false
	end
end)

RegisterNetEvent("XZCore:client:IsDead")
AddEventHandler("XZCore:client:IsDead", function(bool)
	if bool then
		CancelEvent("Drugs:startMission")
		StopMission = true
		RemoveBlip(blip)
		TriggerServerEvent("Drugs:syncMissionData",Config.MissionPosition)
		Citizen.Wait(5000)
		StopMission = false
	end
end)

RegisterNetEvent("Drugs:UsableItem")
AddEventHandler("Drugs:UsableItem",function()
	if not IsPedInAnyVehicle(PlayerPedId()) then
		TaskStartScenarioInPlace(PlayerPedId(), 'WORLD_HUMAN_STAND_MOBILE', 0, true)
		Citizen.Wait(5000)
	end
end)

RegisterNetEvent("Drugs:HackingMiniGame")
AddEventHandler("Drugs:HackingMiniGame",function()
	toggleHackGame()
end)

function toggleHackGame()
	TriggerEvent("mhacking:show")
	TriggerEvent("mhacking:start",4,25,AtmHackFirstSuccess) 
	DisableControls = true
end

function AtmHackFirstSuccess(success)
    DisableControls = false
    TriggerEvent('mhacking:hide')
    if success then
		TriggerEvent("mhacking:show")
		TriggerEvent("mhacking:start",3,25,AtmHackSecondSuccess) 
		DisableControls = true
    else
		TriggerEvent('XZCore:Notify', "You failed to hack the location.", 'error') 
		ClearPedTasks(PlayerPedId())
	end
end

function AtmHackSecondSuccess(success)
    DisableControls = false
    TriggerEvent('mhacking:hide')
    if success then
		XZCore.Functions.TriggerCallback("Drugs:StartMissionNow",function()
			TriggerEvent('XZCore:Notify', "You successfully hacked into the network") 
		end)
    else
		TriggerEvent('XZCore:Notify', "You failed to hack the location.", 'error') 
	end
	ClearPedTasks(PlayerPedId())
end

function DrawText3Ds(x, y, z, text)

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

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

CreateThread(function()
	while true do
		if DisableControls then
			Wait(1)
			DisableControlAction(0, 1, true) -- Disable pan
			DisableControlAction(0, 2, true) -- Disable tilt
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Aim
			DisableControlAction(0, 263, true) -- Melee Attack 1
			DisableControlAction(0, 32, true) -- W
			DisableControlAction(0, 34, true) -- A
			DisableControlAction(0, 31, true) -- S
			DisableControlAction(0, 30, true) -- D
			DisableControlAction(0, 45, true) -- Reload
			DisableControlAction(0, 22, true) -- Jump
			DisableControlAction(0, 44, true) -- Cover
			DisableControlAction(0, 37, true) -- Select Weapon
			DisableControlAction(0, 23, true) -- Also 'enter'?
			DisableControlAction(0, 288,  true) -- Disable phone
			DisableControlAction(0, 289, true) -- Inventory
			DisableControlAction(0, 170, true) -- Animations
			DisableControlAction(0, 167, true) -- Job
			DisableControlAction(0, 73, true) -- Disable clearing animation
			DisableControlAction(2, 199, true) -- Disable pause screen
			DisableControlAction(0, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
			DisableControlAction(0, 72, true) -- Disable reversing in vehicle
			DisableControlAction(2, 36, true) -- Disable going stealth
			DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
			DisablePlayerFiring(PlayerId(), true)
		else
			Wait(200)
		end
	end
end)
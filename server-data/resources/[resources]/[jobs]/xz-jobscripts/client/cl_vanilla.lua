local XZCore = nil
local PlayerData = nil

Citizen.CreateThread(function()
	while XZCore == nil do
		TriggerEvent('XZCore:GetObject', function(obj) XZCore = obj end)
		Citizen.Wait(200)
	end

	while XZCore.Functions.GetPlayerData() == nil do
		Wait(0)
	end

	while XZCore.Functions.GetPlayerData().job == nil do
		Wait(0)
	end

	PlayerData = XZCore.Functions.GetPlayerData()
end)

RegisterNetEvent("XZCore:Client:OnJobUpdate")
AddEventHandler("XZCore:Client:OnJobUpdate", function(JobInfo)
	PlayerData.job = JobInfo
end)

CreateThread(function()
    while true do
        local plyPed = PlayerPedId()
        local plyCoords = GetEntityCoords(plyPed)
        local letSleep = true
        
        if PlayerData and PlayerData.job.name == 'vanilla' then
			local shop = Vanilla.Locations['shop']
			local stripper = Vanilla.Locations['stripper']
			local boss = Vanilla.Locations['boss']
			local vip = Vanilla.Locations['vip']
		
			if (GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, shop.x, shop.y, shop.z, true) < 10) then
				letSleep = false
				DrawMarker(2, shop.x, shop.y, shop.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
				 if (GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, shop.x, shop.y, shop.z, true) < 1.5) then
					DrawText3D(shop.x, shop.y, shop.z, "[E] - Shop")
					if IsControlJustReleased(0, 38) then
						TriggerServerEvent("inventory:server:OpenInventory", "shop", "vanilla", Vanilla.Items)
					end
				end  
			end
			
			if (GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, vip.x, vip.y, vip.z, true) < 10) and PlayerData.job.isboss then
				letSleep = false
				DrawMarker(2, vip.x, vip.y, vip.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
				 if (GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, vip.x, vip.y, vip.z, true) < 1.5) then
					DrawText3D(vip.x, vip.y, vip.z, "[E] - VIP Shop")
					if IsControlJustReleased(0, 38) then
						TriggerServerEvent("inventory:server:OpenInventory", "shop", "vanillaboss", Vanilla.BossItems)
					end
				end  
			end
			
            if (GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, boss.x, boss.y, boss.z, true) < 10) and PlayerData.job.isboss then
                letSleep = false
                DrawMarker(2, boss.x, boss.y, boss.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                if (GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, boss.x, boss.y, boss.z, true) < 1.5) then
                    DrawText3D(boss.x, boss.y, boss.z, "[E] - Boss Menu")
                    if IsControlJustReleased(0, 38) then
                        TriggerServerEvent("xz-bossmenu:server:openMenu")
                    end
                end  
            end
			
            if (GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, stripper.x, stripper.y, stripper.z, true) < 10) and PlayerData.job.isboss then
                letSleep = false
                DrawMarker(2, stripper.x, stripper.y, stripper.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                if (GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, stripper.x, stripper.y, stripper.z, true) < 1.5) then
                    DrawText3D(stripper.x, stripper.y, stripper.z, "[E] - Stripper Bitches")
                    if IsControlJustReleased(0, 38) then
						Progressbar(5000,"Calling In Strippers")
						TriggerEvent("strippers:spawn")
						XZCore.Functions.Notify('Stripper Bitches are here!', 'success')
                    end
                end  
            end

            end
            if letSleep then
            Wait(2000)
        end

        Wait(1)
	end
end)

function Progressbar(duration, label)
	local retval = nil
	XZCore.Functions.Progressbar("stripclub", label, duration, false, false, {
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

local stripperbitchhh = {
  { model="s_f_y_stripper_02", x=112.68, y=-1288.3, z=28.46, a=238.85, animation="mini@strip_club@private_dance@idle", animationName="priv_dance_idle"},
  { model="s_f_y_stripper_02", x=111.99, y=-1286.03, z=28.46, a=308.8, animation="mini@strip_club@lap_dance@ld_girl_a_song_a_p1", animationName="ld_girl_a_song_a_p1_f"},
  { model="s_f_y_stripper_01", x=108.72, y=-1289.33, z=28.86, a=295.53, animation="mini@strip_club@private_dance@part2", animationName="priv_dance_p2"},
  { model="s_f_y_stripper_02", x=103.21, y=-1292.59, z=29.26, a=296.21, animation="mini@strip_club@private_dance@part1", animationName="priv_dance_p1"},
  { model="s_f_y_stripper_02", x=104.66, y=-1294.46, z=29.26, a=287.12, animation="mini@strip_club@lap_dance@ld_girl_a_song_a_p1", animationName="ld_girl_a_song_a_p1_f"},
  { model="s_f_y_stripper_01", x=102.26, y=-1289.92, z=29.26, a=292.05, animation="mini@strip_club@private_dance@idle", animationName="priv_dance_idle"},
}

RegisterNetEvent('strippers:spawn')
AddEventHandler('strippers:spawn', function(spawned)
	if not spawned then
			for k,v in ipairs(stripperbitchhh) do
			RequestModel(GetHashKey(v.model))
			while not HasModelLoaded(GetHashKey(v.model)) do
				Wait(0)
			end
			RequestAnimDict(v.animation)
			while not HasAnimDictLoaded(v.animation) do
				Wait(1)
			end
			local stripperbitch = CreatePed(4, GetHashKey(v.model), v.x, v.y, v.z, v.a, true, true)
			TaskSetBlockingOfNonTemporaryEvents(stripperbitch, true)
			SetPedFleeAttributes(stripperbitch, 0, 0)
			SetPedCombatAttributes(stripperbitch, 17, 1)
			SetAmbientVoiceName(stripperbitch, v.voice)
			SetPedSeeingRange(stripperbitch, 0.0)
    		SetPedHearingRange(stripperbitch, 0.0)
    		SetPedAlertness(stripperbitch, 0)
    		SetPedKeepTask(stripperbitch, true)
			SetEntityInvincible(stripperbitch, true)

			TaskPlayAnim(stripperbitch, v.animation, v.animationName, 8.0, 0.0, -1, 1, 0, 0, 0, 0)
			SetModelAsNoLongerNeeded(GetHashKey(v.model))
		end
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local plyCoords = GetEntityCoords(PlayerPedId(), 0)
        local distance = #(vector3(114.78, -1285.88, 28.26) - plyCoords)
        if distance < 2 then
            if not IsPedInAnyVehicle(PlayerPedId(), true) then
                if distance < 2 then
                    DrawText3D(114.78, -1285.88, 28.26, '[E] - Make It Rain (200$)')
					if IsControlJustReleased(0, 38) then 
						loadAnimDict("anim@mp_player_intcelebrationfemale@raining_cash") 
						TaskPlayAnim( PlayerPedId(), "anim@mp_player_intcelebrationfemale@raining_cash", "raining_cash", 8.0 , -1 , -1 , 0 , 0 , false , false , false)
						Citizen.Wait(2000)
						TriggerServerEvent('stripclubstack:pay')     
						DeleteEntity(cash)
                    end
                end
            end
        else
            Wait(500)
        end
    end
end)

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local plyCoords = GetEntityCoords(PlayerPedId(), 0)
        local distance = #(vector3(126.29, -1297.86, 29.26) - plyCoords)
        if distance < 1 then
            if not IsPedInAnyVehicle(PlayerPedId(), true) then
                if distance < 1 then
                    DrawText3D(126.29, -1297.86, 29.26, '[E] - Entry Fee (150$)')
					if IsControlJustReleased(0, 38) then 
                        TriggerServerEvent('paystripclub:pay')
                        TriggerEvent('animations:client:EmoteCommandStart', {"id"})
                        Progressbar(2500,"Paying...")
                    end
                end
            end
        else
            Wait(500)
        end
    end
end)

function Progressbar(duration, label)
	local retval = nil
	XZCore.Functions.Progressbar("strip", label, duration, false, false, {
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

function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

Citizen.CreateThread(function()
    while (true) do
		ClearAreaOfVehicles(141.71, -1322.01, 29.21, 5.0, false, false, false, false, false);
		ClearAreaOfPeds(115.12, -1285.75, 28.26, 15.0, 1)
        Citizen.Wait(1)
    end
end)

RegisterNetEvent("strippers:mail")
AddEventHandler("strippers:mail", function(mailData)
    if PlayerData and PlayerData.job.name == 'vanilla' then
        TriggerServerEvent('xz-phone:server:sendNewMail', mailData)
    end
end)

RegisterNetEvent("strippers:updateStrippers")
AddEventHandler("strippers:updateStrippers", function(data)
    Vanilla.Strippers['locations'] = data
end)

RegisterNetEvent("strippers:place")
AddEventHandler("strippers:place", function(index)
    local index = index ~= nil and index or GetClosestLocation()
    local location = Vanilla.Strippers['locations'][index]
    if index and location and location['model'] == nil then
        local model = Vanilla.Strippers['peds'][math.random(#Vanilla.Strippers['peds'])]
        local hash = GetHashKey(model)
        local anim = 'timetable@reunited@ig_10'
        local dict = 'base_amanda'

        -- Loads model
        RequestModel(hash)
        while not HasModelLoaded(hash) do
          Wait(1)
        end
    
        -- Loads animation
        RequestAnimDict(anim)
        while not HasAnimDictLoaded(anim) do
          Wait(1)
        end
    
        -- Creates ped when everything is loaded
        local ped = CreatePed(4, hash, location.sit.x, location.sit.y, location.sit.z, location.sit[4], true, true)
        SetEntityHeading(ped, location.sit[4])
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        TaskPlayAnim(ped,anim,dict, 8.0, 0.0, -1, 1, 0, 0, 0, 0)

        Vanilla.Strippers['locations'][index]['model'] = model
        TriggerServerEvent("strippers:updateStrippers", Vanilla.Strippers['locations'])
    end
end)

function GetClosestLocation()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local lastDistance = nil
    local lastLocation = nil
    for k,v in pairs(Vanilla.Strippers['locations']) do
        local distance = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.sit.x, v.sit.y, v.sit.z, true)
        if distance < 2 and (lastDistance == nil or distance < lastDistance) then
            lastDistance = distance
            lastLocation = k
        end
    end
    
    return lastLocation
end

local CurrentDanceIndex = 1
local Dances = {
    {"mp_safehouse", "lap_dance_girl"},
    {"mini@strip_club@private_dance@idle", "priv_dance_idle"},
    {"mini@strip_club@private_dance@part3", "priv_dance_p3"},
}

CreateThread(function()
    local serverID = GetPlayerServerId(PlayerId())

    while true do
        local plyPed = PlayerPedId()
        local coords = GetEntityCoords(plyPed)
        local letSleep = true
        local k = GetClosestLocation()
        local v = Vanilla.Strippers['locations'][k]
        if k and v then
            if v.model ~= nil and v.taken == 0 then
                local distance = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.sit.x, v.sit.y, v.sit.z, true)
                if distance < 1.5 then
                    letSleep = false
                    local msg = "Press ~p~E~w~ to interact"
                    if PlayerData and PlayerData.job.name == 'vanilla' then
                        msg = msg .. '\nPress ~g~K~w~ to change ped'
                        msg = msg .. '\nPress ~g~BACKSPACE~w~ to delete ped'
                    end
                    ShowHelpNotification(msg)
                    if IsControlJustPressed(0,38) then
                        local ped = GetClosestNPC(v.model)
                        DoScreenFadeOut(500)
                        Wait(1000)
                        ClearPedTasksImmediately(ped)
                        ClearPedTasksImmediately(PlayerPedId())
                        SetEntityCoords(ped, v.stand.x, v.stand.y, v.stand.z)
                        SetEntityHeading(ped, v.stand[4])
                        Wait(200)
                        SetEntityCoords(PlayerPedId(), v.sit.x, v.sit.y, v.sit.z)
                        SetEntityHeading(PlayerPedId(), v.sit[4])

                        -- Loads animation
                        RequestAnimDict('timetable@ron@ig_5_p3')
                        while not HasAnimDictLoaded('timetable@ron@ig_5_p3') do
                            Wait(1)
                        end

                        Wait(200)

                        Vanilla.Strippers['locations'][k]['taken'] = serverID
                        TriggerServerEvent("strippers:updateStrippers", Vanilla.Strippers['locations'])
                        DoScreenFadeIn(500)

                        while Vanilla.Strippers['locations'][k]['taken'] == serverID and DoesEntityExist(ped) do
                            Wait(1)

                            DisableControlAction(0, 38, true)
                            DisableControlAction(0, 77, true)
                            DisableControlAction(0, 244, true)
                            DisableControlAction(0, 246, true)
                            DisableControlAction(0, 249, true)
                            DisableControlAction(0, 45, true)
                            DisableControlAction(0, 288, true)
                            DisableControlAction(0, 289, true)
                            DisableControlAction(0, 157, true)
                            DisableControlAction(0, 158, true)
                            DisableControlAction(0, 160, true)
                            DisableControlAction(0, 164, true)
                            DisableControlAction(0, 165, true)
                            DisableControlAction(0, 159, true)
                            DisableControlAction(0, 161, true)
                            DisableControlAction(0, 162, true)

                            local msg = "Press ~p~E~w~ to change dance (" .. CurrentDanceIndex .. "/" .. #Dances .. ")"
                            msg = msg .. '\n Press ~g~BACKSPACE~w~ to stop dance'
                            ShowHelpNotification(msg)

                            if not IsEntityPlayingAnim(PlayerPedId(), 'timetable@ron@ig_5_p3', 'ig_5_p3_base', 3) then
                                ClearPedTasks(PlayerPedId())
                                TaskPlayAnim(PlayerPedId(),'timetable@ron@ig_5_p3',"ig_5_p3_base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
                            end

                            if Dances[CurrentDanceIndex] and not IsEntityPlayingAnim(ped, Dances[CurrentDanceIndex][1], Dances[CurrentDanceIndex][2], 3) then
                                CreateThread(function()
                                    RequestAnimDict(Dances[CurrentDanceIndex][1])
                                    while not HasAnimDictLoaded(Dances[CurrentDanceIndex][1]) do
                                        Wait(100)
                                    end

                                    ClearPedTasks(ped)
                                    Wait(150)

                                    TaskPlayAnim(ped,Dances[CurrentDanceIndex][1],Dances[CurrentDanceIndex][2], 8.0, 0.0, -1, 1, 0, 0, 0, 0)
                                end)
                            end

                            if IsDisabledControlJustPressed(0,38) then
                                DoScreenFadeOut(500)
                                CurrentDanceIndex = CurrentDanceIndex == #Dances and 1 or CurrentDanceIndex+1
                                Wait(1200)
                                DoScreenFadeIn(500)
                            elseif IsDisabledControlJustPressed(0,194) then
                                ClearPedTasksImmediately(PlayerPedId())
                                StopAnimTask(PlayerPedId(), 'timetable@ron@ig_5_p3', 'ig_5_p3_base', 1.0)
                                break
                            end
                        end
                        
                        DoScreenFadeOut(500)
                        Wait(500)
                        if DoesEntityExist(ped) then
                            TriggerServerEvent("strippers:serverDeletePed", v.model, GetEntityCoords(ped))
                        end
                        
                        ClearPedTasksImmediately(PlayerPedId())
                        StopAnimTask(PlayerPedId(), 'timetable@ron@ig_5_p3', 'ig_5_p3_base', 1.0)
                        Vanilla.Strippers['locations'][k]['taken'] = 0
                        Vanilla.Strippers['locations'][k]['model'] = nil
                        TriggerServerEvent("strippers:updateStrippers", Vanilla.Strippers['locations'])
                        Wait(500)
                        DoScreenFadeIn(500)
                        TriggerEvent("dpemotes:WalkCommandStart")
                    elseif PlayerData and PlayerData.job.name == 'vanilla' then
                        if IsControlJustPressed(0,194) then
                            local ped = GetClosestNPC(v.model)
                            if DoesEntityExist(ped) then
                                TriggerServerEvent("strippers:serverDeletePed", v.model, GetEntityCoords(ped))
                            end

                            ClearPedTasksImmediately(PlayerPedId())
                            Vanilla.Strippers['locations'][k]['taken'] = 0
                            Vanilla.Strippers['locations'][k]['model'] = nil
                            TriggerServerEvent("strippers:updateStrippers", Vanilla.Strippers['locations'])
                        elseif IsControlJustPressed(0,311) then
                            local ped = GetClosestNPC(v.model)
                            if DoesEntityExist(ped) then
                                TriggerServerEvent("strippers:serverDeletePed", v.model, GetEntityCoords(ped))
                            end

                            Vanilla.Strippers['locations'][k]['model'] = Vanilla.Strippers['peds'][math.random(#Vanilla.Strippers['peds'])]
                            local location = Vanilla.Strippers['locations'][k]
                            local hash = location['model']
                            local anim = 'timetable@reunited@ig_10'
                            local dict = 'base_amanda'

                            -- Loads model
                            RequestModel(hash)
                            while not HasModelLoaded(hash) do
                                Wait(1)
                            end
                        
                            -- Loads animation
                            RequestAnimDict(anim)
                            while not HasAnimDictLoaded(anim) do
                                Wait(1)
                            end
                        
                            -- Creates ped when everything is loaded
                            local ped = CreatePed(2, hash, location.sit.x, location.sit.y, location.sit.z, location.sit[4], true, true)
                            SetEntityHeading(ped, location.sit[4])
                            FreezeEntityPosition(ped, true)
                            SetEntityInvincible(ped, true)
                            SetBlockingOfNonTemporaryEvents(ped, true)
                            TaskPlayAnim(ped,anim,dict, 8.0, 0.0, -1, 1, 0, 0, 0, 0)
                            TriggerServerEvent("strippers:updateStrippers", Vanilla.Strippers['locations'])
                        end
                    end
                end
            end
        end

        Wait(letSleep and 1000 or 1)
    end
end)

function ShowHelpNotification(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function GetClosestNPC(model, coords)
    local playerped = PlayerPedId()
    local playerCoords = coords ~= nil and coords or GetEntityCoords(playerped)
    local handle, ped = FindFirstPed()
    local success
    local rped = nil
    local distanceFrom
    repeat
        local pos = GetEntityCoords(ped)
        local distance = #(playerCoords - pos)
        if not IsEntityDead(ped) and distance < 2.0 and (distanceFrom == nil or distance < distanceFrom) and (model == nil or model == GetEntityModel(ped) or GetHashKey(model) == GetEntityModel(ped)) then
            distanceFrom = distance
            rped = ped
        end
        success, ped = FindNextPed(handle)
    until not success
    EndFindPed(handle)
    return rped
end

RegisterNetEvent("strippers:clientDeletePed")
AddEventHandler("strippers:clientDeletePed", function(model, coords)
    local ped = GetClosestNPC(model, coords)
    if DoesEntityExist(ped) then
        DeleteEntity(ped)
    end
end)
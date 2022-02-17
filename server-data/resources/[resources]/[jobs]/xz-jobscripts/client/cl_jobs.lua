XZCore = nil
local playerJob, playerData = {}, {}
local isInRun, runJob, taskingRun = false, '', false
local blip, ModuleReady = nil, false

RegisterNetEvent("XZCore:Client:OnJobUpdate", function(jobInfo)
	playerJob = jobInfo
	playerData = XZCore.Functions.GetPlayerData()
end)

RegisterNetEvent("xz-job:client:main", function(job)
	if taskingRun then
		return
	end

	local randomLocations = math.random(1, #Config.DropOffLocations[job])
	CreateBlip(job, randomLocations)

	taskingRun = true
	local toolong = Config.Jobs[job]['settings'].runtimer * 4200

	while taskingRun do
		Wait(1)
		local plycoords = GetEntityCoords(PlayerPedId())
		local dstcheck = #(plycoords - vector3(Config.DropOffLocations[job][randomLocations]["x"],Config.DropOffLocations[job][randomLocations]["y"],Config.DropOffLocations[job][randomLocations]["z"])) 

		toolong = toolong - 1
		if toolong < 0 then
			TriggerEvent('XZCore:Notify', Config.Jobs[job]['settings'].timedout, "error")
			taskingRun = false
		end

		if dstcheck < 50 then
			DrawMarker(2, Config.DropOffLocations[job][randomLocations]["x"], Config.DropOffLocations[job][randomLocations]["y"], Config.DropOffLocations[job][randomLocations]["z"], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.2, 155, 152, 234, 155, false, false, false, true, false, false, false)
			if dstcheck < 3.0 then
				DrawText3DDD(Config.DropOffLocations[job][randomLocations]["x"], Config.DropOffLocations[job][randomLocations]["y"], Config.DropOffLocations[job][randomLocations]["z"] + 0.3, Config.Jobs[job]['settings'].dropoff)

				local LocDeliver = vector3(Config.DropOffLocations[job][randomLocations]["x"], Config.DropOffLocations[job][randomLocations]["y"], Config.DropOffLocations[job][randomLocations]["z"])
				if not IsPedInAnyVehicle(PlayerPedId()) and IsControlJustReleased(0,38) then
					Citizen.Wait(1500)
					DoDropOff(LocDeliver)
					taskingRun = false
				end
			end
		end
	end
	DeleteBlip()
end)

RegisterNetEvent('xz-jobscripts:client:openJobShop', function()
	local shop = {}
	local job = Config.Jobs[playerJob.name]
	shop.label = "Main Shop"
	shop.items = job['shopitems']
	shop.slots = #job['shopitems']

	TriggerServerEvent("inventory:server:OpenInventory", "shop", "shop_" .. math.random(111, 9999), shop)
end)

RegisterNetEvent('xz-jobscripts:client:startJobCook1', function()
	local job = Config.Jobs[playerJob.name]
	local playerPed = PlayerPedId()
	if not IsPedInAnyVehicle(playerPed) then
		Wait(10)
		TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BBQ", 0, true)

		local skillbarAmount, done = math.random(1, 4), true
		for counter = 1, skillbarAmount do
			local finished = exports["taskbarskill"]:taskBar(math.random(1600, 2500), math.random(5, 15))
			if finished ~= 100 then
				done = false
			end
		end

		Wait(7000)
		ClearPedTasks(playerPed)
		if done then
			TriggerServerEvent('xz-jobs:server:addItem', job['settings'].food_item1, 2)
			XZCore.Functions.Notify(job['settings'].made_items1, "success")
		end
	end
end)

RegisterNetEvent('xz-jobscripts:client:startJobCook2', function()
	local job = Config.Jobs[playerJob.name]
	local playerPed = PlayerPedId()
	if not IsPedInAnyVehicle(playerPed) then
		Wait(10)
		TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BBQ", 0, true)

		local skillbarAmount, done = math.random(1, 4), true
		for counter = 1, skillbarAmount do
			local finished = exports["taskbarskill"]:taskBar(math.random(1600, 2500), math.random(5, 15))
			if finished ~= 100 then
				done = false
			end
		end

		Wait(7000)
		ClearPedTasks(playerPed)
		if done then
			TriggerServerEvent('xz-jobs:server:addItem', job['settings'].food_item2, 2)
			XZCore.Functions.Notify(job['settings'].made_items2, "success")
		end
	end
end)

RegisterNetEvent('xz-jobscripts:client:startJobPackage', function()
	local playerPed = PlayerPedId()
	local job = Config.Jobs[playerJob.name]
	if not IsPedInAnyVehicle(playerPed) then
		Wait(10)
		XZCore.Functions.TriggerCallback('xz-jobs:server:getItemCount', function(hasItems)
			if hasItems then
				playerAnim(2)

				local skillbarAmount, done = math.random(1, 4), true
				for counter = 1, skillbarAmount do
					local finished = exports["taskbarskill"]:taskBar(math.random(2000, 2500), math.random(5, 15))
					if finished ~= 100 then
						done = false
					end
				end

				Wait(7000)
				ClearPedTasks(playerPed)
				if done then
					TriggerServerEvent('xz-jobs:server:removeItem', job['settings'].food_item, 2)
					TriggerServerEvent('xz-jobs:server:addItem', job['settings'].bag_item, 1)
					XZCore.Functions.Notify(job['settings'].packed_items, "success")
				end
			else
				XZCore.Functions.Notify(job['settings'].not_enoght, "error")
			end
		end, job['settings'].food_item, 2)
	end
end)

RegisterNetEvent('xz-jobscripts:client:jobReadyDelivery', function()
	local job = Config.Jobs[playerJob.name]
	if not IsPedInAnyVehicle(PlayerPedId()) then
		Wait(10)
		XZCore.Functions.Progressbar("rljobs_preparing", job['settings'].preparing, 3000, false, true, {
			disableMovement = false,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		}, {}, {}, {}, function()
			TriggerServerEvent('xz-jobs:server:readyForDelivery', job['name'], job['settings'].bag_item)
		end, function()
			XZCore.Functions.Notify("Failed!", "error")
		end)
	end
end)

RegisterNetEvent('xz-jobscripts:client:startJobPickup', function()
	local playerPed = PlayerPedId()
	local job = Config.Jobs[playerJob.name]
	if not IsPedInAnyVehicle(playerPed) then
		Wait(10)
		XZCore.Functions.TriggerCallback('xz-jobs:server:getItemCount', function(hasItems)
			if hasItems then
				playerAnim(2)

				local skillbarAmount, done = math.random(1, 4), true
				for counter = 1, skillbarAmount do
					local finished = exports["taskbarskill"]:taskBar(math.random(2000, 2500), math.random(5, 15))
					if finished ~= 100 then
						done = false
					end
				end

				Wait(7000)
				ClearPedTasks(playerPed)
				if done == true then
					TriggerServerEvent('xz-jobs:server:removeItem', job['settings'].food_item, 2)
					TriggerServerEvent('xz-jobs:server:addItem', job['settings'].bag_item, 1)
					XZCore.Functions.Notify(job['settings'].packed_items, "success")
				end
			else
				XZCore.Functions.Notify(job['settings'].not_enoght, "error")
			end
		end, job['settings'].food_item, 2)
	end
end)

RegisterNetEvent('xz-jobscripts:client:cancelJobDelivery', function()
	if not IsPedInAnyVehicle(PlayerPedId()) then
		Wait(10)
		TriggerServerEvent('xz-jobs:server:removeItem', Config.Jobs[playerJob.name]['settings'].bag_item, 1)

		isInRun, runJob, taskingRun = false, '', false
	end
end)

RegisterNetEvent('xz-jobscripts:client:openJobBossMenu', function()
	if not IsPedInAnyVehicle(PlayerPedId()) then
		TriggerServerEvent("xz-bossmenu:server:openMenu")
		Wait(2000)
	end
end)

Citizen.CreateThread(function()
	TriggerEvent("debug", 'Jobs: Wating for module!', 'normal')

	while XZCore == nil do
		TriggerEvent('XZCore:GetObject', function(obj) XZCore = obj end)
		Citizen.Wait(200)
	end

	while XZCore.Functions.GetPlayerData().job == nil do
		Wait(0)
	end

	playerData = XZCore.Functions.GetPlayerData()
	playerJob = XZCore.Functions.GetPlayerData().job

	TriggerEvent("debug", 'Jobs: Module Ready!', 'normal')
	ModuleReady = true

	for k, v in pairs(Config.Pickups) do
		exports['xz-interact']:AddBoxZone(v.name, v.coords, v.length, v.width, {
			name = v.name,
			heading = v.heading,
			debugPoly = v.debugPoly,
			minZ = v.minZ,
			maxZ = v.maxZ
		}, {
			options = v.options,
			distance = v.distance
		})
	end

	for k, v in pairs(Config.Jobs) do
		for j, h in pairs(v['locations']) do
			exports['xz-interact']:AddBoxZone(k..''..j, h.coords, h.length, h.width, {
				name = k..''..j,
				heading = h.heading,
				debugPoly = false,
				minZ = h.minZ,
				maxZ = h.maxZ
			}, {
				options = {
					{
						event = h.event,
						icon = h.icon,
						label = h.label,
						job = h.job,
						canInteract = function()
							return not IsInRun
						end,
					}
				},
				distance = h.distance
			})
		end
	end

	exports['xz-interact']:AddBoxZone('burgershotclothing1', vector3(-1184.997, -899.377, 13.984732), 1.0, 2.5, {
		name = 'burgershotclothing1',
		heading = 303.0,
		debugPoly = false,
		minZ = 13.0,
		maxZ = 15.8
	}, {
		options = {
			{
				action = function()
					TriggerServerEvent("clothing:checkMoney", "clothesmenu")
				end,
				icon = 'fas fa-circle',
				label = 'Clothing Menu',
				job = 'burgershot',
				canInteract = function()
					return not IsInRun
				end,
			},
			{
                type = "xzcommand",
                event = 'outfits',
                icon = 'fas fa-circle',
                label = 'Manage Outfits',
				job = 'burgershot',
				canInteract = function()
					return not IsInRun
				end,
            }
        },
		distance = 2.5
	})
end)

Citizen.CreateThread(function()
	while true do
        if isInRun and runJob then
			if taskingRun then
				Wait(30000)
			else
				TriggerEvent("xz-job:client:main", runJob)
			end
		end
		Wait(0)
    end
end)

function tprint(a, b)
	for c, d in pairs(a) do
		local e = '["'..tostring(c)..'"]'
		if type(c) ~='string' then
			e = '['..c..']'
		end
		local f = '"'..tostring(d)..'"'
		if type(d) =='table' then
			tprint(d, (b or '')..e)
		else
			if type(d)~='string' then
				f = tostring(d)
			end
			print(type(a)..(b or '')..e..' = '..f)
		end
	end
end

RegisterNetEvent("xz-jobs:client:startDelivery", function(job)
	isInRun = true
	runJob = job
end)

RegisterNetEvent("burgershot:pickup1", function()
	TriggerServerEvent("inventory:server:OpenInventory", "stash", "pickupfood1", {
		maxweight = 500000,
		slots = 5,
		label = 'Orders'
	})
	TriggerEvent("inventory:client:SetCurrentStash", "pickupfood1")
end)

RegisterNetEvent("burgershot:pickup2", function()
	TriggerServerEvent("inventory:server:OpenInventory", "stash", "pickupfood2", {
		maxweight = 500000,
		slots = 5,
		label = 'Orders'
	})
	TriggerEvent("inventory:client:SetCurrentStash", "pickupfood2")
end)

RegisterNetEvent("burgershot:pickup3", function()
	TriggerServerEvent("inventory:server:OpenInventory", "stash", "pickupfood3", {
		maxweight = 500000,
		slots = 5,
		label = 'Orders'
	})
	TriggerEvent("inventory:client:SetCurrentStash", "pickupfood3")
end)

RegisterNetEvent("burgershot:pickup4", function()
	TriggerServerEvent("inventory:server:OpenInventory", "stash", "pickupfoodemployee1", {
		maxweight = 500000,
		slots = 5,
		label = 'Orders'
	})
	TriggerEvent("inventory:client:SetCurrentStash", "pickupfoodemployee1")
end)

RegisterNetEvent("xz-burgershot:MurderMeal", function()
		local randomToy = math.random(1,10)
		--remove box
		TriggerServerEvent('XZCore:Server:RemoveItem', "burger-murdermeal", 1)
		--add items from box
		TriggerServerEvent('XZCore:Server:AddItem', "heartstopper", 1)
		TriggerServerEvent('XZCore:Server:AddItem', "softdrink", 1)
		TriggerServerEvent('XZCore:Server:AddItem', "fries", 1)

		if randomToy < 4 then
			
			XZCore.Functions.Notify("Lol you didn't get a toy", "error")
			
		elseif randomToy == 4 then
			
			TriggerServerEvent('XZCore:Server:AddItem', "burger-toy1", 1)
            		TriggerEvent("inventory:client:ItemBox", XZCore.Shared.Items["burger-toy1"], "add")
		
		elseif randomToy < 10 and randomToy > 4 then
			
			XZCore.Functions.Notify("Lol you didn't get a toy", "error")
			
		elseif randomToy == 10 then	
 
			TriggerServerEvent('XZCore:Server:AddItem', "burger-toy2", 1)	
            		TriggerEvent("inventory:client:ItemBox", XZCore.Shared.Items["burger-toy2"], "add")
		else	
            XZCore.Functions.Notify("Lol you didn't get a toy", "error")
    end
end)

RegisterNetEvent("xz-burgershot:CreateMurderMeal", function()
    XZCore.Functions.TriggerCallback('xz-burgershot:server:get:ingredientMurderMeal', function(HasItems)  
    		if HasItems then
				TriggerEvent('inventory:client:busy:status', true)
				XZCore.Functions.Progressbar("pickup_sla", "Making A Murder Meal..", 4000, false, true, {
					disableMovement = true,
					disableCarMovement = false,
					disableMouse = false,
					disableCombat = false,
				}, {
					animDict = "mp_common",
					anim = "givetake1_a",
					flags = 8,
				}, {}, {}, function() -- Done
					
					TriggerEvent('inventory:client:busy:status', false)
					TriggerServerEvent('XZCore:Server:RemoveItem', "fries", 1)
                    TriggerServerEvent('XZCore:Server:RemoveItem', "heartstopper", 1)
					TriggerServerEvent('XZCore:Server:RemoveItem', "softdrink", 1)
					TriggerServerEvent('XZCore:Server:AddItem', "burger-murdermeal", 1)
                    TriggerEvent("inventory:client:ItemBox", XZCore.Shared.Items["burger-murdermeal"], "add")
                    XZCore.Functions.Notify("You made a A Murder Meal", "success")
				end, function()
					TriggerEvent('inventory:client:busy:status', false)
					XZCore.Functions.Notify("Cancelled..", "error")
			end)
		else
   			XZCore.Functions.Notify("You dont have the items to make this", "error")
		end
	end)
end)

Citizen.CreateThread(function()
	for _, job in pairs(Config.Jobs) do
		local blip = AddBlipForCoord(job['blip'].coords)

		SetBlipSprite (blip, job['blip'].sprite)
		SetBlipDisplay(blip, job['blip'].display)
		SetBlipScale  (blip, job['blip'].scale)
		SetBlipColour (blip, job['blip'].color)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(job['blip'].name)
		EndTextCommandSetBlipName(blip)
	end
end)

function DrawText3DDD(x, y, z, text)
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

DrawMarker3D = function(x, y, z)
	DrawMarker(2, x, y, z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
end

function playerAnim(anim)
	if anim == 1 then
		loadAnimDict("mp_safehouselost@")
		TaskPlayAnim( PlayerPedId(), "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0)
	elseif anim == 2 then
		loadAnimDict("anim@amb@business@cfm@cfm_drying_notes@")
		TaskPlayAnim( PlayerPedId(), "anim@amb@business@cfm@cfm_drying_notes@", "loading_v3_worker", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
	elseif anim == 3 then
		loadAnimDict("timetable@jimmy@doorknock@")
    	TaskPlayAnim(PlayerPedId(), "timetable@jimmy@doorknock@", "knockdoor_idle", 8.0, 8.0, -1, 4, 0, 0, 0, 0 )
	end
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded( dict )) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

function DeleteBlip()
	if DoesBlipExist(blip) then
		RemoveBlip(blip)
	end
end

function CreateBlip(job, rndLocation)
	if isInRun then
		blip = AddBlipForCoord(Config.DropOffLocations[job][rndLocation]["x"],Config.DropOffLocations[job][rndLocation]["y"],Config.DropOffLocations[job][rndLocation]["z"])
	end

	SetBlipSprite(blip, Config.DropOff.Sprite)
	SetBlipColour(blip, Config.DropOff.Color)
    SetBlipScale(blip, Config.DropOff.Scale)
    SetBlipAsShortRange(blip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.DropOff.Name)
    EndTextCommandSetBlipName(blip)
end

function DoDropOff(Location)
	Wait(10)
	playerAnim(3)
	Wait(3000)
	ClearPedTasks(PlayerPedId())
	playerAnim(1)
	DeleteBlip()

	Citizen.Wait(2000)
	TriggerServerEvent("xz-jobs:server:dropoff", runJob)
	isInRun, runJob = false, ''
end
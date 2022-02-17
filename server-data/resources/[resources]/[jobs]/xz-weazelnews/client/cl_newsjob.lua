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
        
        if PlayerData and PlayerData.job.name == 'reporter' then
            local shop = News.Locations['shop']
            local stash = News.Locations['stash']
            local vehicle = News.Locations['vehicle']
			local boss = News.Locations['boss']
            local helicopter = News.Locations['helicopter']
            
			if (GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, shop.x, shop.y, shop.z, true) < 10) then
				letSleep = false
				DrawMarker(2, shop.x, shop.y, shop.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
				 if (GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, shop.x, shop.y, shop.z, true) < 1.5) then
					DrawText3D(shop.x, shop.y, shop.z, "~g~E~w~ - Shop")
					if IsControlJustReleased(0, 38) then
                        TriggerServerEvent("inventory:server:OpenInventory", "shop", "news", News.Items)
					end
				end  
			end

            local InVehicle = IsPedInAnyVehicle(PlayerPedId())
            if (GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, vehicle.x, vehicle.y, vehicle.z, true) < 10) and PlayerData.job.isboss then
                letSleep = false
                DrawMarker(2, vehicle.x, vehicle.y, vehicle.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                if (GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, vehicle.x, vehicle.y, vehicle.z, true) < 1.5) then
                    if InVehicle then
                    DrawText3D(vehicle.x, vehicle.y, vehicle.z, '~g~E~w~ - Store the vehicle')
                    if IsControlJustReleased(0, 38) then
                        DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
                    end
                else
                    DrawText3D(vehicle.x, vehicle.y, vehicle.z, '~g~E~w~ - Vehicle')
                    if IsControlJustReleased(0, 38) then
                        if IsControlJustReleased(0, 38) then
                            newsVehList()
                            Menu.hidden = not Menu.hidden
                        end
                    end
                    Menu.renderGUI()
                end  
            end
        end
            
			local InVehicle = IsPedInAnyVehicle(PlayerPedId())
            if (GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, helicopter.x, helicopter.y, helicopter.z, true) < 10) and PlayerData.job.isboss then
                letSleep = false
                DrawMarker(2, helicopter.x, helicopter.y, helicopter.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                if (GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, helicopter.x, helicopter.y, helicopter.z, true) < 1.5) then
                    if InVehicle then
                    DrawText3D(helicopter.x, helicopter.y, helicopter.z, "~g~E~w~ - Store the helicopter")
                    if IsControlJustReleased(0, 38) then
                        DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
                    end
                else
                    DrawText3D(helicopter.x, helicopter.y, helicopter.z, '~g~E~w~ - Spawn Helicopter')
                    if IsControlJustReleased(0, 38) then
                        if IsControlJustReleased(0, 38) then
                            HelicopterList()
                            Menu.hidden = not Menu.hidden
                        end
                    end
                    Menu.renderGUI()
                end  
            end
        end

            if (GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, stash.x, stash.y, stash.z, true) < 10) and PlayerData.job.isboss then
                letSleep = false
                DrawMarker(2, stash.x, stash.y, stash.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                if (GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, stash.x, stash.y, stash.z, true) < 1.5) then
                    DrawText3D(stash.x, stash.y, stash.z, "~g~E~w~ - Open Personal Stash")
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent("InteractSound_CL:PlayOnOne","zipper",0.5)
                        TriggerServerEvent("inventory:server:OpenInventory", "stash", "newsstash_"..XZCore.Functions.GetPlayerData().citizenid)
                        TriggerEvent("inventory:client:SetCurrentStash", "newsstash_"..XZCore.Functions.GetPlayerData().citizenid)
                    end
                end  
            end
			
            if (GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, boss.x, boss.y, boss.z, true) < 10) and PlayerData.job.isboss then
                letSleep = false
                DrawMarker(2, boss.x, boss.y, boss.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                if (GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, boss.x, boss.y, boss.z, true) < 1.5) then
                    DrawText3D(boss.x, boss.y, boss.z, "~g~E~w~ - Boss Menu")
                    if IsControlJustReleased(0, 38) then
                        TriggerServerEvent("xz-bossmenu:server:openMenu")
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

function OpenMenu()
    ClearMenu()
    Menu.addButton("Options", "VehicleOptions", nil)
    Menu.addButton("Close Menu", "CloseMenu", nil) 
end

function newsVehList()
    ClearMenu()
    for k, v in pairs(News.Vehicles) do
        Menu.addButton(v, "SpawnListVehicle", k) 
    end
    Menu.addButton("Close Menu", "CloseMenu", nil) 
end

function HelicopterList()
    ClearMenu()
    for k, v in pairs(News.Helicopter) do
        Menu.addButton(v, "SpawnListHelicopter", k) 
    end
    Menu.addButton("Close Menu", "CloseMenu", nil) 
end

function SpawnListVehicle(model)
    local coords = {
        x = News.Locations["vehspawn"].x,
        y = News.Locations["vehspawn"].y,
        z = News.Locations["vehspawn"].z,
        h = News.Locations["vehspawn"].h,
    }

    if not IsModelValid(model) then
        XZCore.Functions.Notify("Invaild Vehicle Model", "error")
        return false
    end

    XZCore.Functions.SpawnVehicle(model, function(veh)
        SetVehicleNumberPlateText(veh, "NEWS-"..tostring(math.random(1, 30)))
        SetEntityHeading(veh, coords.h)
        exports['LegacyFuel']:SetFuel(veh, 100)
        Menu.hidden = true
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh), veh)
        SetVehicleEngineOn(veh, true, true)
    end, coords, true)
end

function SpawnListHelicopter(model)
    local coords = {
        x = News.Locations["helicopter"].x,
        y = News.Locations["helicopter"].y,
        z = News.Locations["helicopter"].z,
        h = News.Locations["helicopter"].h,
    }

    if not IsModelValid(model) then
        XZCore.Functions.Notify("Invaild Vehicle Model", "error")
        return false
    end

    XZCore.Functions.SpawnVehicle(model, function(veh)
        SetVehicleNumberPlateText(veh, "NEWS-"..tostring(math.random(1, 30)))
        SetEntityHeading(veh, coords.h)
        exports['LegacyFuel']:SetFuel(veh, 100)
        Menu.hidden = true
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh), veh)
        SetVehicleEngineOn(veh, true, true)
    end, coords, true)
end

-- Menu Functions

CloseMenu = function()
    Menu.hidden = true
    currentGarage = nil
    ClearMenu()
end

ClearMenu = function()
	--Menu = {}
	Menu.GUI = {}
	Menu.buttonCount = 0
	Menu.selection = 0
end

function DrawText3D(x, y, z, text)
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
	local blip = AddBlipForCoord(-575.7573, -928.6996, 23.87363)
    SetBlipSprite(blip, 135)
    SetBlipAsShortRange(blip, true)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 57)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Weazel News HQ")
    EndTextCommandSetBlipName(blip)
end)
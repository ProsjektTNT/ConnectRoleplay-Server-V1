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

RegisterNetEvent("XZCore:Client:OnJobUpdate", function(JobInfo)
	PlayerData.job = JobInfo
end)

CreateThread(function()
    while true do
        local plyPed = PlayerPedId()
        local plyCoords = GetEntityCoords(plyPed)
        local letSleep = true
        
        if PlayerData and PlayerData.job.name == 'tequila' then
			local shop = Tequila.Locations['shop']
			local boss = Tequila.Locations['boss']
			local vip = Tequila.Locations['vip']
		
			if (GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, shop.x, shop.y, shop.z, true) < 10) then
				letSleep = false
				DrawMarker(2, shop.x, shop.y, shop.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
				 if (GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, shop.x, shop.y, shop.z, true) < 1.5) then
					DrawText3D(shop.x, shop.y, shop.z, "[E] - Shop")
					if IsControlJustReleased(0, 38) then
						TriggerServerEvent("inventory:server:OpenInventory", "shop", "tequila", Tequila.Items)
					end
				end  
			end
			
			if (GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, vip.x, vip.y, vip.z, true) < 10) and PlayerData.job.isboss then
				letSleep = false
				DrawMarker(2, vip.x, vip.y, vip.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
				 if (GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, vip.x, vip.y, vip.z, true) < 1.5) then
					DrawText3D(vip.x, vip.y, vip.z, "[E] - VIP Shop")
					if IsControlJustReleased(0, 38) then
						TriggerServerEvent("inventory:server:OpenInventory", "shop", "tequilaboss", Tequila.BossItems)
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
			
            end
            if letSleep then
            Wait(2000)
        end

        Wait(1)
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
						TriggerServerEvent('tequilla:pay')     
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
        local distance = #(vector3(-564.3197, 278.22662, 83.136276) - plyCoords)
        if distance < 1 then
            if not IsPedInAnyVehicle(PlayerPedId(), true) then
                if distance < 1 then
                    DrawText3D(-564.3197, 278.22662, 83.136276, '[E] - Entry Fee (150$)')
					if IsControlJustReleased(0, 38) then 
						TriggerServerEvent('tequilla:pay')     
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

RegisterNetEvent("tequila:mail", function(mailData)
    if PlayerData and PlayerData.job.name == 'tequila' then
        TriggerServerEvent('xz-phone:server:sendNewMail', mailData)
    end
end)
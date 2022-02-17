local PlayerData, XZCore = nil, nil

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
        
        if PlayerData and PlayerData.job.name == 'weapondealer' then

            local stash = Weapondealer.Locations['stash']
            local shop = Weapondealer.Locations['shop']

            if (GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, stash.x, stash.y, stash.z, true) < 10) then
                letSleep = false
                DrawMarker(2, stash.x, stash.y, stash.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                 if (GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, stash.x, stash.y, stash.z, true) < 1.5) then
                    DrawText3D(stash.x, stash.y, stash.z, "[E] - Stash")
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent("InteractSound_CL:PlayOnOne","zipper",0.5)
                        TriggerServerEvent("inventory:server:OpenInventory", "stash", "weapondealer")
                        TriggerEvent("inventory:client:SetCurrentStash", "weapondealer")
                    end
                end  
            end

            if (GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, shop.x, shop.y, shop.z, true) < 10) and PlayerData.job.isboss then
                letSleep = false
                DrawMarker(2, shop.x, shop.y, shop.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                 if (GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, shop.x, shop.y, shop.z, true) < 1.5) then
                    DrawText3D(shop.x, shop.y, shop.z, "[E] - Shop")
                    if IsControlJustReleased(0, 38) then
                        TriggerServerEvent("inventory:server:OpenInventory", "shop", "weapondealer", Weapondealer.Items)
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
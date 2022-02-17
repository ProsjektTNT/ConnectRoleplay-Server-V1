local playerData, playerJob = nil, nil
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

	playerData = XZCore.Functions.GetPlayerData()
    playerJob = XZCore.Functions.GetPlayerData().job
end)

RegisterNetEvent("XZCore:Client:OnJobUpdate", function(jobInfo)
    playerJob = jobInfo
    playerData = XZCore.Functions.GetPlayerData()
end)

CreateThread(function()
    for k,v in pairs(Config.Items.items) do
        v.slot = k
    end

    while true do
        Wait(1)
        local plyPed = PlayerPedId()
        local plyCoords = GetEntityCoords(plyPed)
        local letSleep = true
        if playerJob and playerJob.name == 'vanilla' and playerData.job.isboss then
            local ShopDistance = GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, Config.Locations['shop'].x, Config.Locations['shop'].y, Config.Locations['shop'].z, true)
                
            if ShopDistance < 20 then
                letSleep = false
                if ShopDistance < 2.5 then
                    DrawText3Ds(Config.Locations['shop']["x"], Config.Locations['shop']["y"], Config.Locations['shop']["z"], "[E] - Shop")
                    if IsControlJustPressed(0, 38) then
                        TriggerServerEvent("inventory:server:OpenInventory", "shop", "vanilla", Config.Items)
                    end
                end
            end
        end

        if letSleep then
            Wait(1500)
        end
    end
end)
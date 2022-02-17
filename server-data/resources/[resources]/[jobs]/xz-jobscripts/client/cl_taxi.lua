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

-- Code

local isLoggedIn = false
local PlayerData = {}

local meterIsOpen = false

local meterActive = false
local currentTaxi = nil

local lastLocation = nil

local meterData = {
    fareAmount = 3,
    currentFare = 0,
    distanceTraveled = 0,
}

local dutyPlate = nil

local NpcData = {
    Active = false,
    CurrentNpc = nil,
    LastNpc = nil,
    CurrentDeliver = nil,
    LastDeliver = nil,
    Npc = nil,
    NpcBlip = nil,
    DeliveryBlip = nil,
    NpcTaken = false,
    NpcDelivered = false,
    CountDown = 180
}

function TimeoutNpc()
    Citizen.CreateThread(function()
        while NpcData.CountDown ~= 0 do
            NpcData.CountDown = NpcData.CountDown - 1
            Citizen.Wait(1000)
        end
        NpcData.CountDown = 180
    end)
end

CreateThread(function()
    while true do
        local plyPed = PlayerPedId()
        local plyCoords = GetEntityCoords(plyPed)
        local letSleep = true
        
        if PlayerData.job == 'taxi' then
			local boss = Taxi.Markers['boss']
			local stash = Taxi.Markers['stash']
			
            if (GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, stash.x, stash.y, stash.z, true) < 10) then
                letSleep = false
                DrawMarker(2, stash.x, stash.y, stash.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                 if (GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, stash.x, stash.y, stash.z, true) < 1.5) then
                    DrawText3D(stash.x, stash.y, stash.z, "[E] - Stash")
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent("InteractSound_CL:PlayOnOne","zipper",0.5)
                        TriggerServerEvent("inventory:server:OpenInventory", "stash", "taxi")
                        TriggerEvent("inventory:client:SetCurrentStash", "taxi")
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

RegisterNetEvent('xz-taxi:client:DoTaxiNpc', function()
    if whitelistedVehicle() then
        if NpcData.CountDown == 180 then
            if not NpcData.Active then
                NpcData.CurrentNpc = math.random(1, #Taxi.NPCLocations.TakeLocations)
                if NpcData.LastNpc ~= nil then
                    while NpcData.LastNpc ~= NpcData.CurrentNpc do
                        NpcData.CurrentNpc = math.random(1, #Taxi.NPCLocations.TakeLocations)
                    end
                end

                local Gender = math.random(1, #Taxi.NpcSkins)
                local PedSkin = math.random(1, #Taxi.NpcSkins[Gender])
                local model = GetHashKey(Taxi.NpcSkins[Gender][PedSkin])
                RequestModel(model)
                while not HasModelLoaded(model) do
                    Citizen.Wait(0)
                end
                NpcData.Npc = CreatePed(3, model, Taxi.NPCLocations.TakeLocations[NpcData.CurrentNpc].x, Taxi.NPCLocations.TakeLocations[NpcData.CurrentNpc].y, Taxi.NPCLocations.TakeLocations[NpcData.CurrentNpc].z - 0.98, Taxi.NPCLocations.TakeLocations[NpcData.CurrentNpc].h, false, true)
                PlaceObjectOnGroundProperly(NpcData.Npc)
                FreezeEntityPosition(NpcData.Npc, true)
                if NpcData.NpcBlip ~= nil then
                    RemoveBlip(NpcData.NpcBlip)
                end
                XZCore.Functions.Notify('The NPC is indicated on your navigation!', 'success')
                NpcData.NpcBlip = AddBlipForCoord(Taxi.NPCLocations.TakeLocations[NpcData.CurrentNpc].x, Taxi.NPCLocations.TakeLocations[NpcData.CurrentNpc].y, Taxi.NPCLocations.TakeLocations[NpcData.CurrentNpc].z)
                SetBlipColour(NpcData.NpcBlip, 3)
                SetBlipRoute(NpcData.NpcBlip, true)
                SetBlipRouteColour(NpcData.NpcBlip, 3)
                NpcData.LastNpc = NpcData.CurrentNpc
                NpcData.Active = true

                Citizen.CreateThread(function()
                    while not NpcData.NpcTaken do

                        local ped = PlayerPedId()
                        local pos = GetEntityCoords(ped)
                        local dist = GetDistanceBetweenCoords(pos, Taxi.NPCLocations.TakeLocations[NpcData.CurrentNpc].x, Taxi.NPCLocations.TakeLocations[NpcData.CurrentNpc].y, Taxi.NPCLocations.TakeLocations[NpcData.CurrentNpc].z, true)

                        if dist < 20 then
                            DrawMarker(2, Taxi.NPCLocations.TakeLocations[NpcData.CurrentNpc].x, Taxi.NPCLocations.TakeLocations[NpcData.CurrentNpc].y, Taxi.NPCLocations.TakeLocations[NpcData.CurrentNpc].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 255, 0, 0, 0, 1, 0, 0, 0)
                        
                            if dist < 5 then
                                local npccoords = GetEntityCoords(NpcData.Npc)
                                DrawText3D(Taxi.NPCLocations.TakeLocations[NpcData.CurrentNpc].x, Taxi.NPCLocations.TakeLocations[NpcData.CurrentNpc].y, Taxi.NPCLocations.TakeLocations[NpcData.CurrentNpc].z, '[E] NPC calls')
                                if IsControlJustPressed(0, Keys["E"]) then
                                    local veh = GetVehiclePedIsIn(ped, 0)
                                    local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

                                    for i=maxSeats - 1, 0, -1 do
                                        if IsVehicleSeatFree(vehicle, i) then
                                            freeSeat = i
                                            break
                                        end
                                    end

                                    meterIsOpen = true
                                    meterActive = true
                                    lastLocation = GetEntityCoords(PlayerPedId())
                                    SendNUIMessage({
                                        action = "openMeter",
                                        toggle = true,
                                        meterData = Taxi.Meter
                                    })
                                    SendNUIMessage({
                                        action = "toggleMeter"
                                    })

                                    ClearPedTasksImmediately(NpcData.Npc)
                                    FreezeEntityPosition(NpcData.Npc, false)
                                    TaskEnterVehicle(NpcData.Npc, veh, -1, freeSeat, 1.0, 0)
                                    XZCore.Functions.Notify('Bring the NPC to the specified location.')
                                    if NpcData.NpcBlip ~= nil then
                                        RemoveBlip(NpcData.NpcBlip)
                                    end
                                    GetDeliveryLocation()
                                    NpcData.NpcTaken = true
                                end
                            end
                        end

                        Citizen.Wait(1)
                    end
                end)
            else
                XZCore.Functions.Notify('You\'re already doing an NPC mission..')
            end
        else
            XZCore.Functions.Notify('No NPCs are available..')
        end
    else
        XZCore.Functions.Notify('You\'re not in a Taxi :(')
    end
end)

function GetDeliveryLocation()
    NpcData.CurrentDeliver = math.random(1, #Taxi.NPCLocations.DeliverLocations)
    if NpcData.LastDeliver ~= nil then
        while NpcData.LastDeliver ~= NpcData.CurrentDeliver do
            NpcData.CurrentDeliver = math.random(1, #Taxi.NPCLocations.DeliverLocations)
        end
    end

    if NpcData.DeliveryBlip ~= nil then
        RemoveBlip(NpcData.DeliveryBlip)
    end
    NpcData.DeliveryBlip = AddBlipForCoord(Taxi.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].x, Taxi.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].y, Taxi.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].z)
    SetBlipColour(NpcData.DeliveryBlip, 3)
    SetBlipRoute(NpcData.DeliveryBlip, true)
    SetBlipRouteColour(NpcData.DeliveryBlip, 3)
    NpcData.LastDeliver = NpcData.CurrentDeliver

    Citizen.CreateThread(function()
        while true do

            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local dist = GetDistanceBetweenCoords(pos, Taxi.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].x, Taxi.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].y, Taxi.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].z, true)

            if dist < 20 then
                DrawMarker(2, Taxi.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].x, Taxi.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].y, Taxi.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 255, 0, 0, 0, 1, 0, 0, 0)
            
                if dist < 5 then
                    local npccoords = GetEntityCoords(NpcData.Npc)
                    DrawText3D(Taxi.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].x, Taxi.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].y, Taxi.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].z, '[E] NPC deliver')
                    if IsControlJustPressed(0, Keys["E"]) then
                        local veh = GetVehiclePedIsIn(ped, 0)
                        TaskLeaveVehicle(NpcData.Npc, veh, 0)
                        SetEntityAsMissionEntity(NpcData.Npc, false, true)
                        SetEntityAsNoLongerNeeded(NpcData.Npc)
                        local targetCoords = Taxi.NPCLocations.TakeLocations[NpcData.LastNpc]
                        TaskGoStraightToCoord(NpcData.Npc, targetCoords.x, targetCoords.y, targetCoords.z, 1.0, -1, 0.0, 0.0)
                        SendNUIMessage({
                            action = "toggleMeter"
                        })
                        TriggerServerEvent('xz-taxi:server:NpcPay', meterData.currentFare)
                        XZCore.Functions.Notify('Person delivered..', 'success')
                        if NpcData.DeliveryBlip ~= nil then
                            RemoveBlip(NpcData.DeliveryBlip)
                        end
                        local RemovePed = function(ped)
                            SetTimeout(60000, function()
                                DeletePed(ped)
                            end)
                        end
                        TimeoutNpc()
                        RemovePed(NpcData.Npc)
                        ResetNpcTask()
                        break
                    end
                end
            end

            Citizen.Wait(1)
        end
    end)
end

function ResetNpcTask()
    NpcData = {
        Active = false,
        CurrentNpc = nil,
        LastNpc = nil,
        CurrentDeliver = nil,
        LastDeliver = nil,
        Npc = nil,
        NpcBlip = nil,
        DeliveryBlip = nil,
        NpcTaken = false,
        NpcDelivered = false,
    }
end

RegisterNetEvent('XZCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerData = XZCore.Functions.GetPlayerData()
end)

RegisterNetEvent('XZCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

RegisterNetEvent('XZCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000)
        calculateFareAmount()
    end
end)

function calculateFareAmount()
    if meterIsOpen and meterActive then
        start = lastLocation
        if start then
            current = GetEntityCoords(PlayerPedId())
            distance = CalculateTravelDistanceBetweenPoints(start, current)
            meterData['distanceTraveled'] = distance
    
            fareAmount = (meterData['distanceTraveled'] / 400.00) * meterData['fareAmount']
    
            meterData['currentFare'] = math.ceil(fareAmount)

            SendNUIMessage({
                action = "updateMeter",
                meterData = meterData
            })
        end
    end
end

Citizen.CreateThread(function()
    while true do

        inRange = false

        if XZCore ~= nil then
            if isLoggedIn then

                if PlayerData and PlayerData.job.name == 'taxi' then
                    local ped = PlayerPedId()
                    local pos = GetEntityCoords(ped)

                    local vehDist = GetDistanceBetweenCoords(pos, Taxi.Locations["vehicle"]["x"], Taxi.Locations["vehicle"]["y"], Taxi.Locations["vehicle"]["z"])

                    if vehDist < 30 then
                        inRange = true

                        DrawMarker(2, Taxi.Locations["vehicle"]["x"], Taxi.Locations["vehicle"]["y"], Taxi.Locations["vehicle"]["z"], 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.3, 0.5, 0.2, 200, 0, 0, 222, false, false, false, true, false, false, false)

                        if vehDist < 1.5 then
                            if whitelistedVehicle() then
                                DrawText3D(Taxi.Locations["vehicle"]["x"], Taxi.Locations["vehicle"]["y"], Taxi.Locations["vehicle"]["z"] + 0.3, '[E] Vehicle Parking')
                                if IsControlJustReleased(0, Keys["E"]) then
                                    if IsPedInAnyVehicle(PlayerPedId(), false) then
                                        DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
                                    end
                                end
                            else
                                DrawText3D(Taxi.Locations["vehicle"]["x"], Taxi.Locations["vehicle"]["y"], Taxi.Locations["vehicle"]["z"] + 0.3, '[E] Vehicle Packs')
                                if IsControlJustReleased(0, Keys["E"]) then
                                    TaxiGarage()
                                    Menu.hidden = not Menu.hidden
                                end
                            end
                            Menu.renderGUI()
                        end
                    end
                end
            end
        end

        if not inRange then
            Citizen.Wait(3000)
        end

        Citizen.Wait(3)
    end
end)

RegisterNetEvent('xz-taxi:client:toggleMeter', function()
    local ped = PlayerPedId()
    
    if IsPedInAnyVehicle(ped, false) then
        if whitelistedVehicle() then
            if not meterIsOpen then
                SendNUIMessage({
                    action = "openMeter",
                    toggle = true,
                    meterData = Taxi.Meter
                })
                meterIsOpen = true
            else
                SendNUIMessage({
                    action = "openMeter",
                    toggle = false
                })
                meterIsOpen = false
            end
        else
            XZCore.Functions.Notify('This vehicle does not have a Taxi Meter..', 'error')
        end
    else
        XZCore.Functions.Notify('You\'re not in a vehicle..', 'error')
    end
end)

RegisterNetEvent('xz-taxi:client:enableMeter', function()
    local ped = PlayerPedId()

    if meterIsOpen then
        SendNUIMessage({
            action = "toggleMeter"
        })
    else
        XZCore.Functions.Notify('The Taxi Meter is not active..', 'error')
    end
end)

RegisterNUICallback('enableMeter', function(data)
    meterActive = data.enabled

    if not data.enabled then
        SendNUIMessage({
            action = "resetMeter"
        })
    end
    lastLocation = GetEntityCoords(PlayerPedId())
end)

RegisterNetEvent('xz-taxi:client:toggleMuis', function()
    Citizen.Wait(400)
    if meterIsOpen then
        if not mouseActive then
            SetNuiFocus(true, true)
            mouseActive = true
        end
    else
        XZCore.Functions.Notify('No Taxi Meter to confess..', 'error')
    end
end)

RegisterNUICallback('hideMouse', function()
    SetNuiFocus(false, false)
    mouseActive = false
end)

function whitelistedVehicle()
    local ped = PlayerPedId()
    local veh = GetEntityModel(GetVehiclePedIsIn(ped))
    local retval = false

    for i = 1, #Taxi.AllowedVehicles, 1 do
        if veh == GetHashKey(Taxi.AllowedVehicles[i].model) then
            retval = true
        end
    end
    return retval
end

function TaxiGarage()
    ped = PlayerPedId();
    MenuTitle = "Garage"
    ClearMenu()
    Menu.addButton("Vehicles", "VehicleList", nil)
    Menu.addButton("Close Menu", "closeMenuFull", nil) 
end

function VehicleList()
    ped = PlayerPedId();
    MenuTitle = "Vehicles:"
    ClearMenu()
    for k, v in pairs(Taxi.AllowedVehicles) do
        Menu.addButton(Taxi.AllowedVehicles[k].label, "TakeVehicleTaxi", k, "Garage", " Motor: 100%", " Body: 100%", " Fuel: 100%")
    end
        
    Menu.addButton("Terug", "TaxiGarage",nil)
end

function TakeVehicleTaxi(k)
    local coords = {x = Taxi.Locations["vehicle"]["x"], y = Taxi.Locations["vehicle"]["y"], z = Taxi.Locations["vehicle"]["z"]}
    XZCore.Functions.SpawnVehicle(Taxi.AllowedVehicles[k].model, function(veh)
        SetVehicleNumberPlateText(veh, "TAXI"..tostring(math.random(1000, 9999)))
        SetEntityHeading(veh, Taxi.Locations["vehicle"]["h"])
        exports['LegacyFuel']:SetFuel(veh, 100)
        closeMenuFull()
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh), veh)
        SetVehicleEngineOn(veh, true, true)
        dutyPlate = GetVehicleNumberPlateText(veh)
    end, coords, true)
end

function closeMenuFull()
    Menu.hidden = true
    currentGarage = nil
    ClearMenu()
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
    TaxiBlip = AddBlipForCoord(Taxi.Locations["vehicle"]["x"], Taxi.Locations["vehicle"]["y"], Taxi.Locations["vehicle"]["z"])

    SetBlipSprite (TaxiBlip, 198)
    SetBlipDisplay(TaxiBlip, 4)
    SetBlipScale  (TaxiBlip, 0.6)
    SetBlipAsShortRange(TaxiBlip, true)
    SetBlipColour(TaxiBlip, 5)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Downtown Cab")
    EndTextCommandSetBlipName(TaxiBlip)
end)
XZCore = nil

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(10)
        if XZCore == nil then
            TriggerEvent("XZCore:GetObject", function(obj) XZCore = obj end)    
            Citizen.Wait(200)
        end
    end
end)

--CODE
local camZPlus1 = 1500
local camZPlus2 = 50
local pointCamCoords = 75
local pointCamCoords2 = 0
local cam1Time = 500
local cam2Time = 1000
local timer = 0

local choosingSpawn = false

RegisterNUICallback("exit", function(data)
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "ui",
        status = false
    })
    choosingSpawn = false
end)

RegisterNUICallback('chooseAppa', function(data)
    local appaYeet = data.appType

    SetDisplay(false)
    DoScreenFadeOut(500)
    Citizen.Wait(5000)
    print(appaYeet)
    TriggerServerEvent("apartments:server:CreateApartment", appaYeet, "Test")
    FreezeEntityPosition(PlayerPedId(), false)
    SetEntityVisible(PlayerPedId(), true)
    TriggerServerEvent('XZCore:Server:OnPlayerLoaded')
    TriggerEvent('XZCore:Client:OnPlayerLoaded')
    SwitchIN()
end)

RegisterNUICallback('spawnplayer', function(data)
    local location = tostring(data.spawnloc)
    local type = tostring(data.typeLoc)
    local ped = PlayerPedId()
    local PlayerData = XZCore.Functions.GetPlayerData()
    local insideMeta = PlayerData.metadata["inside"]

    if type == "current" then
        TriggerEvent("debug", 'Spawn: Last Location', 'success')

        SetDisplay(false)
        Citizen.Wait(2000)
        XZCore.Functions.GetPlayerData(function(PlayerData)
            SetEntityCoords(PlayerPedId(), PlayerData.position.x, PlayerData.position.y, PlayerData.position.z)
            SetEntityHeading(PlayerPedId(), PlayerData.position.a)
            FreezeEntityPosition(PlayerPedId(), false)
        end)
        if insideMeta.house ~= nil then
            local houseId = insideMeta.house
            TriggerEvent('xz-houses:client:LastLocationHouse', houseId)
        elseif insideMeta.apartment.apartmentType ~= nil or insideMeta.apartment.apartmentId ~= nil then
            local apartmentType = insideMeta.apartment.apartmentType
            local apartmentId = insideMeta.apartment.apartmentId
            TriggerEvent('xz-scripts:client:LastLocationHouse', apartmentType, apartmentId)
        end
        FreezeEntityPosition(ped, false)
        SetEntityVisible(PlayerPedId(), true)
        TriggerServerEvent('XZCore:Server:OnPlayerLoaded')
        TriggerEvent('XZCore:Client:OnPlayerLoaded')
        SwitchIN()
    elseif type == "house" then
        TriggerEvent("debug", 'Spawn: Owned House', 'success')

        SetDisplay(false)
        Citizen.Wait(2000)
        TriggerEvent('xz-houses:client:enterOwnedHouse', location)
        TriggerServerEvent('xz-houses:server:SetInsideMeta', 0, false)
        TriggerServerEvent('xz-scripts:server:SetInsideMeta', 0, 0, false)
        FreezeEntityPosition(ped, false)
        TriggerServerEvent('XZCore:Server:OnPlayerLoaded')
        TriggerEvent('XZCore:Client:OnPlayerLoaded')
        SetEntityVisible(PlayerPedId(), true)
        SwitchIN()
    elseif type == "normal" then
        TriggerEvent("debug", 'Spawn: ' .. Config.Spawns[location].label, 'success')

        local pos = Config.Spawns[location].coords
        SetDisplay(false)
        Citizen.Wait(2000)
        SetEntityCoords(ped, pos.x, pos.y, pos.z)
        TriggerServerEvent('xz-houses:server:SetInsideMeta', 0, false)
        TriggerServerEvent('xz-scripts:server:SetInsideMeta', 0, 0, false)
        Citizen.Wait(500)
        SetEntityCoords(ped, pos.x, pos.y, pos.z)
        SetEntityHeading(ped, pos.h)
        FreezeEntityPosition(ped, false)
        SetEntityVisible(PlayerPedId(), true)
        TriggerServerEvent('XZCore:Server:OnPlayerLoaded')
        TriggerEvent('XZCore:Client:OnPlayerLoaded')
        SwitchIN()
    end
end)

function SetDisplay(bool)
    choosingSpawn = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool
    })
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if choosingSpawn then
            DisableAllControlActions(0)
        else
            Citizen.Wait(1000)
        end
    end
end)

RegisterNetEvent('xz-houses:client:setHouseConfig')
AddEventHandler('xz-houses:client:setHouseConfig', function(houseConfig)
    Config.Houses = houseConfig
end)

RegisterNetEvent('xz-spawn:client:setupSpawns')
AddEventHandler('xz-spawn:client:setupSpawns', function(cData, new, apps)
    if not new then
        XZCore.Functions.TriggerCallback('xz-spawn:server:isJailed', function(lmfao, tt)
            if lmfao == false then  
                XZCore.Functions.TriggerCallback('xz-spawn:server:getOwnedHouses', function(houses)
                    local myHouses = {}
                    if houses ~= nil then
                        for i = 1, (#houses), 1 do
                            table.insert(myHouses, {
                                house = houses[i].house,
                                label = Config.Houses[houses[i].house].adress,
                            })
                        end
                    end

                    Citizen.Wait(50)
                    SendNUIMessage({
                        action = "setupLocations",
                        locations = Config.Spawns,
                        houses = myHouses,
                    })
                end, cData.citizenid)
            else
                SetDisplay(false)
                Citizen.Wait(2000)
                SetEntityCoords(PlayerPedId(), 1769.14, 257709, 45.72)
                TriggerServerEvent('xz-houses:server:SetInsideMeta', 0, false)
                TriggerServerEvent('xz-scripts:server:SetInsideMeta', 0, 0, false)
                Citizen.Wait(500)
                SetEntityCoords(PlayerPedId(), 1769.14, 257709, 45.72)
                SetEntityHeading(PlayerPedId(), 269.01)
                FreezeEntityPosition(PlayerPedId(), false)
                SetEntityVisible(PlayerPedId(), true)
                TriggerServerEvent('XZCore:Server:OnPlayerLoaded')
                TriggerEvent('XZCore:Client:OnPlayerLoaded')
                SwitchIN()
                TriggerEvent('beginJail', tt)
            end
        end, cData.citizenid)
    elseif new then
        SendNUIMessage({
            action = "setupAppartements",
            locations = apps,
        })
    end

    TriggerEvent("debug", 'Spawn: Setup', 'success')
end)


-- Gta V Switch
local cloudOpacity = 0.01
local muteSound = true

function SwitchIN()
    local timer = GetGameTimer()
    while true do
        ClearScreen()
        Citizen.Wait(0)
        if GetGameTimer() - timer > 5000 then
            SwitchInPlayer(PlayerPedId())
            ClearScreen()
            while GetPlayerSwitchState() ~= 12 do
                Citizen.Wait(0)
                ClearScreen()
            end
            
            break
        end
    end

    TriggerServerEvent('mumble:infinity:server:unmutePlayer')
    TriggerEvent('xz-weathersync:client:EnableSync')
	SetEntityHealth(PlayerPedId(), 200.0)
end

function ToggleSound(state)
    if state then
        StartAudioScene("MP_LEADERBOARD_SCENE");
    else
        StopAudioScene("MP_LEADERBOARD_SCENE");
    end
end

function ClearScreen()
    SetCloudHatOpacity(cloudOpacity)
    HideHudAndRadarThisFrame()
    SetDrawOrigin(0.0, 0.0, 0.0, 0)
end

RegisterNetEvent('xz-spawn:client:openUI')
AddEventHandler('xz-spawn:client:openUI', function(value)
    SetEntityVisible(PlayerPedId(), false)
    ToggleSound(muteSound)
    if not IsPlayerSwitchInProgress() then
        CreateThread(function()
            Wait(1000)
            DoScreenFadeIn(750)
        end)
        SwitchOutPlayer(PlayerPedId(), 1, 1)
    end
    while GetPlayerSwitchState() ~= 5 do
        Citizen.Wait(0)
        ClearScreen()
    end

    ClearScreen()
    Citizen.Wait(0)
    
    ToggleSound(false)
    SetDisplay(value)

    TriggerEvent("debug", 'Spawn: Open UI', 'success')
end)
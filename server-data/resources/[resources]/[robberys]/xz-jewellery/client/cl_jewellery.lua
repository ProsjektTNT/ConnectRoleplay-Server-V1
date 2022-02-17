local XZCore = nil
local robberyAlert = false
local isLoggedIn = false
local firstAlarm = false
local isInTimeout = false
local usedCameras = {}

Citizen.CreateThread(function()
    while XZCore == nil do
        Citizen.Wait(10)
        TriggerEvent('XZCore:GetObject', function(obj) XZCore = obj end)
    end

    while not XZCore.Functions.GetPlayerData().job do
        Wait(10)
    end

    XZCore.Functions.TriggerCallback('xz-jewellery:gettimeoutstatus', function(rs)
        isInTimeout = rs
    end)
    isLoggedIn = true
end)

function DrawText3Ds(x, y, z, text)
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

RegisterNetEvent('XZCore:Client:OnPlayerUnload')
AddEventHandler('XZCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        inRange = false

        if XZCore ~= nil then
            if isLoggedIn then
                for case,_ in pairs(Jewellery.Locations) do
                    -- if PlayerData.job.name ~= "police" then
                        local dist = GetDistanceBetweenCoords(pos, Jewellery.Locations[case]["coords"]["x"], Jewellery.Locations[case]["coords"]["y"], Jewellery.Locations[case]["coords"]["z"])
                        local storeDist = GetDistanceBetweenCoords(pos, Jewellery.JewelleryLocation["coords"]["x"], Jewellery.JewelleryLocation["coords"]["y"], Jewellery.JewelleryLocation["coords"]["z"])
                        if dist < 30 then
                            inRange = true

                            if dist < 0.6 then
                                if not Jewellery.Locations[case]["isBusy"] and not Jewellery.Locations[case]["isOpened"] then
                                    DrawText3Ds(Jewellery.Locations[case]["coords"]["x"], Jewellery.Locations[case]["coords"]["y"], Jewellery.Locations[case]["coords"]["z"], '[E] - Break')
                                    if IsControlJustPressed(0, Keys["E"]) then
                                        if isInTimeout == false then
                                        TriggerServerEvent('xz-jewellery:server:startglobaltimeout')
                                        XZCore.Functions.TriggerCallback('xz-jewellery:server:getCops', function(cops)
                                            if cops >= Jewellery.RequiredCops then
                                                if validWeapon() then
                                                    smashVitrine(case)
                                                else
                                                    XZCore.Functions.Notify('Your weapon doesn\'t seem strong enough ..', 'error')
                                                end
                                            else
                                                XZCore.Functions.Notify('Not enough police', 'error')
                                            end                
                                        end)
                                    end
                                    end
                                end
                            end

                            if storeDist < 2 then
                                if not firstAlarm then
                                    if validWeapon() then
                                        TriggerEvent('dispatch:jewelryRobbery')
                                        local cameraID = math.random(31,34)
                                        if not usedCameras[cameraID] then
                                            usedCameras[cameraID] = true
                                            TriggerServerEvent("police:camera", cameraID)
                                        end
                                        firstAlarm = true
                                    end
                                end
                            end
                        end
                    -- end
                end
            end
        end

        if not inRange then
            Citizen.Wait(2000)
        end

        Citizen.Wait(3)
    end
end)

RegisterNetEvent('lkjasdlksa:syncclientnoder')
AddEventHandler('lkjasdlksa:syncclientnoder', function(is)
    isInTimeout = is
end)

function loadParticle()
	if not HasNamedPtfxAssetLoaded("scr_jewelheist") then
    RequestNamedPtfxAsset("scr_jewelheist")
    end
    while not HasNamedPtfxAssetLoaded("scr_jewelheist") do
    Citizen.Wait(0)
    end
    SetPtfxAssetNextCall("scr_jewelheist")
end

function loadAnimDict(dict)  
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(3)
    end
end

function validWeapon()
    local ped = PlayerPedId()
    local pedWeapon = GetSelectedPedWeapon(ped)

    for k, v in pairs(Jewellery.WhitelistedWeapons) do
        if pedWeapon == k then
            return true
        end
    end
    return false
end

local smashing = false

function smashVitrine(k)
    local animDict = "missheist_jewel"
    local animName = "smash_case"
    local ped = PlayerPedId()
    local plyCoords = GetOffsetFromEntityInWorldCoords(ped, 0, 0.6, 0)
    local pedWeapon = GetSelectedPedWeapon(ped)

    if math.random(1, 100) <= 80 and not IsWearingHandshoes() then
        TriggerServerEvent("evidence:server:CreateFingerDrop", plyCoords)
    elseif math.random(1, 100) <= 5 and IsWearingHandshoes() then
        TriggerServerEvent("evidence:server:CreateFingerDrop", plyCoords)
        XZCore.Functions.Notify("You broke the glass.", "error")
    end

    smashing = true

    XZCore.Functions.Progressbar("smash_vitrine", "Robbing", Jewellery.WhitelistedWeapons[pedWeapon]["timeOut"], false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerServerEvent('xz-jewellery:server:setVitrineState', "isOpened", true, k)
        TriggerServerEvent('xz-jewellery:server:setVitrineState', "isBusy", false, k)
        TriggerServerEvent('xz-jewellery:server:vitrineReward')
        TriggerServerEvent('xz-jewellery:server:setTimeout')
        TriggerEvent('dispatch:jewelryRobbery')
        local cameraID = math.random(31,34)
        if not usedCameras[cameraID] then
            usedCameras[cameraID] = true
            TriggerServerEvent("police:camera", cameraID)
        end
        smashing = false
        TaskPlayAnim(ped, animDict, "exit", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
    end, function() -- Cancel
        TriggerServerEvent('xz-jewellery:server:setVitrineState', "isBusy", false, k)
        TaskPlayAnim(ped, animDict, "exit", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
    end)
    TriggerServerEvent('xz-jewellery:server:setVitrineState', "isBusy", true, k)

    Citizen.CreateThread(function()
        while smashing do
            loadAnimDict(animDict)
            TaskPlayAnim(ped, animDict, animName, 3.0, 3.0, -1, 2, 0, 0, 0, 0 )
            Citizen.Wait(500)
            TriggerServerEvent("InteractSound_SV:PlayOnSource", "breaking_vitrine_glass", 0.25)
            loadParticle()
            StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", plyCoords.x, plyCoords.y, plyCoords.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
            Citizen.Wait(2500)
        end
    end)

    isInTimeout = false
end

RegisterNetEvent('xz-jewellery:client:setVitrineState')
AddEventHandler('xz-jewellery:client:setVitrineState', function(stateType, state, k)
    Jewellery.Locations[k][stateType] = state
end)

RegisterNetEvent('xz-jewellery:client:resetCameras')
AddEventHandler('xz-jewellery:client:resetCameras', function()
    usedCameras = {}
end)

RegisterNetEvent('xz-jewellery:client:setAlertState')
AddEventHandler('xz-jewellery:client:setAlertState', function(bool)
    robberyAlert = bool
end)

function IsWearingHandshoes()
    local armIndex = GetPedDrawableVariation(PlayerPedId(), 3)
    local model = GetEntityModel(PlayerPedId())
    local retval = true
    if model == GetHashKey("mp_m_freemode_01") then
        if Jewellery.MaleNoHandshoes[armIndex] ~= nil and Jewellery.MaleNoHandshoes[armIndex] then
            retval = false
        end
    else
        if Jewellery.FemaleNoHandshoes[armIndex] ~= nil and Jewellery.FemaleNoHandshoes[armIndex] then
            retval = false
        end
    end
    return retval
end

Citizen.CreateThread(function()
    Dealer = AddBlipForCoord(Jewellery.JewelleryLocation["coords"]["x"], Jewellery.JewelleryLocation["coords"]["y"], Jewellery.JewelleryLocation["coords"]["z"])

    SetBlipSprite (Dealer, 617)
    SetBlipDisplay(Dealer, 4)
    SetBlipScale  (Dealer, 0.6)
    SetBlipAsShortRange(Dealer, true)
    SetBlipColour(Dealer, 3)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Vangelico")
    EndTextCommandSetBlipName(Dealer)
end)
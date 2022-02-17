

local playerPed, playerCoords, playerInZone, playerInMission

CreateThread(function()
    
    local huntingShopBlip = AddBlipForCoord(Config.Locations["startJob"].x, Config.Locations["startJob"].y, Config.Locations["startJob"].z)
    SetBlipSprite(huntingShopBlip, 119)
    SetBlipColour(huntingShopBlip, 1)
    SetBlipScale(huntingShopBlip, 0.7)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Hunting Shop")
    EndTextCommandSetBlipName(huntingShopBlip)
    SetBlipAsShortRange(huntingShopBlip, true)

    local huntingZoneBlip = AddBlipForCoord(-1189.043, 4661.6391, 249.82835)
    SetBlipSprite(huntingZoneBlip, 141)
    SetBlipScale(huntingZoneBlip, 0.7)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Hunting Zone")
    EndTextCommandSetBlipName(huntingZoneBlip)
    SetBlipAsShortRange(huntingZoneBlip, true)

    local blipId2 = AddBlipForRadius(-1189.043, 4661.6391, 249.82835, 450.00)
    SetBlipHighDetail(blipId2, true)
    SetBlipColour(blipId2, 45)
    SetBlipAlpha(blipId2, 125)
    SetBlipAsShortRange(blipId2, true)


    while true do
        local ped = PlayerPedId()
        local _, weaponHash = GetCurrentPedWeapon(ped, 1)

        if(weaponHash == GetHashKey("weapon_musket")) and not playerInMission then
            DisablePlayerFiring(ped, true)
            Wait(0)
        else
            Wait(250)
        end
    end

end)

RegisterNetEvent("xz-hunting:client:interactionEvent")
AddEventHandler("xz-hunting:client:interactionEvent", function()
    print("meow")
    TriggerServerEvent("inventory:server:OpenInventory", "shop", "hunting_shop", Config.Shop)
end)


RegisterNetEvent("xz-hunting:client:useKnife")
AddEventHandler("xz-hunting:client:useKnife", function(knifeLevel, animalsStriped, item) 

    local ped = PlayerPedId()
    local closestPed, distance = XZCore.Functions.GetClosestPed(nil, {ped})
    local closestPedHash = GetEntityModel(closestPed)

    print(Config.Animals[closestPedHash])
    print(distance)
    print(playerInMission)
    print(GetEntityHealth(closestPed))

    if(Config.Animals[closestPedHash] == nil or distance > 1.5 or playerInMission == nil or GetEntityHealth(closestPed) ~= 0) then
        XZCore.Functions.Notify("You aren't close to any dead animal", "error")
        return
    end

    XZCore.Functions.LoadAnimDict("amb@medic@standing@kneel@base")
    XZCore.Functions.LoadAnimDict("anim@gangops@facility@servers@bodysearch@")

    TaskPlayAnim(ped, "amb@medic@standing@kneel@base", "base", 8.0, -8.0, -1, 1, 0)
    TaskPlayAnim(ped, "anim@gangops@facility@servers@bodysearch@", "player_search", 8.0, -8.0, -1, 48, 0)


    XZCore.Functions.Progressbar("strip_animal", "Stripping Animal..", 8000, false, true, true, {}, {}, {}, function()
       -- On Finish
    
       ClearPedTasks(ped)
       DeleteEntity(closestPed)

       TriggerServerEvent("xz-hunting:server:collectMeat", closestPedHash, item)
    end, function()
       -- On Cancel
       ClearPedTasks(ped)
    end)

end)

RegisterNetEvent("polyzone:enter")
AddEventHandler("polyzone:enter", function(name)
	if name ~= "forest" then
        return
    end

    PlaySoundFrontend(-1, "ScreenFlash", "MissionFailedSounds")
    XZCore.Functions.Notify("You entered the hunting zone, Good luck!", "success", 5000)
    playerInMission = true
    TriggerServerEvent("xz-hunting:server:setInZone")

end)

RegisterNetEvent("polyzone:leave")
AddEventHandler("polyzone:leave", function(name)
	if name ~= "forest" then
        return
    end

    PlaySoundFrontend(-1, "ScreenFlash", "MissionFailedSounds")
    XZCore.Functions.Notify("You exited the hunting zone", "error", 5000)
    playerInMission = false
    TriggerServerEvent("xz-hunting:server:setNotInZone")

end)


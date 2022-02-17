Teleports = Teleports or {}
Teleports.Locations = {
    [1] = {
        [1] = {x = 3540.74, y = 3675.59, z = 20.99, h = 167.5, r = 1.0},
        [2] = {x = 3540.74, y = 3675.59, z = 28.11, h = 172.5, r = 1.0},
	},
    [2] = {
        [1] = {x = 123.79, y = -1297.82, z = 29.26, h = 92.94, r = 1.0},
        [2] = {x = 125.57, y = -1296.88, z = 29.26, h = 115.70, r = 1.0},
    },
    [3] = {
        [1] = {x = -588.8067, y = -928.5881, z = 23.869625, h = 358.78475, r = 1.0},
        [2] = {x = -588.8067, y = -928.5864, z = 28.151098, h = 356.28475, r = 1.0},
    }
}

JustTeleported = false

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

Citizen.CreateThread(function()
    local currentTeleport = false
    while true do
        local inRange = false
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)

        for loc,_ in pairs(Teleports.Locations) do
            for k, v in pairs(Teleports.Locations[loc]) do
                local dist = Vdist2(pos, v.x, v.y, v.z)

                if dist < 2 then
                    inRange = true
                    DrawMarker(2, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.15, 255, 255, 255, 255, 0, 0, 0, 1, 0, 0, 0)
                    if dist < 1 then
                        DrawText3Ds(v.x, v.y, v.z, '[E] - Use the Elevator')
                        if IsControlJustReleased(0, 51) then
                            DoScreenFadeOut(500)
                            while not IsScreenFadedOut() do
                                Citizen.Wait(10)
                            end
                                
                            if k == 1 then
                                SetEntityCoords(ped, Teleports.Locations[loc][2].x, Teleports.Locations[loc][2].y, Teleports.Locations[loc][2].z)
                            elseif k == 2 then
                                SetEntityCoords(ped, Teleports.Locations[loc][1].x, Teleports.Locations[loc][1].y, Teleports.Locations[loc][1].z)
                            end
                            Citizen.Wait(200)
                            DoScreenFadeIn(1000)
                            ResetTeleport()
                        end
                    end
                end
            end
        end

        if not inRange then
            Citizen.Wait(1000)
        end

        Citizen.Wait(3)
    end
end)

ResetTeleport = function()
    SetTimeout(1000, function()
        JustTeleported = false
    end)
end
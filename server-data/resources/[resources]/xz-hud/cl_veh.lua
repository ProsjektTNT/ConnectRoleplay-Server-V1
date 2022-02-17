-- Speedmeeter

CreateThread(function()
    while true do
        local ped = PlayerPedId();
        local vehicle = GetVehiclePedIsIn(ped);
        local speed = math.floor(GetEntitySpeed(vehicle) * 2.236936);
        local vehhash = GetEntityModel(vehicle);
        local maxspeed = GetVehicleModelMaxSpeed(vehhash) * 3.6;

        if IsPedInAnyVehicle(ped) then
            SendNUIMessage({
                VehicleUI = true
            })

            SendNUIMessage({action = "vehicleGoBrrrrrrrr", speed = speed, maxspeed = maxspeed});
            SetRadarBigmapEnabled(false, false);
            HideMinimapInteriorMapThisFrame();
            DisplayRadar(true);
        else
            SendNUIMessage({
                VehicleUI = false
            })

            DisplayRadar(false);
        end
        Wait(350);
    end
end)

-- Seatbelt

local seatbeltOn = false;
CreateThread(function()
    while true do
        Wait(0);
        if IsPedInAnyVehicle(PlayerPedId()) then
            if IsControlJustPressed(0, 29) then
                seatbeltOn = not seatbeltOn;
                TriggerEvent("xz-hud:client:toggleSeatBelt", seatbeltOn);
            end

            if seatbeltOn then 
                DisableControlAction(0, 75) -- leaning up/down
            end
        elseif seatbeltOn then
            seatbeltOn = false
            TriggerEvent("xz-hud:client:toggleSeatBelt", seatbeltOn);
        end
    end
end)

RegisterNetEvent("xz-hud:client:toggleSeatBelt", function(toggle)
    if toggle then
        SendNUIMessage({
            action = "seatbeltOn",
        })
        XZCore.Functions.Notify("Seat Belt Enabled");
        TriggerEvent('InteractSound_CL:PlayOnOne','carbuckle',0.3)
        seatbelt = true;
    else
        SendNUIMessage({
            action = "seatbeltOff",
        })
        XZCore.Functions.Notify("Seat Belt Disabled", "error");
        TriggerEvent('InteractSound_CL:PlayOnOne','carunbuckle',0.3)
        seatbelt = false;
    end
end)


-- Circle MiniMap

local screenX, screenY = GetScreenResolution()
local modifier = screenY / screenX

local baseXOffset = 0.0046875
local baseYOffset = 0.74

local baseSize    = 0.20 -- 20% of screen

local baseXWidth  = 0.1313 -- baseSize * modifier -- %
local baseYHeight = baseSize -- %

local baseXNumber = screenX * baseSize  -- 256
local baseYNumber = screenY * baseSize  -- 144

local radiusX     = baseXNumber / 2     -- 128
local radiusY     = baseYNumber / 2     -- 72

local innerSquareSideSizeX = math.sqrt(radiusX * radiusX * 2) -- 181.0193
local innerSquareSideSizeY = math.sqrt(radiusY * radiusY * 2) -- 101.8233

local innerSizeX = ((innerSquareSideSizeX / screenX) - 0.01) * modifier
local innerSizeY = innerSquareSideSizeY / screenY

local innerOffsetX = (baseXWidth - innerSizeX) / 2
local innerOffsetY = (baseYHeight - innerSizeY) / 2

local innerMaskOffsetPercentX = (innerSquareSideSizeX / baseXNumber) * modifier

local function setPos(type, posX, posY, sizeX, sizeY)
    SetMinimapComponentPosition(type, "I", "I", posX, posY, sizeX, sizeY)
end

CreateThread(function()
    SetBlipAlpha(GetNorthRadarBlip(), 0)
    RequestStreamedTextureDict("circlemap", false)
    while not HasStreamedTextureDictLoaded("circlemap") do
        Citizen.Wait(0)
    end

    AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap", "radarmasklg")
    AddReplaceTexture("platform:/textures/graphics", "radarmasklg", "circlemap", "radarmasklg")

    setPos("minimap",       baseXOffset - (0.025 * modifier), baseYOffset - 0.025, baseXWidth + (0.05 * modifier), baseYHeight + 0.05)
    setPos("minimap_blur",  baseXOffset, baseYOffset, baseXWidth + 0.001, baseYHeight)
    -- setPos("minimap_mask",  baseXOffset + innerOffsetX, baseYOffset + innerOffsetY, innerSizeX, innerSizeY)
    -- The next one is FUCKING WEIRD.
    -- posX is based off top left 0.0 coords of minimap - 0.00 -> 1.00
    -- posY seems to be based off of the top of the minimap, with 0.75 representing 0% and 1.75 representing 100%
    -- sizeX is based off the size of the minimap - 0.00 -> 0.10
    -- sizeY seems to be height based on minimap size, ranging from -0.25 to 0.25
    setPos("minimap_mask", 0.1, 0.95, 0.09, 0.15)
    -- setPos("minimap_mask", 0.0, 0.75, 1.0, 1.0)
    -- setPos("minimap_mask",  baseXOffset, baseYOffset, baseXWidth, baseYHeight)

    SetMinimapClipType(1)
    DisplayRadar(0)
    SetRadarBigmapEnabled(true, false)
    Citizen.Wait(0)
    SetRadarBigmapEnabled(false, false)
    DisplayRadar(1)
    while true do
        Wait(0)
        HideMinimapInteriorMapThisFrame()
        SetRadarZoom(1200) -- 1200
    end
end)

local pauseActive = false
CreateThread(function()
    while true do
        Wait(50)
            local player = PlayerPedId()
            SetRadarBigmapEnabled(false, false)
            local isPMA = IsPauseMenuActive()
            if isPMA and not pauseActive or IsRadarHidden() then 
                pauseActive = true 
                SendNUIMessage({
                    action = "hideCircleUI"
                })
                uiHidden = true
            elseif not isPMA and pauseActive then
                pauseActive = false
                SendNUIMessage({
                    action = "displayCircleUI"
                })
                uiHidden = false
            end
        Wait(0)
        end
    end)

-- Fuel
CreateThread(function()
    while true do
        Wait(500);
        local ped = PlayerPedId();
        if IsPedInAnyVehicle(ped, true) then
			fuel = exports['LegacyFuel']:GetFuel(GetVehiclePedIsIn(PlayerPedId()))
			SendNUIMessage({
                action = "update_fuel",
                key = "gas",
                value = fuel
            })
        end
    end
end)

-- Compass

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(50)

		local Ped = PlayerPedId();
		local vehicle = GetVehiclePedIsIn(Ped, false)
		local vehicleIsOn = GetIsVehicleEngineRunning(vehicle)

		if IsPedInAnyVehicle(Ped, false) and vehicleIsOn then
			SendNUIMessage({
				showcompass = true,
				direction = math.floor(calcHeading(-GetEntityHeading(PlayerPedId()) % 360)),
			})
		end
	end
end)

local imageWidth = 125 -- leave this variable, related to pixel size of the directions
local containerWidth = 125 -- width of the image container

-- local width =  (imageWidth / containerWidth) * 100; -- used to convert image width if changed
local width =  0;
local south = (-imageWidth) + width
local west = (-imageWidth * 2) + width
local north = (-imageWidth * 3) + width
local east = (-imageWidth * 4) + width
local south2 = (-imageWidth * 5) + width

function calcHeading(direction)
    if (direction < 90) then
        return lerp(north, east, direction / 90)
    elseif (direction < 180) then
        return lerp(east, south2, rangePercent(90, 180, direction))
    elseif (direction < 270) then
        return lerp(south, west, rangePercent(180, 270, direction))
    elseif (direction <= 360) then
        return lerp(west, north, rangePercent(270, 360, direction))
    end
end


function rangePercent(min, max, amt)
    return (((amt - min) * 100) / (max - min)) / 100
end

function lerp(min, max, amt)
    return (1 - amt) * min + amt * max
end
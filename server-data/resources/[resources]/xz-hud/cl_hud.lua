local isLoggedIn = false
local hunger = 100
local thirst = 100
local nitrous = 0

local hudSettings = GetResourceKvpString("xz-hud")
if(hudSettings ~= nil) then
    hudSettings = json.decode(hudSettings)
else
    hudSettings = {
        settings = {
            hunger = 100,
            thirst = 100,
            armor = 100,
            health = 100
        },

        show = {
            hunger = true,
            thirst =  true,
            armor = true,
            health = true,
            oxygen = true,
            stamina = true,
        }
    }

    SetResourceKvp("xz-hud", json.encode(hudSettings))
end

-- Disable GTA HUD
CreateThread(function()
    local minimap = RequestScaleformMovie("minimap")
    SetRadarBigmapEnabled(true, false)
    Wait(200)
    SetRadarBigmapEnabled(false, false)

    while true do
        Wait(0)
        BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()
    end
end)



CreateThread(function()
    initSettings()
    Wait(200)

    while true do
        local ped = PlayerPedId()
        local data = {
            InPauseMenu = IsPauseMenuActive(),
            health = GetEntityHealth(ped) - 100,
            armor = GetPedArmour(ped),
            hunger = hunger,
            thirst = thirst,
            oxygen = GetPlayerUnderwaterTimeRemaining(PlayerId()) * 10,
            run = GetPlayerSprintTimeRemaining(PlayerId()) * 10,
            inVehicle = IsPedInAnyVehicle(ped),
            nitrous = nitrous,
            
        }
    
        SendNUIMessage({
            action = "update",
            data = data
        })
        Wait(500)
    end
end)

function initSettings()
    SendNUIMessage({
        action = "updatePreferences",
        data = hudSettings
    })
end

local display = false
RegisterCommand("hud", function()
    display = not display
    SendNUIMessage({display = display})
    SetNuiFocus(display, display)
end)

local resourceName = GetCurrentResourceName();
RegisterNetEvent("xz:interact:init:" .. resourceName, function(Nevo)
    Nevo.Mapping:Listen("hud", "(Player) HUD Settings", "keyboard", "", function(state)
        display = true
        SendNUIMessage({display = display})
        SetNuiFocus(display, display)
    end)
end)

RegisterNUICallback("close", function(data)
    display = false
    SendNUIMessage({display = display})
    SetNuiFocus(display, display)
    hudSettings = data
    SetResourceKvp("xz-hud", json.encode(data))
end)

AddEventHandler('XZCore:Client:OnPlayerDeath', function()
    SendNUIMessage({
        action = "death"
    })
end)

RegisterNetEvent("hud:client:radio", function(bool)
    SendNUIMessage({
        action = "radio",
        radioState = bool
    })
end)

RegisterNetEvent("hud:client:playertalking", function(voiceTalkState, radioTalkState)
    SendNUIMessage({
        action = "talking",
        voiceState = voiceTalkState,
		radioState = radioTalkState
    })
end)

RegisterNetEvent("hud:client:settalkingstate", function(voiceModeState)
    SendNUIMessage({
        action = "talkingstate",
        talkingState = voiceModeState
    })
end)

RegisterNetEvent('xz-hud:debugState', function(debugToggle)
    SendNUIMessage({
        action = "fuckingDebug",
        modeDebug = debugToggle
    })
end)

RegisterNetEvent("hud:client:UpdateNeeds", function(newHunger, newThirst)
    hunger = newHunger
    thirst = newThirst
end)

RegisterNetEvent('xz-hud:nitro', function(newLevel)
    nitrous = newLevel
end)

CreateThread(function()
    TriggerEvent("xz:interact:init", resourceName, "Mapping");
end);

RegisterNetEvent("xz:interact:ready", function()
    TriggerEvent("xz:interact:init", resourceName, "Mapping");
end);
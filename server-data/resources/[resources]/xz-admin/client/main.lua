XZAdmin = {}
XZAdmin.Functions = {}
in_noclip_mode = false

isNoclip = false
isFreeze = false
isSpectating = false
showNames = false
showBlips = false
isInvisible = false
deleteLazer = false
hasGodmode = false

PermissionLevels = {
    [1] = {rank = "user", label = "User"},
    [2] = {rank = "admin", label = "Admin"},
    [3] = {rank = "god", label = "God"},
}

lastSpectateCoord = nil
isManagement = false
isDev = false
myPermissionRank = "user"

local PlayerBlips = {}
local playersInfo, playersUpdate = {}, false
local InSpectatorMode = false
local TargetSpectate = nil
local LastPosition = nil
local polarAngleDeg = 0;
local azimuthAngleDeg = 90;
local radius = -1.5;
local cam = nil
local rzzz = false
local hblips = false
local InfiniteAmmo = false
local SuperDamage = false
local RainbowVehicle = false
local antiRagdoll = false
local fastMode = false
local BoostSpeeds = {2, 5, 10, 20, 35, 50, 100, 150, 200, 250, 300, 350, 400, 450, 500, 550, 600, 650, 700, 750, 800, 850, 900, 950, 1000}

AvailableWeatherTypes = {
    {label = "Extra Sunny",         weather = 'EXTRASUNNY',}, 
    {label = "Clear",               weather = 'CLEAR',}, 
    {label = "Neutral",             weather = 'NEUTRAL',}, 
    {label = "Smog",                weather = 'SMOG',}, 
    {label = "Foggy",               weather = 'FOGGY',}, 
    {label = "Overcast",            weather = 'OVERCAST',}, 
    {label = "Clouds",              weather = 'CLOUDS',}, 
    {label = "Clearing",            weather = 'CLEARING',}, 
    {label = "Rain",                weather = 'RAIN',}, 
    {label = "Thunder",             weather = 'THUNDER',}, 
    {label = "Snow",                weather = 'SNOW',}, 
    {label = "Blizzard",            weather = 'BLIZZARD',}, 
    {label = "Snowlight",           weather = 'SNOWLIGHT',}, 
    {label = "XMAS (Heavy Snow)",   weather = 'XMAS',}, 
    {label = "Halloween (Spooky)",  weather = 'HALLOWEEN',},
}

BanTimes = {
    [1] = 3600,
    [2] = 21600,
    [3] = 43200,
    [4] = 86400,
    [5] = 259200,
    [6] = 604800,
    [7] = 2678400,
    [8] = 8035200,
    [9] = 16070400,
    [10] = 32140800,
    [11] = 99999999999,
}

ServerTimes = {
    [1] = {hour = 0, minute = 0},
    [2] = {hour = 1, minute = 0},
    [3] = {hour = 2, minute = 0},
    [4] = {hour = 3, minute = 0},
    [5] = {hour = 4, minute = 0},
    [6] = {hour = 5, minute = 0},
    [7] = {hour = 6, minute = 0},
    [8] = {hour = 7, minute = 0},
    [9] = {hour = 8, minute = 0},
    [10] = {hour = 9, minute = 0},
    [11] = {hour = 10, minute = 0},
    [12] = {hour = 11, minute = 0},
    [13] = {hour = 12, minute = 0},
    [14] = {hour = 13, minute = 0},
    [15] = {hour = 14, minute = 0},
    [16] = {hour = 15, minute = 0},
    [17] = {hour = 16, minute = 0},
    [18] = {hour = 17, minute = 0},
    [19] = {hour = 18, minute = 0},
    [20] = {hour = 19, minute = 0},
    [21] = {hour = 20, minute = 0},
    [22] = {hour = 21, minute = 0},
    [23] = {hour = 22, minute = 0},
    [24] = {hour = 23, minute = 0},
}

local VehicleColors = {
    [1] = "Metallic Graphite Black",
    [2] = "Metallic Black Steel",
    [3] = "Metallic Dark Silver",
    [4] = "Metallic Silver",
    [5] = "Metallic Blue Silver",
    [6] = "Metallic Steel Gray",
    [7] = "Metallic Shadow Silver",
    [8] = "Metallic Stone Silver",
    [9] = "Metallic Midnight Silver",
    [10] = "Metallic Gun Metal",
    [11] = "Metallic Anthracite Grey",
    [12] = "Matte Black",
    [13] = "Matte Gray",
    [14] = "Matte Light Grey",
    [15] = "Util Black",
    [16] = "Util Black Poly",
    [17] = "Util Dark silver",
    [18] = "Util Silver",
    [19] = "Util Gun Metal",
    [20] = "Util Shadow Silver",
    [21] = "Worn Black",
    [22] = "Worn Graphite",
    [23] = "Worn Silver Grey",
    [24] = "Worn Silver",
    [25] = "Worn Blue Silver",
    [26] = "Worn Shadow Silver",
    [27] = "Metallic Red",
    [28] = "Metallic Torino Red",
    [29] = "Metallic Formula Red",
    [30] = "Metallic Blaze Red",
    [31] = "Metallic Graceful Red",
    [32] = "Metallic Garnet Red",
    [33] = "Metallic Desert Red",
    [34] = "Metallic Cabernet Red",
    [35] = "Metallic Candy Red",
    [36] = "Metallic Sunrise Orange",
    [37] = "Metallic Classic Gold",
    [38] = "Metallic Orange",
    [39] = "Matte Red",
    [40] = "Matte Dark Red",
    [41] = "Matte Orange",
    [42] = "Matte Yellow",
    [43] = "Util Red",
    [44] = "Util Bright Red",
    [45] = "Util Garnet Red",
    [46] = "Worn Red",
    [47] = "Worn Golden Red",
    [48] = "Worn Dark Red",
    [49] = "Metallic Dark Green",
    [50] = "Metallic Racing Green",
    [51] = "Metallic Sea Green",
    [52] = "Metallic Olive Green",
    [53] = "Metallic Green",
    [54] = "Metallic Gasoline Blue Green",
    [55] = "Matte Lime Green",
    [56] = "Util Dark Green",
    [57] = "Util Green",
    [58] = "Worn Dark Green",
    [59] = "Worn Green",
    [60] = "Worn Sea Wash",
    [61] = "Metallic Midnight Blue",
    [62] = "Metallic Dark Blue",
    [63] = "Metallic Saxony Blue",
    [64] = "Metallic Blue",
    [65] = "Metallic Mariner Blue",
    [66] = "Metallic Harbor Blue",
    [67] = "Metallic Diamond Blue",
    [68] = "Metallic Surf Blue",
    [69] = "Metallic Nautical Blue",
    [70] = "Metallic Bright Blue",
    [71] = "Metallic Purple Blue",
    [72] = "Metallic Spinnaker Blue",
    [73] = "Metallic Ultra Blue",
    [74] = "Metallic Bright Blue",
    [75] = "Util Dark Blue",
    [76] = "Util Midnight Blue",
    [77] = "Util Blue",
    [78] = "Util Sea Foam Blue",
    [79] = "Uil Lightning blue",
    [80] = "Util Maui Blue Poly",
    [81] = "Util Bright Blue",
    [82] = "Matte Dark Blue",
    [83] = "Matte Blue",
    [84] = "Matte Midnight Blue",
    [85] = "Worn Dark blue",
    [86] = "Worn Blue",
    [87] = "Worn Light blue",
    [88] = "Metallic Taxi Yellow",
    [89] = "Metallic Race Yellow",
    [90] = "Metallic Bronze",
    [91] = "Metallic Yellow Bird",
    [92] = "Metallic Lime",
    [93] = "Metallic Champagne",
    [94] = "Metallic Pueblo Beige",
    [95] = "Metallic Dark Ivory",
    [96] = "Metallic Choco Brown",
    [97] = "Metallic Golden Brown",
    [98] = "Metallic Light Brown",
    [99] = "Metallic Straw Beige",
    [100] = "Metallic Moss Brown",
    [101] = "Metallic Biston Brown",
    [102] = "Metallic Beechwood",
    [103] = "Metallic Dark Beechwood",
    [104] = "Metallic Choco Orange",
    [105] = "Metallic Beach Sand",
    [106] = "Metallic Sun Bleeched Sand",
    [107] = "Metallic Cream",
    [108] = "Util Brown",
    [109] = "Util Medium Brown",
    [110] = "Util Light Brown",
    [111] = "Metallic White",
    [112] = "Metallic Frost White",
    [113] = "Worn Honey Beige",
    [114] = "Worn Brown",
    [115] = "Worn Dark Brown",
    [116] = "Worn straw beige",
    [117] = "Brushed Steel",
    [118] = "Brushed Black steel",
    [119] = "Brushed Aluminium",
    [120] = "Chrome",
    [121] = "Worn Off White",
    [122] = "Util Off White",
    [123] = "Worn Orange",
    [124] = "Worn Light Orange",
    [125] = "Metallic Securicor Green",
    [126] = "Worn Taxi Yellow",
    [127] = "police car blue",
    [128] = "Matte Green",
    [129] = "Matte Brown",
    [130] = "Worn Orange",
    [131] = "Matte White",
    [132] = "Worn White",
    [133] = "Worn Olive Army Green",
    [134] = "Pure White",
    [135] = "Hot Pink",
    [136] = "Salmon pink",
    [137] = "Metallic Vermillion Pink",
    [138] = "Orange",
    [139] = "Green",
    [140] = "Blue",
    [141] = "Mettalic Black Blue",
    [142] = "Metallic Black Purple",
    [143] = "Metallic Black Red",
    [144] = "hunter green",
    [145] = "Metallic Purple",
    [146] = "Metaillic V Dark Blue",
    [147] = "MODSHOP BLACK1",
    [148] = "Matte Purple",
    [149] = "Matte Dark Purple",
    [150] = "Metallic Lava Red",
    [151] = "Matte Forest Green",
    [152] = "Matte Olive Drab",
    [153] = "Matte Desert Brown",
    [154] = "Matte Desert Tan",
    [155] = "Matte Foilage Green",
    [156] = "DEFAULT ALLOY COLOR",
    [157] = "Epsilon Blue",
}

local blockedPeds = {
    "mp_m_freemode_01",
    "mp_f_freemode_01",
    "tony",
    "g_m_m_chigoon_02_m",
    "u_m_m_jesus_01",
    "a_m_y_stbla_m",
    "ig_terry_m",
    "a_m_m_ktown_m",
    "a_m_y_skater_m",
    "u_m_y_coop",
    "ig_car3guy1_m",
}

-- Events

RegisterNetEvent('XZCore:Client:OnPlayerLoaded', function()
    TriggerServerEvent("xz-admin:server:loadPermissions")
end)

RegisterNetEvent("XZCore:Client:OnPermissionUpdate", function(per)
    myPermissionRank = per
end)

RegisterNetEvent('xz-admin:client:openMenu', function(group, management, developer)
    WarMenu.OpenMenu('admin')
    isManagement = management
    isDev = developer
    myPermissionRank = group
end)

RegisterNetEvent('xz-admin:client:bringTp', function(coords)
    local ped = PlayerPedId()

    SetEntityCoords(ped, coords.x, coords.y, coords.z)
end)

RegisterNetEvent('xz-admin:client:gotoTp', function(targetId)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    TriggerServerEvent('xz-admin:server:gotoTpstage2', targetId, coords)
end)

RegisterNetEvent('xz-admin:client:gotoTp2', function(coords)
    local ped = PlayerPedId()
    SetEntityCoords(ped, coords.x, coords.y, coords.z)
end)

RegisterNetEvent('xz-admin:client:Freeze', function(toggle)
    local ped = PlayerPedId()

    local veh = GetVehiclePedIsIn(ped)

    if veh ~= 0 then
        FreezeEntityPosition(ped, toggle)
        FreezeEntityPosition(veh, toggle)
    else
        FreezeEntityPosition(ped, toggle)
    end
end)

RegisterNetEvent('xz-admin:client:SendStaffChat', function(name, msg)
    TriggerServerEvent('xz-admin:server:StaffChatMessage', name, msg)
end)

RegisterNetEvent('xz-admin:client:SetModel', function(skin)
    local ped = PlayerPedId()
    local model = GetHashKey(skin)
    SetEntityInvincible(ped, true)

    if IsModelInCdimage(model) and IsModelValid(model) then
        LoadPlayerModel(model)
        SetPlayerModel(PlayerId(), model)

        if isPedAllowedRandom() then
            SetPedRandomComponentVariation(ped, true)
        end
        
		SetModelAsNoLongerNeeded(model)
	end
	SetEntityInvincible(ped, false)
end)

RegisterNetEvent('xz-admin:client:SetSpeed', function(speed)
    local ped = PlayerId()
    if speed == "fast" then
        SetRunSprintMultiplierForPlayer(ped, 1.49)
        SetSwimMultiplierForPlayer(ped, 1.49)
    else
        SetRunSprintMultiplierForPlayer(ped, 1.0)
        SetSwimMultiplierForPlayer(ped, 1.0)
    end
end)


RegisterNetEvent('xz-admin:client:GiveNuiFocus', function(focus, mouse)
    SetNuiFocus(focus, mouse)
end)

RegisterNetEvent('xz-admin:client:EnableKeys', function()
    --print('[xz-admin] Enabled Keys.')
    EnableAllControlActions(0)
    SetNuiFocus(true, true)
end)

-- Functions

XZAdmin.Functions.DrawText3D = function(x, y, z, text, lines)
    -- Amount of lines default 1
    if lines == nil then
        lines = 1
    end

    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    if onScreen then
      SetTextScale(0.30, 0.30)
      SetTextFont(4)
      SetTextProportional(1)
      SetTextColour(255, 255, 255, 215)
      SetTextEntry("STRING")
      SetTextCentre(1)
      AddTextComponentString(text)
      DrawText(_x,_y)
      local factor = (string.len(text)) / 370
      DrawRect(_x,_y+0.0120, factor, 0.026, 41, 11, 41, 68)
    end
end

GetPlayers = function()
    local players = {}
    for _, player in ipairs(XZCore.Functions.GetPlayers()) do
        local ped = GetPlayerPed(player)
        if DoesEntityExist(ped) then
            table.insert(players, player)
        end
    end
    return players
end

GetPlayersFromCoords = function(coords, distance)
    local players = getPlayers()
    local closePlayers = {}

    if coords == nil then
		coords = GetEntityCoords(PlayerPedId())
    end
    if distance == nil then
        distance = 5.0
    end
    for _, player in pairs(players) do
		local target = player['ped']
		local targetCoords = GetEntityCoords(target)
		local targetdistance = GetDistanceBetweenCoords(targetCoords, coords.x, coords.y, coords.z, true)
		if targetdistance <= distance then
			table.insert(closePlayers, player.id)
		end
    end
    
    return closePlayers
end

function getPlayers()
    local players = {}
    for k, player in pairs(GetActivePlayers()) do
        local playerId = GetPlayerServerId(player)
        players[k] = {
            ['ped'] = GetPlayerPed(player),
            ['name'] = GetPlayerName(player),
            ['id'] = player,
            ['serverid'] = playerId,
        }
    end

    table.sort(players, function(a, b)
        return a.serverid < b.serverid
    end)

    return players
end

function SpectatePlayer(targetPed, toggle)
    local myPed = PlayerPedId()

    if toggle then
        showNames = true
        SetEntityVisible(myPed, false)
        SetEntityInvincible(myPed, true)
        lastSpectateCoord = GetEntityCoords(myPed)
        DoScreenFadeOut(150)
        SetTimeout(250, function()
            SetEntityVisible(myPed, false)
            SetEntityCoords(myPed, GetOffsetFromEntityInWorldCoords(targetPed, 0.0, 0.45, 0.0))
            AttachEntityToEntity(myPed, targetPed, 11816, 0.0, -1.3, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
            SetEntityVisible(myPed, false)
            SetEntityInvincible(myPed, true)
            DoScreenFadeIn(150)
        end)
    else
        showNames = false
        DoScreenFadeOut(150)
        DetachEntity(myPed, true, false)
        SetTimeout(250, function()
            SetEntityCoords(myPed, lastSpectateCoord)
            SetEntityVisible(myPed, true)
            SetEntityInvincible(myPed, false)
            DoScreenFadeIn(150)
            lastSpectateCoord = nil
        end)
    end
end

function OpenTargetInventory(targetId)
    WarMenu.CloseMenu()

    TriggerServerEvent("inventory:server:OpenInventory", "otherplayer", targetId)
end

function toggleBlips()
    if showBlips then
        Citizen.CreateThread(function()
            while showBlips do 
                print('Refreshed Player Blips')
                local Players = getPlayers()

                for k, v in pairs(Players) do
                    local playerPed = v["ped"]
                    if DoesEntityExist(playerPed) then
                        if PlayerBlips[k] == nil then
                            local playerName = v["name"]
                
                            PlayerBlips[k] = AddBlipForEntity(playerPed)
                
                            SetBlipSprite(PlayerBlips[k], 1)
                            SetBlipColour(PlayerBlips[k], 0)
                            SetBlipScale  (PlayerBlips[k], 0.6)
                            SetBlipAsShortRange(PlayerBlips[k], true)
                            BeginTextCommandSetBlipName("STRING")
                            AddTextComponentString('['..v["serverid"]..'] '..playerName)
                            EndTextCommandSetBlipName(PlayerBlips[k])
                        end
                    else
                        if PlayerBlips[k] ~= nil then
                            RemoveBlip(PlayerBlips[k])
                            PlayerBlips[k] = nil
                        end
                    end
                end
                Citizen.Wait(20000)  

                if next(PlayerBlips) ~= nil then
                    for k, v in pairs(PlayerBlips) do
                        RemoveBlip(PlayerBlips[k])
                    end
                    PlayerBlips = {}
                end
            end
        end)
    else
        if next(PlayerBlips) ~= nil then
            for k, v in pairs(PlayerBlips) do
                RemoveBlip(PlayerBlips[k])
            end
            PlayerBlips = {}
        end
        Citizen.Wait(1000)
    end
end

-- Draws boundingbox around the object with given color parms
function DrawEntityBoundingBox(entity, color)
    local model = GetEntityModel(entity)
    local min, max = GetModelDimensions(model)
    local rightVector, forwardVector, upVector, position = GetEntityMatrix(entity)

    -- Calculate size
    local dim = 
	{ 
		x = 0.5*(max.x - min.x), 
		y = 0.5*(max.y - min.y), 
		z = 0.5*(max.z - min.z)
	}

    local FUR = 
    {
		x = position.x + dim.y*rightVector.x + dim.x*forwardVector.x + dim.z*upVector.x, 
		y = position.y + dim.y*rightVector.y + dim.x*forwardVector.y + dim.z*upVector.y, 
		z = 0
    }

    local FUR_bool, FUR_z = GetGroundZFor_3dCoord(FUR.x, FUR.y, 1000.0, 0)
    FUR.z = FUR_z
    FUR.z = FUR.z + 2 * dim.z

    local BLL = 
    {
        x = position.x - dim.y*rightVector.x - dim.x*forwardVector.x - dim.z*upVector.x,
        y = position.y - dim.y*rightVector.y - dim.x*forwardVector.y - dim.z*upVector.y,
        z = 0
    }
    local BLL_bool, BLL_z = GetGroundZFor_3dCoord(FUR.x, FUR.y, 1000.0, 0)
    BLL.z = BLL_z

    -- DEBUG
    local edge1 = BLL
    local edge5 = FUR

    local edge2 = 
    {
        x = edge1.x + 2 * dim.y*rightVector.x,
        y = edge1.y + 2 * dim.y*rightVector.y,
        z = edge1.z + 2 * dim.y*rightVector.z
    }

    local edge3 = 
    {
        x = edge2.x + 2 * dim.z*upVector.x,
        y = edge2.y + 2 * dim.z*upVector.y,
        z = edge2.z + 2 * dim.z*upVector.z
    }

    local edge4 = 
    {
        x = edge1.x + 2 * dim.z*upVector.x,
        y = edge1.y + 2 * dim.z*upVector.y,
        z = edge1.z + 2 * dim.z*upVector.z
    }

    local edge6 = 
    {
        x = edge5.x - 2 * dim.y*rightVector.x,
        y = edge5.y - 2 * dim.y*rightVector.y,
        z = edge5.z - 2 * dim.y*rightVector.z
    }

    local edge7 = 
    {
        x = edge6.x - 2 * dim.z*upVector.x,
        y = edge6.y - 2 * dim.z*upVector.y,
        z = edge6.z - 2 * dim.z*upVector.z
    }

    local edge8 = 
    {
        x = edge5.x - 2 * dim.z*upVector.x,
        y = edge5.y - 2 * dim.z*upVector.y,
        z = edge5.z - 2 * dim.z*upVector.z
    }

    DrawLine(edge1.x, edge1.y, edge1.z, edge2.x, edge2.y, edge2.z, color.r, color.g, color.b, color.a)
    DrawLine(edge1.x, edge1.y, edge1.z, edge4.x, edge4.y, edge4.z, color.r, color.g, color.b, color.a)
    DrawLine(edge2.x, edge2.y, edge2.z, edge3.x, edge3.y, edge3.z, color.r, color.g, color.b, color.a)
    DrawLine(edge3.x, edge3.y, edge3.z, edge4.x, edge4.y, edge4.z, color.r, color.g, color.b, color.a)
    DrawLine(edge5.x, edge5.y, edge5.z, edge6.x, edge6.y, edge6.z, color.r, color.g, color.b, color.a)
    DrawLine(edge5.x, edge5.y, edge5.z, edge8.x, edge8.y, edge8.z, color.r, color.g, color.b, color.a)
    DrawLine(edge6.x, edge6.y, edge6.z, edge7.x, edge7.y, edge7.z, color.r, color.g, color.b, color.a)
    DrawLine(edge7.x, edge7.y, edge7.z, edge8.x, edge8.y, edge8.z, color.r, color.g, color.b, color.a)
    DrawLine(edge1.x, edge1.y, edge1.z, edge7.x, edge7.y, edge7.z, color.r, color.g, color.b, color.a)
    DrawLine(edge2.x, edge2.y, edge2.z, edge8.x, edge8.y, edge8.z, color.r, color.g, color.b, color.a)
    DrawLine(edge3.x, edge3.y, edge3.z, edge5.x, edge5.y, edge5.z, color.r, color.g, color.b, color.a)
    DrawLine(edge4.x, edge4.y, edge4.z, edge6.x, edge6.y, edge6.z, color.r, color.g, color.b, color.a)
end

-- Embed direction in rotation vector
function RotationToDirection(rotation)
	local adjustedRotation = 
	{ 
		x = (math.pi / 180) * rotation.x, 
		y = (math.pi / 180) * rotation.y, 
		z = (math.pi / 180) * rotation.z 
	}
	local direction = 
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), 
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), 
		z = math.sin(adjustedRotation.x)
	}
	return direction
end

-- Raycast function for "Admin Lazer"
function RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination = 
	{ 
		x = cameraCoord.x + direction.x * distance, 
		y = cameraCoord.y + direction.y * distance, 
		z = cameraCoord.z + direction.z * distance 
	}
	local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, PlayerPedId(), 0))
	return b, c, e
end

function LoadPlayerModel(skin)
    RequestModel(skin)
    while not HasModelLoaded(skin) do
        
        Citizen.Wait(0)
    end
end

function isPedAllowedRandom(skin)
    local retval = false
    for k, v in pairs(blockedPeds) do
        if v ~= skin then
            retval = true
        end
    end
    return retval
end

function polar3DToWorld3D(entityPosition, radius, polarAngleDeg, azimuthAngleDeg)
	-- convert degrees to radians
	local polarAngleRad   = polarAngleDeg   * math.pi / 90.0
	local azimuthAngleRad = azimuthAngleDeg * math.pi / 90.0

	local pos = {
		x = entityPosition.x + radius * (math.sin(azimuthAngleRad) * math.cos(polarAngleRad)),
		y = entityPosition.y - radius * (math.sin(azimuthAngleRad) * math.sin(polarAngleRad)),
		z = entityPosition.z - radius * math.cos(azimuthAngleRad)
	}

	return pos
end
--- Code

local currentPlayerMenu = nil
local currentPlayer = 0
local currentPlayerID = 0

Citizen.CreateThread(function()
    local menus = {
        "admin",
        "playerMan",
        "serverMan",
        currentPlayer,
        "playerOptions",
        "teleportOptions",
        "permissionOptions",
        "exitSpectate",
        "weatherOptions",
        "adminOptions",
        "adminOpt",
        "vehOptions",
        "managementOptions",
        "devOptions",
        "weaponOptions"
    }

    local bans = {
        "1 hour",
        "6 hour",
        "12 hour",
        "1 day",
        "3 days",
        "1 week",
        "1 month",
        "3 months",
        "6 months",
        "1 year",
        "Perm",
        "Self",
    }


    local Weapons = {
        "Knife",
        "Dagger",
        "Baseball Bat",
        "Broken Bottle",
        "Crowbar",
        "Flashlight",
        "Golf Club",
        "Hammer",
        "Hatchet",
        "Brass Knuckles",
        "Machete",
        "Switchblade",
        "Nightstick",
        "Pipe Wrench",
        "Battle Axe",
        "Pool Cue",
        "Brick",
        "Staff of Regeneration",
        "Stungun",
        "PD Taser",
        "SNS Pistol",
        "Colt 1911",
        "Beretta M9",
        "Vintage Pistol",
        "FN FNX-45",
        "AP Pistol",
        "Heavy Pistol",
        "Desert Eagle",
        "Micro SMG",
        "Uzi",
        "MAC-10",
        "Machine Pistol",
        "SMG",
        "SMG Mk II",
        "Gusenberg",
        "Combat PDW",
        "MG",
        "Combat MG",
        "Assault SMG",
        "Assault Rifle",
        "M70",
        "Special Carbine",
        "PD M4",
        "Draco NAK9",
        "Sniper Rifle",
        "Heavy Sniper",
        "RPG",
        "Grenade Launcher",
        "Firework Launcher",
        "Compact Grenade",
        "Railgun",
        "Minigun",
    }

    local WeaponsHashs = {
        "WEAPON_KNIFE",
        "WEAPON_DAGGER",
        "WEAPON_BAT",
        "WEAPON_BOTTLE",
        "WEAPON_CROWBAR",
        "WEAPON_FLASHLIGHT",
        "WEAPON_GOLFCLUB",
        "WEAPON_HAMMER",
        "WEAPON_HATCHET",
        "WEAPON_KNUCKLE",
        "WEAPON_MACHETE",
        "WEAPON_SWITCHBLADE",
        "WEAPON_NIGHTSTICK",
        "WEAPON_WRENCH",
        "WEAPON_BATTLEAXE",
        "WEAPON_POOLCUE",
        "WEAPON_BRICK",
        "WEAPON_STAFF",
        "WEAPON_STUNGUN",
        "WEAPON_TASER",
        "WEAPON_SNSPISTOL",
        "WEAPON_PISTOL",
        "WEAPON_PISTOL_MK2",
        "WEAPON_VINTAGEPISTOL",
        "WEAPON_COMBATPISTOL",
        "WEAPON_APPISTOL",
        "WEAPON_HEAVYPISTOL",
        "WEAPON_PISTOL50",
        "WEAPON_MICROSMG",
        "WEAPON_MICROSMG2",
        "WEAPON_MICROSMG3",
        "WEAPON_MACHINEPISTOL",
        "WEAPON_SMG",
        "WEAPON_SMG_MK2",
        "WEAPON_GUSENBERG",
        "WEAPON_COMBATPDW",
        "WEAPON_MG",
        "WEAPON_COMBATMG",
        "WEAPON_ASSAULTSMG",
        "WEAPON_AssaultRifle",
        "WEAPON_AssaultRifle2",
        "WEAPON_SpecialCarbine",
        "WEAPON_M4",
        "WEAPON_CompactRifle",
        "WEAPON_SniperRifle",
        "WEAPON_HeavySniper",
        "WEAPON_RPG",
        "WEAPON_GRENADELAUNCHER",
        "WEAPON_FIREWORK",
        "WEAPON_COMPACTLAUNCHER",
        "WEAPON_RAILGUN",
        "WEAPON_MINIGUN",
    }

    local times = {
        "00:00",
        "01:00",
        "02:00",
        "03:00",
        "04:00",
        "05:00",
        "06:00",
        "07:00",
        "08:00",
        "09:00",
        "10:00",
        "11:00",
        "12:00",
        "13:00",
        "14:00",
        "15:00",
        "16:00",
        "17:00",
        "18:00",
        "19:00",
        "20:00",
        "21:00",
        "22:00",
        "23:00",
    }

    local perms = {
        "User",
        "Admin",
        "God"
    }

    local currentColorIndex = 1
    local selectedColorIndex = 1

    local currentWeaponIndex = 1
    local selectedWeaponIndex = 1

    local currentBoostIndex = 1
    local selectedBoostIndex = 1

    local currentBanIndex = 1
    local selectedBanIndex = 1
    
    local currentMinTimeIndex = 1
    local selectedMinTimeIndex = 1

    local currentMaxTimeIndex = 1
    local selectedMaxTimeIndex = 1

    local currentPermIndex = 1
    local selectedPermIndex = 1


    WarMenu.CreateMenu('admin', 'Admin Menu')
    WarMenu.CreateSubMenu('playerMan', 'admin')
    WarMenu.CreateSubMenu('serverMan', 'admin')
    WarMenu.CreateSubMenu('exitSpectate', 'admin')
    WarMenu.CreateSubMenu('vehOptions', 'admin')
    WarMenu.CreateSubMenu('managementOptions', 'admin')
    WarMenu.CreateSubMenu('devOptions', 'admin')
    WarMenu.CreateSubMenu('weaponOptions', 'admin')
    WarMenu.CreateSubMenu('adminOpt', 'admin')

    WarMenu.CreateSubMenu('weatherOptions', 'serverMan')
    
    for k, v in pairs(menus) do
        WarMenu.SetMenuX(v, 0.71)
        WarMenu.SetMenuY(v, 0.017)
        WarMenu.SetMenuWidth(v, 0.2)
        WarMenu.SetTitleColor(v, 135, 206, 250, 255)
        WarMenu.SetTitleBackgroundColor(v, 0, 0, 0, 100)
    end

    while true do
        if WarMenu.IsMenuOpened('admin') then
            WarMenu.MenuButton('General Options', 'adminOpt')
            WarMenu.MenuButton('Players Options', 'playerMan')

            if IsPedInAnyVehicle(PlayerPedId()) and isManagement then
                WarMenu.MenuButton('Vehicle Options', 'vehOptions')
            end

            if isManagement and GetSelectedPedWeapon(PlayerPedId()) ~= `weapon_unarmed` then
                
                WarMenu.MenuButton('Weapon Options', 'weaponOptions')
            
            end

            if myPermissionRank == "god" then
                WarMenu.MenuButton('Server Options', 'serverMan')
            end

            if isManagement then
                WarMenu.MenuButton('Management Options', 'managementOptions')
            end

            if isDev then
                WarMenu.MenuButton('Developer Options', 'devOptions')
            end

            if InSpectatorMode then
                WarMenu.MenuButton('Exit Spectate', 'exitSpectate')
            end

            WarMenu.Display()
        
        elseif WarMenu.IsMenuOpened('weaponOptions') then
            if WarMenu.MenuButton('Max Ammo', 'weaponOptions') then
                TriggerEvent('xz-weapons:client:SetWeaponAmmoManual', 'current', 250)
            end

            
            if WarMenu.MenuButton('Add Attachments', 'weaponOptions') then
                TriggerEvent("weapons:client:EquipAttachment", {}, "extendedclip")
                TriggerEvent("weapons:client:EquipAttachment", {}, "suppressor")
            end

            if WarMenu.MenuButton('Repair Weapon', 'weaponOptions') then
                TriggerEvent("weapons:client:SetWeaponQuality", 100)
                XZCore.Functions.Notify('Weapon Fixed!', 'success')
            end

            if WarMenu.CheckBox("Infinite Ammo", InfiniteAmmo, function(checked) InfiniteAmmo = checked end) then
                SetPedInfiniteAmmoClip(PlayerPedId(), InfiniteAmmo)
            end

            if WarMenu.CheckBox("Super Damage", SuperDamage, function(checked) SuperDamage = checked end) then
                local ply = PlayerId()
                                
                if SuperDamage then
                SetPlayerWeaponDamageModifier(ply, 500.0)
            else
                SetPlayerWeaponDamageModifier(ply, 1.0)
            end
        end
        
            if WarMenu.CheckBox("Disable Recoil", rzzz, function(checked)  rzzz = checked end) then
                TriggerEvent("recoil:updateRecoil",  rzzz)
            end
            
            
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('exitSpectate') then
            local playerPed = PlayerPedId()
            WarMenu.CloseMenu()

            InSpectatorMode = false
            TargetSpectate  = nil
        
            SetCamActive(cam,  false)
            RenderScriptCams(false, false, 0, true, true)
        
            SetEntityCollision(playerPed, true, true)
            SetEntityVisible(playerPed, true)
            SetEntityCoords(playerPed, LastPosition.x, LastPosition.y, LastPosition.z)
        elseif WarMenu.IsMenuOpened('adminOpt') then

            if myPermissionRank == "god" then
                if WarMenu.Button("Clothing Menu") then
                    WarMenu.CloseMenu()
                    TriggerServerEvent('xz-admin:server:OpenSkinMenu', GetPlayerServerId(PlayerId()), 'clothesmenu')
                end

                if WarMenu.Button("Barber Menu") then
                    WarMenu.CloseMenu()
                    TriggerServerEvent('xz-admin:server:OpenSkinMenu', GetPlayerServerId(PlayerId()), 'barbermenu')
                end

                if WarMenu.Button("Tattoos Menu") then
                    WarMenu.CloseMenu()
                    TriggerServerEvent('xz-admin:server:OpenSkinMenu', GetPlayerServerId(PlayerId()), 'tattoomenu')
                end
                
                if WarMenu.Button("Outfits Menu") then
                    WarMenu.CloseMenu()
                    TriggerEvent("xz-outfits-ido:client:forceUI")
                end
            end

            if WarMenu.Button('Revive') then
                local target = PlayerId()
                local targetId = GetPlayerServerId(target)
                TriggerServerEvent('xz-admin:server:revivePlayer', targetId)
            end

            if myPermissionRank == "god" then
                if WarMenu.Button('Uncuff') then
                    TriggerEvent('police:client:Uncuffed')
                end
            end

            if WarMenu.CheckBox("Noclip", isNoclip, function(checked) isNoclip = checked end) then
                local target = PlayerId()
                local targetId = GetPlayerServerId(target)
                TriggerServerEvent("xz-admin:server:togglePlayerNoclip", targetId)
            end

            if myPermissionRank == "god" then
                WarMenu.CheckBox("Show ID", showNames, function(checked) showNames = checked end)
            end


            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('playerMan') then
            local players = getPlayers()

            for k, v in pairs(players) do
                WarMenu.CreateSubMenu(v["id"], 'playerMan', v["serverid"].." | "..v["name"])
            end
            
            if WarMenu.MenuButton('#'..GetPlayerServerId(PlayerId()).." | "..GetPlayerName(PlayerId()), PlayerId()) then
                currentPlayer = PlayerId()
                if WarMenu.CreateSubMenu('playerOptions', currentPlayer) then
                    currentPlayerMenu = 'playerOptions'
                elseif WarMenu.CreateSubMenu('teleportOptions', currentPlayer) then
                    currentPlayerMenu = 'teleportOptions'
                elseif WarMenu.CreateSubMenu('adminOptions', currentPlayer) then
                    currentPlayerMenu = 'adminOptions'
                end

                if myPermissionRank == "god" then
                    if WarMenu.CreateSubMenu('permissionOptions', currentPlayer) then
                        currentPlayerMenu = 'permissionOptions'
                    end
                end
            end

            
            for k, v in pairs(players) do
                if v["serverid"] ~= GetPlayerServerId(PlayerId()) then
                    if WarMenu.MenuButton('#'..v["serverid"].." | "..v["name"], v["id"]) then
                        currentPlayer = v.id
                        currentPlayerID = v
                        if WarMenu.CreateSubMenu('playerOptions', currentPlayer) then
                            currentPlayerMenu = 'playerOptions'
                        elseif WarMenu.CreateSubMenu('teleportOptions', currentPlayer) then
                            currentPlayerMenu = 'teleportOptions'
                        elseif WarMenu.CreateSubMenu('adminOptions', currentPlayer) then
                            currentPlayerMenu = 'adminOptions'
                        end
                    end
                end
            end

            if myPermissionRank == "god" then
                if WarMenu.CreateSubMenu('permissionOptions', currentPlayer) then
                    currentPlayerMenu = 'permissionOptions'
                end
            end

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('managementOptions') then

            if WarMenu.MenuButton('Mechanic Menu', 'managementOptions') then
                WarMenu.CloseMenu()
                TriggerEvent('xz-mechanic:forceOpen')
            end

            if WarMenu.MenuButton('Heal & Armor', 'managementOptions') then
                local ped = PlayerPedId()
                SetEntityMaxHealth(ped, 200)
                SetEntityHealth(ped, 200)
                SetPedArmour(ped, 200)
                XZCore.Functions.Notify("You are completely top again!")
            end
            
            if WarMenu.ComboBox('Give Weapon', Weapons, currentWeaponIndex, selectedWeaponIndex, function(currentIndex, selectedIndex)
                currentWeaponIndex = currentIndex
                selectedWeaponIndex = selectedIndex
            end) then
                TriggerServerEvent("xz-admin:server:spawnWeapon", WeaponsHashs[currentWeaponIndex])
            end
 
            if WarMenu.CheckBox("Invisible", isInvisible, function(checked) isInvisible = checked end) then
                local myPed = PlayerPedId()
                
                if isInvisible then
                    SetEntityVisible(myPed, false, false)
                else
                    SetEntityVisible(myPed, true, false)
                end
            end

                if WarMenu.CheckBox("Toggle Player Blips", showBlips, function(checked) showBlips = checked end) then
                    toggleBlips()
                end

                if WarMenu.CheckBox("Access PD Dispatch", Dispatch, function(checked) Dispatch = checked end) then
                TriggerEvent("disptach:management", Dispatch)
            end

            if WarMenu.CheckBox("Access Player Houses", hblips, function(checked) hblips = checked end) then
                TriggerEvent("ToggleHouseBlips", hblips)
                TriggerServerEvent("houses:server:managementAccess", hblips)
            end

        if WarMenu.CheckBox("Godmode", hasGodmode, function(checked) hasGodmode = checked end) then
            local myPlayer = PlayerId()
            
            SetPlayerInvincible(myPlayer, hasGodmode)
        end


        WarMenu.Display()
    elseif WarMenu.IsMenuOpened('devOptions') then

        if WarMenu.CheckBox("Delete Lazer", deleteLazer, function(checked) deleteLazer = checked end) then
        end

        if WarMenu.CheckBox("Rainbow Car", RainbowVehicle, function(checked) RainbowVehicle = checked end) then
        end

        if WarMenu.ComboBox('Boost Vehicle', BoostSpeeds, currentBoostIndex, selectedBoostIndex, function(currentIndex, selectedIndex)
            currentBoostIndex = currentIndex
            selectedBoostIndex = selectedIndex
        end) then
            local speed = BoostSpeeds[currentBoostIndex] + 0.0
            local vehicle = GetVehiclePedIsIn(PlayerPedId())
            SetVehicleForwardSpeed(vehicle, GetEntitySpeed(vehicle) + speed)
        end

        WarMenu.CheckBox("Anti Ragdoll", antiRagdoll, function(checked)
            antiRagdoll = checked
            SetPedCanRagdoll(PlayerPedId(), not antiRagdoll)
        end)

        WarMenu.CheckBox("Fast Mode", fastMode, function(checked)
            fastMode = checked
            SetSwimMultiplierForPlayer(PlayerId(), fastMode and 1.49 or 1.0)
            SetRunSprintMultiplierForPlayer(PlayerId(), fastMode and 1.49 or 1.0)
            antiRagdoll = checked
            SetPedCanRagdoll(PlayerPedId(), not antiRagdoll)
            CreateThread(function()
                while fastMode do
                    Wait(1)
                    SetSuperJumpThisFrame(PlayerId())
                end
            end)
        end)

    if WarMenu.MenuButton('Return all to bucket', 'devOptions') then
        TriggerServerEvent("xz-admin:server:returnAllToBucket")
        XZCore.Functions.Notify('Returned all players to bucket')
    end

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('vehOptions') then

            if WarMenu.MenuButton('Fix Vehicle', 'vehOptions') then
                SetVehicleFixed(GetVehiclePedIsIn(PlayerPedId()))
            end

            if WarMenu.MenuButton('Clean Vehicle', 'vehOptions') then
                SetVehicleDirtLevel(GetVehiclePedIsIn(PlayerPedId()), 0.0)
            end

            if WarMenu.MenuButton('Hotwire Vehicle', 'vehOptions') then
                TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId())), GetVehiclePedIsIn(PlayerPedId()))
            end

            if WarMenu.MenuButton('Set Owned', 'vehOptions') then
                local hash = GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), false))
                local model

                for _, vehicleData in pairs(XZCore.Shared.Vehicles) do
                    if(vehicleData.hash == hash) then
                        model = vehicleData.model
                        break
                    end
                end

				TriggerServerEvent('xz-garages-ido:server:setVehicleOwned', {props = XZCore.Functions.GetVehicleProperties(GetVehiclePedIsIn(PlayerPedId(), false)), stats = {damage = 0, fuel = 100}, model = model, police = false})
            end

            if WarMenu.MenuButton('Fill Fuel', 'vehOptions') then
                local vehicle = (GetVehiclePedIsIn(PlayerPedId()))
                exports['LegacyFuel']:SetFuel(vehicle, 99)
            end

            if WarMenu.MenuButton('Fill Nitros', 'vehOptions') then
                TriggerEvent('nitrous:client:fillVehicle')
            end

            if WarMenu.MenuButton('Flip Vehicle', 'vehOptions') then
                SetVehicleOnGroundProperly(GetVehiclePedIsIn(PlayerPedId()))
            end

            if WarMenu.MenuButton('Delete Vehicle', 'vehOptions') then
                XZCore.Functions.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
            end

            if isManagement then
                if WarMenu.MenuButton('Max Mods', 'vehOptions') then
                    local props = XZCore.Functions.GetVehicleProperties(GetVehiclePedIsIn(PlayerPedId()))
                    props["modEngine"] = 3
                    props["modBrakes"] = 2
                    props["modTransmission"] = 2
                    props["modSuspension"] = 2
                    props["modTurbo"] = true
                    XZCore.Functions.SetVehicleProperties(GetVehiclePedIsIn(PlayerPedId()), props)
                    SetVehicleFixed(GetVehiclePedIsIn(PlayerPedId()))
                end
            end

            if WarMenu.ComboBox('Change Color', VehicleColors, currentColorIndex, selectedColorIndex, function(currentIndex, selectedIndex)
                currentColorIndex = currentIndex
                selectedColorIndex = selectedIndex
            end) then
                local vehicle = GetVehiclePedIsIn(PlayerPedId())
                SetVehicleColours(vehicle, currentColorIndex, currentColorIndex)
            end
        -- end

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('serverMan') then
            WarMenu.MenuButton('Weather Options', 'weatherOptions')

            if WarMenu.ComboBox('Server time', times, currentBanIndex, selectedBanIndex, function(currentIndex, selectedIndex)
                currentBanIndex = currentIndex
                selectedBanIndex = selectedIndex
            end) then
                local time = ServerTimes[currentBanIndex]
                TriggerServerEvent("xz-weathersync:server:setTime", time.hour, time.minute)
                XZCore.Functions.Notify('Changed Time to: '..time.hour)
            end
            
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened(currentPlayer) then
            WarMenu.MenuButton('Player Options', 'playerOptions')
            WarMenu.MenuButton('Teleport Options', 'teleportOptions')
            WarMenu.MenuButton('Admin Options', 'adminOptions')

            if myPermissionRank == "god" then
                WarMenu.MenuButton('Permission Options', 'permissionOptions')
            end

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('playerOptions') then
            if myPermissionRank == "god" then
                    if WarMenu.CheckBox("Noclip", isNoclip, function(checked) isNoclip = checked end) then
                        TriggerServerEvent("xz-admin:server:togglePlayerNoclip", GetPlayerServerId(currentPlayer))
                    end
                end
            

            if WarMenu.CheckBox("Freeze", isFreeze, function(checked) isFreeze = checked end) then
                TriggerServerEvent("xz-admin:server:Freeze", GetPlayerServerId(currentPlayer), isFreeze)
            end

            if WarMenu.MenuButton('Revive', currentPlayer) then
                TriggerServerEvent('xz-admin:server:revivePlayer', GetPlayerServerId(currentPlayer))
            end

            if WarMenu.MenuButton('Slay', currentPlayer) then
                TriggerServerEvent("xz-admin:server:killPlayer", GetPlayerServerId(currentPlayer))
            end

            if isManagement then
                if WarMenu.MenuButton('Return to bucket', currentPlayer) then
                    TriggerServerEvent('xz-admin:server:returnBucket', GetPlayerServerId(currentPlayer))
                end

                if WarMenu.MenuButton('Uncuff', currentPlayer) then
                    TriggerServerEvent('xz-admin:server:uncuff', GetPlayerServerId(currentPlayer))
                end
            end

            if WarMenu.MenuButton("Spectate", currentPlayer) then
                WarMenu.CloseMenu()

                local playerPed = PlayerPedId()
                if not InSpectatorMode then
                    LastPosition = GetEntityCoords(playerPed)
                end

                SetEntityCollision(playerPed, false, false)
                SetEntityVisible(playerPed, false)

                Citizen.CreateThread(function()
                    
                    if not DoesCamExist(cam) then
                        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
                    end
        
                    SetCamActive(cam, true)
                    RenderScriptCams(true, false, 0, true, true)
        
                    InSpectatorMode = true
                    TargetSpectate  = currentPlayer
                end)
            end

            if myPermissionRank == "god" then
                if WarMenu.MenuButton("Open Inventory", currentPlayer) then
                    OpenTargetInventory(GetPlayerServerId(currentPlayer))
            end
        end
            
            if WarMenu.MenuButton("Give Clothing Menu", currentPlayer) then
                TriggerServerEvent('xz-admin:server:OpenSkinMenu', GetPlayerServerId(currentPlayer), 'clothesmenu')
            end

            if WarMenu.MenuButton("Give Barber Menu", currentPlayer) then
                TriggerServerEvent('xz-admin:server:OpenSkinMenu', GetPlayerServerId(currentPlayer), 'barbermenu')
            end

            if WarMenu.MenuButton("Give Tattoos Menu", currentPlayer) then
                TriggerServerEvent('xz-admin:server:OpenSkinMenu', GetPlayerServerId(currentPlayer), 'tattoomenu')
            end

            if WarMenu.MenuButton("Give Outfits Menu", currentPlayer) then
                TriggerServerEvent('xz-admin:server:OpenOutfitsMenu', GetPlayerServerId(currentPlayer))
            end

            WarMenu.Display()
            
        elseif WarMenu.IsMenuOpened('teleportOptions') then
            if WarMenu.MenuButton('Goto', currentPlayer) then
                if in_noclip_mode then
                    turnNoClipOff()
                    TriggerServerEvent('xz-admin:server:gotoTp', GetPlayerServerId(currentPlayer), GetPlayerServerId(PlayerId()))
                    turnNoClipOn()
                else
                    TriggerServerEvent('xz-admin:server:gotoTp', GetPlayerServerId(currentPlayer), GetPlayerServerId(PlayerId()))
                end
            end
            if WarMenu.MenuButton('Bring', currentPlayer) then
                local target = GetPlayerPed(currentPlayer)
                local plyCoords = GetEntityCoords(PlayerPedId())

                TriggerServerEvent('xz-admin:server:bringTp', GetPlayerServerId(currentPlayer), plyCoords)
            end
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('permissionOptions') then
            if WarMenu.ComboBox('Permission Group', perms, currentPermIndex, selectedPermIndex, function(currentIndex, selectedIndex)
                currentPermIndex = currentIndex
                selectedPermIndex = selectedIndex
            end) then
                local group = PermissionLevels[currentPermIndex]
                local target = GetPlayerServerId(currentPlayer)

                TriggerServerEvent('xz-admin:server:setPermissions', target, group)

                XZCore.Functions.Notify('You have ' .. GetPlayerName(currentPlayer) .. '\'s group has changed to '..group.label)
            end
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('adminOptions') then
            if WarMenu.ComboBox('Ban Length', bans, currentBanIndex, selectedBanIndex, function(currentIndex, selectedIndex)
                currentBanIndex = currentIndex
                selectedBanIndex = selectedIndex
            end) then
                local time = BanTimes[currentBanIndex]
                local index = currentBanIndex
                if index == 12 then
                    DisplayOnscreenKeyboard(1, "Time", "", "Length", "", "", "", 128 + 1)
                    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
                        Citizen.Wait(7)
                    end
                    time = tonumber(GetOnscreenKeyboardResult())
                    time = time * 3600
                end
                DisplayOnscreenKeyboard(1, "Reason", "", "Reason", "", "", "", 128 + 1)
				while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
					Citizen.Wait(7)
				end
                local reason = GetOnscreenKeyboardResult()
                if reason ~= nil and reason ~= "" and time ~= 0 then
                    local target = GetPlayerServerId(currentPlayer)
                    TriggerServerEvent("xz-admin:server:banPlayer", target, time, reason)
                end
            end
            if WarMenu.MenuButton('Kick', currentPlayer) then
                DisplayOnscreenKeyboard(1, "Reason", "", "Reason", "", "", "", 128 + 1)
				while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
					Citizen.Wait(7)
				end
                local reason = GetOnscreenKeyboardResult()
                if reason ~= nil and reason ~= "" then
                    local target = GetPlayerServerId(currentPlayer)
                    TriggerServerEvent("xz-admin:server:kickPlayer", target, reason)
                end
            end
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('weatherOptions') then
            for k, v in pairs(AvailableWeatherTypes) do
                if WarMenu.MenuButton(AvailableWeatherTypes[k].label, 'weatherOptions') then
                    TriggerServerEvent('xz-weathersync:server:setWeather', AvailableWeatherTypes[k].weather)
                    XZCore.Functions.Notify('Weather has changed to: '..AvailableWeatherTypes[k].label)
                end
            end
            WarMenu.Display()
        end
        Citizen.Wait(3)
    end
end)

Citizen.CreateThread(function()
    while true do
        if showNames then

            for _, player in pairs(GetPlayersFromCoords(GetEntityCoords(PlayerPedId()), 5.0)) do
                local PlayerId = GetPlayerServerId(player)
                local PlayerPed = GetPlayerPed(player)
                local PlayerName = GetPlayerName(player)
                local PlayerCoords = GetEntityCoords(PlayerPed)
                if PlayerName ~= "0C9" then

                    XZAdmin.Functions.DrawText3D(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z + 1.0, '['..PlayerId..'] '..PlayerName)
                end
            end
        else
            Citizen.Wait(1000)
        end
        Citizen.Wait(3)
    end
end)

Citizen.CreateThread(function()	
	while true do
		Citizen.Wait(0)

        if deleteLazer then
            local color = {r = 255, g = 255, b = 255, a = 200}
            local position = GetEntityCoords(PlayerPedId())
            local hit, coords, entity = RayCastGamePlayCamera(1000.0)
            
            -- If entity is found then verifie entity
            if hit and (IsEntityAVehicle(entity) or IsEntityAPed(entity) or IsEntityAnObject(entity)) then
                local entityCoord = GetEntityCoords(entity)
                local minimum, maximum = GetModelDimensions(GetEntityModel(entity))
                
                DrawEntityBoundingBox(entity, color)
                DrawLine(position.x, position.y, position.z, coords.x, coords.y, coords.z, color.r, color.g, color.b, color.a)
                XZAdmin.Functions.DrawText3D(entityCoord.x, entityCoord.y, entityCoord.z, "Object: " .. entity .. " Model: " .. GetEntityModel(entity).. " \nPress [~g~E~s~] to delete this object.", 2)

                -- When E pressed then remove targeted entity
                if IsControlJustReleased(0, 38) then
                    -- Set as missionEntity so the object can be remove (Even map objects)
                    SetEntityAsMissionEntity(entity, true, true)
                    --SetEntityAsNoLongerNeeded(entity)
                    --RequestNetworkControl(entity)
                    DeleteEntity(entity)
                end
            -- Only draw of not center of map
            elseif coords.x ~= 0.0 and coords.y ~= 0.0 then
                -- Draws line to targeted position
                DrawLine(position.x, position.y, position.z, coords.x, coords.y, coords.z, color.r, color.g, color.b, color.a)
                DrawMarker(28, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.1, 0.1, 0.1, color.r, color.g, color.b, color.a, false, true, 2, nil, nil, false)
            end
        else
            Citizen.Wait(1000)
        end
	end
end)

Citizen.CreateThread(function()
    while true do

      Wait(0)

      if InSpectatorMode then

          local targetPlayerId = TargetSpectate
          local playerPed	  = PlayerPedId()
          local targetPed	  = GetPlayerPed(targetPlayerId)
          local coords	 = GetEntityCoords(targetPed)

          if not DoesEntityExist(targetPed) then
            local playerPed = PlayerPedId()
            WarMenu.CloseMenu()

            InSpectatorMode = false
            TargetSpectate  = nil
        
            SetCamActive(cam,  false)
            RenderScriptCams(false, false, 0, true, true)
        
            SetEntityCollision(playerPed, true, true)
            SetEntityVisible(playerPed, true)
            SetEntityCoords(playerPed, LastPosition.x, LastPosition.y, LastPosition.z)
          end

          for i = 0, 128, 1 do
              if i ~= PlayerId() then
                  local otherPlayerPed = GetPlayerPed(i)
                  SetEntityNoCollisionEntity(playerPed,  otherPlayerPed,  true)
                  SetEntityVisible(playerPed, false)
              end
          end

          if IsControlPressed(2, 241) then
              radius = radius + 2.0;
          end

          if IsControlPressed(2, 242) then
              radius = radius - 2.0;
          end

          if radius > -1 then
              radius = -1
          end

          local xMagnitude = GetDisabledControlNormal(0, 1);
          local yMagnitude = GetDisabledControlNormal(0, 2);

          polarAngleDeg = polarAngleDeg + xMagnitude * 10;

          if polarAngleDeg >= 360 then
              polarAngleDeg = 0
          end

          azimuthAngleDeg = azimuthAngleDeg + yMagnitude * 10;

          if azimuthAngleDeg >= 360 then
              azimuthAngleDeg = 0;
          end

          local nextCamLocation = polar3DToWorld3D(coords, radius, polarAngleDeg, azimuthAngleDeg)

          SetCamCoord(cam,  nextCamLocation.x,  nextCamLocation.y,  nextCamLocation.z)
          PointCamAtEntity(cam,  targetPed)
          SetEntityCoords(playerPed,  coords.x, coords.y, coords.z + 2)

      end
    end
end)

CreateThread(function()
    while true do
        if RainbowVehicle and IsPedInAnyVehicle(PlayerPedId()) then
            local color = math.random(#VehicleColors)
            SetVehicleColours(GetVehiclePedIsIn(PlayerPedId()),color,color)
        else
            Wait(1000)
        end

        Wait(150)
    end
end)
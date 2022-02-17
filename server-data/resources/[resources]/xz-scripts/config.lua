Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}

Consumeables = {
    ["null"] = math.random(1, 5),
}

Config = {}
Carwash = {}
Crafting = {}
Detector = {}

Detector.MetalDetectors = {
    [1] = vector3(1841.6561, 2585.864, 45.891891),
    [2] = vector3(1752.2569, 3252.2927, 41.566249),
    [3] = vector3(-592.3825, -934.246, 23.881818),
    [4] = vector3(-592.056, -924.2531, 23.869644),
    [5] = vector3(-592.2147, -924.2528, 23.869646),
    [6] = vector3(-592.4472, -934.387, 23.869646)
}

Detector.IllegalItems = {
    "metalscrap",
    "plastic",
    "copper",
    "iron",
    "aluminum",
    "steel",
    "glass",
    "methburn",
    "cokeburn",
    "weedburn",
    "lockpick",
    "WEAPON_PISTOL",
    "WEAPON_FLASHLIGHT",
    "WEAPON_COMBATPISTOL",
    "WEAPON_KNIFE",
    "WEAPON_SWITCHBLADE",
    "WEAPON_HEAVYPISTOL",
    "WEAPON_VINTAGEPISTOL",
    "WEAPON_STUNGUN",
    "WEAPON_MACHINEPISTOL",
    "WEAPON_REVOLVER",
    "WEAPON_HEAVYREVOLVER",
    "WEAPON_APPISTOL",
    "WEAPON_SNSPISTOL",
    "WEAPON_PISTOL50",
    "WEAPON_MARKSMANPISTOL",
    "WEAPON_HEAVYREVOLVER",
    "WEAPON_KNUCKLE",
    "WEAPON_KNIGHTSTICK",
    "WEAPON_HAMMER",
    "WEAPON_CROWBAR",
    "WEAPON_GOLFCLUB",
    "WEAPON_DAGGER",
    "WEAPON_MACHETE",
    "WEAPON_MICROSMG",
    "WEAPON_ASSAULTSMG",
    "WEAPON_MG",
    "WEAPON_COMBATMG",
    "WEAPON_COMBATPDW",
    "WEAPON_ASSAULTRIFLE",
    "WEAPON_ADVANCEDRIFLE",
    "WEAPON_CARBINERIFLE",
    "WEAPON_SPECIALRIFLE",
    "WEAPON_BULLPUPRIFLE",
    "WEAPON_COMPACTRIFLE",
    "WEAPON_PUMPSHOTGUN",
    "WEAPON_ASSAULTSHOTGUN",
    "WEAPON_BULLPUPSHOTGUN",
    "WEAPON_HEAVYSHOTGUN",
    "WEAPON_MUSKET",
    "WEAPON_SNIPERRIFLE",
    "WEAPON_HEAVYSNIPER",
    "WEAPON_MARKSMANRIFLE",
}

Carwash.Locations = {
    [1] = {
        ["label"] = "Car Wash",
        ["coords"] = {
            ["x"] = 29.63,
            ["y"] = -1391.92,
            ["z"] = 28.62,
		  }
		},
		[2] = {
			["label"] = "Car Wash",
			["coords"] = {
				["x"] = -699.90,
				["y"] = -932.50,
				["z"] = 19.01,	
		  }
		},	
		[3] = {
			["label"] = "Car Wash",
			["coords"] = {
				["x"] = 170.69,
				["y"] = -1718.41,
				["z"] = 29.30,	
		  }
		},	
		[4] = {
			["label"] = "Car Wash",
			["coords"] = {
				["x"] = 1362.15,
				["y"] = 3592.14,
				["z"] = 34.92,	
		  }
		},			
		[5] = {
			["label"] = "Car Wash",
			["coords"] = {
				["x"] = -217.50,
				["y"] = 6201.15,
				["z"] = 31.48,
        }
    }
}

Carwash.DefaultPrice = 15

Config.RemoveWeaponDrops = true
Config.RemoveWeaponDropsTimer = 25

Config.JointEffectTime = 60

Config.BlacklistedScenarios = {
    ['TYPES'] = {
        "WORLD_VEHICLE_MILITARY_PLANES_SMALL",
        "WORLD_VEHICLE_MILITARY_PLANES_BIG",
    },
    ['GROUPS'] = {
        2017590552,
        2141866469,
        1409640232,
        `ng_planes`,
    }
}
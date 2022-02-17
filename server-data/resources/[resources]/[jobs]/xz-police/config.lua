Config = {}

local StringCharset = {}
local NumberCharset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
for i = 65,  90 do table.insert(StringCharset, string.char(i)) end
for i = 97, 122 do table.insert(StringCharset, string.char(i)) end

Config.RandomStr = function(length)
	if length > 0 then
		return Config.RandomStr(length-1) .. StringCharset[math.random(1, #StringCharset)]
	else
		return ''
	end
end

Config.RandomInt = function(length)
	if length > 0 then
		return Config.RandomInt(length-1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

Config.Objects = {
    ["cone"] = {model = `prop_roadcone02a`, freeze = false},
    ["barier"] = {model = `prop_barrier_work06a`, freeze = true},
    ["schotten"] = {model = `prop_snow_sign_road_06g`, freeze = true},
    ["tent"] = {model = `prop_gazebo_03`, freeze = true},
    ["light"] = {model = `prop_worklight_03b`, freeze = true},
    ["chair"] = {model = `prop_chair_08`, freeze = true},
    ["chairs"] = {model = `prop_chair_pile_01`, freeze = true},
    ["table"] = {model = `prop_table_03`, freeze = true},
    ["monitor"] = {model = `des_tvsmash_root`, freeze = true},
}

Config.Locations = {
   ["duty"] = {
       [1] = {x = 441.7989, y = -982.0529, z = 30.67834, h = 11.0, l = 0.45, w = 0.35, minZ = 30.77834, maxZ = 30.87834},
       [2] = {x = 1854.2322, y = 3689.1831, z = 34.267089, h = 122.54818, l = 0.45, w = 0.35, minZ = 34.257089, maxZ = 34.367089},
       [3] = {x = -448.8587, y = 6013.7817, z = 31.716449, h = 243.82, l = 0.45, w = 0.35, minZ = 31.706449, maxZ = 31.816449},
   },
   ["vest"] = {
       [1] = {x = 487.9186, y = -997.0125, z = 30.689662, h = 270.7536, l = 0.6, w = 1.8, minZ = 30.189662, maxZ = 30.689662},
   },
   ["vehicle"] = {
       [1] = {x = 449.58587, y = -975.7857, z = 25.699932, h = 94.317794},
       [2] = {x = 471.13, y = -1024.05, z = 28.17, h = 274.5},
       [3] = {x = 1853.30, y = 3674.85, z = 33.72, h = 215.21},
       [4] = {x = -455.39, y = 6002.02, z = 31.34, h = 87.93},
       [5] = {x = 1753.7666, y = 2600.7036, z = 45.564975, h = 357.73715}
   },
   ["stash"] = {
       [1] = {x = 486.4896, y = -994.6768, z = 31.38975, h = 0.6497069, l = 0.6, w = 1.0, minZ = 30.589662, maxZ = 32.489662},
       [2] = {x = 445.9918, y = -997.0145, z = 30.710865, h = 89.0885, l = 0.7, w = 1.2, minZ = 30.589662, maxZ = 30.989662},
       [3] = {x = 1851.928, y = 3692.394, z = 34.89, h = 30.0, l = 0.7, w = 1.2, minZ = 34.899662, maxZ = 35.289662},
       [4] = {x = 1765.101, y = 2588.624, z = 49.71, h = 180.13, l = 0.7, w = 3.0, minZ = 48.599662, maxZ = 50.589662},
       [5] = {x = 1835.699, y = 2572.287, z = 46.11, h = 179.96, l = 0.7, w = 0.5, minZ = 46.009662, maxZ = 46.189662},
       [6] = {x = -434.63, y = 6001.63, z = 31.71, h = 316.5, l = 0.7, w = 2.5, minZ = 30.509662, maxZ = 33.189662},
   },
   ["impound"] = {},
   ["helicopter"] = {
       [1] = {x = 449.168, y = -981.325, z = 43.691, h = 87.234},
       [2] = {x = 481.63015, y = -982.1334, z = 41.006763, h = 91.873512},
       [3] = {x = 1893.71, y = 3697.82, z = 32.88, h = 213.31},
       [4] = {x = -475.43, y = 5988.353, z = 31.716, h = 31.34},
   },
   ["boat"] = {
       [1] = {x = -789.27, y = -1486.10, z = 0.26, h = 105.81},
	   [2] = {x = -1613.35, y = -1168.50, z = 0.33, h = 126.32},
	   [3] = {x = 1583.26, y = 3861.79, z = 30.19, h = 68.31},
	   [4] = {x = -723.85, y = 6115.57, z = 0.12, h = 24.24},
   },
   ["armory"] = {
       [1] = {x = 482.46997, y = -994.7919, z = 30.689701, h = 0.7731413, l = 0.5, w = 1.2, minZ = 29.889701, maxZ = 31.489701},
       [2] = {x = 1842.6733, y = 3689.9104, z = 34.267086, h = 209.652, l = 0.8, w = 1.1, minZ = 33.367086, maxZ = 35.067086},
       [3] = {x = 1841.4768, y = 3689.8164, z = 34.267086, h = 178.23878, l = 0.7, w = 1.0, minZ = 33.367086, maxZ = 34.967086},
       [4] = {x = -435.3767, y = 5997.6293, z = 31.71607, h = 224.56816, l = 0.8, w = 1.0, minZ = 30.71607, maxZ = 32.389701},
       [5] = {x = -434.6308, y = 5998.2983, z = 31.71607, h = 224.56816, l = 0.8, w = 1.0, minZ = 30.71607, maxZ = 32.389701},
       [6] = {x = -433.9764, y = 5999.0429, z = 31.71607, h = 224.56816, l = 0.8, w = 1.0, minZ = 30.71607, maxZ = 32.389701},
   }, 
   ["jail"] = {
       [1] = {x = 1763.052, y = 2591.579, z = 49.71, h = 90.55, l = 0.7, w = 3.0, minZ = 48.599662, maxZ = 50.589662},
   },
   ["trash"] = {
       [1] = {x = 471.9498, y = -996.4371, z = 26.273391, h = 88.421257, l = 0.9, w = 2.3, minZ = 25.37834, maxZ = 28.27834},
   },
   ["property"] = {
       [1] = {x = 444.59, y = -987.46, z = 30.68, h = 272.23},
   },
   ["fingerprint"] = {
       [1] = {x = 473.67401, y = -1013.407, z = 26.273426, h = 179.79368},
       [2] = {x = 1848.60, y = 3680.75, z = 30.25, h = 115.46},
       [3] = {x = -442.38, y = 6011.9, z = 27.98, h = 311.5},
   },
   ["evidence"] = {
       [1] = {x = 474.0357, y = -1004.515, z = 26.2734, h = 0.1609873, l = 0.9, w = 1.1, minZ = 25.37834, maxZ = 27.27834},
   },

   ["evidence2"] = {
       [1] =  {x = 471.9217, y = -994.059, z = 26.273391, h = 91.455833, l = 0.9, w = 2.3, minZ = 25.37834, maxZ = 28.27834},
   },

   ["evidence3"] = {
       [1] = {x = 475.8264, y = -996.6343, z = 26.273387, h = 269.1004, l = 0.9, w = 2.3, minZ = 25.37834, maxZ = 28.27834},
   },

   ["evidence4"] = {
       [1] = {x = 475.8095, y = -994.0399, z = 26.273387, h = 273.86346, l = 0.9, w = 2.3, minZ = 25.37834, maxZ = 28.27834},
   },

   ["evidence5"] = {
       [1] = {x = -439.8393, y = 6011.737, z = 27.98, h = 44.5, l = 0.9, w = 2.6, minZ = 27.07834, maxZ = 29.27834},
       [2] = {x = -439.7186, y = 6009.156, z = 27.98, h = 134.5, l = 0.9, w = 2.6, minZ = 27.07834, maxZ = 29.27834},
   },
   ["evidence6"] = {
       [1] = {x = 1855.131, y = 3700.189, z = 34.26, h = 30.88, l = 0.9, w = 2.4, minZ = 33.27834, maxZ = 35.57834},
       [2] = {x = 1854.647, y = 3698.404, z = 34.26, h = 120.0, l = 0.9, w = 2.0, minZ = 33.27834, maxZ = 35.57834},
   },
    ["prison"] = {
       [1] = {label = "Prison", coords = {x = 1845.903, y = 2585.873, z = 45.672, h = 272.249}},
    },
   ["stations"] = {
       [1] = {label = "Police Station 1", coords = {x = 428.23, y = -984.28, z = 29.76, h = 3.5}},
       [2] = {label = "Police Station 2", coords = {x = -451.55, y = 6014.25, z = 31.716, h = 223.81}},
       [3] = {label = "Police Station 3", coords = {x = 1856.36, y = 3681.32, z = 34.26, h = 212.73}},
   },
   ["boss"] = {
        [1] = {x = 461.4661, y = -986.1932, z = 30.728078, h = 170.48483, l = 0.4, w = 0.5, minZ = 30.62834, maxZ = 30.77834},
        [2] = {x = -446.6255, y = 6013.573, z = 36.6272, h = 282.97558, l = 0.3, w = 0.4, minZ = 36.32834, maxZ = 36.47834},
        [3] = {x = 1861.573, y = 3690.147, z = 34.26, h = 331.00, l = 0.3, w = 0.4, minZ = 34.12834, maxZ = 34.27834},
    },
}

Config.Helicopter = "polas350"
Config.Boat = "predator"

Config.SecurityCameras = {
    hideradar = false,
    cameras = {
        [1] = {label = "Pacific Bank CAM#1", x = 257.45, y = 210.07, z = 109.08, r = {x = -25.0, y = 0.0, z = 28.05}, canRotate = false, isOnline = true},
        [2] = {label = "Pacific Bank CAM#2", x = 232.86, y = 221.46, z = 107.83, r = {x = -25.0, y = 0.0, z = -140.91}, canRotate = false, isOnline = true},
        [3] = {label = "Pacific Bank CAM#3", x = 252.27, y = 225.52, z = 103.99, r = {x = -35.0, y = 0.0, z = -74.87}, canRotate = false, isOnline = true},
        [4] = {label = "Limited Ltd Grove St. CAM#1", x = -53.1433, y = -1746.714, z = 31.546, r = {x = -35.0, y = 0.0, z = -168.9182}, canRotate = false, isOnline = true},
        [5] = {label = "Rob's Liqour Prosperity St. CAM#1", x = -1482.9, y = -380.463, z = 42.363, r = {x = -35.0, y = 0.0, z = 79.53281}, canRotate = false, isOnline = true},
        [6] = {label = "Rob's Liqour San Andreas Ave. CAM#1", x = -1224.874, y = -911.094, z = 14.401, r = {x = -35.0, y = 0.0, z = -6.778894}, canRotate = false, isOnline = true},
        [7] = {label = "Limited Ltd Ginger St. CAM#1", x = -718.153, y = -909.211, z = 21.49, r = {x = -35.0, y = 0.0, z = -137.1431}, canRotate = false, isOnline = true},
        [8] = {label = "24/7 Supermarket Innocence Blvd. CAM#1", x = 23.885, y = -1342.441, z = 31.672, r = {x = -35.0, y = 0.0, z = -142.9191}, canRotate = false, isOnline = true},
        [9] = {label = "Rob's Liqour El Rancho Blvd. CAM#1", x = 1133.024, y = -978.712, z = 48.515, r = {x = -35.0, y = 0.0, z = -137.302}, canRotate = false, isOnline = true},
        [10] = {label = "Limited Ltd West Mirror Drive CAM#1", x = 1151.93, y = -320.389, z = 71.33, r = {x = -35.0, y = 0.0, z = -119.4468}, canRotate = false, isOnline = true},
        [11] = {label = "24/7 Supermarket Clinton Ave CAM#1", x = 383.402, y = 328.915, z = 105.541, r = {x = -35.0, y = 0.0, z = 118.585}, canRotate = false, isOnline = true},
        [12] = {label = "Limited Ltd Banham Canyon Dr CAM#1", x = -1832.057, y = 789.389, z = 140.436, r = {x = -35.0, y = 0.0, z = -91.481}, canRotate = false, isOnline = true},
        [13] = {label = "Rob's Liqour Great Ocean Hwy CAM#1", x = -2966.15, y = 387.067, z = 17.393, r = {x = -35.0, y = 0.0, z = 32.92229}, canRotate = false, isOnline = true},
        [14] = {label = "24/7 Supermarket Ineseno Road CAM#1", x = -3046.749, y = 592.491, z = 9.808, r = {x = -35.0, y = 0.0, z = -116.673}, canRotate = false, isOnline = true},
        [15] = {label = "24/7 Supermarket Barbareno Rd. CAM#1", x = -3246.489, y = 1010.408, z = 14.705, r = {x = -35.0, y = 0.0, z = -135.2151}, canRotate = false, isOnline = true},
        [16] = {label = "24/7 Supermarket Route 68 CAM#1", x = 539.773, y = 2664.904, z = 44.056, r = {x = -35.0, y = 0.0, z = -42.947}, canRotate = false, isOnline = true},
        [17] = {label = "Rob's Liqour Route 68 CAM#1", x = 1169.855, y = 2711.493, z = 40.432, r = {x = -35.0, y = 0.0, z = 127.17}, canRotate = false, isOnline = true},
        [18] = {label = "24/7 Supermarket Senora Fwy CAM#1", x = 2673.579, y = 3281.265, z = 57.541, r = {x = -35.0, y = 0.0, z = -80.242}, canRotate = false, isOnline = true},
        [19] = {label = "24/7 Supermarket Alhambra Dr. CAM#1", x = 1966.24, y = 3749.545, z = 34.143, r = {x = -35.0, y = 0.0, z = 163.065}, canRotate = false, isOnline = true},
        [20] = {label = "24/7 Supermarket Senora Fwy CAM#2", x = 1729.522, y = 6419.87, z = 37.262, r = {x = -35.0, y = 0.0, z = -160.089}, canRotate = false, isOnline = true},
        [21] = {label = "Fleeca Bank Hawick Ave CAM#1", x = 309.341, y = -281.439, z = 55.88, r = {x = -35.0, y = 0.0, z = -146.1595}, canRotate = false, isOnline = true},
        [22] = {label = "Fleeca Bank Legion Square CAM#1", x = 144.871, y = -1043.044, z = 31.017, r = {x = -35.0, y = 0.0, z = -143.9796}, canRotate = false, isOnline = true},
        [23] = {label = "Fleeca Bank Hawick Ave CAM#2", x = -355.7643, y = -52.506, z = 50.746, r = {x = -35.0, y = 0.0, z = -143.8711}, canRotate = false, isOnline = true},
        [24] = {label = "Fleeca Bank Del Perro Blvd CAM#1", x = -1214.226, y = -335.86, z = 39.515, r = {x = -35.0, y = 0.0, z = -97.862}, canRotate = false, isOnline = true},
        [25] = {label = "Fleeca Bank Great Ocean Hwy CAM#1", x = -2958.885, y = 478.983, z = 17.406, r = {x = -35.0, y = 0.0, z = -34.69595}, canRotate = false, isOnline = true},
        [26] = {label = "Paleto Bank CAM#1", x = -102.939, y = 6467.668, z = 33.424, r = {x = -35.0, y = 0.0, z = 24.66}, canRotate = false, isOnline = true},
        [27] = {label = "Del Vecchio Liquor Paleto Bay", x = -163.75, y = 6323.45, z = 33.424, r = {x = -35.0, y = 0.0, z = 260.00}, canRotate = false, isOnline = true},
        [28] = {label = "Don's Country Store Paleto Bay CAM#1", x = 166.42, y = 6634.4, z = 33.69, r = {x = -35.0, y = 0.0, z = 32.00}, canRotate = false, isOnline = true},
        [29] = {label = "Don's Country Store Paleto Bay CAM#2", x = 163.74, y = 6644.34, z = 33.69, r = {x = -35.0, y = 0.0, z = 168.00}, canRotate = false, isOnline = true},
        [30] = {label = "Don's Country Store Paleto Bay CAM#3", x = 169.54, y = 6640.89, z = 33.69, r = {x = -35.0, y = 0.0, z = 5.78}, canRotate = false, isOnline = true},
        [31] = {label = "Vangelico CAM#1", x = -627.54, y = -239.74, z = 40.33, r = {x = -35.0, y = 0.0, z = 5.78}, canRotate = true, isOnline = true},
        [32] = {label = "Vangelico CAM#2", x = -627.51, y = -229.51, z = 40.24, r = {x = -35.0, y = 0.0, z = -95.78}, canRotate = true, isOnline = true},
        [33] = {label = "Vangelico CAM#3", x = -620.3, y = -224.31, z = 40.23, r = {x = -35.0, y = 0.0, z = 165.78}, canRotate = true, isOnline = true},
        [34] = {label = "Vangelico CAM#4", x = -622.57, y = -236.3, z = 40.31, r = {x = -35.0, y = 0.0, z = 5.78}, canRotate = true, isOnline = true},
    },
}

Config.Vehicles = {
    ["npolvic"] = "Polvic",
    ["POLTAURUS"] = "Taurus",
    ["POLTAH"] = "Tahoe",
    ["2015POLSTANG"] = "Mustang",
    ["POLCHAR"] = "Dodge Charger",
    ["pbus2"] = "Prison Bus",
    ["riot"] = "Riot Van",
    ["pol8"] = "Motorbike",
    ["npolstang"] = "Pursuit Mustang",
    ["npolvette"] = "Pursuit Corvette",
    ["npolchal"] = "Pursuit Challenger",
    ["polraptor"] = "Raptor",
}

Config.AmmoLabels = {
    ["AMMO_PISTOL"] = "9x19mm Pistol Ammo",
    ["AMMO_SMG"] = "9x19mm SMG Ammo",
    ["AMMO_RIFLE"] = "7.62x39mm Rifle Ammo",
    ["AMMO_MG"] = "7.92x57mm MG Ammo",
    ["AMMO_SHOTGUN"] = "12 Shotgun shells",
    ["AMMO_SNIPER"] = "Sniper bullet",
}

Config.Radars = {
	{x = -623.44421386719, y = -823.08361816406, z = 25.25704574585, h = 145.0 },
	{x = -652.44421386719, y = -854.08361816406, z = 24.55704574585, h = 325.0 },
	{x = 1623.0114746094, y = 1068.9924316406, z = 80.903594970703, h = 84.0 },
	{x = -2604.8994140625, y = 2996.3391113281, z = 27.528566360474, h = 175.0 },
	{x = 2136.65234375, y = -591.81469726563, z = 94.272926330566, h = 318.0 },
	{x = 2117.5764160156, y = -558.51013183594, z = 95.683128356934, h = 158.0 },
	{x = 406.89505004883, y = -969.06286621094, z = 29.436267852783, h = 33.0 },
	{x = 657.315, y = -218.819, z = 44.06, h = 320.0 },
	{x = 2118.287, y = 6040.027, z = 50.928, h = 172.0 },
	{x = -106.304, y = -1127.5530, z = 30.778, h = 230.0 },
	{x = -823.3688, y = -1146.980, z = 8.0, h = 300.0 },
}

Config.CarItems = {
    [1] = {
        name = "weapon_fireextinguisher",
        amount = 1,
        info = {},
        type = "weapon",
        slot = 1,
    },
}

Config.Items = {
    label = "Police Weapon Safe",
    slots = 1,
    items = {
        [1] = {
            name = "weapon_pistol_mk2",
            price = 100,
            amount = 3,
            info = {
                serie = "",                
                attachments = {
                    {component = "COMPONENT_PISTOL_MK2_CLIP_02", label = "Extended"},
                    {component = "COMPONENT_AT_PI_FLSH_02", label = "Flashlight"},
                }
            },
            type = "weapon",
            slot = 1,
        },
        [2] = {
            name = "weapon_glock",
            price = 100,
            amount = 3,
            info = {
                serie = "",                
                attachments = {
                    {component = "COMPONENT_GLOCK_CLIP_01", label = "Extended"},
                    {component = "COMPONENT_AT_GLOCK_FLSH", label = "Flashlight"},
                }
            },
            type = "weapon",
            slot = 2,
        },
        [3] = {
            name = "weapon_combatpdw",
            price = 150,
            amount = 2,
            info = {
                serie = "",                
                attachments = {
                    {component = "COMPONENT_COMBATPDW_CLIP_02", label = "Extended"},
                    {component = "COMPONENT_AT_AR_FLSH", label = "Flashlight"},
                    {component = "COMPONENT_AT_AR_AFGRIP", label = "Grip"},
                    {component = "COMPONENT_AT_SCOPE_SMALL", label = "Scope"},
                }
            },
            type = "weapon",
            slot = 3,
        },
        [4] = {
            name = "weapon_m4",
            price = 200,
            amount = 2,
            info = {
                serie = "",                
                attachments = {
                    {component = "COMPONENT_M4_CLIP_02", label = "Extended"},
                    {component = "COMPONENT_AT_M4_FLSH", label = "Flashlight"},
                    {component = "COMPONENT_AT_SCOPE_M4", label = "Scope"},
                    {component = "COMPONENT_AT_M4_AFGRIP", label = "Grip"},
                }
            },
            type = "weapon",
            slot = 4,
        },
        [5] = {
            name = "weapon_carbinerifle_mk2",
            price = 250,
            amount = 1,
            info = {
                serie = "",                
                attachments = {
                    {component = "COMPONENT_CARBINERIFLE_CLIP_02", label = "Extended"},
                    {component = "COMPONENT_AT_AR_FLSH", label = "Flashlight"},
                    {component = "COMPONENT_AT_AR_AFGRIP", label = "Grip"},
                }
            },
            type = "weapon",
            slot = 5,
        }, 
        [6] = {
            name = "weapon_taser",
            price = 50,
            amount = 3,
            info = {},
            type = "weapon",
            slot = 6,
        },
        [7] = {
            name = "weapon_fireextinguisher",
            price = 25,
            amount = 1,
            info = {},
            type = "weapon",
            slot = 7,
        },
        [8] = {
            name = "weapon_flashlight",
            price = 25,
            amount = 3,
            info = {},
            type = "weapon",
            slot = 8,
        },
        [9] = {
            name = "weapon_nightstick",
            price = 25,
            amount = 3,
            info = {},
            type = "weapon",
            slot = 9,
        },
        [10] = {
            name = "handcuffs",
            price = 20,
            amount = 10,
            info = {},
            type = "item",
            slot = 10,
        },
        [11] = {
            name = "binoculars",
            price = 20,
            amount = 5,
            info = {},
            type = "item",
            slot = 11,
        },
        [12] = {
            name = "diving_gear",
            price = 20,
            amount = 2,
            info = {},
            type = "item",
            slot = 12,
        }, 
        [13] = {
            name = "parachute",
            price = 20,
            amount = 2,
            info = {},
            type = "item",
            slot = 13,
        }, 
        [14] = {
            name = "pdvest",
            price = 200,
            amount = 50,
            info = {},
            type = "item",
            slot = 14,
        },
        [15] = {
            name = "phone",
            price = 150,
            amount = 50,
            info = {},
            type = "item",
            slot = 15,
        },
        [16] = {
            name = "radio",
            price = 150,
            amount = 50,
            info = {},
            type = "item",
            slot = 16,
        },
        [17] = {
            name = "empty_evidence_bag",
            price = 2,
            amount = 25,
            info = {},
            type = "item",
            slot = 17,
        },
        [18] = {
            name = "taser_ammo",
            price = 2,
            amount = 100,
            info = {},
            type = "item",
            slot = 18,
        },
        [19] = {
            name = "pd_pistol_ammo",
            price = 7.5,
            amount = 100,
            info = {},
            type = "item",
           slot = 19,
        },
        [20] = {
            name = "pd_rifle_ammo",
            price = 40,
            amount = 100,
            info = {},
            type = "item",
           slot = 20,
        },     
        [21] = {
            name = "pd_smg_ammo",
            price = 25,
            amount = 100,
            info = {},
            type = "item",
           	slot = 21,
        },
        [22] = {
            name = "police_stormram",
            price = 1000,
            amount = 10,
            info = {},
            type = "item",
            slot = 22,
        },
        [23] = {
            name = "signalradar",
            price = 10,
            amount = 500,
            info = {},
            type = "item",
            slot = 23,
        },
        [24] = {
            name = "ifak",
            price = 25,
            amount = 30,
            info = {},
            type = "item",
            slot = 24,
        }, 
        [25] = {
            name = "adrenaline",
            price = 300,
            amount = 30,
            info = {},
            type = "item",
            slot = 25,
        }, 
        [26] = {
            name = "advancedrepairkit",
            price = 0,
            amount = 30,
            info = {},
            type = "item",
            slot = 26,
        }
    }
}

Config.JailItems = {
    label = "Jail Weapon Safe",
    slots = 1,
    items = {
        [1] = {
            name = "weapon_stungun",
            price = 150,
            amount = 3,
            info = {},
            type = "weapon",
            slot = 1,
        },
        [2] = {
            name = "weapon_nightstick",
            price = 0,
            amount = 3,
            info = {},
            type = "weapon",
            slot = 2,
        },
        [3] = {
            name = "weapon_flashlight",
            price = 150,
            amount = 3,
            info = {},
            type = "weapon",
            slot = 3,
        },
        [4] = {
            name = "handcuffs",
            price = 0,
            amount = 10,
            info = {},
            type = "item",
            slot = 4,
        },
        [5] = {
            name = "binoculars",
            price = 300,
            amount = 5,
            info = {},
            type = "item",
            slot = 5,
        },
        [6] = {
            name = "heavyarmor",
            price = 100,
            amount = 50,
            info = {},
            type = "item",
            slot = 6,
        },
        [7] = {
            name = "radio",
            price = 350,
            amount = 50,
            info = {},
            type = "item",
            slot = 7,
		},
        [8] = {
            name = "ifak",
            price = 150,
            amount = 100,
            info = {},
            type = "item",
            slot = 8,
        }
    }
}
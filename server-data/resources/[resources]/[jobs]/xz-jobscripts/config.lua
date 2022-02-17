Keys = {
    ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
    ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
    ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
    ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
    ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
    ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
    ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DEL'] = 178,
    ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}

Config = {}

Config.Pickups = {
    ["burgershot1"] = {
        name = "burgershot1",
        coords = vector3(-1195.93, -891.3494, 14.076261),
        length = 0.9,
        width = 0.6,
        heading = 303.0,
        debugPoly = false,
        minZ = 13.9,
        maxZ = 14.5,
        options = {
            {
                event = 'burgershot:pickup1',
                icon = 'fas fa-search',
                label = 'Pickup Order'
            },
            {
                event = 'xz-jobscripts:client:startJobPickup',
                label = 'Start Delivery',
                icon = 'fas fa-circle'
            }
        },
        distance = 2.5
    },

    ["burgershot2"] = {
        name = "burgershot2",
        coords = vector3(-1194.918, -892.8637, 13.984725),
        length = 0.9,
        width = 0.6,
        heading = 303.0,
        debugPoly = false,
        minZ = 13.9,
        maxZ = 14.5,
        options = {
            {
                event = 'burgershot:pickup2',
                icon = 'fas fa-search',
                label = 'Pickup Order'
            }
        },
        distance = 2.5
    },

    ["burgershot3"] = {
        name = "burgershot3",
        coords = vector3(-1193.775, -907.0484, 13.98473),
        length = 0.8,
        width = 1.2,
        heading = 350.0,
        debugPoly = false,
        minZ = 14.0,
        maxZ = 14.2,
        options = {
            {
                event = 'burgershot:pickup1',
                icon = 'fas fa-search',
                label = 'Pickup Order'
            }
        },
        distance = 2.5
    },

    ["burgershot4"] = {
        name = "burgershot4",
        coords = vector3(-1197.746, -893.8963, 13.984728),
        length = 1.0,
        width = 3.0,
        heading = 125.0,
        debugPoly = false,
        minZ = 13.0,
        maxZ = 14.7,
        options = {
            {
                event = 'burgershot:pickup4',
                icon = 'fas fa-search',
                label = 'Pickup Order',
                job = 'burgershot'
            }
        },
        distance = 2.5
    },

    --[[ ["pizza1"] = {
        name = "pizza1",
        coords = vector3(279.74414, -974.9084, 29.823194),
        length = 1.5,
        width = 1.6,
        heading = 12.0,
        debugPoly = false,
        minZ = 13.0,
        maxZ = 15.0,
        options = {
            {
                event = 'pizza:pickup3',
                icon = 'fas fa-circle',
                label = 'Take Food'
            }
        },
        distance = 2.5
    } ]]
}

Config.Jobs = {
    -- ['taco'] = {
    --     ['name'] = 'taco',

    --     ['blip'] = {
    --         coords = vector3(8.0058841, -1604.92, 29.365726),
    --         name = 'Taco Shop',
    --         color = 60,
    --         sprite = 209,
    --         display = 4,
    --         scale = 0.7,
    --     },

    --     ['settings'] = {
    --         runtimer = 5,
    --         private_deliveries = false,
    --         name = 'Taco run',
    --         cooking = 'Press ~g~E~w~ to make tacos',
    --         packaging = 'Press ~g~E~w~ to package tacos',
    --         ready = "Press ~g~E~w~ to put bag out for delivery",
    --         cancle = "Press ~g~E~w~ to cancel delivery",
    --         food_item = 'taco',
    --         bag_item = 'taco-bag',
    --         timedout = 'Your run just timed out!',

    --         made_items = "You made some tacos..",
    --         packed_items = "You packed few tacos..",
    --         not_enoght = "The customer wants more then 2 tacos lmao",
    --         preparing = "Preparing Delivery..",
    --         pickup = "Press ~g~E~w~ to deliver food.",
    --         dropoff = "Press ~g~E~w~ to drop off package.",
    --         boss = "Press ~g~E~w~ to open boss menu",
    --         shop = "Press ~g~E~w~ to open the shop",

    --         payment = {55, 125},
    --     },

    --     ['shopitems'] = {
    --         [1] = {
    --             name = "fishtaco",
    --             price = 10,
    --             amount = 5,
    --             info = {},
    --             type = "item",
    --             slot = 1,
    --         },
    --         [2] = {
    --             name = "torpedo",
    --             price = 10,
    --             amount = 5,
    --             info = {},
    --             type = "item",
    --             slot = 2,
    --         },
    --         [3] = {
    --             name = "torta",
    --             price = 10,
    --             amount = 5,
    --             info = {},
    --             type = "item",
    --             slot = 3,
    --         },
    --         [4] = {
    --             name = "eggsbacon",
    --             price = 20,
    --             amount = 5,
    --             info = {},
    --             type = "item",
    --             slot = 4,
    --         },
    --         [5] = {
    --             name = "churro",
    --             price = 20,
    --             amount = 5,
    --             info = {},
    --             type = "item",
    --             slot = 5,
    --         },
    --         [6] = {
    --             name = "hotdog",
    --             price = 20,
    --             amount = 5,
    --             info = {},
    --             type = "item",
    --             slot = 6,
    --         },
    --         [7] = {
    --             name = "greencow",
    --             price = 20,
    --             amount = 5,
    --             info = {},
    --             type = "item",
    --             slot = 7,
    --         },
    --         [8] = {
    --             name = "donut",
    --             price = 5,
    --             amount = 5,
    --             info = {},
    --             type = "item",
    --             slot = 8,
    --         },
    --         [9] = {
    --             name = "spirte",
    --             price = 3,
    --             amount = 5,
    --             info = {},
    --             type = "item",
    --             slot = 9,
    --         }, 			
    --         [10] = {
    --             name = "cocacola",
    --             price = 3,
    --             amount = 5,
    --             info = {},
    --             type = "item",
    --             slot = 10,
    --         }, 
    --         [11] = {
    --             name = "water_bottle",
    --             price = 3,
    --             amount = 5,
    --             info = {},
    --             type = "item",
    --             slot = 11,
    --         }   
    --     },

    --     ['locations'] = {
    --         cook = vector3(11.30451, -1599.315, 29.375711),
    --         packaging = vector3(17.040874, -1599.736, 29.377927),
    --         ready = vector3(7.1598858, -1605.184, 29.371147),
    --         pickup = vector3(4.6257419, -1605.361, 29.318107),
    --         cancle = vector3(6.4681196, -1612.416, 29.298511),
    --         boss = vector3(16.851915, -1606.724, 29.390621),
    --         shop = vector3(20.285358, -1602.047, 29.377981),
    --     }
    -- },
    --[[['pizza'] = {
        ['name'] = 'pizza',
        
        ['blip'] = {
            coords = vector3(283.80258, -969.8561, 29.871028),
            name = 'Pizza',
            color = 25,
            sprite = 267,
            display = 4,
            scale = 0.7,
        },
        ['settings'] = {
            runtimer = 5,
            private_deliveries = false,
            name = 'Pizza Run',
            cooking = 'Press ~g~E~w~ to make pizza',
            packaging = 'Press ~g~E~w~ to package pizza',
            ready = "Press ~g~E~w~ to put bag out for delivery",
            cancle = "Press ~g~E~w~ to cancel delivery",
            food_item = 'pizza',
            bag_item = 'pizzabox',
            timedout = 'Your run just timed out!',

            made_items = "You made some pizzas..",
            packed_items = "You packed few pizzas..",
            not_enoght = "The customer wants more then 2 pizzas lmao",
            preparing = "Preparing Delivery..",
            pickup = "Press ~g~E~w~ to deliver pizzas.",
            dropoff = "Press ~g~E~w~ to drop off package.",
            boss = "Press ~g~E~w~ to open boss menu",
            shop = "Press ~g~E~w~ to open the shop",

            payment = {55, 125},
        },
        ['shopitems'] = {
            [1] = {
                name = "mshake",
                price = 6,
                amount = 5,
                info = {},
                type = "item",
                slot = 1,
            },
            [2] = {
                name = "waffle",
                price = 6,
                amount = 5,
                info = {},
                type = "item",
                slot = 2,
            },
            [3] = {
                name = "donut",
                price = 5,
                amount = 5,
                info = {},
                type = "item",
                slot = 3,
            },
            [4] = {
                name = "frenchtoast",
                price = 6,
                amount = 5,
                info = {},
                type = "item",
                slot = 4,
            },
            [5] = {
                name = "capuchino",
                price = 5,
                amount = 5,
                info = {},
                type = "item",
                slot = 5,
            },
            [6] = {
                name = "frappuccino",
                price = 5,
                amount = 5,
                info = {},
                type = "item",
                slot = 6,
            },
            [7] = {
                name = "latte",
                price = 5,
                amount = 5,
                info = {},
                type = "item",
                slot = 7,
            },
            [8] = {
                name = "icecream",
                price = 5,
                amount = 5,
                info = {},
                type = "item",
                slot = 8,
            },
            [9] = {
                name = "spirte",
                price = 3,
                amount = 5,
                info = {},
                type = "item",
                slot = 9,
			},
            [10] = {
                name = "cocacola",
                price = 3,
                amount = 5,
                info = {},
                type = "item",
                slot = 10,
			},
            [11] = {
                name = "water_bottle",
                price = 3,
                amount = 5,
                info = {},
                type = "item",
                slot = 11,
            }
        },
        ['locations'] = {
            shop = vector3(275.21463, -977.0054, 29.868488),
            cook = vector3(271.73715, -975.2576, 29.868707),
            packaging = vector3(278.65982, -976.9053, 29.871288),
            ready = vector3(282.14172, -975.6256, 29.871347),
            pickup = vector3(282.27062, -974.0377, 29.870456),
            cancle = vector3(279.57278, -973.9963, 29.871084),
            boss = vector3(285.84875, -978.2113, 29.871379),
        }
    },]]
    ['burgershot'] = {
        ['name'] = 'burgershot',

        ['blip'] = {
            coords = vector3(-1199.911, -900.4355, 13.995184),
            name = 'Burger Shot',
            color = 8,
            sprite = 106,
            display = 4,
            scale = 0.7,
        },

        ['settings'] = {
            runtimer = 5,
            private_deliveries = false,
            name = 'Burgers run',
            cooking = 'Press ~g~E~w~ to make burger',
            packaging = 'Press ~g~E~w~ to package burgers',
            ready = "Press ~g~E~w~ to put bag out for delivery",
            cancle = "Press ~g~E~w~ to cancel delivery",
            food_item1 = 'burger',
            food_item2 = 'fries',
            bag_item = 'burger-bag',
            timedout = 'Your run just timed out!',

            made_items1 = "You made a burger..",
            made_items2 = "You made some fries..",
            packed_items = "You packed few burgers..",
            not_enoght = "The customer wants more then 2 burgers lmao",
            preparing = "Preparing Delivery..",
            pickup = "Press ~g~E~w~ to deliver burgers.",
            dropoff = "Press ~g~E~w~ to drop off package.",
            boss = "Press ~g~E~w~ to open boss menu",
            shop = "Press ~g~E~w~ to open the shop",

            payment = {55, 125},
        },

        ['shopitems'] = {
            [1] = {
                name = "fowlburger",
                price = 10,
                amount = 5,
                info = {},
                type = "item",
                slot = 1,
            },
            [2] = {
                name = "meatfree",
                price = 10,
                amount = 5,
                info = {},
                type = "item",
                slot = 2,
            },
            [3] = {
                name = "heartstopper",
                price = 10,
                amount = 5,
                info = {},
                type = "item",
                slot = 3,
            },
            [4] = {
                name = "bleederburger",
                price = 10,
                amount = 5,
                info = {},
                type = "item",
                slot = 4,
            },
            [5] = {
                name = "fries",
                price = 7,
                amount = 5,
                info = {},
                type = "item",
                slot = 5,
            },
            [6] = {
                name = "wings",
                price = 7,
                amount = 5,
                info = {},
                type = "item",
                slot = 6,
            },
            [7] = {
                name = "donut",
                price = 5,
                amount = 5,
                info = {},
                type = "item",
                slot = 7,
            },
            [8] = {
                name = "beer",
                price = 5,
                amount = 5,
                info = {},
                type = "item",
                slot = 8,
            },
            [9] = {
                name = "spirte",
                price = 3,
                amount = 5,
                info = {},
                type = "item",
                slot = 9,
            },
            [10] = {
                name = "cocacola",
                price = 3,
                amount = 5,
                info = {},
                type = "item",
                slot = 10,
            },
            [11] = {
                name = "bscoffee",
                price = 5,
                amount = 5,
                info = {},
                type = "item",
                slot = 11,
            },
            [12] = {
                name = "softdrink",
                price = 5,
                amount = 5,
                info = {},
                type = "item",
                slot = 12,
            },
            [13] = {
                name = "water_bottle",
                price = 3,
                amount = 5,
                info = {},
                type = "item",
                slot = 13,
            }
        },

        ['locations'] = {
            shop = {coords = vector3(-1196.505, -902.0673, 13.98473), length = 0.8, width = 1.4, heading = 215.0, minZ = 13.0, maxZ = 15.5, job = 'burgershot', event = 'xz-jobscripts:client:openJobShop', label = 'Open Shop', distance = 2.5, icon = 'fas fa-circle'},
            cook1 = {coords = vector3(-1202.889, -897.2893, 13.984732), length = 1.1, width = 1.5, heading = 125.0, minZ = 13.0, maxZ = 14.2, job = 'burgershot', event = 'xz-jobscripts:client:startJobCook1', label = 'Make a burger', distance = 2.5, icon = 'fas fa-circle'},
            cook2 = {coords = vector3(-1201.982, -898.7389, 13.984732), length = 1.1, width = 1.5, heading = 125.0, minZ = 13.0, maxZ = 14.2, job = 'burgershot', event = 'xz-jobscripts:client:startJobCook2', label = 'Make fries', distance = 2.5, icon = 'fas fa-circle'},
            packaging = {coords = vector3(-1196.353, -905.0533, 13.984731), length = 0.8, width = 2.3, heading = 124.0, minZ = 13.0, maxZ = 14.3, job = 'burgershot', event = 'xz-jobscripts:client:startJobPackage', label = 'Start Packaging', distance = 2.5, icon = 'fas fa-circle'},
            ready = {coords = vector3(-1193.887, -894.3522, 14.1), length = 0.9, width = 0.6, heading = 125.0, minZ = 13.9, maxZ = 14.5, job = 'burgershot', event = 'xz-jobscripts:client:jobReadyDelivery', label = 'Put bag here', distance = 2.5, icon = 'fas fa-circle'},
            cancle = {coords = vector3(-1190.463, -893.4804, 13.984732), length = 1.0, width = 1.0, heading = 125.0, minZ = 13.0, maxZ = 14.0, event = 'xz-jobscripts:client:cancelJobDelivery', label = 'Cancel Delivery', distance = 2.5, icon = 'fas fa-circle'},
            boss = {coords = vector3(-1178.224, -896.4282, 13.98472), length = 1.0, width = 2.5, heading = 124.0, minZ = 13.0, maxZ = 14.0, job = 'burgershot', event = 'xz-jobscripts:client:openJobBossMenu', label = 'Boss Menu', distance = 2.5, icon = 'fas fa-circle'},
            murdermeal = {coords = vector3(-1197.929, -891.4113, 13.884683), length = 1.0, width = 2.5, heading = 124.0, minZ = 13.0, maxZ = 14.0, job = 'burgershot', event = 'xz-burgershot:CreateMurderMeal', label = 'Murdermeal Package', distance = 2.5, icon = 'fas fa-circle'},
        }
    }
}

Config.DropOff = {
    Name = "Drop Off",
    Sprite = 514,
    Color = 4,
    Scale = 1.0,
}

Config.DropOffLocations = {
    ['taco'] = {
        [1] =  { ['x'] = -148.69,['y'] = -1687.35,['z'] = 36.17},
        [2] =  { ['x'] = -157.54,['y'] = -1679.61,['z'] = 36.97},
        [3] =  { ['x'] = -158.86,['y'] = -1680.02,['z'] = 36.97},
        [4] =  { ['x'] = -160.83,['y'] = -1637.93,['z'] = 34.03},
        [5] =  { ['x'] = -160.0,['y'] = -1636.41,['z'] = 34.03},
        [6] =  { ['x'] = -153.87,['y'] = -1641.77,['z'] = 36.86},
        [7] =  { ['x'] = -159.85,['y'] = -1636.42,['z'] = 37.25},
        [8] =  { ['x'] = -161.31,['y'] = -1638.13,['z'] = 37.25},
        [9] =  { ['x'] = -150.79,['y'] = -1625.26,['z'] = 33.66},
        [10] =  { ['x'] = -150.74,['y'] = -1622.68,['z'] = 33.66},
        [11] =  { ['x'] = -145.59,['y'] = -1617.88,['z'] = 36.05},
        [12] =  { ['x'] = -145.84,['y'] = -1614.71,['z'] = 36.05},
        [13] =  { ['x'] = -152.23,['y'] = -1624.37,['z'] = 36.85},
        [14] =  { ['x'] = -150.38,['y'] = -1625.5,['z'] = 36.85},
        [15] =  { ['x'] = -120.58,['y'] = -1575.04,['z'] = 34.18},
        [16] =  { ['x'] = -114.73,['y'] = -1579.95,['z'] = 34.18},
        [17] =  { ['x'] = -119.6,['y'] = -1585.41,['z'] = 34.22},
        [18] =  { ['x'] = -123.81,['y'] = -1590.67,['z'] = 34.21},
        [19] =  { ['x'] = -139.85,['y'] = -1598.7,['z'] = 34.84},
        [20] =  { ['x'] = -146.85,['y'] = -1596.64,['z'] = 34.84},
        [21] =  { ['x'] = -139.49,['y'] = -1588.39,['z'] = 34.25},
        [22] =  { ['x'] = -133.47,['y'] = -1581.2,['z'] = 34.21},
        [23] =  { ['x'] = -120.63,['y'] = -1575.05,['z'] = 37.41},
        [24] =  { ['x'] = -114.71,['y'] = -1580.4,['z'] = 37.41},
        [25] =  { ['x'] = -119.53,['y'] = -1585.26,['z'] = 37.41},
        [26] =  { ['x'] = -123.67,['y'] = -1590.39,['z'] = 37.41},
        [27] =  { ['x'] = -140.08,['y'] = -1598.75,['z'] = 38.22},
        [28] =  { ['x'] = -145.81,['y'] = -1597.55,['z'] = 38.22},
        [29] =  { ['x'] = -147.47,['y'] = -1596.26,['z'] = 38.22},
        [30] =  { ['x'] = -139.77,['y'] = -1587.8,['z'] = 37.41},
        [31] =  { ['x'] = -133.78,['y'] = -1580.56,['z'] = 37.41},
        [32] =  { ['x'] = -157.6,['y'] = -1680.11,['z'] = 33.44},
        [33] =  { ['x'] = -148.39,['y'] = -1688.04,['z'] = 32.88},
        [34] =  { ['x'] = -147.3,['y'] = -1688.99,['z'] = 32.88},
        [35] =  { ['x'] = -143.08,['y'] = -1692.38,['z'] = 32.88},
        [36] =  { ['x'] = -141.89,['y'] = -1693.43,['z'] = 32.88},
        [37] =  { ['x'] = -167.71,['y'] = -1534.71,['z'] = 35.1},
        [38] =  { ['x'] = -180.71,['y'] = -1553.51,['z'] = 35.13},
        [39] =  { ['x'] = -187.47,['y'] = -1562.96,['z'] = 35.76},
        [40] =  { ['x'] = -191.86,['y'] = -1559.4,['z'] = 34.96},
        [41] =  { ['x'] = -195.55,['y'] = -1556.06,['z'] = 34.96},
        [42] =  { ['x'] = -183.81,['y'] = -1540.59,['z'] = 34.36},
        [43] =  { ['x'] = -179.69,['y'] = -1534.66,['z'] = 34.36},
        [44] =  { ['x'] = -175.06,['y'] = -1529.53,['z'] = 34.36},
        [45] =  { ['x'] = -167.62,['y'] = -1534.9,['z'] = 38.33},
        [46] =  { ['x'] = -180.19,['y'] = -1553.89,['z'] = 38.34},
        [47] =  { ['x'] = -186.63,['y'] = -1562.32,['z'] = 39.14},
        [48] =  { ['x'] = -188.32,['y'] = -1562.5,['z'] = 39.14},
        [49] =  { ['x'] = -192.14,['y'] = -1559.64,['z'] = 38.34},
        [50] =  { ['x'] = -195.77,['y'] = -1555.92,['z'] = 38.34},
        [51] =  { ['x'] = -184.06,['y'] = -1539.83,['z'] = 37.54},
        [52] =  { ['x'] = -179.58,['y'] = -1534.93,['z'] = 37.54},
        [53] =  { ['x'] = -174.87,['y'] = -1529.18,['z'] = 37.54},
        [54] =  { ['x'] = -208.75,['y'] = -1600.32,['z'] = 34.87},
        [55] =  { ['x'] = -210.05,['y'] = -1607.17,['z'] = 34.87},
        [56] =  { ['x'] = -212.05,['y'] = -1616.86,['z'] = 34.87},
        [57] =  { ['x'] = -213.8,['y'] = -1618.07,['z'] = 34.87},
        [58] =  { ['x'] = -221.82,['y'] = -1617.45,['z'] = 34.87},
        [59] =  { ['x'] = -223.06,['y'] = -1601.38,['z'] = 34.89},
        [60] =  { ['x'] = -222.52,['y'] = -1585.71,['z'] = 34.87},
        [61] =  { ['x'] = -218.91,['y'] = -1580.06,['z'] = 34.87},
        [62] =  { ['x'] = -216.48,['y'] = -1577.45,['z'] = 34.87},
        [63] =  { ['x'] = -206.23,['y'] = -1585.55,['z'] = 34.87},
        [64] =  { ['x'] = -206.63,['y'] = -1585.8, ['z'] = 38.06},
        [65] =  { ['x'] = -216.05,['y'] = -1576.86,['z'] = 38.06},
        [66] =  { ['x'] = -218.37,['y'] = -1579.89,['z'] = 38.06},
        [67] =  { ['x'] = -222.25,['y'] = -1585.37,['z'] = 38.06},
        [68] =  { ['x'] = -222.26,['y'] = -1600.93,['z'] = 38.06},
        [69] =  { ['x'] = -222.21,['y'] = -1617.39,['z'] = 38.06},
        [70] =  { ['x'] = -214.12,['y'] = -1617.62,['z'] = 38.06},
        [71] =  { ['x'] = -212.29,['y'] = -1617.34,['z'] = 38.06},
        [72] =  { ['x'] = -210.46,['y'] = -1607.36,['z'] = 38.05},
        [73] =  { ['x'] = -209.45,['y'] = -1600.57,['z'] = 38.05},
        [74] =  { ['x'] = -216.64,['y'] = -1673.73,['z'] = 34.47},
        [75] =  { ['x'] = -224.15,['y'] = -1673.67,['z'] = 34.47},
        [76] =  { ['x'] = -224.17,['y'] = -1666.14,['z'] = 34.47},
        [77] =  { ['x'] = -224.32,['y'] = -1649.0,['z'] = 34.86},
        [78] =  { ['x'] = -216.34,['y'] = -1648.94,['z'] = 34.47},
        [79] =  { ['x'] = -212.92,['y'] = -1660.54,['z'] = 34.47},
        [80] =  { ['x'] = -212.95,['y'] = -1667.96,['z'] = 34.47},
        [81] =  { ['x'] = -216.55,['y'] = -1673.88,['z'] = 37.64},
        [82] =  { ['x'] = -224.34,['y'] = -1673.79,['z'] = 37.64},
        [83] =  { ['x'] = -223.99,['y'] = -1666.29,['z'] = 37.64},
        [84] =  { ['x'] = -224.44,['y'] = -1653.99,['z'] = 37.64},
        [85] =  { ['x'] = -223.96,['y'] = -1649.16,['z'] = 38.45},
        [86] =  { ['x'] = -216.44,['y'] = -1649.13,['z'] = 37.64},
        [87] =  { ['x'] = -212.85,['y'] = -1660.74,['z'] = 37.64},
        [88] =  { ['x'] = -212.72,['y'] = -1668.23,['z'] = 37.64},
        [89] =  { ['x'] = -141.79,['y'] = -1693.55,['z'] = 36.17},
        [90] =  { ['x'] = -142.19,['y'] = -1692.69,['z'] = 36.17},
        [91] =  { ['x'] = -147.39,['y'] = -1688.39,['z'] = 36.17},
        [92] =  { ['x'] = 179.94,['y'] = -1831.79,['z'] = 28.12},
        [93] =  { ['x'] = 212.34,['y'] = -1856.49,['z'] = 27.2},
        [94] =  { ['x'] = 174.48,['y'] = -2025.75,['z'] = 18.34},
        [95] =  { ['x'] = 409.69,['y'] = -1910.84,['z'] = 25.46},
        [96] =  { ['x'] = 450.73,['y'] = -1862.38,['z'] = 27.8},
        [97] =  { ['x'] = 482.94,['y'] = -1685.85,['z'] = 29.3},
        [98] =  { ['x'] = 225.16,['y'] = -1511.8,['z'] = 29.3},
        [99] =  { ['x'] = 168.77,['y'] = -1633.48,['z'] = 29.3},
        [100] =  { ['x'] = 161.63,['y'] = -1485.4,['z'] = 29.15},
        [101] =  { ['x'] = 83.58,['y'] = -1551.61,['z'] = 29.6},
        [102] =  { ['x'] = 95.02,['y'] = -1810.52,['z'] = 27.09},
        [103] =  { ['x'] = -297.78,['y'] = -1332.4,['z'] = 31.3},
        [104] =  { ['x'] = -1.58,['y'] = -1400.38,['z'] = 29.28},
        [105] =  { ['x'] = -10.81,['y'] = -1828.68,['z'] = 25.4},
    },

    ['pizza'] = {
        [1] =  { ['x'] = -613.2788,['y'] = 323.81179,['z'] = 82.261268},
        [2] =  { ['x'] = -742.789,['y'] = 247.28901,['z'] =77.332794},
        [3] =  { ['x'] = -819.3536,['y'] = 268.01205,['z'] = 86.395942},
        [4] =  { ['x'] = -877.4011,['y'] = 306.41491,['z'] = 84.154304},
        [5] =  { ['x'] = -842.7734,['y'] = 466.92758,['z'] = 87.601287},
        [6] =  { ['x'] = -850.4257,['y'] = 522.36022,['z'] = 90.622322},
        [7] =  { ['x'] = -907.7296,['y'] = 544.99822,['z'] = 100.40779},
        [8] =  { ['x'] = -761.8388,['y'] = 431.52124,['z'] = 100.19976},
        [9] =  { ['x'] = -622.8532,['y'] = 488.86599,['z'] = 108.87752},
        [10] =  { ['x'] = -207.0818,['y'] = 163.44096,['z'] = 74.05313},
        [11] =  { ['x'] = -476.8085,['y'] = 217.54107,['z'] = 83.702545},
        [12] =  { ['x'] = -207.4753,['y'] = 159.42839,['z'] = 74.053131},
        [13] =  { ['x'] = -655.0702, ['y'] = -414.2643, ['z'] = 35.479915 },
        [14] =  { ['x'] = -385.2475, ['y'] = 270.15991, ['z'] = 86.367485 },
        [15] =  { ['x'] = -413.9096, ['y'] = 220.52507, ['z'] = 83.427467 },
        [16] =  { ['x'] = -419.5444, ['y'] = 221.21493, ['z'] = 83.395278 },
        [17] =  { ['x'] = -394.2344, ['y'] = 208.50917, ['z'] = 83.632904 },
        [18] =  { ['x'] = -242.0425, ['y'] = 279.85229, ['z'] = 92.039863 },
        [19] =  { ['x'] = -178.7237, ['y'] = 314.27059, ['z'] = 97.964214 },
        [20] = { ['x'] = -92.77323, ['y'] = 233.14714, ['z'] = 100.58019 },
        [21] = { ['x'] = -40.53652, ['y'] = 227.85008, ['z'] = 107.96794 },
        [22] =  { ['x'] = 81.467658, ['y'] = 275.05633, ['z'] = 110.21013 },
        [23] =  { ['x'] = -60.9231, ['y'] = 360.48562, ['z'] = 113.05636 },
        [24] =  { ['x'] = -102.9935, ['y'] = 397.4869, ['z'] = 112.65986 },
        [25] =  { ['x'] = -54.15459, ['y'] = 374.72796, ['z'] = 112.43081 },
        [26] =  { ['x'] = -72.9051, ['y'] = 428.51367, ['z'] = 113.03815 },
        [27] =  { ['x'] = -6.494105, ['y'] = 409.04806, ['z'] = 120.2888 },
        [28] =  { ['x'] = 22.056957, ['y'] = 173.87936, ['z'] = 101.11345 },
        [29] =  { ['x'] = -37.57359, ['y'] = 170.36849, ['z'] = 95.359237 },
        [30] =  { ['x'] = 17.745203, ['y'] = -13.83824, ['z'] = 70.310768 },
        [31] =  { ['x'] = 101.53557, ['y'] = -222.4989, ['z'] = 54.636135 },
    },

    ['burgershot'] = {
        [1] =   { ['x'] = -613.2788,['y'] = 323.81179,['z'] = 82.261268},
        [2] =   { ['x'] = -742.789,['y'] = 247.28901,['z'] =77.332794},
        [3] =   { ['x'] = -819.3536,['y'] = 268.01205,['z'] = 86.395942},
        [4] =   { ['x'] = -877.4011,['y'] = 306.41491,['z'] = 84.154304},
        [5] =   { ['x'] = -842.7734,['y'] = 466.92758,['z'] = 87.601287},
        [6] =   { ['x'] = -850.4257,['y'] = 522.36022,['z'] = 90.622322},
        [7] =   { ['x'] = -907.7296,['y'] = 544.99822,['z'] = 100.40779},
        [8] =   { ['x'] = -761.8388,['y'] = 431.52124,['z'] = 100.19976},
        [9] =   { ['x'] = -622.8532,['y'] = 488.86599,['z'] = 108.87752},
        [10] =  { ['x'] = -207.0818,['y'] = 163.44096,['z'] = 74.05313},
        [11] =  { ['x'] = -476.8085,['y'] = 217.54107,['z'] = 83.702545},
        [12] =  { ['x'] = -207.4753,['y'] = 159.42839,['z'] = 74.053131},
        [13] =  { ['x'] = -655.0702, ['y'] = -414.2643, ['z'] = 35.479915 },
        [14] =  { ['x'] = -385.2475, ['y'] = 270.15991, ['z'] = 86.367485 },
        [15] =  { ['x'] = -413.9096, ['y'] = 220.52507, ['z'] = 83.427467 },
        [16] =  { ['x'] = -419.5444, ['y'] = 221.21493, ['z'] = 83.395278 },
        [17] =  { ['x'] = -394.2344, ['y'] = 208.50917, ['z'] = 83.632904 },
        [18] =  { ['x'] = -242.0425, ['y'] = 279.85229, ['z'] = 92.039863 },
        [19] =  { ['x'] = -178.7237, ['y'] = 314.27059, ['z'] = 97.964214 },
        [20] =  { ['x'] = -92.77323, ['y'] = 233.14714, ['z'] = 100.58019 },
        [21] =  { ['x'] = -40.53652, ['y'] = 227.85008, ['z'] = 107.96794 },
        [22] =  { ['x'] = 81.467658, ['y'] = 275.05633, ['z'] = 110.21013 },
        [23] =  { ['x'] = -60.9231, ['y'] = 360.48562, ['z'] = 113.05636 },
        [24] =  { ['x'] = -102.9935, ['y'] = 397.4869, ['z'] = 112.65986 },
        [25] =  { ['x'] = -54.15459, ['y'] = 374.72796, ['z'] = 112.43081 },
        [26] =  { ['x'] = -72.9051, ['y'] = 428.51367, ['z'] = 113.03815 },
        [27] =  { ['x'] = -6.494105, ['y'] = 409.04806, ['z'] = 120.2888 },
        [28] =  { ['x'] = 22.056957, ['y'] = 173.87936, ['z'] = 101.11345 },
        [29] =  { ['x'] = -37.57359, ['y'] = 170.36849, ['z'] = 95.359237 },
        [30] =  { ['x'] = 17.745203, ['y'] = -13.83824, ['z'] = 70.310768 },
        [31] =  { ['x'] = 101.53557, ['y'] = -222.4989, ['z'] = 54.636135 },
    }
}

Drugdealer = {}

Drugdealer.Locations = {
    ['stash'] = { ['x'] = 241.31401, ['y'] = 369.25064, ['z'] = 106.41964, ['h'] = 74.061767 },
    ['shop'] = { ['x'] = 244.61791, ['y'] = 374.68429, ['z'] = 105.73821, ['h'] = 335.76373 }
}

Drugdealer.Items = {
    label = "Drugs",
    slots = 1,
    items = {
        [1] = {
            name = "weed_white-widow",
            price = 270,
            amount = 100,
            info = {},
            type = "item",
            slot = 1,
        },
        [2] = {
            name = "weed_skunk",
            price = 260,
            amount = 100,
            info = {},
            type = "item",
            slot = 2,
        },
        [3] = {
            name = "weed_purple-haze",
            price = 260,
            amount = 100,
            info = {},
            type = "item",
            slot = 3,
        },
        [4] = {
            name = "weed_og-kush",
            price = 260,
            amount = 100,
            info = {},
            type = "item",
            slot = 4,
        },
        [5] = {
            name = "weed_amnesia",
            price = 260,
            amount = 100,
            info = {},
            type = "item",
            slot = 5,
        },
        [6] = {
            name = "weed_ak47",
            price = 260,
            amount = 100,
            info = {},
            type = "item",
            slot = 6,
        },
        [7] = {
            name = "crack_baggy",
            price = 280,
            amount = 100,
            info = {},
            type = "item",
            slot = 7,
        },
        [8] = {
            name = "cokebaggy",
            price = 280,
            amount = 100,
            info = {},
            type = "item",
            slot = 8,
        }
    }
}

Weapondealer = {}

Weapondealer.Locations = {
    ['stash'] = { ['x'] = -108.9136, ['y'] = -12.13637, ['z'] = 70.519638, ['h'] = 251.3009 },
    ['shop'] = { ['x'] = -110.6005, ['y'] = -14.79134, ['z'] = 70.519638, ['h'] = 158.73928 }
}

Weapondealer.Items = {
    label = "Weapons",
    slots = 1,
    items = {
        [1] = {
            name = "weapon_snspistol",
            price = 5000,
            amount = 30,
            info = {},
            type = "weapon",
            slot = 1,
        },
        [2] = {
            name = "weapon_pistol",
            price = 8500,
            amount = 30,
            info = {},
            type = "weapon",
            slot = 2,
        },
        [3] = {
            name = "weapon_pistol_mk2",
            price = 16500,
            amount = 30,
            info = {},
            type = "weapon",
            slot = 3,
        },
        [4] = {
            name = "weapon_microsmg",
            price = 70000,
            amount = 20,
            info = {},
            type = "weapon",
            slot = 5,
        },
        [6] = {
            name = "weapon_minismg",
            price = 30000,
            amount = 20,
            info = {},
            type = "weapon",
            slot = 6,
        },
        [7] = {
            name = "weapon_machinepistol",
            price = 40000,
            amount = 20,
            info = {},
            type = "weapon",
            slot = 7,
        },
        [8] = {
            name = "weapon_compactrifle",
            price = 102000,
            amount = 15,
            info = {},
            type = "item",
            slot = 8,
        },
        [9] = {
            name = "weapon_bullpuprifle",
            price = 1500000,
            amount = 10,
            info = {},
            type = "weapon",
            slot = 9,
        },
        [10] = {
            name = "weapon_assaultrifle",
            price = 100000,
            amount = 10,
            info = {},
            type = "weapon",
            slot = 10,
        },
        [11] = {
            name = "weapon_assaultrifle_mk2",
            price = 130000,
            amount = 10,
            info = {},
            type = "weapon",
            slot = 11,
        },
        [12] = {
            name = "weapon_gusenberg",
            price = 102000,
            amount = 15,
            info = {},
            type = "item",
            slot = 12,
        },
        [13] = {
            name = "weapon_mg",
            price = 165000,
            amount = 3,
            info = {},
            type = "weapon",
            slot = 13,
        },
        [14] = {
            name = "weapon_combatmg",
            price = 180000,
            amount = 3,
            info = {},
            type = "weapon",
            slot = 14,
        },
        [15] = {
            name = "weapon_machete",
            price = 1500,
            amount = 25,
            info = {},
            type = "weapon",
            slot = 15,
        }, 
        [16] = {
            name = "weapon_hatchet",
            price = 1000,
            amount = 25,
            info = {},
            type = "weapon",
            slot = 16,
        }, 
        [17] = {
            name = "weapon_dagger",
            price = 1000,
            amount = 25,
            info = {},
            type = "weapon",
            slot = 17,
        },
        [18] = {
            name = "weapon_knife",
            price = 500,
            amount = 25,
            info = {},
            type = "weapon",
            slot = 18,
        },
        [19] = {
            name = "weapon_switchblade",
            price = 1000,
            amount = 25,
            info = {},
            type = "weapon",
            slot = 19,
        },
        [20] = {
            name = "weapon_golfclub",
            price = 500,
            amount = 25,
            info = {},
            type = "weapon",
            slot = 20,
        },
        [21] = {
            name = "weapon_crowbar",
            price = 500,
            amount = 25,
            info = {},
            type = "weapon",
            slot = 21,
        },
        [22] = {
            name = "weapon_hammer",
            price = 500,
            amount = 25,
            info = {},
            type = "weapon",
            slot = 22,
        },
        [23] = {
            name = "weapon_molotov",
            price = 4000,
            amount = 50,
            info = {},
            type = "weapon",
            slot = 23,
        },
        [24] = {
            name = "pistol_ammo",
            price = 50,
            amount = 100,
            info = {},
            type = "item",
            slot = 24,
        },
        [25] = {
            name = "smg_ammo",
            price = 100,
            amount = 100,
            info = {},
            type = "item",
            slot = 25,
        },
        [26] = {
            name = "mg_ammo",
            price = 200,
            amount = 100,
            info = {},
            type = "item",
            slot = 26,
        },
        [27] = {
            name = "rifle_ammo",
            price = 150,
            amount = 100,
            info = {},
            type = "item",
            slot = 27,
        },
        [28] = {
            name = "pistol_suppressor",
            price = 2000,
            amount = 25,
            info = {},
            type = "item",
            slot = 28,
        }, 
        [29] = {
            name = "pistol_extendedclip",
            price = 1500,
            amount = 25,
            info = {},
            type = "item",
            slot = 29,
        }, 
        [30] = {
            name = "smg_flashlight",
            price = 250,
            amount = 25,
            info = {},
            type = "item",
            slot = 30,
        }, 
        [31] = {
            name = "smg_extendedclip",
            price = 1500,
            amount = 25,
            info = {},
            type = "item",
            slot = 31,
        }, 
        [32] = {
            name = "smg_scope",
            price = 2000,
            amount = 25,
            info = {},
            type = "item",
            slot = 32,
        }, 
        [33] = {
            name = "smg_suppressor",
            price = 2000,
            amount = 25,
            info = {},
            type = "item",
            slot = 33,
        }, 
        [34] = {
            name = "rifle_extendedclip",
            price = 1500,
            amount = 25,
            info = {},
            type = "item",
            slot = 34,
        }, 
        [35] = {
            name = "rifle_drummag",
            price = 4000,
            amount = 25,
            info = {},
            type = "item",
            slot = 35,
        },
        [36] = {
            name = "rifle_suppressor",
            price = 2000,
            amount = 25,
            info = {},
            type = "item",
            slot = 36,
        }
    }
}

Vanilla = {}

Vanilla.Locations = {
	['shop'] = { ['x'] = 129.76, ['y'] = -1281.82, ['z'] = 29.26, ['h'] = 295.61 },
	['vip'] = { ['x'] = 92.97, ['y'] = -1291.31, ['z'] = 29.26, ['h'] = 26.38 },
	['stripper'] = { ['x'] = 108.55, ['y'] = -1305.98, ['z'] = 28.76, ['h'] = 212.00  },
	['boss'] = { ['x'] = 95.15, ['y'] = -1293.38, ['z'] = 29.26, ['h'] = 290.99  },
}

Vanilla.Strippers = {
    ['locations'] ={
        {
            ['taken'] = 0,
            ['model'] = nil,
            ['sit'] = vector4(118.77422, -1302.212, 28.269432, 31.382211),
            ['stand'] = vector4(118.42105, -1301.561, 28.269502, 208.21502),
        },
        {
            ['taken'] = 0,
            ['model'] = nil,
            ['sit'] = vector4(116.74626, -1303.393, 28.273693, 32.705486),
            ['stand'] = vector4(116.29303, -1302.636, 28.269521, 207.09544),
        },
        {
            ['taken'] = 0,
            ['model'] = nil,
            ['sit'] = vector4(114.60829, -1304.639, 28.269498, 25.138725),
            ['stand'] = vector4(114.19611, -1303.985, 28.269498, 207.37702),
        },
        {
            ['taken'] = 0,
            ['model'] = nil,
            ['sit'] = vector4(112.82508, -1305.668, 28.2695, 30.056648),
            ['stand'] = vector4(112.34696, -1305.062, 28.269504, 202.59379),
        },
        {
            ['taken'] = 0,
            ['model'] = nil,
            ['sit'] = vector4(112.82508, -1305.668, 28.2695, 30.056648),
            ['stand'] = vector4(112.34696, -1305.062, 28.269504, 202.59379),
        },
    },
    ['peds'] = {
       'csb_stripper_01', -- White Stripper
	   's_f_y_stripperlite', -- Black Stripper
       'mp_f_stripperlite', -- Black Stripper
    }
}

Vanilla.Items = {
    label = "Vanilla Unicorn",
    slots = 1,
    items = {
        [1] = {
            name = "glassbeer",
            price = 4,
            amount = 125,
            info = {},
            type = "item",
            slot = 1,
		},
        [2] = {
            name = "bloodymary",
            price = 4,
            amount = 125,
            info = {},
            type = "item",
            slot = 2,
        },
        [3] = {
            name = "dusche",
            price = 4,
            amount = 125,
            info = {},
            type = "item",
            slot = 3,
        },
        [4] = {
            name = "tequilashot",
            price = 4,
            amount = 125,
            info = {},
            type = "item",
            slot = 4,
        },
        [5] = {
            name = "pinacolada",
            price = 4,
            amount = 125,
            info = {},
            type = "item",
            slot = 5,
		},
        [6] = {
            name = "beer",
            price = 4,
            amount = 1251,
            info = {},
            type = "item",
            slot = 6,
        },
        [7] = {
            name = "whiskey",
            price = 4,
            amount = 125,
            info = {},
            type = "item",
            slot = 7,
        },
        [8] = {
            name = "vodka",
            price = 4,
            amount = 125,
            info = {},
            type = "item",
            slot = 8,
		},
        [9] = {
            name = "tequila",
            price = 4,
            amount = 125,
            info = {},
            type = "item",
            slot = 9,
		},
        [10] = {
            name = "fries",
            price = 7,
            amount = 125,
            info = {},
            type = "item",
            slot = 10,
        }
    }
}

Vanilla.BossItems = {
    label = "Vanilla Unicorn VIP",
    slots = 1,
    items = {
        [1] = {
            name = "champagne",
            price = 1500,
            amount = 125,
            info = {},
            type = "item",
            slot = 1,	
		},
        [2] = {
            name = "whitewine",
            price = 1000,
            amount = 125,
            info = {},
            type = "item",
            slot = 2,	
		},
        [3] = {
            name = "glasschampagne",
            price = 0,
            amount = 125,
            info = {},
            type = "item",
            slot = 3,
        },
        [4] = {
            name = "glasswhiskey",
            price = 0,
            amount = 125,
            info = {},
            type = "item",
            slot = 4,
        },
        [5] = {
            name = "glasswine",
            price = 0,
            amount = 125,
            info = {},
            type = "item",
            slot = 5,
        }
    }
}

Gangs = {}

Gangs.Locations = {
    ["stashballas"] = {
        label = "Ballas Stash",
        coords = { x = 106.11578, y = -1981.437, z = 20.962614 },
    },
    ["stashgsf"] = {
        label = "GSF Stash",
        coords = { x = -136.91, y = -1609.84, z = 35.03, h = 66.89 },
    },
    ["stashMarabunta"] = {
        label = "Marabunta Stash",
        coords = { x = 1438.95, y = -1489.91, z = 66.62, h = 151.24 },
    },
    ["stashVagos"] = {
        label = "Vagos Stash",
        coords = { x = 344.67, y = -2022.14, z = 22.39, h = 318.46 },
    },
}

Tequila = {}

Tequila.Locations = {
	['shop'] = { ['x'] = -561.8057, ['y'] = 286.38418, ['z'] = 82.176399, ['h'] = 268.885 },
	['vip'] = { ['x'] = -565.476, ['y'] = 286.11187, ['z'] = 85.377906, ['h'] = 76.174407 },
	['boss'] = { ['x'] = -561.9248, ['y'] = 281.63714, ['z'] = 85.676368, ['h'] = 173.36518  },
}

Tequila.Items = {
    label = "Tequila Club",
    slots = 1,
    items = {
        [1] = {
            name = "glassbeer",
            price = 4,
            amount = 125,
            info = {},
            type = "item",
            slot = 1,
		},
        [2] = {
            name = "bloodymary",
            price = 4,
            amount = 125,
            info = {},
            type = "item",
            slot = 2,
        },
        [3] = {
            name = "dusche",
            price = 4,
            amount = 125,
            info = {},
            type = "item",
            slot = 3,
        },
        [4] = {
            name = "tequilashot",
            price = 4,
            amount = 125,
            info = {},
            type = "item",
            slot = 4,
        },
        [5] = {
            name = "pinacolada",
            price = 4,
            amount = 125,
            info = {},
            type = "item",
            slot = 5,
		},
        [6] = {
            name = "beer",
            price = 4,
            amount = 1251,
            info = {},
            type = "item",
            slot = 6,
        },
        [7] = {
            name = "whiskey",
            price = 4,
            amount = 125,
            info = {},
            type = "item",
            slot = 7,
        },
        [8] = {
            name = "vodka",
            price = 4,
            amount = 125,
            info = {},
            type = "item",
            slot = 8,
		},
        [9] = {
            name = "tequila",
            price = 4,
            amount = 125,
            info = {},
            type = "item",
            slot = 9,
		},
        [10] = {
            name = "fries",
            price = 7,
            amount = 125,
            info = {},
            type = "item",
            slot = 10,
        }
    }
}

Tequila.BossItems = {
    label = "Tequila Club VIP",
    slots = 1,
    items = {
        [1] = {
            name = "champagne",
            price = 1500,
            amount = 125,
            info = {},
            type = "item",
            slot = 1,	
		},
        [2] = {
            name = "whitewine",
            price = 1000,
            amount = 125,
            info = {},
            type = "item",
            slot = 2,	
		},
        [3] = {
            name = "glasschampagne",
            price = 0,
            amount = 125,
            info = {},
            type = "item",
            slot = 3,
        },
        [4] = {
            name = "glasswhiskey",
            price = 0,
            amount = 125,
            info = {},
            type = "item",
            slot = 4,
        },
        [5] = {
            name = "glasswine",
            price = 0,
            amount = 125,
            info = {},
            type = "item",
            slot = 5,
        }
    }
}

Trucker = {}

Trucker.BailPrice = 1000

Trucker.Locations = {
    ["main"] = {
        label = "Truck Shed",
        coords = {x = 153.68, y = -3211.88, z = 5.91, h = 274.5},
    },
    ["vehicle"] = {
        label = "Truck Storage",
        coords = {x = 141.12, y = -3204.31, z = 5.85, h = 267.5},
    },
    ["stores"] ={
        [1] = {
            name = "ltdgasoline",
            coords = {x = -41.07, y = -1747.91, z = 29.4, h = 137.5},
        },
        [2] = {
            name = "247supermarket",
            coords = {x = 31.62, y = -1315.87, z = 29.52, h = 179.5},
        },
        [3] = {
            name = "robsliquor",
            coords = {x = -1226.48, y = -907.58, z = 12.32, h = 119.5},
        },
        [4] = {
            name = "ltdgasoline2",
            coords = {x = -714.13, y = -909.13, z = 19.21, h = 0.5},
        },
        [5] = {
            name = "robsliquor2",
            coords = {x = -1469.78, y = -366.72, z = 40.2, h = 138.5},
        },
        [6] = {
            name = "ltdgasoline3",
            coords = {x = -1829.15, y = 791.99, z = 138.26, h = 46.5},
        },
        [7] = {
            name = "robsliquor3",
            coords = {x = -2959.92, y = 396.77, z = 15.02, h = 178.5},
        },
        [8] = {
            name = "247supermarket2",
            coords = {x = -3047.58, y = 589.89, z = 7.78, h = 199.5},
        },
        [9] = {
            name = "247supermarket3",
            coords = {x = -3245.85, y = 1008.25, z = 12.83, h = 90.5},
        },
        [10] = {
            name = "247supermarket4",
            coords = {x = 1735.54, y = 6416.28, z = 35.03, h = 332.5},
        },
        [11] = {
            name = "247supermarket5",
            coords = {x = 1702.84, y = 4917.28, z = 42.22, h = 323.5},
        },
        [12] = {
            name = "247supermarket6",
            coords = {x = 1960.47, y = 3753.59, z = 32.26, h = 127.5},
        },
        [13] = {
            name = "robsliquor4",
            coords = {x = 1169.27, y = 2707.7, z = 38.15, h = 267.5},
        },
        [14] = {
            name = "247supermarket7",
            coords = {x = 543.47, y = 2658.81, z = 42.17, h = 277.5},
        },
        [15] = {
            name = "247supermarket8",
            coords = {x = 2678.09, y = 3288.43, z = 55.24, h = 61.5},
        },
        [16] = {
            name = "247supermarket9",
            coords = {x = 2553.0, y = 399.32, z = 108.61, h = 179.5, r = 1.0},
        },
        [17] = {
            name = "ltdgasoline4",
            coords = {x = 1155.97, y = -319.76, z = 69.2, h = 17.5},
        },
        [18] = {
            name = "robsliquor5",
            coords = {x = 1119.78, y = -983.99, z = 46.29, h = 287.5},
        },
        [19] = {
            name = "247supermarket9",
            coords = {x = 382.13, y = 326.2, z = 103.56, h = 253.5},
        },
        [20] = {
            name = "hardware",
            coords = {x = 89.33, y = -1745.44, z = 30.08, h = 143.5},
        },
        [21] = {
            name = "hardware2",
            coords = {x = 2704.09, y = 3457.55, z = 55.53, h = 339.5},
        },
    },
}

Trucker.Vehicles = {
    ["mule"] = "Mule",
}

Tow = {}

Tow.BailPrice = 1000

Tow.MaxStatusValues = {
    ["breaks"] = 100,
    ["axle"] = 100,
    ["radiator"] = 100,
    ["clutch"] = 100,
    ["transmission"] = 100,
    ["electronics"] = 100,
    ["fuel_injector"] = 100,
    ["fuel_tank"] = 100 
}

Tow.Locations = {
    ["payslip"] = { ['x'] = 722.91192, ['y'] = -1069.582, ['z'] = 23.062397, ['h'] = 271.64846 },
    ["vehicle"] = { ['x'] = 710.70153, ['y'] = -1076.035, ['z'] = 22.32954, ['h'] = 91.672828 },
    ["shop"] = { ['x'] = 724.15087, ['y'] = -1071.721, ['z'] = 23.126478, ['h'] = 89.121253 },
    ["stash"] = { ['x'] = 728.19061, ['y'] = -1063.946, ['z'] = 22.168693, ['h'] = 1.6629546 },
    ["boss"] = { ['x'] = 736.38281, ['y'] = -1064.012, ['z'] = 22.168373, ['h'] = 324.12149 },
    ["towspots"] = {
        [1] = {model = "sultanrs", coords = { x = -2480.8720703125, y = -211.96409606934, z = 17.397672653198 }},
        [2] = {model = "zion", coords = { x = -2723.392578125, y = 13.207388877869, z = 15.12806892395 }},
        [3] = {model = "oracle", coords = { x = -3169.6235351563, y = 976.18127441406, z = 15.038360595703 }},
        [4] = {model = "chino", coords = { x = -3139.7568359375, y = 1078.7182617188, z = 20.189767837524 }},
        [5] = {model = "baller2", coords = { x = -1656.9357910156, y = -246.16479492188, z = 54.510955810547 }},
        [6] = {model = "stanier", coords = { x = -1586.6560058594, y = -647.56115722656, z = 29.441320419312 }},
        [7] = {model = "washington", coords = { x = -1036.1470947266, y = -491.05856323242, z = 36.214912414551 }},
        [8] = {model = "buffalo", coords = { x = -1029.1884765625, y = -475.53167724609, z = 36.416831970215 }},
        [9] = {model = "feltzer2", coords = { x = 75.212287902832, y = 164.8522644043, z = 104.69123077393 }},
        [10] = {model = "asea", coords = { x = -534.60491943359, y = -756.71801757813, z = 31.599143981934 }},
        [11] = {model = "fq2", coords = { x = 487.24212646484, y = -30.827201843262, z = 88.856712341309 }},
        [12] = {model = "jackal", coords = { x = -772.20111083984, y = -1281.8114013672, z = 4.5642876625061 }},
        [13] = {model = "sultanrs", coords = { x = -663.84173583984, y = -1206.9936523438, z = 10.171216011047 }},
        [14] = {model = "zion", coords = { x = 719.12451171875, y = -767.77545166016, z = 24.892364501953 }},
        [15] = {model = "oracle", coords = { x = -970.95465087891, y = -2410.4453125, z = 13.344270706177 }},
        [16] = {model = "chino", coords = { x = -1067.5234375, y = -2571.4064941406, z = 13.211874008179 }},
        [17] = {model = "baller2", coords = { x = -619.23968505859, y = -2207.2927246094, z = 5.5659561157227 }},
        [18] = {model = "stanier", coords = { x = 1192.0831298828, y = -1336.9086914063, z = 35.106426239014 }},
        [19] = {model = "washington", coords = { x = -432.81033325195, y = -2166.0505371094, z = 9.8885231018066 }},
        [20] = {model = "buffalo", coords = { x = -451.82403564453, y = -2269.34765625, z = 7.1719741821289 }},
        [21] = {model = "asea", coords = { x = 939.26702880859, y = -2197.5390625, z = 30.546691894531 }},
        [22] = {model = "fq2", coords = { x = -556.11486816406, y = -1794.7312011719, z = 22.043060302734 }},
        [23] = {model = "jackal", coords = { x = 591.73504638672, y = -2628.2197265625, z = 5.5735430717468 }},
        [24] = {model = "sultanrs", coords = { x = 1654.515625, y = -2535.8325195313, z = 74.491394042969 }},
        [25] = {model = "oracle", coords = { x = 1642.6146240234, y = -2413.3159179688, z = 93.139915466309 }},
        [26] = {model = "chino", coords = { x = 1371.3223876953, y = -2549.525390625, z = 47.575256347656 }},
        [27] = {model = "baller2", coords = { x = 383.83779907227, y = -1652.8695068359, z = 37.278503417969 }},
        [28] = {model = "stanier", coords = { x = 27.219129562378, y = -1030.8818359375, z = 29.414621353149 }},
        [29] = {model = "washington", coords = { x = 229.26435852051, y = -365.91101074219, z = 43.750762939453 }},
        [30] = {model = "asea", coords = { x = -85.809432983398, y = -51.665500640869, z = 61.10591506958 }},
        [31] = {model = "fq2", coords = { x = -4.5967531204224, y = -670.27124023438, z = 31.85863494873 }},
        [32] = {model = "oracle", coords = { x = -111.89884185791, y = 91.96940612793, z = 71.080169677734 }},
        [33] = {model = "zion", coords = { x = -314.26129150391, y = -698.23309326172, z = 32.545776367188 }},
        [34] = {model = "buffalo", coords = { x = -366.90979003906, y = 115.53963470459, z = 65.575706481934 }},
        [35] = {model = "fq2", coords = { x = -592.06726074219, y = 138.20733642578, z = 60.074813842773 }},
        [36] = {model = "zion", coords = { x = -1613.8572998047, y = 18.759860992432, z = 61.799819946289 }},
        [37] = {model = "baller2", coords = { x = -1709.7995605469, y = 55.105819702148, z = 65.706237792969 }},
        [38] = {model = "chino", coords = { x = -521.88830566406, y = -266.7805480957, z = 34.940990447998 }},
        [39] = {model = "washington", coords = { x = -451.08666992188, y = -333.52026367188, z = 34.021533966064 }},
        [40] = {model = "baller2", coords = { x = 322.36480712891, y = -1900.4990234375, z = 25.773607254028 }},
    }
}

Tow.Vehicles = {
    ["flatbed"] = "Flatbed",
}

Tow.Items = {
    label = "Tow",
    slots = 1,
    items = {
        [1] = {
            name = "advancedrepairkit",
            price = 300,
            amount = 10,
            info = {},
            type = "item",
            slot = 1,
        },
        [2] = {
            name = "repairkit",
            price = 100,
            amount = 10,
            info = {},
            type = "item",
            slot = 2,
        },
        [3] = {
            name = "glass",
            price = 0,
            amount = 10,
            info = {
                cansell = false
            },
            type = "item",
            slot = 3,
        },
        [4] = {
            name = "metalscrap",
            price = 0,
            amount = 10,
            info = {
                cansell = false
            },
            type = "item",
            slot = 4,
        },
        [5] = {
            name = "rubber",
            price = 0,
            amount = 10,
            info = {
                cansell = false
            },
            type = "item",
            slot = 5,
        },
        [6] = {
            name = "plastic",
            price = 0,
            amount = 10,
            info = {
                cansell = false
            },
            type = "item",
            slot = 6,
        },
        [7] = {
            name = "steel",
            price = 0,
            amount = 10,
            info = {
                cansell = false
            },
            type = "item",
            slot = 7,
        },
        [8] = {
            name = "aluminum",
            price = 0,
            amount = 10,
            info = {
                cansell = false
            },
            type = "item",
            slot = 8,
        },
        [9] = {
            name = "copper",
            price = 0,
            amount = 10,
            info = {
                cansell = false
            },
            type = "item",
            slot = 9,
        },
    }
}

Jewellery = {}

Jewellery.Timeout = 120 * (60 * 1000)
Jewellery.DiscordWebhook = 'https://discord.com/api/webhooks/774093302743564361/MJdhJuEnAlP3O6keU0oRfwvNfX0aabYWTQnzYbpniQbU-m7Uomi-AzCSBNh0smR1YgVY'
Jewellery.RequiredCops = 0

Jewellery.JewelleryLocation = {
    ["coords"] = {
        ["x"] = -630.5,
        ["y"] = -237.13,
        ["z"] = 38.08,
    }
}

Jewellery.WhitelistedWeapons = {
    [GetHashKey("weapon_snspistol")] = {
        ["timeOut"] = 5000
    },
    [GetHashKey("weapon_vintagepistol")] = {
        ["timeOut"] = 5000
    },
    [GetHashKey("weapon_pistol")] = {
        ["timeOut"] = 5000
    },
    [GetHashKey("weapon_pistol_mk2")] = {
        ["timeOut"] = 5000
    },
    [GetHashKey("weapon_combatpistol")] = {
        ["timeOut"] = 5000
    },
    [GetHashKey("weapon_appistol")] = {
        ["timeOut"] = 5000
    },
    [GetHashKey("weapon_pistol50")] = {
        ["timeOut"] = 5000
    },
    [GetHashKey("weapon_heavypistol")] = {
        ["timeOut"] = 5000
    },
    [GetHashKey("weapon_marksmanpistol")] = {
        ["timeOut"] = 5000
    },
    [GetHashKey("weapon_revolver")] = {
        ["timeOut"] = 5000
    },
    [GetHashKey("weapon_revolver_mk2")] = {
        ["timeOut"] = 5000
    },
    [GetHashKey("weapon_doubleaction")] = {
        ["timeOut"] = 5000
    },
    [GetHashKey("weapon_compactrifle")] = {
        ["timeOut"] = 5000
    },
    [GetHashKey("weapon_assaultrifle")] = {
        ["timeOut"] = 5000
    },
    [GetHashKey("weapon_assaultrifle_mk2")] = {
        ["timeOut"] = 5000
    },
    [GetHashKey("weapon_gusenberg")] = {
        ["timeOut"] = 5000
    },
    [GetHashKey("weapon_carbinerifle")] = {
        ["timeOut"] = 5000
    },
    [GetHashKey("weapon_carbinerifle_mk2")] = {
        ["timeOut"] = 5000
    },
    [GetHashKey("weapon_advancedrifle")] = {
        ["timeOut"] = 5000
    },
    [GetHashKey("weapon_bullpuprifle")] = {
        ["timeOut"] = 5000
    },
    [GetHashKey("weapon_pumpshotgun")] = {
        ["timeOut"] = 5000
    },
    [GetHashKey("weapon_sawnoffshotgun")] = {
        ["timeOut"] = 5000
    },
    [GetHashKey("weapon_heavyshotgun")] = {
        ["timeOut"] = 5000
    },
    [GetHashKey("weapon_dbshotgun")] = {
        ["timeOut"] = 5000
    },
    [GetHashKey("weapon_compactrifle")] = {
        ["timeOut"] = 5000
    },
    [GetHashKey("weapon_bullpupshotgun")] = {
        ["timeOut"] = 5000
    },
    [GetHashKey("weapon_autoshotgun")] = {
        ["timeOut"] = 5000
    },
    [GetHashKey("weapon_assaultshotgun")] = {
        ["timeOut"] = 5000
    },
    [GetHashKey("weapon_machinepistol")] = {
        ["timeOut"] = 5000
    },
    [GetHashKey("weapon_smg")] = {
        ["timeOut"] = 5000
    },
    [GetHashKey("weapon_smg_mk2")] = {
        ["timeOut"] = 5000
    },
    [GetHashKey("weapon_minismg")] = {
        ["timeOut"] = 5000
    },
    [GetHashKey("weapon_assaultsmg")] = {
        ["timeOut"] = 5000
    },
    [GetHashKey("weapon_mg")] = {
        ["timeOut"] = 5000
    },
    [GetHashKey("weapon_combatmg")] = {
        ["timeOut"] = 5000
    },
    [GetHashKey("weapon_microsmg")] = {
        ["timeOut"] = 5000
    },
}

Jewellery.VitrineRewards = {
    [1] = {
        ["item"] = "rolex",
        ["amount"] = {
            ["min"] = 4,
            ["max"] = 6
        },
    },
}

Jewellery.Locations = {
    [1] = {
        ["coords"] = {
            ["x"] = -626.83, 
            ["y"] = -235.35, 
            ["z"] = 38.05,
        },
        ["isOpened"] = false,
    }, 
    [2] = {
        ["coords"] = {
            ["x"] = -625.81, 
            ["y"] = -234.7, 
            ["z"] = 38.05,
        },
        ["isOpened"] = false,
    },
    [3] = {
        ["coords"] = {
            ["x"] = -626.95, 
            ["y"] = -233.14, 
            ["z"] = 38.05,
        },
        ["isOpened"] = false,
    },
    [4] = {
        ["coords"] = {
            ["x"] = -628.0, 
            ["y"] = -233.86, 
            ["z"] = 38.05,
        },
        ["isOpened"] = false,
    },
    [5] = {
        ["coords"] = {
            ["x"] = -625.7, 
            ["y"] = -237.8, 
            ["z"] = 38.05,
        },
        ["isOpened"] = false,
    }, 
    [6] = {
        ["coords"] = {
            ["x"] = -626.7, 
            ["y"] = -238.58, 
            ["z"] = 38.05,
        },
        ["isOpened"] = false,
    },
    [7] = {
        ["coords"] = {
            ["x"] = -624.55, 
            ["y"] = -231.06, 
            ["z"] = 38.05,
        },
        ["isOpened"] = false,
    },
    [8] = {
        ["coords"] = {
            ["x"] = -623.13, 
            ["y"] = -232.94, 
            ["z"] = 38.05,
        },
        ["isOpened"] = false,
    },
    [9] = {
        ["coords"] = {
            ["x"] = -620.29, 
            ["y"] = -234.44, 
            ["z"] = 38.05,
        },
        ["isOpened"] = false,
    }, 
    [10] = {
        ["coords"] = {
            ["x"] = -619.15, 
            ["y"] = -233.66, 
            ["z"] = 38.05,
        },
        ["isOpened"] = false,

    },
    [11] = {
        ["coords"] = {
            ["x"] = -620.19, 
            ["y"] = -233.44, 
            ["z"] = 38.05,
        },
        ["isOpened"] = false,
    }, 
    [12] = {
        ["coords"] = {
            ["x"] = -617.63, 
            ["y"] = -230.58, 
            ["z"] = 38.05,
        },
        ["isOpened"] = false,
    }, 
    [13] = {
        ["coords"] = {
            ["x"] = -618.33, 
            ["y"] = -229.55, 
            ["z"] = 38.05,
        },
        ["isOpened"] = false,
    }, 
    [14] = {
        ["coords"] = {
            ["x"] = -619.7, 
            ["y"] = -230.33, 
            ["z"] = 38.05,
        },
        ["isOpened"] = false,
    }, 
    [15] = {
        ["coords"] = {
            ["x"] = -620.95, 
            ["y"] = -228.6, 
            ["z"] = 38.05,
        },
        ["isOpened"] = false,
    },
    [16] = {
        ["coords"] = {
            ["x"] = -619.79, 
            ["y"] = -227.6, 
            ["z"] = 38.05,
        },
        ["isOpened"] = false,
    },
    [17] = {
        ["coords"] = {
            ["x"] = -620.42, 
            ["y"] = -226.6, 
            ["z"] = 38.05,
        },
        ["isOpened"] = false,
    },
    [18] = {
        ["coords"] = {
            ["x"] = -623.94, 
            ["y"] = -227.18, 
            ["z"] = 38.05,
        },
        ["isOpened"] = false,
    },
    [19] = {
        ["coords"] = {
            ["x"] = -624.91, 
            ["y"] = -227.87, 
            ["z"] = 38.05,
        },
        ["isOpened"] = false,
    },
    [20] = {
        ["coords"] = {
            ["x"] = -623.94, 
            ["y"] = -228.05, 
            ["z"] = 38.05,
        },
        ["isOpened"] = false,
    }
}

Jewellery.MaleNoHandshoes = {
    [0] = true,
    [1] = true,
    [2] = true,
    [3] = true,
    [4] = true,
    [5] = true,
    [6] = true,
    [7] = true,
    [8] = true,
    [9] = true,
    [10] = true,
    [11] = true,
    [12] = true,
    [13] = true,
    [14] = true,
    [15] = true,
    [18] = true,
    [26] = true,
    [52] = true,
    [53] = true,
    [54] = true,
    [55] = true,
    [56] = true,
    [57] = true,
    [58] = true,
    [59] = true,
    [60] = true,
    [61] = true,
    [62] = true,
    [112] = true,
    [113] = true,
    [114] = true,
    [118] = true,
    [125] = true,
    [132] = true,
}

Jewellery.FemaleNoHandshoes = {
    [0] = true,
    [1] = true,
    [2] = true,
    [3] = true,
    [4] = true,
    [5] = true,
    [6] = true,
    [7] = true,
    [8] = true,
    [9] = true,
    [10] = true,
    [11] = true,
    [12] = true,
    [13] = true,
    [14] = true,
    [15] = true,
    [19] = true,
    [59] = true,
    [60] = true,
    [61] = true,
    [62] = true,
    [63] = true,
    [64] = true,
    [65] = true,
    [66] = true,
    [67] = true,
    [68] = true,
    [69] = true,
    [70] = true,
    [71] = true,
    [129] = true,
    [130] = true,
    [131] = true,
    [135] = true,
    [142] = true,
    [149] = true,
    [153] = true,
    [157] = true,
    [161] = true,
    [165] = true,
}

Towing = {}

Towing.Vehicles = {
    ["flatbed"] = "Flatbed",
}

Truckrobbery = {}

Truckrobbery.DiscordWebhook = 'https://discord.com/api/webhooks/847821202407292958/UH8oyvn1pV6_cJg3CYZa7dmZjlpRnA1PREYwDILjRlpnJXfrlr29jqIFE0rgTjn02X5q'

Truckrobbery.Items = {
    [1] = {name = 'cashroll', count = math.random(3, 7)},
    [2] = {name = 'cashstack', count = math.random(3, 9)},
}
Truckrobbery.Money = math.random(15000, 25000)
Truckrobbery.MinCops = 4

Lawyer = {}

Lawyer.Locations = {
    ['vehicles'] = { ['x'] = 116.26222, ['y'] = -937.1817, ['z'] = 29.674716, ['h'] = 157.00186 },
    ['boss'] = { ['x'] = 76.276954, ['y'] = -921.2986, ['z'] = 29.856935, ['h'] = 163.34269 }
}

Lawyer.Vehicles = {
    ['baller'] = 'Baller',
    ['washington'] = 'Washington',
}

Taxi = {}

Taxi.AllowedVehicles = {
   [1] = {model = "taxirooster", label = "Taxi"}
}

Taxi.Markers = {
    ['stash'] = { ['x'] = -10000.97, ['y'] = 10000.95, ['z'] = 10000.17, ['h'] = 10000.66 },
    ['boss'] = { ['x'] = 894.92, ['y'] = -179.29, ['z'] = 74.70, ['h'] = 59.65 }
}

Taxi.Meter = {
    ["defaultPrice"] = 1.60
}

Taxi.Locations = {
    ["vehicle"] = {
        ["x"] = 909.5,
        ["y"] = -177.35,
        ["z"] = 74.22,
        ["h"] = 238.5,
    }
}

Taxi.NPCLocations = {
    TakeLocations = {
        [1] = {x = 257.61, y = -380.57, z = 44.71, h = 340.5, r = 1.0}, 
        [2] = {x = -48.58, y = -790.12, z = 44.22, h = 340.5, r = 1.0}, 
        [3] = {x = 240.06, y = -862.77, z = 29.73, h = 341.5, r = 1.0}, 
        [4] = {x = 826.0, y = -1885.26, z = 29.32, h = 81.5, r = 1.0}, 
        [5] = {x = 350.84, y = -1974.13, z = 24.52, h = 318.5, r = 1.0}, 
        [6] = {x = -229.11, y = -2043.16, z = 27.75, h = 233.5, r = 1.0}, 
        [7] = {x = -1053.23, y = -2716.2, z = 13.75, h = 329.5, r = 1.0}, 
        [8] = {x = -774.04, y = -1277.25, z = 5.15, h = 171.5, r = 1.0}, 
        [9] = {x = -1184.3, y = -1304.16, z = 5.24, h = 293.5, r = 1.0}, 
        [10] = {x = -1321.28, y = -833.8, z = 16.95, h = 140.5, r = 1.0}, 
        [11] = {x = -1613.99, y = -1015.82, z = 13.12, h = 342.5, r = 1.0}, 
        [12] = {x = -1392.74, y = -584.91, z = 30.24, h = 32.5, r = 1.0}, 
        [13] = {x = -515.19, y = -260.29, z = 35.53, h = 201.5, r = 1.0}, 
        [14] = {x = -760.84, y = -34.35, z = 37.83, h = 208.5, r = 1.0}, 
        [15] = {x = -1284.06, y = 297.52, z = 64.93, h = 148.5, r = 1.0}, 
        [16] = {x = -808.29, y = 828.88, z = 202.89, h = 200.5, r = 1.0},
    },
    DeliverLocations = {
        [1] = {x = -1074.39, y = -266.64, z = 37.75, h = 117.5, r = 1.0}, 
        [2] = {x = -1412.07, y = -591.75, z = 30.38, h = 298.5, r = 1.0}, 
        [3] = {x = -679.9, y = -845.01, z = 23.98, h = 269.5, r = 1.0}, 
        [4] = {x = -158.05, y = -1565.3, z = 35.06, h = 139.5, r = 1.0}, 
        [5] = {x = 442.09, y = -1684.33, z = 29.25, h = 320.5, r = 1.0}, 
        [6] = {x = 1120.73, y = -957.31, z = 47.43, h = 289.5, r = 1.0}, 
        [7] = {x = 1238.85, y = -377.73, z = 69.03, h = 70.5, r = 1.0}, 
        [8] = {x = 922.24, y = -2224.03, z = 30.39, h = 354.5, r = 1.0}, 
        [9] = {x = 1920.93, y = 3703.85, z = 32.63, h = 120.5, r = 1.0}, 
        [10] = {x = 1662.55, y = 4876.71, z = 42.05, h = 185.5, r = 1.0}, 
        [11] = {x = -9.51, y = 6529.67, z = 31.37, h = 136.5, r = 1.0}, 
        [12] = {x = -3232.7, y = 1013.16, z = 12.09, h = 177.5, r = 1.0}, 
        [13] = {x = -1604.09, y = -401.66, z = 42.35, h = 321.5, r = 1.0}, 
        [14] = {x = -586.48, y = -255.96, z = 35.91, h = 210.5, r = 1.0},
        [15] = {x = 23.66, y = -60.23, z = 63.62, h = 341.5, r = 1.0}, 
        [16] = {x = 550.3, y = 172.55, z = 100.11, h = 339.5, r = 1.0}, 
        [17] = {x = -1048.55, y = -2540.58, z = 13.69, h = 148.5, r = 1.0}, 
        [18] = {x = -9.55, y = -544.0, z = 38.63, h = 87.5, r = 1.0}, 
        [19] = {x = -7.86, y = -258.22, z = 46.9, h = 68.5, r = 1.0}, 
        [20] = {x = -743.34, y = 817.81, z = 213.6, h = 219.5, r = 1.0}, 
        [21] = {x = 218.34, y = 677.47, z = 189.26, h = 359.5, r = 1.0}, 
        [22] = {x = 263.2, y = 1138.81, z = 221.75, h = 203.5, r = 1.0}, 
        [23] = {x = 220.64, y = -1010.81, z = 29.22, h = 160.5, r = 1.0}, 
    }
}

Taxi.NpcSkins = {
    [1] = {
        'a_f_m_skidrow_01',
        'a_f_m_soucentmc_01',
        'a_f_m_soucent_01',
        'a_f_m_soucent_02',
        'a_f_m_tourist_01',
        'a_f_m_trampbeac_01',
        'a_f_m_tramp_01',
        'a_f_o_genstreet_01',
        'a_f_o_indian_01',
        'a_f_o_ktown_01',
        'a_f_o_salton_01',
        'a_f_o_soucent_01',
        'a_f_o_soucent_02',
        'a_f_y_beach_01',
        'a_f_y_bevhills_01',
        'a_f_y_bevhills_02',
        'a_f_y_bevhills_03',
        'a_f_y_bevhills_04',
        'a_f_y_business_01',
        'a_f_y_business_02',
        'a_f_y_business_03',
        'a_f_y_business_04',
        'a_f_y_eastsa_01',
        'a_f_y_eastsa_02',
        'a_f_y_eastsa_03',
        'a_f_y_epsilon_01',
        'a_f_y_fitness_01',
        'a_f_y_fitness_02',
        'a_f_y_genhot_01',
        'a_f_y_golfer_01',
        'a_f_y_hiker_01',
        'a_f_y_hipster_01',
        'a_f_y_hipster_02',
        'a_f_y_hipster_03',
        'a_f_y_hipster_04',
        'a_f_y_indian_01',
        'a_f_y_juggalo_01',
        'a_f_y_runner_01',
        'a_f_y_rurmeth_01',
        'a_f_y_scdressy_01',
        'a_f_y_skater_01',
        'a_f_y_soucent_01',
        'a_f_y_soucent_02',
        'a_f_y_soucent_03',
        'a_f_y_tennis_01',
        'a_f_y_tourist_01',
        'a_f_y_tourist_02',
        'a_f_y_vinewood_01',
        'a_f_y_vinewood_02',
        'a_f_y_vinewood_03',
        'a_f_y_vinewood_04',
        'a_f_y_yoga_01',
        'g_f_y_ballas_01',
    },
    [2] = {
        'ig_barry',
        'ig_bestmen',
        'ig_beverly',
        'ig_car3guy1',
        'ig_car3guy2',
        'ig_casey',
        'ig_chef',
        'ig_chengsr',
        'ig_chrisformage',
        'ig_clay',
        'ig_claypain',
        'ig_cletus',
        'ig_dale',
        'ig_dreyfuss',
        'ig_fbisuit_01',
        'ig_floyd',
        'ig_groom',
        'ig_hao',
        'ig_hunter',
        'csb_prolsec',
        'ig_joeminuteman',
        'ig_josef',
        'ig_josh',
        'ig_lamardavis',
        'ig_lazlow',
        'ig_lestercrest',
        'ig_lifeinvad_01',
        'ig_lifeinvad_02',
        'ig_manuel',
        'ig_milton',
        'ig_mrk',
        'ig_nervousron',
        'ig_nigel',
        'ig_old_man1a',
        'ig_old_man2',
        'ig_oneil',
        'ig_orleans',
        'ig_ortega',
        'ig_paper',
        'ig_priest',
        'ig_prolsec_02',
        'ig_ramp_gang',
        'ig_ramp_hic',
        'ig_ramp_hipster',
        'ig_ramp_mex',
        'ig_roccopelosi',
        'ig_russiandrunk',
        'ig_siemonyetarian',
        'ig_solomon',
        'ig_stevehains',
        'ig_stretch',
        'ig_talina',
        'ig_taocheng',
        'ig_taostranslator',
        'ig_tenniscoach',
        'ig_terry',
        'ig_tomepsilon',
        'ig_tylerdix',
        'ig_wade',
        'ig_zimbor',
        's_m_m_paramedic_01',
        'a_m_m_afriamer_01',
        'a_m_m_beach_01',
        'a_m_m_beach_02',
        'a_m_m_bevhills_01',
        'a_m_m_bevhills_02',
        'a_m_m_business_01',
        'a_m_m_eastsa_01',
        'a_m_m_eastsa_02',
        'a_m_m_farmer_01',
        'a_m_m_fatlatin_01',
        'a_m_m_genfat_01',
        'a_m_m_genfat_02',
        'a_m_m_golfer_01',
        'a_m_m_hasjew_01',
        'a_m_m_hillbilly_01',
        'a_m_m_hillbilly_02',
        'a_m_m_indian_01',
        'a_m_m_ktown_01',
        'a_m_m_malibu_01',
        'a_m_m_mexcntry_01',
        'a_m_m_mexlabor_01',
        'a_m_m_og_boss_01',
        'a_m_m_paparazzi_01',
        'a_m_m_polynesian_01',
        'a_m_m_prolhost_01',
        'a_m_m_rurmeth_01',
    }
}

Recycle = {}

Recycle['delivery'] = {
	
	outsideLocation = {x= 90.960121 ,y= -1603.624 ,z= 31.078811 ,a= 56.892559}	,
	insideLocation = {x=1072.72,y=-3102.51,z=-40.0,a=82.95},
	pickupLocations = {
		[1] = {x=1067.68,y=-3095.43,z=-39.9,a=342.39},
		[2] = {x=1065.2,y=-3095.56,z=-39.9,a=356.53},
		[3] = {x=1062.73,y=-3095.15,z=-39.9,a=184.81},
		[4] = {x=1060.37,y=-3095.06,z=-39.9,a=190.3},
		[5] = {x=1057.95,y=-3095.51,z=-39.9,a=359.02},
		[6] = {x=1055.58,y=-3095.53,z=-39.9,a=0.95},
		[7] = {x=1053.09,y=-3095.57,z=-39.9,a=347.64},
		[8] = {x=1053.07,y=-3102.46,z=-39.9,a=180.26},
		[9] = {x=1055.49,y=-3102.45,z=-39.9,a=180.46},
		[10] = {x=1057.93,y=-3102.55,z=-39.9,a=174.22},
		[11] = {x=1060.19,y=-3102.38,z=-39.9,a=189.44},
		[12] = {x=1062.71,y=-3102.53,z=-39.9,a=182.11},
		[13] = {x=1065.19,y=-3102.48,z=-39.9,a=176.23},
		[14] = {x=1067.46,y=-3102.62,z=-39.9,a=188.28},
		[15] = {x=1067.69,y=-3110.01,z=-39.9,a=173.63},
		[16] = {x=1065.13,y=-3109.88,z=-39.9,a=179.46},
		[17] = {x=1062.7,y=-3110.07,z=-39.9,a=174.32},
		[18] = {x=1060.24,y=-3110.26,z=-39.9,a=177.77},
		[19] = {x=1057.76,y=-3109.82,z=-39.9,a=183.88},
		[20] = {x=1055.52,y=-3109.76,z=-39.9,a=181.36},
		[21] = {x=1053.16,y=-3109.71,z=-39.9,a=177.0},
	},
	dropLocation = {x = 1048.224, y = -3097.071, z = -38.999, a = 274.810},
	warehouseObjects = {
		"prop_boxpile_05a",
		"prop_boxpile_04a",
		"prop_boxpile_06b",
		"prop_boxpile_02c",
		"prop_boxpile_02b",
		"prop_boxpile_01a",
		"prop_boxpile_08a",
	},
}

Justice = {}

Justice.Locations = {
    ["courthouse"] = {
        enter = {
            x = 329.46292, 
            y = -1650.588, 
            z = 32.53173, 
            h = 306.05245,
        },
        exit = {
            x = 329.52896, 
            y = -1650.518, 
            z = 60.53371, 
            h = 330.12997,
        },
    }
}
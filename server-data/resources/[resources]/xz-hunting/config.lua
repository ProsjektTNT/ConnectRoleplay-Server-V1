Config = {}

Config.Animals = {
    [GetHashKey("a_c_mtlion")] = {
        meatAmount = {min = 3, max = 7},
        meatName = "lion_meat",
    },

    [GetHashKey("a_c_deer")] = {
        meatAmount = {min = 5, max = 10},
        meatName = "deer_meat",
    },

    [GetHashKey("a_c_pig")] = {
        meatAmount = {min = 4, max = 7},
        meatName = "pig_meat",
    },

    [GetHashKey("a_c_rabbit_01")] = {
        meatAmount = {min = 1, max = 2},
        meatName = "rabbit_meat",
    }
}

Config.Prices = {
    Items = {
        ["lion_meat"] = {min = 150, max = 200},
        ["deer_meat"] = {min = 60, max = 80},
        ["pig_meat"] = {min = 180, max = 260},
        ["rabbit_meat"] = {min = 20, max = 50},
    },

    Other = {
        ["weapon_rent"] = 250
    }
}

Config.Levels = {
    [2] = {
        animalsNeeded = 50,
        meatMulti = 1.5
    },
    [3] = {
        animalsNeeded = 150,
        meatMulti = 3
    }
}

Config.Messages = {
    Notify = {
        ["arrived_to_location"] = {
            text = "Welcome to the hunting field, have fun hunting, to stop hunting and earn your money go back to where you started.",
            type = "primary",
            length = 10000
        },

        ["location_set"] = {
            text = "the hunting location has been marked in your GPS.",
            type = "primary",
            length = 10000
        },

        ["sold_items"] = {
            text = "You sold %s items for %s$.",
            type = "primary",
            length = 2500
        },

        ["no_items"] = {
            text = "You didn't have any items to sell.",
            type = "primary",
            length = 2500
        },

        ["collected_meat"] = {
            text = "You got %skg from %s.",
            type = "primary",
            length = 2500
        },

        ["no_money"] = {
            text = "You don't have enough money.",
            type = "error",
            length = 2500
        },
    },


    Text = {
        ["collect_meat"] = "~g~E~w~ Collect Meat [~g~%s~w~kg]",
        ["start_hunt"] = "~g~E~w~ - Start Hunting 250$",
        ["stop_hunt"] = "~g~E~w~ Stop Hunting"
    }


}

Config.Blips = {
    Shop = {

    },

    HuntingZone = {
        
    }
}

Config.Locations = {
    ["enemy"] = vector4(-765.6273803710938, 5601.37548828125, 33.41631317138672, 73.0),

    ["startJob"] = vector3(-679.8206, 5838.873, 17.331434),
    ["startHunting"] = vector3(-1591.9956054688, 4772.4399414063, 50.931644439697),
}

Config.Shop = {

    label = "Hunting Shop",
    slots = 20,

    items = {
        {
            name = "weapon_musket",
            price = 5,
            amount = 200,
            info = {},
            type = "weapon",
            slot = 1,
        },
        {
            name = "shotgun_ammo",
            price = 5,
            amount = 200,
            info = {},
            type = "item",
            slot = 2,
        },
        {
            name = "hunting_knife",
            price = 5,
            amount = 200,
            info = {
                level = 1,
                animals = 0
            },
            type = "item",
            slot = 3,
        },

    }
}
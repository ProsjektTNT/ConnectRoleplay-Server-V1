Config = {}

Config.BillingCommissions = { -- This is a percentage (0.10) == 10%
    mechanic = 0.10
}
Config.RepeatTimeout = 2000
Config.CallRepeats = 10
Config.OpenPhone = 244
Config.PhoneApplications = {
    ["phone"] = {
        app = "phone",
        color = "#04b543",
        icon = "fa fa-phone-alt",
        tooltipText = "Phone",
        tooltipPos = "bottom",
        job = false,
        blockedjobs = {},
        slot = 1,
        Alerts = 0,
    },
    ["whatsapp"] = {
        app = "whatsapp",
        color = "#25d366",
        icon = "fab fa-whatsapp",
        tooltipText = "Whatsapp",
        tooltipPos = "bottom",
        style = "font-size: 2.8vh";
        job = false,
        blockedjobs = {},
        slot = 2,
        Alerts = 0,
    },
    ["twitter"] = {
        app = "twitter",
        color = "#1da1f2",
        icon = "fab fa-twitter",
        tooltipText = "Twitter",
        tooltipPos = "bottom",
        job = false,
        blockedjobs = {},
        slot = 3,
        Alerts = 0,
    },
    ["settings"] = {
        app = "settings",
        color = "#636e72",
        icon = "fa fa-cog",
        tooltipText = "Settings",
        tooltipPos = "bottom",
        style = "padding-right: .08vh; font-size: 2.3vh";
        job = false,
        blockedjobs = {},
        slot = 4,
        Alerts = 0,
    },
    ["garage"] = {
        app = "garage",
        color = "#575fcf",
        icon = "fas fa-warehouse",
        tooltipText = "Vehicles",
        job = false,
        blockedjobs = {},
        slot = 5,
        Alerts = 0,
    },
    ["mail"] = {
        app = "mail",
        color = "#ff002f",
        icon = "fas fa-envelope",
        tooltipText = "Mail",
        job = false,
        blockedjobs = {},
        slot = 6,
        Alerts = 0,
    },
    ["advert"] = {
        app = "advert",
        color = "#ff8f1a",
        icon = "fas fa-ad",
        tooltipText = "Advertisements",
        job = false,
        blockedjobs = {},
        slot = 7,
        Alerts = 0,
    },
    ["bank"] = {
        app = "bank",
        color = "#9c88ff",
        icon = "fas fa-university",
        tooltipText = "Bank",
        job = false,
        blockedjobs = {},
        slot = 8,
        Alerts = 0,
    },
    ["crypto"] = {
        app = "crypto",
        color = "#004682",
        icon = "fas fa-chart-pie",
        tooltipText = "Crypto",
        job = false,
        blockedjobs = {},
        slot = 9,
        Alerts = 0,
    },
    ["racing"] = {
        app = "racing",
        color = "#353b48",
        icon = "fas fa-flag-checkered",
        tooltipText = "Racing",
        job = false,
        blockedjobs = {},
        slot = 10,
        Alerts = 0,
    },
    ["houses"] = {
        app = "houses",
        color = "#27ae60",
        icon = "fas fa-home",
        tooltipText = "Houses",
        job = false,
        blockedjobs = {},
        slot = 11,
        Alerts = 0,
    },
    ["lawyers"] = {
        app = "lawyers",
        color = "#26d4ce",
        icon = "fas fa-user-tie",
        tooltipText = "Services",
        tooltipPos = "bottom",
        job = false,
        blockedjobs = {},
        slot = 12,
        Alerts = 0,
    },
    ["rentel"] = {
        app = "rentel",
        color = "‎#ee82ee",
        icon = "fas fa-car",
        tooltipText = "Rental",
        style = "padding-right: .3.2vh; font-size: 2.3vh";
        job = false,
        blockedjobs = {},
        slot = 13,
        Alerts = 0,
    },
    ["meos"] = {
        app = "meos",
        color = "#004682",
        icon = "fas fa-ad",
        tooltipText = "MDT",
        job = "police",
        blockedjobs = {},
        slot = 14,
        Alerts = 0,
    },
   --[[ ["store"] = {
        app = "store",
        color = "#27ae60",
        icon = "fas fa-cart-arrow-down",
        tooltipText = "App Store",
        tooltipPos = "right",
        style = "padding-right: .3vh; font-size: 2.2vh";
        job = false,
        blockedjobs = {},
        slot = 15,
        Alerts = 0,
    },]]
    -- ["trucker"] = {
    --     app = "trucker",
    --     color = "#cccc33",
    --     icon = "fas fa-truck-moving",
    --     tooltipText = "Dumbo",
    --     tooltipPos = "right",
    --     job = false,
    --     blockedjobs = {},
    --     slot = 16,
    --     Alerts = 0,
    -- },
}
Config.MaxSlots = 20

Config.StoreApps = {
    ["territory"] = {
        app = "territory",
        color = "#353b48",
        icon = "fas fa-globe-europe",
        tooltipText = "Territorium",
        tooltipPos = "right",
        style = "";
        job = false,
        blockedjobs = {},
        slot = 15,
        Alerts = 0,
        password = true,
        creator = "XZCore",
        title = "Territory",
    },
}

Config.RentelVehicles = {
	['tribike3'] = { ['model'] = 'tribike3', ['label'] = 'Tribike Blue', ['price'] = 100, ['icon'] = 'fas fa-biking', ["papers"] = false },
	['bimx'] = { ['model'] = 'bmx', ['label'] = 'BIMX', ['price'] = 100, ['icon'] = 'fas fa-biking', ["papers"] = false },
    ['panto'] = { ['model'] = 'panto', ['label'] = 'Panto', ['price'] = 250, ['icon'] = 'fas fa-car', ["papers"] = true },
	['rhapsody'] = { ['model'] = 'rhapsody', ['label'] = 'Rhapsody', ['price'] = 300, ['icon'] = 'fas fa-car', ["papers"] = true },
	['felon'] = { ['model'] = 'felon', ['label'] = 'Felon', ['price'] = 400, ['icon'] = 'fas fa-car', ["papers"] = true },
	['bagger'] = { ['model'] = 'bagger', ['label'] = 'Bagger', ['price'] = 400, ['icon'] = 'fas fa-motorcycle', ["papers"] = true },
}

Config.RentelLocations = {

    {
        coords = vector3(-212.5594, -1003.85, 29.147315),
        heading = 70.0,
        width = 1,
        heigth = 0.6,

        carSpawn = vector4(-211.151, -996.0937, 29.150337, 336.8041)
    },
    {
        coords = vector3(-1206.875, -851.004, 13.691901),
        heading = 31.0,
        width = 1.0,
        heigth = 0.76,

        carSpawn = vector4(-1210.846, -855.6194, 12.912775, 123.50523)
    },
    {
        coords = vector3(21.162067, -1699.44, 29.140592),
        heading = 201.40,
        width = 1.0,
        heigth = 0.74,

        carSpawn = vector4(25.028827, -1696.207, 28.556863, 290.96386)
    },
    {
        coords = vector3(412.64337, -632.6001, 28.500022),
        heading = 359.0,
        width = 1.0,
        heigth = 0.73,

        carSpawn = vector4(408.3887, -638.7281, 27.894241, 270.56179)
    },
    {
        coords = vector3(127.75584, -897.8503, 30.257951),
        heading = 70.0,
        width = 1,
        heigth = 0.78,

        carSpawn = vector4(125.67895, -908.4204, 29.987586, 157.26879)
    },
    {
        coords = vector3(1504.7943, 3767.4741, 33.971286),
        heading = 30.0,
        width = 1,
        heigth = 0.78,

        carSpawn = vector4(1497.9998, 3760.1149, 33.323825, 30.445491)
    },
    {
        coords = vector3(1887.7885, 2594.8972, 45.671905),
        heading = 270.0,
        width = 1,
        heigth = 0.78,

        carSpawn = vector4(1876.2009, 2595.0366, 45.065185, 89.639587)
    },
    {
        coords = vector3(204.1175, 6632.1533, 31.554899),
        heading = 341.0,
        width = 1,
        heigth = 0.78,

        carSpawn = vector4(199.6793, 6630.0693, 30.921258, 348.73699)
    },
}

Config.BoatLocations = {

    {
        coords = vector3(-732.8048, -1311.849, 5.0003786),
        boatSpawn = vector4(-726.2034, -1326.876, 0.0668057, 226.7127)
    },
    {
        coords = vector3(3854.6093, 4458.9965, 1.8497662),
        boatSpawn = vector4(3852.8601, 4455.7749, -0.109287, 270.19085)
    },
    {
        coords = vector3(-3425.839, 952.20977, 8.3466939),
        boatSpawn = vector4(-3424.609, 948.19409, 0.0134553, 88.102264)
    },
}

Config.RentelBoats = {
    ['seashark'] = { ['model'] = 'seashark', ['label'] = 'Seashark', ['price'] = 1000 },
    ['dinghy'] = { ['model'] = 'dinghy', ['label'] = 'Dinghy', ['price'] = 2500 },
    ['toro'] = { ['model'] = 'toro', ['label'] = 'Toro', ['price'] = 4000 },
    ['speeder'] = { ['model'] = 'speeder', ['label'] = 'Speeder', ['price'] = 4500 },
    ['marquis'] = { ['model'] = 'marquis', ['label'] = 'Marquis', ['price'] = 5000 },
}

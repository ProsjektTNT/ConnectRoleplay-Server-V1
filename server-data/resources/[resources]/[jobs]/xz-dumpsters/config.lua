local Config, PlayerData = {}, {}

Config.DumpsterModels = {
    'prop_dumpster_01a',
    'prop_dumpster_02a',
    'prop_dumpster_02b',
    'prop_dumpster_3a',
    'prop_dumpster_4a',
    'prop_dumpster_4b',
}

Config.TrashCanModels = {
    'v_ret_gc_bin',
    'v_serv_metro_floorbin',
    'v_serv_metro_wallbin',
    'v_serv_tc_bin3_',
    'v_serv_waste_bin1',
    'v_serv_tc_bin1_',
    'v_serv_tc_bin2_',
    'prop_cs_bin_01',
    'prop_cs_bin_02',
    'prop_cs_bin_03',
    'prop_cs_bin_01_skinned',
    'v_med_cor_cembin',
    'prop_bin_01a',
    'prop_bin_02a',
    'prop_bin_03a',
}

Config.DumpsterTimeout = 48 -- minutes

Config.DailyLimitTimeout = 48 -- minutes
Config.DailyLimit = 5 -- Max dumpsters you can search every day

Config.UseMoney = true
Config.MoneyChance = 20
Config.MoneyAmount = math.random(50, 350)

Config.UseLootTable = true
Config.LootTable = {
    [1] = {
        ['item'] = 'metalscrap',
        ['amount'] = math.random(1, 5),
        ['chance'] = 90
    },
    [2] = {
        ['item'] = 'coffeebag',
        ['amount'] = math.random(1, 1),
        ['chance'] = 60
    },
    [3] = {
        ['item'] = 'twerks_candy',
        ['amount'] = math.random(1, 2),
        ['chance'] = 80
    },
    [4] = {
        ['item'] = 'snikkel_candy',
        ['amount'] = math.random(1, 2),
        ['chance'] = 80
    },
    [5] = {
        ['item'] = 'crack_baggy',
        ['amount'] = math.random(1, 3),
        ['chance'] = 25
    },
    [6] = {
        ['item'] = 'shitlockpick',
        ['amount'] = math.random(1, 1),
        ['chance'] = 85
    },
    [7] = {
        ['item'] = 'watch',
        ['amount'] = math.random(1, 1),
        ['chance'] = 15
    },
    [8] = {
        ['item'] = 'goldchain',
        ['amount'] = math.random(1, 1),
        ['chance'] = 15
    },
    [9] = {
        ['item'] = 'assphone',
        ['amount'] = math.random(1, 1),
        ['chance'] = 75
    },
    [10] = {
        ['item'] = 'binoculars',
        ['amount'] = math.random(1, 1),
        ['chance'] = 70
    },
    [11] = {
        ['item'] = 'firework1',
        ['amount'] = math.random(1, 2),
        ['chance'] = 70
    },
    [12] = {
        ['item'] = 'samsungphone',
        ['amount'] = math.random(1, 1),
        ['chance'] = 70
    },
    [13] = {
        ['item'] = 'iphone',
        ['amount'] = math.random(1, 1),
        ['chance'] = 65
    },
    [14] = {
        ['item'] = 'lighter',
        ['amount'] = math.random(1, 2),
        ['chance'] = 90
    },
    [15] = {
        ['item'] = 'ciggy',
        ['amount'] = math.random(1, 5),
        ['chance'] = 85
    },
    [16] = {
        ['item'] = 'cigar',
        ['amount'] = math.random(1, 3),
        ['chance'] = 80
    },
}

Config.ItemRewardMessage = 'You got x%s %s in your inventory'

Config.FullInventoryMessage = 'Full Inventory!'

Config.TargetIcon = 'fas fa-circle'
Config.TargetLabel = 'Search Dumpster'

Config.NoLuckMessage = 'You had no luck this time'

Config.ProgressLabel = 'Searching Dumpster'
Config.ProgressDuration = 15000

Config.ProgressAnimDict = "amb@prop_human_bum_bin@idle_b"
Config.ProgressAnim = "idle_d"
Config.ProgressAnimFlag = 50

return Config, PlayerData
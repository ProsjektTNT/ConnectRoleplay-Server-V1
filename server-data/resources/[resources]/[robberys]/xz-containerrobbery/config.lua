local Config, PlayerData = {}, {}

Config.ContainerModel = 'prop_truktrailer_01a'

Config.OnlyNight = false
Config.NeededCops = 4
Config.RobberyTimeout = 60 -- minutes

Config.MoneyReward = math.random(1000,2000)
Config.MoneyRewardMessage = 'You got $%s amount of money'
Config.ItemRewardMessage = 'You got x%s %s in your inventory'

Config.FullInventoryMessage = 'Full Inventory!'

Config.NoCopsMessage = 'No Cops!'

Config.UseLootTable = true
Config.LootTable = {
    [1] = {
        ['item'] = 'metalscrap',
        ['amount'] = math.random(25, 50),
        ['chance'] = 80
    },
    [2] = {
        ['item'] = 'copper',
        ['amount'] = math.random(25, 50),
        ['chance'] = 80
    },
    [3] = {
        ['item'] = 'plastic',
        ['amount'] = math.random(25, 50),
        ['chance'] = 80
    },
    [4] = {
        ['item'] = 'aluminum',
        ['amount'] = math.random(25, 50),
        ['chance'] = 100
    },
    [5] = {
        ['item'] = 'iron',
        ['amount'] = math.random(25, 50),
        ['chance'] = 80
    },
    [6] = {
        ['item'] = 'steel',
        ['amount'] = math.random(25, 50),
        ['chance'] = 80
    },
    [7] = {
        ['item'] = 'rubber',
        ['amount'] = math.random(25, 50),
        ['chance'] = 80
    },
    [8] = {
        ['item'] = 'glass',
        ['amount'] = math.random(25, 50),
        ['chance'] = 80
    },
    [9] = {
        ['item'] = 'electronickit',
        ['amount'] = math.random(1, 2),
        ['chance'] = 40
    },
    [10] = {
        ['item'] = 'rolex',
        ['amount'] = math.random(5, 10),
        ['chance'] = 40
    },
    [11] = {
        ['item'] = 'watch',
        ['amount'] = math.random(5, 10),
        ['chance'] = 40
    },
    [12] = {
        ['item'] = '10kgoldchain',
        ['amount'] = math.random(5, 10),
        ['chance'] = 40
    },
    [13] = {
        ['item'] = 'goldchain',
        ['amount'] = math.random(5, 10),
        ['chance'] = 20
    },
    [14] = {
        ['item'] = 'diamond_ring',
        ['amount'] = math.random(5, 10),
        ['chance'] = 40
    },
    [15] = {
        ['item'] = 'security_card_02',
        ['amount'] = math.random(1, 1),
        ['chance'] = 4
    },
    [16] = {
        ['item'] = 'cashstack',
        ['amount'] = math.random(2, 6),
        ['chance'] = 100
    },
}

Config.TargetIcon = "fas fa-circle"
Config.TargetLabel = "Rob Container"

Config.UseItems = true
Config.UseWeapons = true

Config.NeededItem = 'weapon_crowbar'
Config.NeededHoldingWeapon = 'weapon_crowbar'

Config.TaskBarSkillDifficulty = math.random(1000,1000)
Config.TaskBarSkillCount = math.random(8, 12)

Config.FailMessage = 'You Failed!'
Config.BusyMessage = 'Cannot perform this action at the moment!'

Config.ProgressLabel = 'Robbing Container'
Config.ProgressDuration = math.random(10000, 20000)

Config.ProgressAnimDict = "missheistfbi3b_ig7"
Config.ProgressAnim = "lift_fibagent_loop"
Config.ProgressAnimFlag = 51

Config.MaleNoHandshoes = {
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

Config.FemaleNoHandshoes = {
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

return Config, PlayerData
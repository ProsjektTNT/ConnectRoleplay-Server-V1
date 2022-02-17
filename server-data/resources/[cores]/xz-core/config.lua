XZConfig = {}

XZConfig.MaxPlayers = GetConvarInt('sv_maxclients', 48) -- Gets max players from config file, default 32
XZConfig.DefaultSpawn = {x=-1035.71,y=-2731.87,z=12.86,a=0.0}

XZConfig.Money = {}
XZConfig.Money.MoneyTypes = {['cash'] = 2500, ['bank'] = 10000, ['crypto'] = 0 } -- ['type'] = startamount - Add or remove money types for your server (for ex. ['blackmoney']=0), remember once added it will not be removed from the database!
XZConfig.Money.DontAllowMinus = {'cash', 'crypto'} -- Money that is not allowed going in minus
XZConfig.Money.PayCheckTimeOut = 25 -- The time in minutes that it will give the paycheck

XZConfig.Player = {}
XZConfig.Player.MaxWeight = 250000 -- Max weight a player can carry (currently 120kg, written in grams)
XZConfig.Player.MaxInvSlots = 41 -- Max inventory slots for a player
XZConfig.Player.HungerRate = 4.2 -- Rate at which hunger goes down.
XZConfig.Player.ThirstRate = 3.8 -- Rate at which thirst goes down.
XZConfig.Player.Bloodtypes = {
    "A+",
    "A-",
    "B+",
    "B-",
    "AB+",
    "AB-",
    "O+",
    "O-",
}

XZConfig.Server = {} -- General server config
XZConfig.Server.closed = false -- Set server closed (no one can join except people with ace permission 'XZAdmin.join')
XZConfig.Server.closedReason = "Closed for testing." -- Reason message to display when people can't join the server
XZConfig.Server.uptime = 0 -- Time the server has been up.
XZConfig.Server.discord = "https://discord.gg/Rss88ESsWA" -- Discord invite link
XZConfig.Server.PermissionList = {"license:88c4f89bfcbbf4c5eac449133f45b45043d146c1"} -- permission list
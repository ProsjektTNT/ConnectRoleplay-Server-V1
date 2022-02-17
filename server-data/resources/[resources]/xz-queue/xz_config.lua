Config = {}

local Prefix = "[XZoneRP] "
Config.DiscordServerID = 776605690269270028
Config.DiscordBotToken = "YOUR TOKEN HERE"
Config.maxServerSlots = 48
Config.Roles = {
	
	Civilians = {
		roleID = "848931719075463199",
		points = 0,
		name = "Civilians"
	},

	DonatorTier1 = {
		roleID = "848933171608944671",
		points = 15,
		name = "Silver Donator"
	},

	DonatorTier2 = {
		roleID = "848933864780726303",
		points = 20,
		name = "Gold Donator"
	},

	DonatorTier3 = {
		roleID = "848933874436407366",
		points = 25,
		name = "Diamond Donator"
	},
	
	DonatorTier4 = {
		roleID = "848933883109441607",
		points = 30,
		name = "Super Donator"
	},

	DonatorTier5 = {
		roleID = "848933914646413342",
		points = 40,
		name = "Mega Donator"
	},

	SeniorAdmin = {
		roleID = "848931696845783061",
		points = 40,
		name = "Senior Admin"
	},

	HeadAdmin = {
		roleID = "848931695947284511",
		points = 45,
		name = "Head Admin"
	},

	StaffManager = {
		roleID = "848931694765277235",
		points = 50,
		name = "Staff Manager"
	},

	Management = {
		roleID = "848931693771620352",
		points = 50,
		name = "Management"
	},

	Inspector = {
		roleID = "848931692835504138",
		points = 55,
		name = "Inspector"
	},

	CoServerManager = {
		roleID = "848931690487349248",
		points = 70,
		name = "Co Server Manager"
	},

	ServerManager = {
		roleID = "848931686867140701",
		points = 70,
		name = "Server Manager"
	},

	CommunityManager = {
		roleID = "848931684728832030",
		points = 75,
		name = "Community Management"
	},

	Developer = {
		roleID = "848931691347443811",
		points = 200,
		name = "Development Team"
	},

	Owner = {
		roleID = "848931682542551050",
		points = 200,
		name = "Community Owner"
	}
}

Config.Colors = {
	"accent",
	"good",
	"warning",
	"attention",
}

Config.Verifiying = Prefix .. "Please wait, Downloading content from XZoneRP database."
Config.VerifiyingLauncher = Prefix .. "Please wait, Verifiying you entered through the launcher."
Config.VerifiyingDiscord = Prefix .. "Please wait, Verifiying your Discord ID."
Config.VerifiyingSteam = Prefix .. "Please wait, Verifiying your Steam."
Config.VerifiyingQueue = Prefix .. "Please wait, Adding you to the queue."

Config.NotWhitelisted = Prefix .. "Sorry, You are not whitelisted for our server."
Config.NoDiscord = Prefix .. "Please make sure your Discord is open."
Config.NoSteam = Prefix .. "Please make sure your Steam is open."
Config.NoLauncher = Prefix .. "The server can only be accessed through its launcher."
Config.Blacklisted = Prefix .. "You're blacklisted from the server, fuck off please."

Config.Welcome = Prefix .. "Welcome Sir."
Config.Error = Prefix .. "Error, Please try again later."
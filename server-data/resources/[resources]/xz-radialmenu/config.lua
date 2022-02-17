local isJudge = false
local isPolice = false
local isMedic = false
local isDoctor = false
local isNews = false
local isInstructorMode = false
local myJob = "unemployed"
local isHandcuffed = false
local isHandcuffedAndWalking = false
local hasOxygenTankOn = false
local gangNum = 0
local cuffStates = {}

local deadcooldown = false

rootMenuConfig =  {

    {
        id = "policeDeadA",
        displayName = "10-13A",
        icon = "#police-dead",
        functionName = "dispatch:officerDown",
        enableMenu = function()
            local Data, hasItem = XZCore.Functions.GetPlayerData()
            XZCore.Functions.TriggerCallback('XZCore:HasItem', function(result)
                hasItem = result
            end, "signalradar")
            while hasItem == nil do
                Wait(10)
            end
            return hasItem and (Data.metadata["isdead"] or Data.metadata["inlaststand"]) and (Data.job.name == 'police' and Data.job.onduty)
        end
    },

    {
        id = "emsDeadA",
        displayName = "10-14A",
        icon = "#ems-dead",
        functionName = "dispatch:emsDown",
        enableMenu = function()
            local Data, hasItem = XZCore.Functions.GetPlayerData()
            XZCore.Functions.TriggerCallback('XZCore:HasItem', function(result)
                hasItem = result
            end, "signalradar")
            while hasItem == nil do
                Wait(10)
            end
            return hasItem and (Data.metadata["isdead"] or Data.metadata["inlaststand"]) and (Data.job.name == 'ambulance' and Data.job.onduty)
        end
    },

    {
        id = "general",
        displayName = "General",
        icon = "#globe-europe",
        enableMenu = function()
            local Data = XZCore.Functions.GetPlayerData()
            return not Data.metadata["isdead"] and not Data.metadata["inlaststand"]
        end,
        subMenus = {"vehicle:giveKeys", "general:hotdog", "general:givenum", "general:getintrunk", "general:cornerselling"}
    },
    {
        id = "bennysEnter",
        displayName = "Enter Benny's",
        icon = "#general-mechanic",
        functionName = "enter:Bennys",
        enableMenu = function()
            local Data = XZCore.Functions.GetPlayerData()
            local isInBennys = exports["xz-bennys"]:isInBennys()
            return isInBennys and (not Data.metadata["isdead"] and not Data.metadata["inlaststand"] and IsPedInAnyVehicle(PlayerPedId(), false))
        end
    },
    {
        id = "garages",
        displayName = "Garages",
        icon = "#garages",
        functionName = "xz-garages-ido:client:requestGarageMenu",
        enableMenu = function()
            local Data = XZCore.Functions.GetPlayerData()
            local closeToGarage = exports["xz-garages-ido"]:closeToGarage()
            return closeToGarage and (not Data.metadata["isdead"] and not Data.metadata["inlaststand"])
        end
    },
    {
        id = "garages",
        displayName = "Park",
        icon = "#blips-garages",
        functionName = "xz-garages-ido:client:requestDepositCar",
        enableMenu = function()
            local Data = XZCore.Functions.GetPlayerData()
            local ped = PlayerPedId()
            local closeToGarage = exports["xz-garages-ido"]:closeToGarage()
            return closeToGarage and (not Data.metadata["isdead"] and not Data.metadata["inlaststand"]) and IsPedInAnyVehicle(ped) and (GetPedInVehicleSeat(GetVehiclePedIsIn(ped), -1) == ped)
        end
    },
    {
        id = "bennyssEnter",
        displayName = "Enter Billy's",
        icon = "#general-mechanic",
        functionName = "enter:bennyss",
        enableMenu = function()
            local Data = XZCore.Functions.GetPlayerData()
            local isInBily = exports["xz-bennys"]:isInBilys()
            return isInBily and (not Data.metadata["isdead"] and not Data.metadata["inlaststand"] and IsPedInAnyVehicle(PlayerPedId(), false))
        end
    },
    {
        id = "bennys2Enter",
        displayName = "Enter Benny's",
        icon = "#general-mechanic",
        functionName = "enter:bennys2",
        enableMenu = function()
            local Data = XZCore.Functions.GetPlayerData()
            local isInBennys2 = exports["xz-bennys"]:isInBennys2()
            return isInBennys2 and (not Data.metadata["isdead"] and not Data.metadata["inlaststand"] and IsPedInAnyVehicle(PlayerPedId(), false))
        end
    },
    {
        id = "blips",
        displayName = "Blips",
        icon = "#blips",
        enableMenu = function()
            local Data = XZCore.Functions.GetPlayerData()
            return not Data.metadata["isdead"] and not Data.metadata["inlaststand"]
        end,
        subMenus = {"blips:gas", "blips:bank", "blips:clothing", "blips:tatto", "blips:barber"}
    },

    {
        id = "house",
        displayName = "House Interaction",
        icon = "#house",
        enableMenu = function()
            local Data = XZCore.Functions.GetPlayerData()
            return not Data.metadata["isdead"] and not Data.metadata["inlaststand"]
        end,
        subMenus = {"house:give","house:remove", "house:doorlock", "house:reset", "house:decorate", "house:setstash", "house:setoutift", "house:setlogout"}
    },

    {
        id = "tow",
        displayName = "Tow Actions",
        icon = "#mechanic",
        enableMenu = function()
            local Data = XZCore.Functions.GetPlayerData()
            return (not Data.metadata["isdead"] and not Data.metadata["inlaststand"] and Data.job ~= nil and (Data.job.name == "tow"))
        end,
        subMenus = {"mechanic:impound","tow:towvehicle"} --[[,"tow:checkstatus", "tow:togglenpc"]]--
    },

    {
        id = "cuff",
        displayName = "Interaction",
        icon = "#cuffs",
        enableMenu = function()
            local Data = XZCore.Functions.GetPlayerData()
            return not Data.metadata["isdead"] and not Data.metadata["inlaststand"]
        end,
        subMenus = { "cuffing:cuff", "cuffing:steal", 'ems:putinvehicle','ems:unseatvehicle', 'police:drag', 'police:takehostage' } 
    },   

    {
        id = "vehicle",
        displayName = "Vehicle",
        icon = "#vehicle-options",
        functionName = "veh:options",
        enableMenu = function()
            local Data = XZCore.Functions.GetPlayerData()
            return (not Data.metadata["isdead"] and not Data.metadata["inlaststand"] and IsPedInAnyVehicle(PlayerPedId(), false))
        end
    },

    {
        id = "mechanic",
        displayName = "Mechanic Actions",
        icon = "#mechanic",
        enableMenu =function()
            local Data = XZCore.Functions.GetPlayerData()
            return (not Data.metadata["isdead"] and not Data.metadata["inlaststand"] and Data.job ~= nil and Data.job.name == "mechanic")
        end,
        subMenus = { "mechanic:impound", "mechanic:flatbed" }
    },

    {
        id = "judge",
        displayName = "Judge Actions",
        icon = "judge-actions",
        enableMenu =function()
            local Data = XZCore.Functions.GetPlayerData()
            return (not Data.metadata["isdead"] and not Data.metadata["inlaststand"] and Data.job ~= nil and Data.job.name == "mayor" and Data.job.grade >= 2)
        end,
        subMenus = { 'judge:mdt' }
    },

    {
        id = "taxi",
        displayName = "Taxi Actions",
        icon = "#taxi",
        enableMenu =function()
            local Data = XZCore.Functions.GetPlayerData()
            return (not Data.metadata["isdead"] and not Data.metadata["inlaststand"] and Data.job ~= nil and Data.job.name == "taxi")
        end,
        subMenus = { "taxi:togglemeter", "taxi:npcmission" }
    },

    {
        id = "police",
        displayName = "Police Actions",
        icon = "#police",
        enableMenu =function()
            local Data = XZCore.Functions.GetPlayerData()
            return (not Data.metadata["isdead"] and not Data.metadata["inlaststand"] and (Data.job ~= nil and Data.job.name == "police" and Data.job.onduty))
        end,
        subMenus = {"police:drag", "police:softcuff", "police:cuff", "ems:putinvehicle","ems:unseatvehicle","police:unmask"}
    },

    {
        id = "police-check",
        displayName = "Police Checks",
        icon = "#police-check",
        enableMenu = function()
            local Data = XZCore.Functions.GetPlayerData()
            return (not Data.metadata["isdead"] and not Data.metadata["inlaststand"] and (Data.job ~= nil and Data.job.name == "police" and Data.job.onduty))
        end,
        subMenus = {"police:checkbank", "police:checklicenses","police:checkfines", "police:search" }
    },

    {
        id = "objects",
        displayName = "Objects",
        icon = "#objects",
        enableMenu = function()
            local Data = XZCore.Functions.GetPlayerData()
            return (not Data.metadata["isdead"] and not Data.metadata["inlaststand"] and (Data.job ~= nil and Data.job.name == "police" and Data.job.onduty))
        end,
        subMenus = {"objects:barier", "objects:cone", "objects:tent", "objects:spike", "objects:remove"}
    },

    {
        id = "police-mdt",
        displayName = "MDT",
        icon = "#police-mdt",
        functionName = "xz-mdt:client:openShit",
        enableMenu = function()
            local Data = XZCore.Functions.GetPlayerData()
            return (not Data.metadata["isdead"] and not Data.metadata["inlaststand"] and (Data.job ~= nil and Data.job.name == "police" and Data.job.onduty))
        end
    },

    {
        id = "radio",
        displayName = "Radio",
        icon = "#police-radio",
        enableMenu = function()
            local Data, hasItem = XZCore.Functions.GetPlayerData()
            XZCore.Functions.TriggerCallback('XZCore:HasItem', function(result)
                hasItem = result
            end, "radio")
            while hasItem == nil do
                Wait(10)
            end
            return hasItem and (not Data.metadata["isdead"] and not Data.metadata["inlaststand"] and (Data.job ~= nil and Data.job.name == "police" or Data.job.name == "ambulance" and Data.job.onduty))
        end,
        subMenus = {"xz-radio:radialChannel1","xz-radio:radialChannel2","xz-radio:radialChannel3","xz-radio:radialChannel4","xz-radio:radialChannel5","xz-radio:radialChannel6","xz-radio:radialChannel7","xz-radio:radialChannel8"}
    },


    {
        id = "police-cry",
        displayName = "Panic Button",
        icon = "#police-cry",
        functionName = "dispatch:panicButton",
        enableMenu = function()
            local Data, hasItem = XZCore.Functions.GetPlayerData()
            XZCore.Functions.TriggerCallback('XZCore:HasItem', function(result)
                hasItem = result
            end, "signalradar")
            while hasItem == nil do
                Wait(10)
            end
            return hasItem and (not Data.metadata["isdead"] and not Data.metadata["inlaststand"] and (Data.job ~= nil and Data.job.name == "police" and Data.job.onduty))
        end
    },

    {
        id = "objects",
        displayName = "Objects",
        icon = "#objects",
        enableMenu =function()
            local Data = XZCore.Functions.GetPlayerData()
            return (not Data.metadata["isdead"] and not Data.metadata["inlaststand"] and (Data.job ~= nil and Data.job.name == "ambulance" and Data.job.onduty))
        end,
        subMenus = {"ems:bed","ems:wheelchair", "objects:remove", "objects:barier", "objects:cone", "objects:tent"}
    },

    {
        id = "deadblip",
        displayName = "10-11",
        icon = "#police-dead",
        enableMenu =function()
            local Data = XZCore.Functions.GetPlayerData()
            return (isDead and Data.job ~= nil and (Data.job.name == "police" or Data.job.name == "ambulance"))
        end,
        subMenus = { "esx_outlawalert:deadofficerinprogress"}
    },

    {
        id = "vanilla",
        displayName = "Vanilla",
        icon = "#vanilla",
        enableMenu =function()
            local Data = XZCore.Functions.GetPlayerData()
            return (not Data.metadata["isdead"] and not Data.metadata["inlaststand"] and Data.job ~= nil and Data.job.name == "vanilla")
        end,
        subMenus = { "vanilla:place" }
    },

    {
        id = "news",
        displayName = "News",
        icon = "#news",
        enableMenu =function()
            local Data = XZCore.Functions.GetPlayerData()
            return (not Data.metadata["isdead"] and not Data.metadata["inlaststand"] and Data.job ~= nil and (Data.job.name == "reporter" or Data.job.name == "weaponary"))
        end,
        subMenus = { "news:boom", "news:mic", "news:cam" }
    },

    {
        id = "ems",
        displayName = "EMS",
        icon = "#medic",
        enableMenu = function()
            local Data = XZCore.Functions.GetPlayerData()
            return (not Data.metadata["isdead"] and not Data.metadata["inlaststand"] and (Data.job ~= nil and Data.job.name == "ambulance" and Data.job.onduty))
        end,
        subMenus = { 'police:drag', "ems:revive", 'ems:heal',  'ems:putinvehicle','ems:unseatvehicle'}
    }
}

newSubMenus = {
    -- Blips
    ['blips:gas'] = {
        title = "Gas Station",
        icon = "#blips-gasstations",
        functionName = "xz-gasBlips"
    },

    ['blips:bank'] = {
        title = "Banks",
        icon = "#blips-bank",
        functionName = "xz-banksBlips"
    },

    ['blips:garages'] = {
        title = "Garages",
        icon = "#blips-garages",
        functionName = "radial:client:garage"
    },

    ['blips:clothing'] = {
        title = "Clothing Shop",
        icon = "#house-setoutift",
        functionName = "xz-clothingBlips"
    },

    ['blips:barber'] = {
        title = "Barber Shop",
        icon = "#blips-barbershop",
        functionName = "xz-barberBlips"
    },

    ['blips:tatto'] = {
        title = "Tattoo Shop",
        icon = "#blips-tattooshop",
        functionName = "xz-tattooBlips"
    },

    --
    ['judge:mdt'] = {
        title = "MDT",
        icon = "#police-mdt",
        functionName = "xz-menu:police:mdt"
    },

    ['general:bills'] = {
        title = "Bills",
        icon = "#police-bills",
        functionName = "xz-menu:general:bills"
    },

    ['general:hotdog'] = {
        title = "Toggle Sale",
        icon = "#hotdog",
        functionName = "xz-hotdogjob:client:ToggleSell"
    },

    ['general:givenum'] = {
        title = "Provide Contact Details",
        icon = "#givenum",
        functionName = "xz-phone:client:GiveContactDetails"
    },

    ['general:getintrunk'] = {
        title = "Enter Trunk",
        icon = "#getintrunk",
        functionName = "xz-trunk:client:GetIn"
    },
	
    ['general:cornerselling'] = {
        title = "Corner Selling",
        icon = "#cornerselling",
        functionName = "xz-drugs:client:cornerselling"
    },
    ['deadblip:sendBlip'] = {
        title = "10-11 Distress Call",
        icon = "#police-dead",
        functionName = "xz-menu:senddeadblip"
    },
    --------------------------------------
    
    ['objects:barier'] = {
        title = "Barier",
        icon = "#barier",
        functionName = "police:client:spawnBarier"
    },

    ['objects:cone'] = {
        title = "Cone",
        icon = "#cone",
        functionName = "police:client:spawnCone"
    },

    ['objects:tent'] = {
        title = "Tent",
        icon = "#tent",
        functionName = "police:client:spawnTent"
    },

    ['objects:spike'] = {
        title = "Spike",
        icon = "#spike",
        functionName = "police:client:SpawnSpikeStrip"
    },

    ['objects:remove'] = {
        title = "Remove",
        icon = "#removeobject",
        functionName = "police:client:deleteObject"
    },

    ['ems:bed'] = {
        title = "Bed",
        icon = "#bed",
        functionName = "xz-mada:client:bed"
    },

    ['ems:wheelchair'] = {
        title = "Wheelchair",
        icon = "#wheelchair",
        functionName = "xz-mada:client:wheelchair"
    },
    --------------------------------------

    ['house:give'] = {
        title = "Give House Key",
        icon = "#house-givekey",
        functionName = "xz-houses:client:giveHouseKey"
    },

    ['house:remove'] = {
        title = "Remove House Key",
        icon = "#house-removekey",
        functionName = "xz-houses:client:removeHouseKey"
    },

    ['house:doorlock'] = {
        title = "Toggle Door lock",
        icon = "#house-doorlock",
        functionName = "xz-houses:client:toggleDoorlock"
    },

    ['house:reset'] = {
        title = "Reset Home lock",
        icon = "#house-resetlock",
        functionName = "xz-houses:client:ResetHouse"
    },

    ['house:decorate'] = {
        title = "Decorate house",
        icon = "#house-decorate",
        functionName = "xz-houses:client:decorate",
        enableMenu = function()
            local Data = XZCore.Functions.GetPlayerData()
            return not Data.metadata["isdead"] and not Data.metadata["inlaststand"]
        end,
    },

    ['house:setstash'] = {
        title = "Set Stash",
        icon = "#house-setstash",
        functionName = "xz-houses:client:setLocation",
        functionParameters =  "setstash"
    },

    ['house:setoutift'] = {
        title = "Outfit Set",
        icon = "#house-setoutift",
        functionName = "xz-houses:client:setLocation",
        functionParameters =  "setoutift"
    },

    ['house:setlogout'] = {
        title = "Logout",
        icon = "#house-logout",
        functionName = "xz-houses:client:setLocation",
        functionParameters =  "setlogout"
    },

    --------------------------------------

    ['cuffing:steal'] = {
        title = "Rob Person",
        icon = "#cuffs-steal",
        functionName = "police:client:RobPlayer",
    },
	
    ['kidnap:person'] = {
        title = "Kidnap Person",
        icon = "#cuffs-steal",
        functionName = "police:client:KidnapPlayer",
    },
	
	
    ['kidnap:trunk'] = {
        title = "Kidnap into Trunk",
        icon = "#cuffs-steal",
        functionName = "xz-trunk:client:KidnapTrunk",
    },

    ['cuffing:cuff'] = {
        title = "Cuff",
        icon = "#cuffs-cuff",
        enableMenu = function()
            local Data = XZCore.Functions.GetPlayerData()
            return (not Data.metadata["isdead"] and not Data.metadata["inlaststand"] and Data.job ~= nil and Data.job.name ~= "ambulance" and Data.job.name ~= "police" and not IsPedInAnyVehicle(ped, true))
        end,
        functionName = "police:client:CuffPlayerSoft",
    },

    ['vanilla:place'] = {
        title = "Place Stripper",
        icon = "#stripper",
        functionName = "strippers:place",
    },
    
    --------------------------------------
    ['animations:brave'] = {
        title = "Brave",
        icon = "#animation-brave",
        functionName = "AnimSet:Brave"
    },

    ['animations:hurry'] = {
        title = "Hurry",
        icon = "#animation-hurry",
        functionName = "AnimSet:Hurry"
    },

    ['animations:business'] = {
        title = "Business",
        icon = "#animation-business",
        functionName = "AnimSet:Business"
    },

    ['animations:tipsy'] = {
        title = "Tipsy",
        icon = "#animation-tipsy",
        functionName = "AnimSet:Tipsy"
    },

    ['animations:injured'] = {
        title = "Injured",
        icon = "#animation-injured",
        functionName = "AnimSet:Injured"
    },

    ['animations:tough'] = {
        title = "Tough",
        icon = "#animation-tough",
        functionName = "AnimSet:ToughGuy"
    },

    ['animations:sassy'] = {
        title = "Sassy",
        icon = "#animation-sassy",
        functionName = "AnimSet:Sassy"
    },

    ['animations:sad'] = {
        title = "Sad",
        icon = "#animation-sad",
        functionName = "AnimSet:Sad"
    },

    ['animations:posh'] = {
        title = "Posh",
        icon = "#animation-posh",
        functionName = "AnimSet:Posh"
    },

    ['animations:alien'] = {
        title = "Alien",
        icon = "#animation-alien",
        functionName = "AnimSet:Alien"
    },

    ['animations:nonchalant'] = {
        title = "Calm",
        icon = "#animation-nonchalant",
        functionName = "AnimSet:NonChalant"
    },

    ['animations:hobo'] = {
        title = "Hobo",
        icon = "#animation-hobo",
        functionName = "AnimSet:Hobo"
    },

    ['animations:money'] = {
        title = "Money",
        icon = "#animation-money",
        functionName = "AnimSet:Money"
    },

    ['animations:swagger'] = {
        title = "Swagger",
        icon = "#animation-swagger",
        functionName = "AnimSet:Swagger"
    },

    ['animations:shady'] = {
        title = "Shady",
        icon = "#animation-shady",
        functionName = "AnimSet:Shady"
    },

    ['animations:maneater'] = {
        title = "Maneater",
        icon = "#animation-maneater",
        functionName = "AnimSet:ManEater"
    },

    ['animations:chichi'] = {
        title = "Chichi",
        icon = "#animation-chichi",
        functionName = "AnimSet:ChiChi"
    },

    ['animations:default'] = {
        title = "Default",
        icon = "#animation-default",
        functionName = "AnimSet:default"
    },

    ["expressions:angry"] = {
        title="Angry",
        icon="#expressions-angry",
        functionName = "expressions",
        functionParameters =  { "mood_angry_1" }
    },

    ["expressions:drunk"] = {
        title="Drunk",
        icon="#expressions-drunk",
        functionName = "expressions",
        functionParameters =  { "mood_drunk_1" }
    },

    ["expressions:dumb"] = {
        title="Dumb",
        icon="#expressions-dumb",
        functionName = "expressions",
        functionParameters =  { "pose_injured_1" }
    },

    ["expressions:electrocuted"] = {
        title="Electrocuted",
        icon="#expressions-electrocuted",
        functionName = "expressions",
        functionParameters =  { "electrocuted_1" }
    },

    ["expressions:grumpy"] = {
        title="Grumpy",
        icon="#expressions-grumpy",
        functionName = "expressions", 
        functionParameters =  { "mood_drivefast_1" }
    },

    ["expressions:happy"] = {
        title="Happy",
        icon="#expressions-happy",
        functionName = "expressions",
        functionParameters =  { "mood_happy_1" }
    },

    ["expressions:injured"] = {
        title="Injured",
        icon="#expressions-injured",
        functionName = "expressions",
        functionParameters =  { "mood_injured_1" }
    },

    ["expressions:joyful"] = {
        title="Joyful",
        icon="#expressions-joyful",
        functionName = "expressions",
        functionParameters =  { "mood_dancing_low_1" }
    },

    ["expressions:mouthbreather"] = {
        title="Mouthbreather",
        icon="#expressions-mouthbreather",
        functionName = "expressions",
        functionParameters = { "smoking_hold_1" }
    },

    ["expressions:normal"]  = {
        title="Normal",
        icon="#expressions-normal",
        functionName = "expressions:clear"
    },

    ["expressions:oneeye"]  = {
        title="Oneeye",
        icon="#expressions-oneeye",
        functionName = "expressions",
        functionParameters = { "pose_aiming_1" }
    },

    ["expressions:shocked"]  = {
        title="Shocked",
        icon="#expressions-shocked",
        functionName = "expressions",
        functionParameters = { "shocked_1" }
    },

    ["expressions:sleeping"]  = {
        title="Sleeping",
        icon="#expressions-sleeping",
        functionName = "expressions",
        functionParameters = { "dead_1" }
    },

    ["expressions:smug"]  = {
        title="Smug",
        icon="#expressions-smug",
        functionName = "expressions",
        functionParameters = { "mood_smug_1" }
    },

    ["expressions:speculative"]  = {
        title="Speculative",
        icon="#expressions-speculative",
        functionName = "expressions",
        functionParameters = { "mood_aiming_1" }
    },

    ["expressions:stressed"]  = {
        title="Stressed",
        icon="#expressions-stressed",
        functionName = "expressions",
        functionParameters = { "mood_stressed_1" }
    },

    ["expressions:sulking"]  = {
        title="Sulking",
        icon="#expressions-sulking",
        functionName = "expressions",
        functionParameters = { "mood_sulk_1" },
    },

    ["expressions:weird"]  = {
        title="Weird",
        icon="#expressions-weird",
        functionName = "expressions",
        functionParameters = { "effort_2" }
    },

    ["expressions:weird2"]  = {
        title="Weird 2",
        icon="#expressions-weird2",
        functionName = "expressions",
        functionParameters = { "effort_3" }
     },    
    --------------------------------------
    ['vehicle:giveKeys'] = {
        title = "Give Key",
        icon = "#vehicle-givekeys",
        functionName = "vehiclekeys:client:GiveKeys"
    },
    --------------------------------------

    ['police:unmask'] = {
        title = "Remove Mask Hat",
        icon = "#unmask",
        functionName = "police:unmask"
    },

    ['police:checkbank'] = {
        title = "Check Bank",
        icon = "#police-check-bank",
        functionName = "police:client:checkBank"
    },

    ['police:checklicenses'] = {
        title = "Check Licenses",
        icon = "#police-check-licenses",
        functionName = "police:client:checkLicenses"
    },

    ['police:checkfines'] = {
        title = "Check Fines",
        icon = "#police-check-fines",
        functionName = "police:client:checkFines"
    },

    ['police:search'] = {
        title = "Search Person",
        icon = "#police-search",
        functionName = "police:client:SearchPlayer"
    },

    ['police:drag'] = {
        title = "Escort",
        icon = "#general-escort",
        functionName = "police:client:EscortPlayer",
    },
    
    ['police:cuff'] = {
        title = "Cuff",
        icon = "#cuffs-cuff",
        functionName = "police:client:CuffPlayer"
    },

    ['police:softcuff'] = {
        title = "Soft Cuff",
        icon = "#cuffs-cuff",
        functionName = "police:client:CuffPlayerSoft"
    },

    ['police:takehostage'] = {
        title = "Take Hostage",
        icon = "#cuffs-carry",
        functionName = 'action:TakeHostage'
    },
	
	--------------------------------------
    ['ems:revive'] = {
        title = "Revive",
        icon = "#ems-revive",
        functionName = "hospital:client:RevivePlayer",
    },

    ['ems:heal'] = {
        title = "Heal",
        icon = "#ems-heal",
        functionName = "hospital:client:TreatWounds",
    },

    ['ems:undrag'] = {
        title = "Drag",
        icon = "#general-escort",
        functionName = "police:client:EscortPlayer"
    },

    ['ems:putinvehicle'] = {
        title = "Seat Vehicle",
        icon = "#general-put-in-veh",
        functionName = "police:client:PutPlayerInVehicle"
    },

    ['ems:unseatvehicle'] = {
        title = "Unseat Nearest",
        icon = "#general-unseat-nearest",
        functionName = "police:client:SetPlayerOutVehicle"
    },
    --------------------------------------
	['news:boom'] = {
        title = "Boom Microphone",
        icon = "#news-boom",
        functionName = "Mic:ToggleBMic"
    },

    ['news:cam'] = {
        title = "Camera",
        icon = "#news-cam",
        functionName = "Cam:ToggleCam"
    },

    ['news:mic'] = {
        title = "Microphone",
        icon = "#news-mic",
        functionName = "Mic:ToggleMic"
    },
    --------------------------------------
    ["taxi:togglemeter"] = {
        title = "Show/Hide Meter",
        icon = "#taxi-togglemeter",
        functionName = "xz-taxi:client:toggleMeter",
    },

    ["taxi:npcmission"] = {
        title = "Start/Stop Meter",
        icon = "#taxi-power",
        functionName = "xz-taxi:client:enableMeter",
    },
    --------------------------------------
    ["tow:togglenpc"] = {
        title = "Toggle NPC",
        icon = "#tow-npcmission",
        functionName = "jobs:client:ToggleNpc",
    },
    
    ["tow:towvehicle"] = {
        title = "Hoist Vehicle",
        icon = "#mechanic-flatbed",
        functionName = "xz-tow:client:TowVehicle",
    },

    ["tow:checkstatus"] = {
        title = "Check Status",
        icon = "#tow-status",
        functionName = "xz-tow:client:status",
    },

    --------------------------------------
    ["mechanic:impound"] = {
        title = "Impound",
        icon = "#police-jail",
        functionName = "xz-tow:client:ImpoundVehicle"
    },

    ["mechanic:flatbed"] = {
        title = "Tow",
        icon = "#mechanic-flatbed",
        functionName = "xz-tow:client:TowVehicle"
    }
}

function GetPlayers()
    local players = {}

    for i = 0, 128 do
        if NetworkIsPlayerActive(i) then
            players[#players+1]= i
        end
    end

    return players
end

function GetClosestPlayer()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local closestPed = -1
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply, 0)
    if not IsPedInAnyVehicle(PlayerPedId(), false) then
        for index,value in ipairs(players) do
            local target = GetPlayerPed(value)
            if(target ~= ply) then
                local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
                local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
                if(closestDistance == -1 or closestDistance > distance) and not IsPedInAnyVehicle(target, false) then
                    closestPlayer = value
                    closestPed = target
                    closestDistance = distance
                end
            end
        end
        return closestPlayer, closestDistance, closestPed
    end
end

function HasItem(item)
    local retval = nil
    XZCore.Functions.TriggerCallback("XZCore:HasItem", function(data)
        retval = data
    end, item)

    while retval == nil do
        Wait(1)
    end

    return retval
end

for i=1,8 do
    newSubMenus["xz-radio:radialChannel"..i] = {
        title = "Radio "..i,
        icon = "#police-radio",
        functionName = "xz-radio:radialChannel",
        functionParameters = i,
    }
end

TrunkClasses = {
    [0]  = { allowed = true, x = 0.0, y = -1.5, z = 0.0 }, --Coupes  
    [1]  = { allowed = true, x = 0.0, y = -2.0, z = 0.0 }, --Sedans  
    [2]  = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --SUVs  
    [3]  = { allowed = true, x = 0.0, y = -1.5, z = 0.0 }, --Coupes  
    [4]  = { allowed = true, x = 0.0, y = -2.0, z = 0.0 }, --Muscle  
    [5]  = { allowed = true, x = 0.0, y = -2.0, z = 0.0 }, --Sports Classics  
    [6]  = { allowed = true, x = 0.0, y = -2.0, z = 0.0 }, --Sports  
    [7]  = { allowed = true, x = 0.0, y = -2.0, z = 0.0 }, --Super  
    [8]  = { allowed = false, x = 0.0, y = -1.0, z = 0.25 }, --Motorcycles  
    [9]  = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Off-road  
    [10] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Industrial  
    [11] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Utility  
    [12] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Vans  
    [13] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Cycles  
    [14] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Boats  
    [15] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Helicopters  
    [16] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Planes  
    [17] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Service  
    [18] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Emergency  
    [19] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Military  
    [20] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Commercial  
    [21] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Trains  
}
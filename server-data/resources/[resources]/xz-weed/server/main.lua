XZCore.Functions.CreateCallback('xz-weed:server:getBuildingPlants', function(source, cb, building)
    local buildingPlants = {}

    exports.oxmysql:fetch('SELECT * FROM house_plants WHERE building = ?', {building}, function(plants)
        for i = 1, #plants, 1 do
            table.insert(buildingPlants, plants[i])
        end

        if buildingPlants ~= nil then
            cb(buildingPlants)
        else
            cb(nil)
        end
    end)
end)

RegisterServerEvent('xz-weed:server:placePlant')
AddEventHandler('xz-weed:server:placePlant', function(coords, sort, currentHouse)
    local random = math.random(1, 2)
    local gender
    if random == 1 then
        gender = "man"
    else
        gender = "woman"
    end
    exports.oxmysql:insert('INSERT INTO house_plants (building, coords, gender, sort, plantid) VALUES (?, ?, ?, ?, ?)',
        {currentHouse, coords, gender, sort, math.random(111111, 999999)})
    TriggerClientEvent('xz-weed:client:refreshHousePlants', -1, currentHouse)
end)

RegisterServerEvent('xz-weed:server:removeDeathPlant')
AddEventHandler('xz-weed:server:removeDeathPlant', function(building, plantId)
    exports.oxmysql:execute('DELETE FROM house_plants WHERE plantid = ? AND building = ?', {plantId, building})
    TriggerClientEvent('xz-weed:client:refreshHousePlants', -1, building)
end)

Citizen.CreateThread(function()
    while true do
        local housePlants = exports.oxmysql:fetchSync('SELECT * FROM house_plants', {})
        for k, v in pairs(housePlants) do
            if housePlants[k].food >= 50 then
                exports.oxmysql:execute('UPDATE house_plants SET food = ? WHERE plantid = ?',
                    {(housePlants[k].food - 1), housePlants[k].plantid})
                if housePlants[k].health + 1 < 100 then
                    exports.oxmysql:execute('UPDATE house_plants SET health = ? WHERE plantid = ?',
                        {(housePlants[k].health + 1), housePlants[k].plantid})
                end
            end

            if housePlants[k].food < 50 then
                if housePlants[k].food - 1 >= 0 then
                    exports.oxmysql:execute('UPDATE house_plants SET food = ? WHERE plantid = ?',
                        {(housePlants[k].food - 1), housePlants[k].plantid})
                end
                if housePlants[k].health - 1 >= 0 then
                    exports.oxmysql:execute('UPDATE house_plants SET health = ? WHERE plantid = ?',
                        {(housePlants[k].health - 1), housePlants[k].plantid})
                end
            end
        end
        TriggerClientEvent('xz-weed:client:refreshPlantStats', -1)
        Citizen.Wait((60 * 1000) * 19.2)
    end
end)

Citizen.CreateThread(function()
    while true do
        local housePlants = exports.oxmysql:fetchSync('SELECT * FROM house_plants', {})
        for k, v in pairs(housePlants) do
            if housePlants[k].health > 50 then
                local Grow = math.random(1, 3)
                if housePlants[k].progress + Grow < 100 then
                    exports.oxmysql:execute('UPDATE house_plants SET progress = ? WHERE plantid = ?',
                        {(housePlants[k].progress + Grow), housePlants[k].plantid})
                elseif housePlants[k].progress + Grow >= 100 then
                    if housePlants[k].stage ~= XZWeed.Plants[housePlants[k].sort]["highestStage"] then
                        if housePlants[k].stage == "stage-a" then
                            exports.oxmysql:execute('UPDATE house_plants SET stage = ? WHERE plantid = ?',
                                {'stage-b', housePlants[k].plantid})
                        elseif housePlants[k].stage == "stage-b" then
                            exports.oxmysql:execute('UPDATE house_plants SET stage = ? WHERE plantid = ?',
                                {'stage-c', housePlants[k].plantid})
                        elseif housePlants[k].stage == "stage-c" then
                            exports.oxmysql:execute('UPDATE house_plants SET stage = ? WHERE plantid = ?',
                                {'stage-d', housePlants[k].plantid})
                        elseif housePlants[k].stage == "stage-d" then
                            exports.oxmysql:execute('UPDATE house_plants SET stage = ? WHERE plantid = ?',
                                {'stage-e', housePlants[k].plantid})
                        elseif housePlants[k].stage == "stage-e" then
                            exports.oxmysql:execute('UPDATE house_plants SET stage = ? WHERE plantid = ?',
                                {'stage-f', housePlants[k].plantid})
                        elseif housePlants[k].stage == "stage-f" then
                            exports.oxmysql:execute('UPDATE house_plants SET stage = ? WHERE plantid = ?',
                                {'stage-g', housePlants[k].plantid})
                        end
                        exports.oxmysql:execute('UPDATE house_plants SET progress = ? WHERE plantid = ?',
                            {0, housePlants[k].plantid})
                    end
                end
            end
        end
        TriggerClientEvent('xz-weed:client:refreshPlantStats', -1)
        Citizen.Wait((60 * 1000) * 9.6)
    end
end)

XZCore.Functions.CreateUseableItem("weed_white-widow_seed", function(source, item)
    local Player = XZCore.Functions.GetPlayer(source)
    TriggerClientEvent('xz-weed:client:placePlant', source, 'white-widow', item)
end)

XZCore.Functions.CreateUseableItem("weed_skunk_seed", function(source, item)
    local Player = XZCore.Functions.GetPlayer(source)
    TriggerClientEvent('xz-weed:client:placePlant', source, 'skunk', item)
end)

XZCore.Functions.CreateUseableItem("weed_purple-haze_seed", function(source, item)
    local Player = XZCore.Functions.GetPlayer(source)
    TriggerClientEvent('xz-weed:client:placePlant', source, 'purple-haze', item)
end)

XZCore.Functions.CreateUseableItem("weed_og-kush_seed", function(source, item)
    local Player = XZCore.Functions.GetPlayer(source)
    TriggerClientEvent('xz-weed:client:placePlant', source, 'og-kush', item)
end)

XZCore.Functions.CreateUseableItem("weed_amnesia_seed", function(source, item)
    local Player = XZCore.Functions.GetPlayer(source)
    TriggerClientEvent('xz-weed:client:placePlant', source, 'amnesia', item)
end)

XZCore.Functions.CreateUseableItem("weed_ak47_seed", function(source, item)
    local Player = XZCore.Functions.GetPlayer(source)
    TriggerClientEvent('xz-weed:client:placePlant', source, 'ak47', item)
end)

XZCore.Functions.CreateUseableItem("weed_nutrition", function(source, item)
    local Player = XZCore.Functions.GetPlayer(source)
    TriggerClientEvent('xz-weed:client:foodPlant', source, item)
end)

RegisterServerEvent('xz-weed:server:removeSeed')
AddEventHandler('xz-weed:server:removeSeed', function(itemslot, seed)
    local Player = XZCore.Functions.GetPlayer(source)
    Player.Functions.RemoveItem(seed, 1, itemslot)
end)

RegisterServerEvent('xz-weed:server:harvestPlant')
AddEventHandler('xz-weed:server:harvestPlant', function(house, amount, plantName, plantId)
    local src = source
    local Player = XZCore.Functions.GetPlayer(src)
    local weedBag = Player.Functions.GetItemByName('empty_weed_bag')
    local sndAmount = math.random(12, 16)

    if weedBag ~= nil then
        if weedBag.amount >= sndAmount then
            if house ~= nil then
                local result = exports.oxmysql:fetchSync(
                    'SELECT * FROM house_plants WHERE plantid = ? AND building = ?', {plantId, house})
                if result[1] ~= nil then
                    Player.Functions.AddItem('weed_' .. plantName .. '_seed', amount)
                    Player.Functions.AddItem('weed_' .. plantName, sndAmount)
                    Player.Functions.RemoveItem('empty_weed_bag', 1)
                    exports.oxmysql:execute('DELETE FROM house_plants WHERE plantid = ? AND building = ?',
                        {plantId, house})
                    TriggerClientEvent('XZCore:Notify', src, 'The plant has been harvested', 'success', 3500)
                    TriggerClientEvent('xz-weed:client:refreshHousePlants', -1, house)
                else
                    TriggerClientEvent('XZCore:Notify', src, 'This plant no longer exists?', 'error', 3500)
                end
            else
                TriggerClientEvent('XZCore:Notify', src, 'House Not Found', 'error', 3500)
            end
        else
            TriggerClientEvent('XZCore:Notify', src, "You Don't Have Enough Resealable Bags", 'error', 3500)
        end
    else
        TriggerClientEvent('XZCore:Notify', src, "You Don't Have Enough Resealable Bags", 'error', 3500)
    end
end)

RegisterServerEvent('xz-weed:server:foodPlant')
AddEventHandler('xz-weed:server:foodPlant', function(house, amount, plantName, plantId)
    local src = source
    local Player = XZCore.Functions.GetPlayer(src)
    local plantStats = exports.oxmysql:fetchSync(
        'SELECT * FROM house_plants WHERE building = ? AND sort = ? AND plantid = ?',
        {house, plantName, tostring(plantId)})
    TriggerClientEvent('XZCore:Notify', src,
        XZWeed.Plants[plantName]["label"] .. ' | Nutrition: ' .. plantStats[1].food .. '% + ' .. amount .. '% (' ..
            (plantStats[1].food + amount) .. '%)', 'success', 3500)
    if plantStats[1].food + amount > 100 then
        exports.oxmysql:execute('UPDATE house_plants SET food = ? WHERE building = ? AND plantid = ?',
            {100, house, plantId})
    else
        exports.oxmysql:execute('UPDATE house_plants SET food = ? WHERE building = ? AND plantid = ?',
            {(plantStats[1].food + amount), house, plantId})
    end
    Player.Functions.RemoveItem('weed_nutrition', 1)
    TriggerClientEvent('xz-weed:client:refreshHousePlants', -1, house)
end)


local guild = "776605690269270028"
local token = "ODYwOTc5MjcxOTc4NzEzMDk4.YODHbg.a4KJqDNqsL2NhIFV5srR3KtOOh0"
local cooldowns = {}

RegisterCommand("testi", function(source)

    local discord
    for _, identifier in pairs(GetPlayerIdentifiers(source)) do
        if(identifier:match("discord:")) then
            discord = identifier:gsub("discord:", "")
        end
    end

    if(discord == nil) then
        -- Discord not found

        return
    end

    if(cooldowns[discord] ~= nil) then
        print("User have cooldown!")
        return
    end

    local link = string.format("https://discord.com/api/guilds/%s/members/%s", guild, discord)

    cooldowns[discord] = true
    Citizen.SetTimeout(7500, function()
        cooldowns[discord] = nil
    end)

    PerformHttpRequest(link, function (errorCode, data)
        if(errorCode == 404) then
            print("User not in guild.")
        elseif(errorCode ~= 200) then
            print("[ERROR]: Discord roles check got an error while requesting roles. [" .. errorCode .. "]")
            return
        end

        local userData = json.decode(data)
        if(userData ~= nil) then
            local haveRole = false

            for _, roleId in pairs(userData.roles) do
                if(roleId == "850421179524579339") then
                    haveRole = true
                    break
                end
            end

            print(haveRole)
        end

    end, "GET", "", { ["Authorization"] = "Bot " .. token })
end)

function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
 end
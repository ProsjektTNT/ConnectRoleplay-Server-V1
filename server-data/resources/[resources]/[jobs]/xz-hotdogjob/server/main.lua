XZCore = nil
TriggerEvent('XZCore:GetObject', function(obj) XZCore = obj end)

local Bail, runningStands = {}
XZCore.Functions.CreateCallback('xz-hotdogjob:server:HasMoney', function(source, cb)
    local Player = XZCore.Functions.GetPlayer(source)

    if Player.PlayerData.money.cash >= Config.Bail then
        Player.Functions.RemoveMoney('cash', Config.Bail, 'xz-hotdogjob:server:HasMoney')
        Bail[Player.PlayerData.citizenid] = true
        cb(true)
    elseif Player.PlayerData.money.bank >= Config.Bail then
        Player.Functions.RemoveMoney('bank', Config.Bail, 'xz-hotdogjob:server:HasMoney')
        Bail[Player.PlayerData.citizenid] = true
        cb(true)
    else
        Bail[Player.PlayerData.citizenid] = false
        cb(false)
    end
end)

XZCore.Functions.CreateCallback('xz-hotdogjob:server:BringBack', function(source, cb)
    local Player = XZCore.Functions.GetPlayer(source)

    if Bail[Player.PlayerData.citizenid] and Bail[Player.PlayerData.citizenid] == true then
        Player.Functions.AddMoney('cash', Config.Bail, "hotdog-return-money")
        cb(true)
    else
        cb(false)
    end
end)

local canGetPaid = {}
RegisterServerEvent('xz-scripts:locationChange:b')
AddEventHandler('xz-scripts:locationChange:b', function()
    canGetPaid[source] = true
end)

RegisterServerEvent('xz-hotdogjob:server:Pay')
AddEventHandler('xz-hotdogjob:server:Pay', function(Amount, Price)
    local src = source
    local Player = XZCore.Functions.GetPlayer(src)

    Player.Functions.AddMoney('cash', tonumber(Amount * Price), 'hotdog-payment')
    if canGetPaid[src] ~= nil and canGetPaid[src] == true then
        canGetPaid[src] = false
        Player.Functions.AddMoney('cash', amount, 'hotdog-payment')
    end
end)

RegisterServerEvent('hotdog:cash')
AddEventHandler('hotdog:cash', function()
	local src = source
    local Player = XZCore.Functions.GetPlayer(src)
	local cash = math.random(8, 13)
	
	Player.Functions.AddMoney('cash', cash, 'hotdog-npcpayment')
end)

local Reset = false
RegisterServerEvent('xz-hotdogjob:server:UpdateReputation')
AddEventHandler('xz-hotdogjob:server:UpdateReputation', function(quality)
    local src = source
    local Player = XZCore.Functions.GetPlayer(src)
    local JobReputation = Player.PlayerData.metadata["jobrep"]
    
    if Reset then
        JobReputation["hotdog"] = 0
        Player.Functions.SetMetaData("jobrep", JobReputation)
        TriggerClientEvent('xz-hotdogjob:client:UpdateReputation', src, JobReputation)
        return
    end

    if quality == "exotic" then
        if JobReputation["hotdog"] ~= nil and JobReputation["hotdog"] + 3 > Config.MaxReputation then
            JobReputation["hotdog"] = Config.MaxReputation
            Player.Functions.SetMetaData("jobrep", JobReputation)
            TriggerClientEvent('xz-hotdogjob:client:UpdateReputation', src, JobReputation)
            return
        end
        if JobReputation["hotdog"] == nil then
            JobReputation["hotdog"] = 3
        else
            JobReputation["hotdog"] = JobReputation["hotdog"] + 3
        end
    elseif quality == "rare" then
        if JobReputation["hotdog"] ~= nil and JobReputation["hotdog"] + 2 > Config.MaxReputation then
            JobReputation["hotdog"] = Config.MaxReputation
            Player.Functions.SetMetaData("jobrep", JobReputation)
            TriggerClientEvent('xz-hotdogjob:client:UpdateReputation', src, JobReputation)
            return
        end
        if JobReputation["hotdog"] == nil then
            JobReputation["hotdog"] = 2
        else
            JobReputation["hotdog"] = JobReputation["hotdog"] + 2
        end
    elseif quality == "common" then
        if JobReputation["hotdog"] ~= nil and JobReputation["hotdog"] + 1 > Config.MaxReputation then
            JobReputation["hotdog"] = Config.MaxReputation
            Player.Functions.SetMetaData("jobrep", JobReputation)
            TriggerClientEvent('xz-hotdogjob:client:UpdateReputation', src, JobReputation)
            return
        end
        if JobReputation["hotdog"] == nil then
            JobReputation["hotdog"] = 1
        else
            JobReputation["hotdog"] = JobReputation["hotdog"] + 1
        end
    end
    Player.Functions.SetMetaData("jobrep", JobReputation)
    TriggerClientEvent('xz-hotdogjob:client:UpdateReputation', src, JobReputation)
end)

XZCore.Commands.Add("dvstand", "Delete hotdogs stand", {}, false, function(source, args)
    TriggerClientEvent('xz-hotdogjob:staff:DeletStand', source)
end, 'admin')

RegisterServerEvent('xz-hotdogjob:server:updateRunningStand')
AddEventHandler('xz-hotdogjob:server:updateRunningStand', function()
    
end)
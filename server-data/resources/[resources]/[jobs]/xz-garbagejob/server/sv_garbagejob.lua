XZCore = nil
TriggerEvent('XZCore:GetObject', function(obj) XZCore = obj end)

local Bail = {}

XZCore.Functions.CreateCallback('xz-garbagejob:server:HasMoney', function(source, cb)
    local Player = XZCore.Functions.GetPlayer(source)
    local CitizenId = Player.PlayerData.citizenid

    if Player.PlayerData.money.cash >= Garbage.BailPrice then
        Bail[CitizenId] = "cash"
        Player.Functions.RemoveMoney('cash', Garbage.BailPrice, 'xz-garbagejob:server:HasMoney')
        cb(true)
    elseif Player.PlayerData.money.bank >= Garbage.BailPrice then
        Bail[CitizenId] = "bank"
        Player.Functions.RemoveMoney('bank', Garbage.BailPrice, 'xz-garbagejob:server:HasMoney')
        cb(true)
    else
        cb(false)
    end
end)

XZCore.Functions.CreateCallback('xz-garbagejob:server:CheckBail', function(source, cb)
    local Player = XZCore.Functions.GetPlayer(source)
    local CitizenId = Player.PlayerData.citizenid

    if Bail[CitizenId] ~= nil then
        Player.Functions.AddMoney(Bail[CitizenId], Garbage.BailPrice, 'xz-garbagejob:server:CheckBail')
        Bail[CitizenId] = nil
        cb(true)
    else
        cb(false)
    end
end)

local Materials = {
    "metalscrap",
    "plastic",
    "copper",
    "iron",
    "aluminum",
    "steel",
    "glass",
}

local canGetPaid = {}
RegisterServerEvent('xz-scripts:locationChange:a')
AddEventHandler('xz-scripts:locationChange:a', function()
    canGetPaid[source] = true
end)

RegisterServerEvent('xz-garbagejob:server:Pay')
AddEventHandler('xz-garbagejob:server:Pay', function(amount, location)
    local src = source
    local Player = XZCore.Functions.GetPlayer(src)

    if amount > 0 then
            Player.Functions.AddMoney('cash', amount, 'xz-garbagejob:server:Pay')

            if location == #Garbage.Locations["trashcan"] then
                for i = 1, math.random(3, 5), 1 do
                    local item = Materials[math.random(1, #Materials)]
                    Player.Functions.AddItem(item, math.random(40, 70))
                    TriggerClientEvent('inventory:client:ItemBox', src, XZCore.Shared.Items[item], 'add')
                    Citizen.Wait(500)
                end
            end

        TriggerClientEvent('XZCore:Notify', src, "You have got paid $"..amount.."", "success")
    else
        TriggerClientEvent('XZCore:Notify', src, "You have earned nothing..", "error")
    end
end)
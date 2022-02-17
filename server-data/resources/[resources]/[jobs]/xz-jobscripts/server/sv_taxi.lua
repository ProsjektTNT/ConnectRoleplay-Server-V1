XZCore = nil
TriggerEvent('XZCore:GetObject', function(obj) XZCore = obj end)

-- Code

RegisterServerEvent('xz-taxi:server:NpcPay')
AddEventHandler('xz-taxi:server:NpcPay', function(Payment)
    local fooikansasah = math.random(1, 5)
    local r1, r2 = math.random(1, 5), math.random(1, 5)

    if fooikansasah == r1 or fooikansasah == r2 then
        Payment = Payment + math.random(5, 10)
    end

    local src = source
    local Player = XZCore.Functions.GetPlayer(src)

    Player.Functions.AddMoney('cash', Payment, 'xz-taxi:server:NpcPay')
end)
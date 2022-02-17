XZCore = nil
TriggerEvent('XZCore:GetObject', function(obj) XZCore = obj end)

local ItemTable = {
    "metalscrap",
    "plastic",
    "copper",
    "iron",
    "aluminum",
    "steel",
    "glass",
}

RegisterServerEvent("xz-recycle:server:getItem")
AddEventHandler("xz-recycle:server:getItem", function()
    local src = source
    local Player = XZCore.Functions.GetPlayer(src)
    for i = 1, 1, 1 do
        local randItem = ItemTable[math.random(1, #ItemTable)]
        local amount = math.random(5,11)
        Player.Functions.AddItem(randItem, amount)
        TriggerClientEvent('inventory:client:ItemBox', src, XZCore.Shared.Items[randItem], 'add')
        Citizen.Wait(500)
    end

    local Luck = math.random(1, 10)
    local Odd = math.random(1, 10)
    if Luck == Odd then
        local random = math.random(4, 11)
        Player.Functions.AddItem("rubber", random)
        TriggerClientEvent('inventory:client:ItemBox', src, XZCore.Shared.Items["rubber"], 'add')
    end
end)
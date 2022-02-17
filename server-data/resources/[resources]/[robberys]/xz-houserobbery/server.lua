local XZCore = nil

XZCore = nil
TriggerEvent('XZCore:GetObject', function(obj) XZCore = obj end)

RegisterServerEvent('houseRobberies:removeLockpick')
AddEventHandler('houseRobberies:removeLockpick', function()
 local source = tonumber(source)
 local xPlayer = XZCore.Functions.GetPlayer(source)
 xPlayer.Functions.RemoveItem('advancedlockpick', 1)
 TriggerClientEvent('XZCore:Notify', source, 'The lockpick bent out of shape.', "error")
end)

RegisterServerEvent('houseRobberies:giveMoney')
AddEventHandler('houseRobberies:giveMoney', function()
 local source = tonumber(source)
 local xPlayer = XZCore.Functions.GetPlayer(source)
 local cash = math.random(500, 1200)
 xPlayer.Functions.AddMoney('cash', cash, 'houseRobberies:giveMoney')
 TriggerEvent("xz-logs:server:sendLog", {User = source}, "robbery", "House Robbery - Money Found", GetPlayerName(source) .. " Got money `" .. cash .. "$`", {}, "green", "xz-houserobbery")
 TriggerClientEvent('XZCore:Notify', source, 'You found $'..cash)
end)

RegisterServerEvent('houseRobberies:searchItem')
AddEventHandler('houseRobberies:searchItem', function()
 local source = tonumber(source)
 local item = {}
 local xPlayer = XZCore.Functions.GetPlayer(source)
 local gotID = {}

 for i=1, math.random(1, 2) do
  item = Config.RobbableItems[math.random(1, #Config.RobbableItems)]
  if math.random(1, 10) >= item.chance then
   if tonumber(item.id) == 0 and not gotID[item.id] then
    gotID[item.id] = true
    xPlayer.Functions.AddMoney('cash', item.quantity, 'houseRobberies:searchItem')
    TriggerEvent("xz-logs:server:sendLog", {User = source}, "robbery", "House Robbery - Item Found", GetPlayerName(source) .. " Found `" .. item.isWeapon .. "`", {}, "green", "xz-houserobbery")
    TriggerClientEvent('XZCore:Notify', source, 'You found $'..item.quantity)
   elseif not gotID[item.id] then
    gotID[item.id] = true
    xPlayer.Functions.AddItem(item.id, item.quantity)
    TriggerEvent("xz-logs:server:sendLog", {User = source}, "robbery", "House Robbery - Item Found", GetPlayerName(source) .. " Found `" .. item.id .. "`", {}, "green", "xz-houserobbery")
    TriggerClientEvent('XZCore:Notify', source, 'Item Added!')
   end
  end
 end
end)

XZCore.Functions.CreateCallback('houserob:checkcops', function(source, cb)
  local currentplayers = XZCore.Functions.GetPlayers()
  local cops = 0

  for i = 1, #currentplayers, 1 do
    local xPlayer = XZCore.Functions.GetPlayer(currentplayers[i])
    if xPlayer.PlayerData.job ~= nil and xPlayer.PlayerData.job.name == "police" then
      cops = cops + 1
    end
  end

  cb(cops)
end)

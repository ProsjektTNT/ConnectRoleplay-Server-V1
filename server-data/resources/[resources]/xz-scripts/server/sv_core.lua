XZCore = nil
TriggerEvent('XZCore:GetObject', function(obj) XZCore = obj end)

XZCore.Commands.Add("id", "Check Your ID #", {}, false, function(source, args)
    TriggerClientEvent('XZCore:Notify', source,  "ID: ".. source)
end)

XZCore.Commands.Add('dvall', 'Delete All Vehicles', {}, false, function(source, args)
    TriggerClientEvent("wld:delallveh", -1)
end, 'god')

XZCore.Functions.CreateUseableItem("harness", function(source, item)
    local Player = XZCore.Functions.GetPlayer(source)
    TriggerClientEvent('seatbelt:client:UseHarness', source, item)
end)

XZCore.Commands.Add("carry", "Carry a person.", {}, false, function(source, args)
	local src = source
    local Player = XZCore.Functions.GetPlayer(source)
    if not Player.PlayerData.metadata['isdead'] and not Player.PlayerData.metadata['inlaststand'] then
        TriggerClientEvent("carry:Event", src)
    end
end)

RegisterServerEvent('CrashTackle', function(playerId)
	TriggerClientEvent("playerTackled", playerId)
end)

RegisterServerEvent('undragTarget', function(playerId)
	TriggerClientEvent("undragPlayer", playerId, source)
end)

RegisterServerEvent('dragTarget', function(playerId)
	TriggerClientEvent("dragPlayer", playerId, source)
end)

RegisterServerEvent("xz-carry:beingCarried", function(beingCarried)
	local src = source
	local Player = XZCore.Functions.GetPlayer(src)
	TriggerClientEvent("xz-carry:beingCarried", src, beingCarried)
	Player.Functions.SetMetaData('incarry', beingCarried)
end)

RegisterServerEvent('tackle:server:TacklePlayer', function(playerId)
    TriggerClientEvent("tackle:client:GetTackled", playerId)
end)

RegisterServerEvent('animation:sync', function(target, animationLib,animationLib2, animation, animation2, distans, distans2, height,targetSrc,length,spin,controlFlagSrc,controlFlagTarget,animFlagTarget,attachFlag, emote)
	TriggerClientEvent('animation:syncTarget', targetSrc, source, animationLib2, animation2, distans, distans2, height, length,spin,controlFlagTarget,animFlagTarget,attachFlag, emote)
	TriggerClientEvent('animation:syncMe', source, animationLib, animation,length,controlFlagSrc,animFlagTarget)
end)

RegisterServerEvent('animation:stop', function(targetSrc)
	TriggerClientEvent('animation:cl_stop', targetSrc)
end)

RegisterServerEvent('equip:harness', function(item)
    local src = source
    local Player = XZCore.Functions.GetPlayer(src)
    if Player.PlayerData.items[item.slot].info.uses - 1 == 0 then
        TriggerClientEvent("inventory:client:ItemBox", source, XZCore.Shared.Items['harness'], "remove")
        Player.Functions.RemoveItem('harness', 1)
    else
        Player.PlayerData.items[item.slot].info.uses = Player.PlayerData.items[item.slot].info.uses - 1
        Player.Functions.SetInventory(Player.PlayerData.items)
    end
end)

RegisterServerEvent('seatbelt:DoHarnessDamage', function(hp, data)
    local src = source
    local Player = XZCore.Functions.GetPlayer(src)

    if hp == 0 then
        Player.Functions.RemoveItem('harness', 1, data.slot)
    else
        Player.PlayerData.items[data.slot].info.uses = Player.PlayerData.items[data.slot].info.uses - 1
        Player.Functions.SetInventory(Player.PlayerData.items)
    end
end)

RegisterNetEvent('xz-metaldetector:checkForWeapons', function(detector)
  local src = source
  local xPlayer = XZCore.Functions.GetPlayer(src)

  for _,v in pairs(Detector.IllegalItems) do
    local item = xPlayer.Functions.GetItemByName(v:lower())
    if item ~= nil and item.amount > 0 then
      TriggerClientEvent('xz-metaldetector:playSound', -1, detector)
    end
  end
end)

RegisterServerEvent('carhud:ejection:server', function(plyID, veloc)
    TriggerClientEvent("carhud:ejection:client", plyID, veloc)
end)

Citizen.CreateThread(function()
    while true do
        local playersInfo = {}
        for k, v in pairs(GetPlayers()) do
            if v ~= nil then
                local identifier = GetPlayerIdentifier(v)
                local serverid = XZCore.Functions.GetSource(identifier)
                table.insert(playersInfo, serverid)
            end
        end

        TriggerClientEvent('xz-core:client:updatePlayers', -1, playersInfo)
        Wait(35000)
    end
end)
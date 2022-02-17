XZCore = nil

TriggerEvent('XZCore:GetObject', function(obj) XZCore = obj end)

XZCore.Functions.CreateUseableItem("duffelbag", function(source, item)
    local Player = XZCore.Functions.GetPlayer(source)
    TriggerClientEvent("attachItemPerm", source, "blackduffelbag")
end)

XZCore.Functions.CreateUseableItem("securitycase", function(source, item)
    local Player = XZCore.Functions.GetPlayer(source)
    TriggerClientEvent("attachItemPerm", source, "securityCase")
end)

XZCore.Functions.CreateUseableItem("boombox", function(source, item)
    local Player = XZCore.Functions.GetPlayer(source)
    TriggerClientEvent("attachItemPerm", source, "boombox01")
end)

XZCore.Functions.CreateUseableItem("briefcase", function(source, item)
    local Player = XZCore.Functions.GetPlayer(source)
    TriggerClientEvent("attachItemPerm", source, "briefcase01")
end)

XZCore.Functions.CreateUseableItem("joint", function(source, item)
    local Player = XZCore.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:UseJoint", source)
    end
end)

XZCore.Functions.CreateUseableItem("armor", function(source, item)
    local Player = XZCore.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:UseArmor", source)
end)

XZCore.Functions.CreateUseableItem("heavyarmor", function(source, item)
    local Player = XZCore.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:UseHeavyArmor", source)
end)

XZCore.Functions.CreateUseableItem("pdvest", function(source, item)
    local Player = XZCore.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:UsePDArmor", source)
end)

XZCore.Functions.CreateUseableItem("ciggy", function(source, item)
    local Player = XZCore.Functions.GetPlayer(source)
    TriggerClientEvent("client:cigarette", source)
end)

XZCore.Functions.CreateUseableItem("cigar", function(source, item)
    local Player = XZCore.Functions.GetPlayer(source)
    TriggerClientEvent("client:cigar", source)
end)

-- XZCore.Functions.CreateUseableItem("smoketrailred", function(source, item)
--     local Player = XZCore.Functions.GetPlayer(source)
-- 	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
--         TriggerClientEvent("consumables:client:UseRedSmoke", source)
--     end
-- end)

XZCore.Functions.CreateUseableItem("parachute", function(source, item)
    local Player = XZCore.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:UseParachute", source)
    end
end)

XZCore.Commands.Add("parachuteoff", "Take off your parachute", {}, false, function(source, args)
    local Player = XZCore.Functions.GetPlayer(source)
        TriggerClientEvent("consumables:client:ResetParachute", source)
end)

RegisterServerEvent("xz-smallpenis:server:AddParachute")
AddEventHandler("xz-smallpenis:server:AddParachute", function()
    local src = source
    local Ply = XZCore.Functions.GetPlayer(src)

    Ply.Functions.AddItem("parachute", 1)
end)

XZCore.Functions.CreateUseableItem("binoculars", function(source, item)
    local Player = XZCore.Functions.GetPlayer(source)
    TriggerClientEvent("binoculars:Toggle", source)
end)

XZCore.Functions.CreateUseableItem("cokebaggy", function(source, item)
    local Player = XZCore.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:Cokebaggy", source)
end)

XZCore.Functions.CreateUseableItem("oxy", function(source, item)
    local Player = XZCore.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:oxy", source)
end)

XZCore.Functions.CreateUseableItem("ifak", function(source, item)
    local Player = XZCore.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:ifak", source)
end)

XZCore.Functions.CreateUseableItem("adrenaline", function(source, item)
    local Player = XZCore.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:adrenaline", source)
end)

XZCore.Functions.CreateUseableItem("crack_baggy", function(source, item)
    local Player = XZCore.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:Crackbaggy", source)
end)

XZCore.Functions.CreateUseableItem("methbag", function(source, item)
    local Player = XZCore.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:methbag", source)
end)

XZCore.Functions.CreateUseableItem("xtcbaggy", function(source, item)
    local Player = XZCore.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:EcstasyBaggy", source)
end)

XZCore.Functions.CreateUseableItem("firework1", function(source, item)
    local Player = XZCore.Functions.GetPlayer(source)
    TriggerClientEvent("fireworks:client:UseFirework", source, item.name, "proj_indep_firework")
end)

XZCore.Functions.CreateUseableItem("firework2", function(source, item)
    local Player = XZCore.Functions.GetPlayer(source)
    TriggerClientEvent("fireworks:client:UseFirework", source, item.name, "proj_indep_firework_v2")
end)

XZCore.Functions.CreateUseableItem("firework3", function(source, item)
    local Player = XZCore.Functions.GetPlayer(source)
    TriggerClientEvent("fireworks:client:UseFirework", source, item.name, "proj_xmas_firework")
end)

XZCore.Functions.CreateUseableItem("firework4", function(source, item)
    local Player = XZCore.Functions.GetPlayer(source)
    TriggerClientEvent("fireworks:client:UseFirework", source, item.name, "scr_indep_fireworks")
end)

XZCore.Commands.Add("vestoff", "Take your vest off. (Police Only)", {}, false, function(source, args)
    local Player = XZCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("consumables:client:ResetArmor", source)
    else
        TriggerClientEvent('chat:addMessage', source , {
            template = '<div class="chat-message server"><b>SYSTEM:</b> {0}</div>',
            args = { "This command is for emergency services!!" }
        })
    end
end)

XZCore.Commands.Add("divingsuit", "Take off your diving suit", {}, false, function(source, args)
    local Player = XZCore.Functions.GetPlayer(source)
    TriggerClientEvent("oxygenmaskclient:UseGear", source, false)
end)

XZCore.Functions.CreateUseableItem("diving_gear", function(source, item)
    local Player = XZCore.Functions.GetPlayer(source)

    TriggerClientEvent("oxygenmaskclient:UseGear", source, true)
end)

RegisterServerEvent('oxygengear:RemoveGear')
AddEventHandler('oxygengear:RemoveGear', function()
    local src = source
    local Player = XZCore.Functions.GetPlayer(src)

    Player.Functions.RemoveItem("diving_gear", 1)
    TriggerClientEvent('inventory:client:ItemBox', src, XZCore.Shared.Items["diving_gear"], "remove")
end)

RegisterServerEvent('oxygengear:GiveBackGear')
AddEventHandler('oxygengear:GiveBackGear', function()
    local src = source
    local Player = XZCore.Functions.GetPlayer(src)
    
    Player.Functions.AddItem("diving_gear", 1)
    TriggerClientEvent('inventory:client:ItemBox', src, XZCore.Shared.Items["diving_gear"], "add")
end)
XZCore = nil
TriggerEvent('XZCore:GetObject', function(obj) XZCore = obj end)

XZCore.Functions.CreateUseableItem("lawyerpass", function(source, item)
    local Player = XZCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("xz-justice:client:showLawyerLicense", -1, source, item.info)
    end
end)
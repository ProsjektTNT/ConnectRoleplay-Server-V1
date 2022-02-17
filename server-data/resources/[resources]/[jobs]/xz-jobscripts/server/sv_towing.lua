XZCore = nil
TriggerEvent('XZCore:GetObject', function(obj) XZCore = obj end)

XZCore.Commands.Add("tow", "Tow a vehicle on the back of your flatbed", {}, false, function(source, args)
    local Player = XZCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "tow" then
        TriggerClientEvent("xz-tow:client:TowVehicle", source)
    end
end)
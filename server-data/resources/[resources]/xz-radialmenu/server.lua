XZCore = nil
TriggerEvent("XZCore:GetObject", function(obj) XZCore = obj end)    

local trunkBusy = {}

RegisterServerEvent('xz-trunk:server:setTrunkBusy')
AddEventHandler('xz-trunk:server:setTrunkBusy', function(plate, busy)
    trunkBusy[plate] = busy
end)

XZCore.Functions.CreateCallback('xz-trunk:server:getTrunkBusy', function(source, cb, plate)
    if trunkBusy[plate] then
        cb(true)
    end
    cb(false)
end)

RegisterServerEvent('xz-trunk:server:KidnapTrunk')
AddEventHandler('xz-trunk:server:KidnapTrunk', function(targetId, closestVehicle)
    TriggerClientEvent('xz-trunk:client:KidnapGetIn', targetId, closestVehicle)
end)

RegisterNetEvent('vehicle:flipit')
AddEventHandler('vehicle:flipit', function()
	TriggerClientEvent('vehicle:flipit')
end)
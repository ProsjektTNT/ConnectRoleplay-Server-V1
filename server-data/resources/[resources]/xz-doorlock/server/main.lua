XZCore = nil
TriggerEvent('XZCore:GetObject', function(obj) XZCore = obj end)

local doorInfo = {}

RegisterServerEvent('xz-doorlock:server:setupDoors')
AddEventHandler('xz-doorlock:server:setupDoors', function()
	local src = source
	TriggerClientEvent("xz-doorlock:client:setDoors", XZConfig.Doors)
end)

RegisterServerEvent('xz-doorlock:server:updateState')
AddEventHandler('xz-doorlock:server:updateState', function(doorID, state)
	local src = source
	local Player = XZCore.Functions.GetPlayer(src)
	
	XZConfig.Doors[doorID].locked = state

	TriggerClientEvent('xz-doorlock:client:setState', -1, doorID, state)
end)
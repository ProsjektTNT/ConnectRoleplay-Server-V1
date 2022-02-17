local SeatsTaken = {}

-- SEATS
RegisterServerEvent('xz-sit:server:TakeChair')
AddEventHandler('xz-sit:server:TakeChair', function(object)
	table.insert(SeatsTaken, object)
end)

RegisterServerEvent('xz-sit:server:LeaveChair')
AddEventHandler('xz-sit:server:LeaveChair', function(object)
	local _SeatsTaken = {}
	for i=1, #SeatsTaken, 1 do
		if object ~= SeatsTaken[i] then
			table.insert(_SeatsTaken, SeatsTaken[i])
		end
	end
	SeatsTaken = _SeatsTaken
end)

RegisterServerEvent('xz-sit:server:GetChair')
AddEventHandler('xz-sit:server:GetChair', function(id)
    local found = false

	if SeatsTaken[id] ~= nil then
		found = true
	end
    TriggerClientEvent('xz-sit:client:GetChair', source, found)
end)

RegisterServerEvent('xz-sit:server:GetChairAlt')
AddEventHandler('xz-sit:server:GetChairAlt', function(id, dat)
    local found = false

	if SeatsTaken[id] ~= nil then
		found = true
	end
    TriggerClientEvent('xz-sit:client:GetChairAlt', source, found, dat)
end)
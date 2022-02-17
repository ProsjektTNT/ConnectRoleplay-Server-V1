local sitting = false
local pos = nil
local lastPos = nil
local currentScenario = nil
local data = nil
local object = nil
local id = 0
local distance = 0

Citizen.CreateThread(function()
	local Sitables = {}

	for k, v in pairs(Config.Props) do
		table.insert(Sitables, GetHashKey(v))
	end

	exports['xz-interact']:AddTargetModel(Sitables, {
        options = {
            {
                event = "xz-sit:sit",
                icon = "fas fa-chair",
                label = "Sit down",
            },
        },
        distance = 1.5
    })

    for k, v in pairs(Config.PolyChairs) do
        exports['xz-interact']:AddBoxZone('PolyChair'..k, v.coords, v.length, v.width, {
            name = 'PolyChair'..k,
            heading = v.heading,
            debugPoly = false,
            minZ = v.minZ,
            maxZ = v.maxZ
        }, {
            options = {
                {
                    event = 'xz-sit:sitAlt',
                    icon = 'fas fa-circle',
                    label = 'Sit',
                    zOffset = v.zOffset,
                    PolyCoords = v.coords,
                    PolyHeading = v.heading
                }
            },
            distance = 2.0
        })
    end

	while true do
		Citizen.Wait(100)

		if sitting and not IsPedUsingScenario(PlayerPedId(), currentScenario) then
			Standup()
		end
	end
end)

RegisterNetEvent("xz:interact:init:" .. GetCurrentResourceName(), function(Mapper)
    Mapper.Mapping:Listen("standup", "Get out of chair~", "keyboard", "X", function(state)
        if state then
            if sitting then
                Standup()
            end
        end
    end)
end)

RegisterNetEvent('xz-sit:sit', function()
    if not IsPedInAnyVehicle(PlayerPedId()) then
        if sitting then
            Standup()
        else
            object, distance = GetNearChair()

            if distance < 1.5 then
                local hash = GetEntityModel(object)
                data = nil
                local modelName = nil
                local found = false
                for k,v in pairs(Config.Sitable) do
                    if GetHashKey(k) == hash then
                        data = v
                        modelName = k
                        found = true
                        break
                    end
                end

                if found then
                    sit(object, modelName, data)
                end
            else
                XZCore.Functions.Notify('Not Near Something To Sit On', 'error')
            end
        end
    else
        XZCore.Functions.Notify('Can\'t Do That In A Vehicle', 'error')
    end
end)

RegisterNetEvent('xz-sit:sitAlt', function(dat)
    if not IsPedInAnyVehicle(PlayerPedId()) then
        if sitting then
            Standup()
        else
            sitAlt(dat)
        end
    else
        XZCore.Functions.Notify('Can\'t Do That In A Vehicle', 'error')
    end
end)

function GetNearChair()
	local obj, dist
	local coords = GetEntityCoords(PlayerPedId())
	for i=1, #Config.Props do
		obj = GetClosestObjectOfType(coords, 3.0, GetHashKey(Config.Props[i]), false, false, false)
		dist = #(coords - GetEntityCoords(obj))
		if dist < 1.6 then
			return obj, dist
		end
	end
	return nil, nil
end

function Standup()
    local playerPed = PlayerPedId()
	ClearPedTasks(playerPed)
	sitting = false
	SetEntityCoords(playerPed, lastPos)
	FreezeEntityPosition(playerPed, false)
    TriggerServerEvent('xz-sit:server:LeaveChair', id)
    id = 0
	currentScenario = nil
end

function sit(object)
	pos = GetEntityCoords(object)
	id = math.random(11111, 99999)
    TriggerServerEvent('xz-sit:server:GetChair', id)
end

function sitAlt(dat)
    if dat.PolyCoords == nil then return end
    id = math.random(11111, 99999)
    TriggerServerEvent('xz-sit:server:GetChairAlt', id, dat)
end

RegisterNetEvent('xz-sit:client:GetChair', function(occupied)
    if occupied then
        XZCore.Functions.Notify('Chair Is Occupied', 'error')
        id = 0
        currentScenario = nil
    else
        local playerPed = PlayerPedId()
        lastPos = GetEntityCoords(playerPed)
        TriggerServerEvent('xz-sit:server:TakeChair', id)
        currentScenario = data.scenario
        TaskStartScenarioAtPosition(playerPed, currentScenario, pos.x, pos.y, pos.z - data.verticalOffset, GetEntityHeading(object) + 180.0, 0, true, true)
        sitting = true
    end
end)

RegisterNetEvent('xz-sit:client:GetChairAlt', function(occupied, dat)
    if occupied then
        XZCore.Functions.Notify('Chair Is Occupied', 'error')
        id = 0
        currentScenario = nil
    else
        local playerPed = PlayerPedId()
        lastPos = GetEntityCoords(playerPed)
        SetEntityHeading(playerPed, dat.PolyHeading)
        TriggerServerEvent('xz-sit:server:TakeChair', id)
        currentScenario = 'PROP_HUMAN_SEAT_CHAIR_UPRIGHT'
        TaskStartScenarioAtPosition(playerPed, 'PROP_HUMAN_SEAT_CHAIR_UPRIGHT', dat.PolyCoords.x, dat.PolyCoords.y, dat.PolyCoords.z + dat.zOffset, dat.PolyHeading, -1, true, true)
        sitting = true
    end
end)

CreateThread(function()
    TriggerEvent("xz:interact:init", GetCurrentResourceName(), "Mapping")
end)

RegisterNetEvent("xz:interact:ready", function()
    TriggerEvent("xz:interact:init", GetCurrentResourceName(), "Mapping")
end)
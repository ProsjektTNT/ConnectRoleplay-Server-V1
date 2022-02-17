RegisterNetEvent('ems:chatMessage')
AddEventHandler('ems:chatMessage', function(data)
    if not XZCore or not XZCore.Functions.GetPlayerData().job or XZCore.Functions.GetPlayerData().job.name ~= 'ambulance' or not XZCore.Functions.GetPlayerData().job.onduty then
        return
    end

    TriggerEvent('chat:addMessage', {
        template = '<div class="chat-message server" style="background-color: rgba(255, 0, 21, 0.75);"><b>EMS Chat - {0}:</b> {1}</div>',
        args = data
    })
end)

local Vehicles = {
    { model = "emsc", label = "Dodge Charger"},
    { model = "emsf", label = "Paramedic SUV"},
    { model = "emst", label = "Paramedic Chevrolet SUV"},
    { model = "madabike", label = "Bike"},
    { model = "16explorer", label = "Explorer"},
    { model = "emsa", label = "Ambulance 2"},
    { model = "ems1", label = "Ramag Ambulance"},
    { model = "polnspeedo", label = "Ambulance"},
    { model = "emsv", label = "Coroner"}
}

RegisterNetEvent('ems:sv')
AddEventHandler('ems:sv', function(index)

    if not IsNearPoliceGarage() then
        return
    end

    if index == 'help' then
        local str = ""
        local last = true
        for i=1,#Vehicles do
            local vehicle = Vehicles[i]
            if last then
                str = str .. '<br>'
            else
                str = str .. '  '
            end
            str = str .. i .. '. ' .. vehicle.label
            last = not last
        end

        TriggerEvent('chat:addMessage', {
            template = '<div class="chat-message emergency">EMS Vehicles: '.. str ..' </div>',
        })
    elseif Vehicles[tonumber(index)] then
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local head = GetEntityHeading(ped)
        local radhead = math.rad(head)
        local model = GetHashKey(Vehicles[tonumber(index)]['model'])
        local newpos = {x = pos.x-math.sin(radhead)*3, y = pos.y+math.cos(radhead)*3, z = pos.z}
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(1)
        end
        local veh = CreateVehicle(model, newpos.x, newpos.y, newpos.z, head, true, true)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh), veh)
		SetVehicleExtra(veh, 1, true)
        SetVehicleExtra(veh, 2, true)
		SetVehicleExtra(veh, 3, true)
		SetVehicleExtra(veh, 4, true)
		SetVehicleExtra(veh, 5, true)
		SetVehicleExtra(veh, 6, true)
		SetVehicleExtra(veh, 7, true)
		SetVehicleExtra(veh, 8, true)
		SetVehicleExtra(veh, 9, true)
		SetVehicleExtra(veh, 10, true)
		SetVehicleExtra(veh, 11, true)
		SetVehicleExtra(veh, 12, true)
		SetVehicleDirtLevel(veh, 0.0)
		WashDecalsFromVehicle(veh, 1.0)
		--                                        exports['LegacyFuel']:SetFuel(veh, 100)

        SetVehicleEngineOn(veh, true, true)
    end
end)
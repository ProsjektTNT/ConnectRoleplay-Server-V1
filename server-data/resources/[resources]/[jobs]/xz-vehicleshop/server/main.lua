local NumberCharset = {}
local Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

-- code

RegisterNetEvent('xz-vehicleshop:server:buyShowroomVehicle')
AddEventHandler('xz-vehicleshop:server:buyShowroomVehicle', function(vehicle, props)
    local src = source
    local pData = XZCore.Functions.GetPlayer(src)
    local cid = pData.PlayerData.citizenid
    local cash = pData.PlayerData.money["cash"]
    local bank = pData.PlayerData.money["bank"]
    local vehiclePrice = XZCore.Shared.Vehicles[vehicle]["price"]
    local plate = GeneratePlate()

    if (cash - vehiclePrice) >= 0 then
        exports.oxmysql:insert('INSERT INTO xzvehicles (citizenid, plate, fakeplate, model, props, stats, state, parking, parts, lastparked) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', {
            cid,
            plate,
            "",
            vehicle,
            json.encode({}),
            json.encode({fuel = 100, damage = 0}),
            "",
            "",
            "",
            ""
        })
        TriggerClientEvent("XZCore:Notify", src, "Success! Your vehicle will be waiting for you outside", "success", 5000)
        TriggerClientEvent('xz-vehicleshop:client:buyShowroomVehicle', src, vehicle, plate)
        pData.Functions.RemoveMoney('cash', vehiclePrice, "vehicle-bought-in-showroom")
        TriggerEvent("xz-log:server:CreateLog", "vehicleshop", "Vehicle purchased (showroom)", "green", "**"..GetPlayerName(src) .. "** bought a " .. XZCore.Shared.Vehicles[vehicle]["name"] .. " for $" .. vehiclePrice .. " with cash") -- TO DO LIAM YOU MOTHER FUCKER
    elseif (bank - vehiclePrice) >= 0 then
        exports.oxmysql:insert('INSERT INTO xzvehicles (citizenid, plate, fakeplate, model, props, stats, state, parking, parts, lastparked) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', {
            cid,
            plate,
            "",
            vehicle,
            json.encode({}),
            json.encode({fuel = 100, damage = 0}),
            "",
            "",
            "",
            ""
        })
        TriggerClientEvent("XZCore:Notify", src, "Success! Your vehicle will be waiting for you outside", "success", 5000)
        TriggerClientEvent('xz-vehicleshop:client:buyShowroomVehicle', src, vehicle, plate)
        pData.Functions.RemoveMoney('bank', vehiclePrice, "vehicle-bought-in-showroom")
        TriggerEvent("xz-log:server:CreateLog", "vehicleshop", "Vehicle purchased (showroom)", "green", "**"..GetPlayerName(src) .. "** bought a " .. XZCore.Shared.Vehicles[vehicle]["name"] .. " for $" .. vehiclePrice .. " from the bank") -- TO DO LIAM YOU MOTHER FUCKER
    elseif (cash - vehiclePrice) < 0 then
        TriggerClientEvent("XZCore:Notify", src, "You don't have enough money, you're missing $"..format_thousand(vehiclePrice - cash).." cash", "error", 5000)
    elseif (bank - vehiclePrice) < 0 then
        TriggerClientEvent("XZCore:Notify", src, "You don't have enough money, you're missing $"..format_thousand(vehiclePrice - bank).." in the bank", "error", 5000)
    end
end)

RegisterNetEvent("xz-vehicleshop:server:SaveVehicleProps", function(props, plate)
    props.plate = plate
    exports.oxmysql:execute("UPDATE xzvehicles SET props = ? WHERE plate = ?", { json.encode(props), plate })
end)

function format_thousand(v)
    local s = string.format("%d", math.floor(v))
    local pos = string.len(s) % 3
    if pos == 0 then pos = 3 end
    return string.sub(s, 1, pos)
            .. string.gsub(string.sub(s, pos+1), "(...)", ",%1")
end

RegisterNetEvent("xz-vehicleshop:server:changeColor", function(color1, color2, veh)
    TriggerClientEvent("xz-vehicleshop:client:changeColorForClient", -1, color1, color2, veh)
end)


function GeneratePlate()
    local plate = tostring(GetRandomNumber(1)) .. GetRandomLetter(2) .. tostring(GetRandomNumber(3)) .. GetRandomLetter(2)
    local result = exports.oxmysql:scalarSync('SELECT plate FROM player_vehicles WHERE plate = ?', {plate})
    if result then
        plate = tostring(GetRandomNumber(1)) .. GetRandomLetter(2) .. tostring(GetRandomNumber(3)) .. GetRandomLetter(2)
    end
    return plate:upper()
end

function GetRandomNumber(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end

RegisterServerEvent('xz-vehicleshop:server:setShowroomCarInUse')
AddEventHandler('xz-vehicleshop:server:setShowroomCarInUse', function(data)
    local showroomVehicle = data.ClosestVehicle
    local bool = data.bolbol
    local currentindex = data.ClosestShopIndex

    XZ.VehicleShops[currentindex]["ShowroomVehicles"][showroomVehicle].inUse = bool
    TriggerClientEvent('xz-vehicleshop:client:setShowroomCarInUse', -1, showroomVehicle, bool)
end)

RegisterServerEvent('xz-vehicleshop:server:setShowroomVehicle')
AddEventHandler('xz-vehicleshop:server:setShowroomVehicle', function(data)
    XZ.VehicleShops[data.currentindex]["ShowroomVehicles"][data.k].chosenVehicle = data.vData
    TriggerClientEvent('xz-vehicleshop:client:setShowroomVehicle', -1, data.vData, data.k)
end)

function CheckOwnedJob(source, grade)
    local ownedjob = false
    local Player = XZCore.Functions.GetPlayer(source)

    for k, v in pairs(XZ.VehicleShops) do
        if v["OwnedJob"] then
            if v["OwnedJob"] == Player.PlayerData.job.name then
                if grade ~= nil and grade == Player.PlayerData.job.grade.level then
                    ownedjob = true
                elseif grade == nil then
                    ownedjob = true
                end
                break
            end
        end
    end

    return ownedjob
end

XZCore.Commands.Add("sell", "Sell Vehicle (Car Dealer Only)", {{name="ID", help="ID of Player to sell to"}}, true, function(source, args)
    local TargetId = tonumber(args[1])

    if CheckOwnedJob(source) then
        if TargetId ~= nil then
            if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(TargetId))) < 3.0 then
                TriggerClientEvent('xz-vehicleshop:client:SellCustomVehicle', source, TargetId)
            else
                TriggerClientEvent('XZCore:Notify', source, 'The provided Player with ID '..TargetId..' is not nearby', 'error')
            end
        else
            TriggerClientEvent('XZCore:Notify', source, 'You must provide a Player ID!', 'error')
        end
    else
        TriggerClientEvent('XZCore:Notify', source, "You don't have access to this command", 'error')
    end
end)

XZCore.Commands.Add("testdrive", "Test Drive Vehicle (Car Dealer Only)", {}, false, function(source, args)
    if CheckOwnedJob(source) then
        TriggerClientEvent('xz-vehicleshop:client:DoTestrit', source, GeneratePlate())
    else
        TriggerClientEvent('XZCore:Notify', source, "You don't have access to this command", 'error')
    end
end)

RegisterServerEvent('xz-vehicleshop:server:SellCustomVehicle')
AddEventHandler('xz-vehicleshop:server:SellCustomVehicle', function(TargetId, ShowroomSlot)
    TriggerClientEvent('xz-vehicleshop:client:BuyVehicleCustom', TargetId, ShowroomSlot)
end)

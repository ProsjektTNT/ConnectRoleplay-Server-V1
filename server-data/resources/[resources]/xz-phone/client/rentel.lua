MenuEnable = false
local menuItem = {}
local currentCoords

CreateThread(function()
    for k,v in pairs(Config.RentelLocations) do
        local RentalPoint = AddBlipForCoord(v["coords"][1], v["coords"][2], v["coords"][3])

        SetBlipSprite (RentalPoint, 348)
        SetBlipDisplay(RentalPoint, 4)
        SetBlipScale  (RentalPoint, 0.6)
        SetBlipAsShortRange(RentalPoint, true)
        SetBlipColour(RentalPoint, 46)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Rental")
        EndTextCommandSetBlipName(RentalPoint)
    end

    for model, data in pairs(Config.RentelVehicles) do
        menuItem[#menuItem + 1] = {
            title = data.label .. " [" .. data.price .. "$]",
            description = "Rent " .. data.label .. " For " .. data.price .. "$",
            event = "xz-phone:server:spawnVehicle",
            eventType = "server",
            args = {
                ["model"] = model,
                ["price"] = data.price
            },
            close = true,
        }
    end

    for id, rentalPos in pairs(Config.RentelLocations) do 
        exports['xz-interact']:AddBoxZone("rentalPos" .. id, rentalPos.coords, rentalPos.heigth, rentalPos.width, {
            name = "rentalPos" .. id,
            heading = rentalPos.heading,
            debugPoly = true,
            minZ = rentalPos.coords.z - 1,
            maxZ = rentalPos.coords.z + 1,
        }, {
            options = {
                {
                    event = 'xz-phone:client:openMenu',
                    icon = 'fas fa-key',
                    label = 'Rent A Vehicle',
                },
                {
                    event = 'xz-phone:client:returnVehicle',
                    icon = 'fas fa-undo',
                    label = 'Return Vehicle',
                }
            },
            distance = 2.0
        })
    end
end)

local boatItem = {}
CreateThread(function()
    for k,v in pairs(Config.BoatLocations) do
        local BoatRentel = AddBlipForCoord(v["coords"][1], v["coords"][2], v["coords"][3])

        SetBlipSprite (BoatRentel, 427)
        SetBlipDisplay(BoatRentel, 4)
        SetBlipScale  (BoatRentel, 0.6)
        SetBlipAsShortRange(BoatRentel, true)
        SetBlipColour(BoatRentel, 46)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Boat Rental")
        EndTextCommandSetBlipName(BoatRentel)
    end

    for model, data in pairs(Config.RentelBoats) do
        boatItem[#boatItem + 1] = {
            title = data.label .. " [" .. data.price .. "$]",
            description = "Rent " .. data.label .. " For " .. data.price .. "$",
            event = "xz-phone:server:spawnBoat",
            eventType = "server",
            args = {
                ["model"] = model,
                ["price"] = data.price
            },
            close = true,
        }
    end
end)

RegisterNetEvent("xz-phone:client:openMenu", function()
    exports["xz-menu"]:openMenu(menuItem)
end)

RegisterNetEvent("xz-phone:client:boatMenu", function()
    exports["xz-menu"]:openMenu(boatItem)
end)

local vehicles = {}

RegisterNetEvent('xz-phone:client:spawnVehicle', function(data)
    local ped       = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    local coords

    for _, rentalLocation in pairs(Config.RentelLocations) do
        if(#(pedCoords - rentalLocation.coords) < 2.5) then
            coords = rentalLocation.carSpawn
        end
    end

    if(coords == nil) then
        return XZCore.Functions.Notify("Unknown coords", "error")
    end

    local vaildComp = vector3(coords.x, coords.y, coords.z)
    local closestVehicle = XZCore.Functions.GetClosestVehicle(vaildComp)

    if(#(vaildComp - GetEntityCoords(closestVehicle)) < 1.5) then
        return XZCore.Functions.Notify("There is a vehicle too close.", "error")
    end
    
    TriggerServerEvent('xz-phone:server:removeMoney', 'cash', data.price)
    XZCore.Functions.Notify("You sucessfully rented a vehicle.", "success")

    XZCore.Functions.SpawnVehicle(data.model, function(veh)
        SetEntityHeading(veh, coords.w)
        SetVehicleNumberPlateText(veh, data.plate)

        local plate = GetVehicleNumberPlateText(veh)
        vehicles[plate] = {
            object = veh,
            model = data.model
        } 

        Wait(100)
        TriggerEvent("vehiclekeys:client:SetOwner", plate, veh)
        if(Config.RentelVehicles[data.model].papers) then
            TriggerServerEvent('xz-rentel:rentelPapers', plate)
        end
    end, coords, true)
end)

RegisterNetEvent('xz-phone:client:spawnBoat', function(data)
    local ped       = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    local coords

    for _, boatLocation in pairs(Config.BoatLocations) do
        if(#(pedCoords - boatLocation.coords) < 2.5) then
            coords = boatLocation.boatSpawn
        end
    end

    if(coords == nil) then
        return XZCore.Functions.Notify("Unknown coords", "error")
    end

    local vaildComp = vector3(coords.x, coords.y, coords.z)
    local closestVehicle = XZCore.Functions.GetClosestVehicle(vaildComp)

    if(#(vaildComp - GetEntityCoords(closestVehicle)) < 1.5) then
        return XZCore.Functions.Notify("There is a vehicle too close.", "error")
    end
    
    TriggerServerEvent('xz-phone:server:removeMoney', 'cash', data.price)
    XZCore.Functions.Notify("You sucessfully rented a boat.", "success")

    XZCore.Functions.SpawnVehicle(data.model, function(veh)
        SetEntityHeading(veh, coords.w)
        SetVehicleNumberPlateText(veh, data.plate)

        local plate = GetVehicleNumberPlateText(veh)
        vehicles[plate] = {
            object = veh,
            model = data.model
        } 

        Wait(100)
        TriggerEvent("vehiclekeys:client:SetOwner", plate, veh)
    end, coords, true)
end)

RegisterNetEvent('xz-phone:client:returnVehicle', function()

    local ped       = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    local coords

    for _, rentalLocation in pairs(Config.RentelLocations) do
        if(#(pedCoords - rentalLocation.coords) < 2.5) then
            coords = rentalLocation.coords
        end
    end

    if(coords == nil) then
        return XZCore.Functions.Notify("Unknown coords", "error")
    end

    local closestVehicle = XZCore.Functions.GetClosestVehicle(coords)
    local plate = GetVehicleNumberPlateText(closestVehicle)

    if(#(coords - GetEntityCoords(closestVehicle)) > 3.8) then
        return XZCore.Functions.Notify("Can't find the vehicle.", "error")
    end

    if(vehicles[plate] == nil) then
        return XZCore.Functions.Notify("Vehicle isn't a rental vehicle.", "error")
    end

    XZCore.Functions.TriggerCallback("xz-phone:server:restoreRental", function(success)
        if(success) then
            SendNUIMessage({
                action = "PhoneNotification",
                PhoneNotify = {
                    title = "Rentel",
                    text = "You returned a rented vehicle!",
                    icon = Config.RentelVehicles[vehicles[plate].model]['icon'],
                    color = "#ee82ee",
                    timeout = 1500,
                },
            })

            XZCore.Functions.DeleteVehicle(vehicles[plate].object)
            vehicles[plate] = nil
        end
    end, vehicles[plate].model, plate)
end)

function DrawText3Ds(x, y, z, text)

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end
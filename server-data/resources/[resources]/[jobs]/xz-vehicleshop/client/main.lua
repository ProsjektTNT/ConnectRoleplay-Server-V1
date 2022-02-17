local ClosestVehicle, ClosestShopIndex = 1, 1
local inMenu = false
local modelLoaded = true
local testritveh = 0
local fakecar = {model = '', car = nil}
local PlayerJob = {}
local isLoggedIn = false
local Categories = {}
local VehStrings = {}

local menuItem = {}
local indexs = {}

local colorMenu = {
    {
        title = "Primary color",
        description = "The primary color of the vehicle.",
        sub_menu = {}
    },
    {
        title = "Secondary color",
        description = "The secondary color of the vehicle.",
        sub_menu = {}
    }
}

local colors = {
    ["0"] = "Metallic Black",
    ["1"] = "Metallic Graphite Black",
    ["2"] = "Metallic Black Steal",
    ["3"] = "Metallic Dark Silver",
    ["4"] = "Metallic Silver",
    ["5"] = "Metallic Blue Silver",
    ["6"] = "Metallic Steel Gray",
    ["7"] = "Metallic Shadow Silver",
    ["8"] = "Metallic Stone Silver",
    ["9"] = "Metallic Midnight Silver",
    ["10"] = "Metallic Gun Metal",
    ["11"] = "Metallic Anthracite Grey",
    ["12"] = "Matte Black",
    ["13"] = "Matte Gray",
    ["14"] = "Matte Light Grey",
    ["15"] = "Util Black",
    ["16"] = "Util Black Poly",
    ["17"] = "Util Dark silver",
    ["18"] = "Util Silver",
    ["19"] = "Util Gun Metal",
    ["20"] = "Util Shadow Silver",
    ["21"] = "Worn Black",
    ["22"] = "Worn Graphite",
    ["23"] = "Worn Silver Grey",
    ["24"] = "Worn Silver",
    ["25"] = "Worn Blue Silver",
    ["26"] = "Worn Shadow Silver",
    ["27"] = "Metallic Red",
    ["28"] = "Metallic Torino Red",
    ["29"] = "Metallic Formula Red",
    ["30"] = "Metallic Blaze Red",
    ["31"] = "Metallic Graceful Red",
    ["32"] = "Metallic Garnet Red",
    ["33"] = "Metallic Desert Red",
    ["34"] = "Metallic Cabernet Red",
    ["35"] = "Metallic Candy Red",
    ["36"] = "Metallic Sunrise Orange",
    ["37"] = "Metallic Classic Gold",
    ["38"] = "Metallic Orange",
    ["39"] = "Matte Red",
    ["40"] = "Matte Dark Red",
    ["41"] = "Matte Orange",
    ["42"] = "Matte Yellow",
    ["43"] = "Util Red",
    ["44"] = "Util Bright Red",
    ["45"] = "Util Garnet Red",
    ["46"] = "Worn Red",
    ["47"] = "Worn Golden Red",
    ["48"] = "Worn Dark Red",
    ["49"] = "Metallic Dark Green",
    ["50"] = "Metallic Racing Green",
    ["51"] = "Metallic Sea Green",
    ["52"] = "Metallic Olive Green",
    ["53"] = "Metallic Green",
    ["54"] = "Metallic Gasoline Blue Green",
    ["55"] = "Matte Lime Green",
    ["56"] = "Util Dark Green",
    ["57"] = "Util Green",
    ["58"] = "Worn Dark Green",
    ["59"] = "Worn Green",
    ["60"] = "Worn Sea Wash",
    ["61"] = "Metallic Midnight Blue",
    ["62"] = "Metallic Dark Blue",
    ["63"] = "Metallic Saxony Blue",
    ["64"] = "Metallic Blue",
    ["65"] = "Metallic Mariner Blue",
    ["66"] = "Metallic Harbor Blue",
    ["67"] = "Metallic Diamond Blue",
    ["68"] = "Metallic Surf Blue",
    ["69"] = "Metallic Nautical Blue",
    ["70"] = "Metallic Bright Blue",
    ["71"] = "Metallic Purple Blue",
    ["72"] = "Metallic Spinnaker Blue",
    ["73"] = "Metallic Ultra Blue",
    ["74"] = "Metallic Bright Blue",
    ["75"] = "Util Dark Blue",
    ["76"] = "Util Midnight Blue",
    ["77"] = "Util Blue",
    ["78"] = "Util Sea Foam Blue",
    ["79"] = "Util Lightning blue",
    ["80"] = "Util Maui Blue Poly",
    ["81"] = "Util Bright Blue",
    ["82"] = "Matte Dark Blue",
    ["83"] = "Matte Blue",
    ["84"] = "Matte Midnight Blue",
    ["85"] = "Worn Dark blue",
    ["86"] = "Worn Blue",
    ["87"] = "Worn Light blue",
    ["88"] = "Metallic Taxi Yellow",
    ["89"] = "Metallic Race Yellow",
    ["90"] = "Metallic Bronze",
    ["91"] = "Metallic Yellow Bird",
    ["92"] = "Metallic Lime",
    ["93"] = "Metallic Champagne",
    ["94"] = "Metallic Pueblo Beige",
    ["95"] = "Metallic Dark Ivory",
    ["96"] = "Metallic Choco Brown",
    ["97"] = "Metallic Golden Brown",
    ["98"] = "Metallic Light Brown",
    ["99"] = "Metallic Straw Beige",
    ["100"] = "Metallic Moss Brown",
    ["101"] = "Metallic Biston Brown",
    ["102"] = "Metallic Beechwood",
    ["103"] = "Metallic Dark Beechwood",
    ["104"] = "Metallic Choco Orange",
    ["105"] = "Metallic Beach Sand",
    ["106"] = "Metallic Sun Bleeched Sand",
    ["107"] = "Metallic Cream",
    ["108"] = "Util Brown",
    ["109"] = "Util Medium Brown",
    ["110"] = "Util Light Brown",
    ["111"] = "Metallic White",
    ["112"] = "Metallic Frost White",
    ["113"] = "Worn Honey Beige",
    ["114"] = "Worn Brown",
    ["115"] = "Worn Dark Brown",
    ["116"] = "Worn straw beige",
    ["117"] = "Brushed Steel",
    ["118"] = "Brushed Black steel",
    ["119"] = "Brushed Aluminium",
    ["120"] = "Chrome",
    ["121"] = "Worn Off White",
    ["122"] = "Util Off White",
    ["123"] = "Worn Orange",
    ["124"] = "Worn Light Orange",
    ["125"] = "Metallic Securicor Green",
    ["126"] = "Worn Taxi Yellow",
    ["127"] = "police car blue",
    ["128"] = "Matte Green",
    ["129"] = "Matte Brown",
    ["130"] = "Worn Orange",
    ["131"] = "Matte White",
    ["132"] = "Worn White",
    ["133"] = "Worn Olive Army Green",
    ["134"] = "Pure White",
    ["135"] = "Hot Pink",
    ["136"] = "Salmon pink",
    ["137"] = "Metallic Vermillion Pink",
    ["138"] = "Orange",
    ["139"] = "Green",
    ["140"] = "Blue",
    ["141"] = "Mettalic Black Blue",
    ["142"] = "Metallic Black Purple",
    ["143"] = "Metallic Black Red",
    ["144"] = "hunter green",
    ["145"] = "Metallic Purple",
    ["146"] = "Metaillic V Dark Blue",
    ["147"] = "MODSHOP BLACK1",
    ["148"] = "Matte Purple",
    ["149"] = "Matte Dark Purple",
    ["150"] = "Metallic Lava Red",
    ["151"] = "Matte Forest Green",
    ["152"] = "Matte Olive Drab",
    ["153"] = "Matte Desert Brown",
    ["154"] = "Matte Desert Tan",
    ["155"] = "Matte Foilage Green",
    ["156"] = "DEFAULT ALLOY COLOR",
    ["157"] = "Epsilon Blue",
    ["158"] = "Pure Gold",
    ["159"] = "Brushed Gold",
}



CreateThread(function()
    Wait(1500)
    for i = 1, #XZ.VehicleShops do
        for k, v in pairs(XZ.VehicleShops[i]["Categories"]) do
            Categories[k] = {
                label = v,
                vehicles = {}
            }

            indexs[k] = #menuItem + 1
            menuItem[#menuItem + 1] = {
                title = v,
                description = v .. " Category",
                sub_menu = {}
            }
        end
    end

    for colorId, colorName in pairs(colors) do
        colorMenu[1].sub_menu[#colorMenu[1].sub_menu + 1] = {
            title = colorName,
            description = "Select " .. colorName,
            event = "xz-vehicleshop:client:changeColorForReal",
            eventType = "client",
            close = true,
            args = {
                ["name"] = colorName,
                ["id"] = tonumber(colorId),
                ["type"] = "primary"
            }
        }
    end

    for colorId, colorName in pairs(colors) do
        colorMenu[2].sub_menu[#colorMenu[2].sub_menu + 1] = {
            title = colorName,
            description = "Select " .. colorName,
            event = "xz-vehicleshop:client:changeColorForReal",
            eventType = "client",
            close = true,
            args = {
                ["name"] = colorName,
                ["id"] = tonumber(colorId),
                ["type"] = "secondary"
            }
        }
    end

end)

RegisterCommand("elior_sexy", function()
    exports["xz-menu"]:openMenu(colorMenu)
end)

RegisterNetEvent("xz-vehicleshop:client:changeColor", function()
    exports["xz-menu"]:openMenu(colorMenu)
end)

RegisterNetEvent("xz-vehicleshop:client:changeColorForReal", function(data)
    local veh = XZCore.Functions.GetClosestVehicle()
    local color1, color2 = GetVehicleColours(veh)

    if(data.type == "primary") then
        color1 = data.id
    else
        color2 = data.id
    end

    TriggerServerEvent("xz-vehicleshop:server:changeColor", color1, color2, GetEntityCoords(veh))
end)

RegisterNetEvent("xz-vehicleshop:client:changeColorForClient", function(color1, color2, coords)
    SetVehicleColours(XZCore.Functions.GetClosestVehicle(coords), color1, color2)
    XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][ClosestVehicle].colors = {}
    XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][ClosestVehicle].colors["color1"] = color1
    XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][ClosestVehicle].colors["color2"] = color2
end)



function refreshMenu()
    for cat, _ in pairs(Categories) do
        menuItem[indexs[cat]].sub_menu = {}
    end

    for k, v in pairs(XZCore.Shared.Vehicles) do
        for cat,_ in pairs(Categories) do
            if XZCore.Shared.Vehicles[k]["category"] == cat then
                table.insert(Categories[cat].vehicles, XZCore.Shared.Vehicles[k])
                local brand = v.brand == nil and "Unknown" or v.brand
                menuItem[indexs[cat]].sub_menu[#menuItem[indexs[cat]].sub_menu + 1] = {
                    title = v.name .. " [" .. comma_value(v.price) .. "$]",
                    description = v.name .. " Of Brand " .. brand,
                    event = "xz-vehicleshop:server:setShowroomVehicle",
                    eventType = "server",
                    close = true,
                    args = {
                        ["vData"] = v.model,
                        ["k"] = ClosestVehicle,
                        ["currentindex"] = ClosestShopIndex
                    }
                }
            end
        end
    end
end

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        Wait(200)
        PlayerJob = XZCore.Functions.GetPlayerData().job
        isLoggedIn = true
    end
end)

RegisterNetEvent('XZCore:Client:OnPlayerLoaded')
AddEventHandler('XZCore:Client:OnPlayerLoaded', function()
    PlayerJob = XZCore.Functions.GetPlayerData().job
    isLoggedIn = true
end)

RegisterNetEvent('XZCore:Client:OnPlayerUnload')
AddEventHandler('XZCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
    PlayerJob = {}
end)

RegisterNetEvent('XZCore:Client:OnJobUpdate')
AddEventHandler('XZCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

CreateThread(function()
    for i = 1, #XZ.VehicleShops do
        local Dealer = AddBlipForCoord(XZ.VehicleShops[i]["Location"])
        SetBlipSprite (Dealer, 326)
        SetBlipDisplay(Dealer, 4)
        SetBlipScale  (Dealer, 0.75)
        SetBlipAsShortRange(Dealer, true)
        SetBlipColour(Dealer, 3)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(XZ.VehicleShops[i]["ShopLabel"])
        EndTextCommandSetBlipName(Dealer)
    end
end)

CreateThread(function()
    Wait(2000)

    for k, v in pairs(Categories) do
        for i = 1, #XZ.VehicleShops do
            local toInsertVehicles = {}
            local vehiclesTable = v.vehicles

            if XZ.VehicleShops[i]["Categories"][k] then
                for k, v in pairs(vehiclesTable) do
                    if v["shop"] == XZ.VehicleShops[i]["ShopName"] then
                        table.insert(toInsertVehicles, vehiclesTable[k])
                    end
                end

                table.insert(XZ.VehicleShops[i]["menu"]["vehicles"]["buttons"], {
                    menu = k,
                    name = v.label,
                    description = {}
                })

                XZ.VehicleShops[i]["menu"][k] = {
                    title = k,
                    name = v.label,
                    buttons = toInsertVehicles
                }
            end
        end
    end
end)

CreateThread(function()
    Wait(1000)
    while true do
        if isLoggedIn and XZ.VehicleShops[ClosestShopIndex]["OwnedJob"] then
            local ped = PlayerPedId()
            local bringcoords = XZ.VehicleShops[ClosestShopIndex]["ReturnLocation"]
            local pos = GetEntityCoords(ped, false)
            local dist = #(pos - vector3(bringcoords.x, bringcoords.y, bringcoords.z))

            if IsPedInAnyVehicle(ped, false) then
                if dist < 15 then
                    local veh = GetVehiclePedIsIn(ped)
                    DrawMarker(2, bringcoords.x, bringcoords.y, bringcoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.1, 255, 255, 255, 155, false, false, false, false, false, false, false)

                    if dist < 2 then
                        if veh == testritveh then
                            DrawText3Ds(bringcoords.x, bringcoords.y, bringcoords.z, '~g~E~w~ - Return Vehicle')
                            if IsControlJustPressed(0, 38) then
                                testritveh = 0
                                XZCore.Functions.DeleteVehicle(veh)
                            end
                        end
                    end
                end
            end

            if testritveh == 0 then
                Wait(2000)
            end
        end

        Wait(3)
    end
end)

CreateThread(function()
    Wait(1000)
    for d = 1, #XZ.VehicleShops do
        for i = 1, #XZ.VehicleShops[d]["ShowroomVehicles"] do
            local oldVehicle = GetClosestVehicle(XZ.VehicleShops[d]["ShowroomVehicles"][i].coords.x, XZ.VehicleShops[d]["ShowroomVehicles"][i].coords.y, XZ.VehicleShops[d]["ShowroomVehicles"][i].coords.z, 3.0, 0, 70)
            if oldVehicle ~= 0 then
                exports['xz-interact']:RemoveTargetEntity(oldVehicle, VehStrings[oldVehicle])
                XZCore.Functions.DeleteVehicle(oldVehicle)
                VehStrings[oldVehicle] = nil
            end

            local model = GetHashKey(XZ.VehicleShops[d]["ShowroomVehicles"][i].chosenVehicle)
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(0)
            end

            local veh = CreateVehicle(model, XZ.VehicleShops[d]["ShowroomVehicles"][i].coords.x, XZ.VehicleShops[d]["ShowroomVehicles"][i].coords.y, XZ.VehicleShops[d]["ShowroomVehicles"][i].coords.z, XZ.VehicleShops[d]["ShowroomVehicles"][i].coords.w, false, false)
            SetModelAsNoLongerNeeded(model)
            SetVehicleOnGroundProperly(veh)
            SetEntityInvincible(veh,true)
            SetVehicleDoorsLocked(veh, 3)
            SetEntityHeading(veh, XZ.VehicleShops[d]["ShowroomVehicles"][i].coords.w)
            FreezeEntityPosition(veh,true)
            SetVehicleNumberPlateText(veh, i .. "CARSALE")
            local vehPrice = XZCore.Shared.Vehicles[XZ.VehicleShops[d]["ShowroomVehicles"][i].chosenVehicle]["price"]
            local vehName = XZCore.Shared.Vehicles[XZ.VehicleShops[d]["ShowroomVehicles"][i].chosenVehicle]["name"]
            local color1, color2 = GetVehicleColours(veh)
            XZ.VehicleShops[d]["ShowroomVehicles"][i].colors = {
                ["color1"] = color1,
                ["color2"] = color2
            }
            local vehstring = 'Purchase Vehicle ['..comma_value(vehPrice)..'$]'
            local vehstring2 = 'Change Vehicle ['..vehName..']'
            exports['xz-interact']:AddTargetEntity(veh, {
                options = {
                    {
                        event = 'xz-vehicleshop:client:BuyVehicle',
                        label = vehstring,
                        icon = 'fas fa-circle'
                    },
                    {
                        event = 'xz-vehicleshop:client:openMenu',
                        label = vehstring2,
                        icon = 'fas fa-circle',
                        canInteract = function()
                            return not XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][ClosestVehicle].inUse
                        end,
                    },
                    {
                        event = 'xz-vehicleshop:client:DoTestrit',
                        label = "Test drive",
                        icon = 'fas fa-circle'
                    },
                    {
                        event = 'xz-vehicleshop:client:changeColor',
                        label = "Chgane Color",
                        icon = 'fas fa-circle'
                    }
                },
                distance = 2.0
            })
            VehStrings[veh] = {vehstring, vehstring2}
        end
    end
end)

CreateThread(function()
    while true do
        if isLoggedIn then
            local pos = GetEntityCoords(PlayerPedId(), true)
            for i = 1, #XZ.VehicleShops do
                local shopDist = #(pos - XZ.VehicleShops[i]["Location"])
                if shopDist <= 20 then
                    ClosestShopIndex = i
                    setClosestShowroomVehicle(i)
                end
            end
        end
        Wait(1000)
    end
end)

CreateThread(function()
    Wait(1000)
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local dist = #(pos - vector3(XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][ClosestVehicle].coords.x, XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][ClosestVehicle].coords.y, XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][ClosestVehicle].coords.z))
        if ClosestVehicle ~= nil then
            if dist < 2.5 then
                if not XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][ClosestVehicle].inUse then
                    if not XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][ClosestVehicle].inUse and not XZ.VehicleShops[ClosestShopIndex]["OwnedJob"] then
                        if XZ.VehicleShops[ClosestShopIndex]["opened"] then
                            if modelLoaded then
                                DrawText3Ds(XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][ClosestVehicle].coords.x, XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][ClosestVehicle].coords.y, XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][ClosestVehicle].coords.z + 1.65, 'Choosing A Vehicle')
                            else
                                DrawText3Ds(XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][ClosestVehicle].coords.x, XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][ClosestVehicle].coords.y, XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][ClosestVehicle].coords.z + 1.65, 'Model Loading')
                            end
                        end
                    elseif XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][ClosestVehicle].inUse and not XZ.VehicleShops[ClosestShopIndex]["OwnedJob"] then
                        DrawText3Ds(XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][ClosestVehicle].coords.x, XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][ClosestVehicle].coords.y, XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][ClosestVehicle].coords.z + 1.65, 'Currently In Use')
                    else
                        if CheckJob() then
                            DrawText3Ds(XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][ClosestVehicle].coords.x, XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][ClosestVehicle].coords.y, XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][ClosestVehicle].coords.z + 1.75, '~b~/sell [id]~w~ - Sell Vehicle ~b~/testdrive~w~ - Test Drive')
                        end
                    end

                    if XZ.VehicleShops[ClosestShopIndex]["opened"] then
                        local menu = XZ.VehicleShops[ClosestShopIndex]["menu"][XZ.VehicleShops[ClosestShopIndex]["currentmenu"]]
                        local y = XZ.VehicleShops[ClosestShopIndex]["menu"]["y"] + 0.12
                        buttoncount = tablelength(menu["buttons"])
                        local selected = false

                        for i,button in pairs(menu["buttons"]) do
                            if i >= XZ.VehicleShops[ClosestShopIndex]["menu"]["from"] and i <= XZ.VehicleShops[ClosestShopIndex]["menu"]["to"] then

                                if i == XZ.VehicleShops[ClosestShopIndex]["selectedbutton"] then
                                    selected = true
                                else
                                    selected = false
                                end
                                drawMenuButton(button,XZ.VehicleShops[ClosestShopIndex]["menu"]["x"],y,selected)
                                if button.price ~= nil then

                                    drawMenuRight("$"..button.price,XZ.VehicleShops[ClosestShopIndex]["menu"]["x"],y,selected)

                                end
                                y = y + 0.04
                                if isValidMenu(XZ.VehicleShops[ClosestShopIndex]["currentmenu"]) then
                                    if selected then
                                        if IsControlJustPressed(1, 18) then
                                            if modelLoaded then
                                                TriggerServerEvent('xz-vehicleshop:server:setShowroomVehicle', button.model, ClosestVehicle, ClosestShopIndex)
                                            end
                                        end
                                    end
                                end
                                if selected and (IsControlJustPressed(1,38) or IsControlJustPressed(1, 18)) then
                                    ButtonSelected(button)
                                end
                            end
                        end
                    end

                    if XZ.VehicleShops[ClosestShopIndex]["opened"] then
                        if IsControlJustPressed(1,202) then
                            Back()
                        end
                        if IsControlJustReleased(1,202) then
                            backlock = false
                        end
                        if IsControlJustPressed(1,188) then
                            if modelLoaded then
                                if XZ.VehicleShops[ClosestShopIndex]["selectedbutton"] > 1 then
                                    XZ.VehicleShops[ClosestShopIndex]["selectedbutton"] = XZ.VehicleShops[ClosestShopIndex]["selectedbutton"] -1
                                    if buttoncount > 10 and XZ.VehicleShops[ClosestShopIndex]["selectedbutton"] < XZ.VehicleShops[ClosestShopIndex]["menu"]["from"] then
                                        XZ.VehicleShops[ClosestShopIndex]["menu"]["from"] = XZ.VehicleShops[ClosestShopIndex]["menu"]["from"] -1
                                        XZ.VehicleShops[ClosestShopIndex]["menu"]["to"] = XZ.VehicleShops[ClosestShopIndex]["menu"]["to"] - 1
                                    end
                                end
                            end
                        end
                        if IsControlJustPressed(1,187) then
                            if modelLoaded then
                                if XZ.VehicleShops[ClosestShopIndex]["selectedbutton"] < buttoncount then
                                    XZ.VehicleShops[ClosestShopIndex]["selectedbutton"] = XZ.VehicleShops[ClosestShopIndex]["selectedbutton"] +1
                                    if buttoncount > 10 and XZ.VehicleShops[ClosestShopIndex]["selectedbutton"] > XZ.VehicleShops[ClosestShopIndex]["menu"]["to"] then
                                        XZ.VehicleShops[ClosestShopIndex]["menu"]["to"] = XZ.VehicleShops[ClosestShopIndex]["menu"]["to"] + 1
                                        XZ.VehicleShops[ClosestShopIndex]["menu"]["from"] = XZ.VehicleShops[ClosestShopIndex]["menu"]["from"] + 1
                                    end
                                end
                            end
                        end
                    end

                    if GetVehiclePedIsTryingToEnter(PlayerPedId()) ~= nil and GetVehiclePedIsTryingToEnter(PlayerPedId()) ~= 0 then
                        ClearPedTasksImmediately(PlayerPedId())
                    end
                elseif XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][ClosestVehicle].inUse then
                    DrawText3Ds(XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][ClosestVehicle].coords.x, XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][ClosestVehicle].coords.y, XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][ClosestVehicle].coords.z + 0.5, 'Currently In Use')
                end
            elseif dist > 1.5 then
                if XZ.VehicleShops[ClosestShopIndex]["opened"] then
                    CloseCreator()
                end
            end
        end

        Wait(3)
    end
end)


RegisterNetEvent('xz-vehicleshop:client:DoTestrit')
AddEventHandler('xz-vehicleshop:client:DoTestrit', function(plate)
    if ClosestVehicle ~= 0 then
        XZCore.Functions.SpawnVehicle(XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][ClosestVehicle].chosenVehicle, function(veh)
            TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
            exports['LegacyFuel']:SetFuel(veh, 100)
            SetVehicleNumberPlateText(veh, plate)
            SetEntityAsMissionEntity(veh, true, true)
            SetVehicleColours(veh, XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][ClosestVehicle].colors.color1, XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][ClosestVehicle].colors.color2)
            SetEntityHeading(veh, XZ.VehicleShops[ClosestShopIndex]["VehicleSpawn"].w)
            TriggerEvent('vehiclekeys:client:SetOwner', GetVehicleNumberPlateText(veh))
            TriggerServerEvent('xz-vehicleshop:server:SaveVehicleProps', XZCore.Functions.GetVehicleProperties(veh))
            testritveh = veh

            XZCore.Functions.Notify("Good luck on the test drive! You have a 3 minute time limit until the vehicle is deleted.")

            SetTimeout(XZ.VehicleShops[ClosestShopIndex]["TestDriveTimeLimit"] * 60000, function()
                if testritveh ~= 0 then
                    testritveh = 0
                    XZCore.Functions.DeleteVehicle(veh)
                    XZCore.Functions.Notify("The time limit has been reached, the vehicle has been deleted")
                end
            end)
        end, XZ.VehicleShops[ClosestShopIndex]["VehicleSpawn"], false)
    end
end)

RegisterNetEvent('xz-vehicleshop:client:SellCustomVehicle')
AddEventHandler('xz-vehicleshop:client:SellCustomVehicle', function(TargetId)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)

    local VehicleDist = #(pos - vector3(XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][ClosestVehicle].coords.x, XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][ClosestVehicle].coords.y, XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][ClosestVehicle].coords.z))
    if VehicleDist < 2.5 then
        TriggerServerEvent('xz-vehicleshop:server:SellCustomVehicle', TargetId, ClosestVehicle)
    else
        XZCore.Functions.Notify('Not Near The Vehicle', 'error')
    end
end)

RegisterNetEvent('xz-vehicleshop:client:BuyVehicle', function()
    while true do
        Wait(5)
        DisableControlAction(0, 161, true)
        DisableControlAction(0, 162, true)
        DrawText3Ds(XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][ClosestVehicle].coords.x, XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][ClosestVehicle].coords.y, XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][ClosestVehicle].coords.z + 1.65, 'Are You Sure? | ~g~[7]~w~ Confirm -/- ~r~[8]~w~ Cancel')
        if IsDisabledControlJustPressed(0, 161) then
            local propss =  XZCore.Functions.GetVehicleProperties(XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][ClosestVehicle].chosenVehicle)
            TriggerServerEvent('xz-vehicleshop:server:buyShowroomVehicle', XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][ClosestVehicle].chosenVehicle, propss)
            break
        end

        if IsDisabledControlJustPressed(0, 162) then
            XZCore.Functions.Notify('Purchase Cancelled', 'error')
            break
        end
    end
end)

RegisterNetEvent('xz-vehicleshop:client:BuyVehicleCustom', function(slot)
    while true do
        Wait(5)
        DisableControlAction(0, 161, true)
        DisableControlAction(0, 162, true)
        DrawText3Ds(XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][slot].coords.x, XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][slot].coords.y, XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][slot].coords.z + 1.6, '~g~7~w~ - Confirm / ~r~8~w~ - Cancel - ~g~($'..XZCore.Shared.Vehicles[XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][slot].chosenVehicle].price..',-)')
        if IsDisabledControlJustPressed(0, 161) then
            TriggerServerEvent('xz-vehicleshop:server:buyShowroomVehicle', XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][slot].chosenVehicle)
            break
        end

        if IsDisabledControlJustPressed(0, 162) then
            XZCore.Functions.Notify('Purchase Cancelled', 'error')
            break
        end
    end
end)

RegisterNetEvent('xz-vehicleshop:client:SetVehicleBuying')
AddEventHandler('xz-vehicleshop:client:SetVehicleBuying', function(slot)
    XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][slot].buying = true
    SetTimeout((60 * 1000) * 5, function()
        XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][slot].buying = false
    end)
end)

RegisterNetEvent('xz-vehicleshop:client:setShowroomCarInUse')
AddEventHandler('xz-vehicleshop:client:setShowroomCarInUse', function(showroomVehicle, inUse)
    XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][showroomVehicle].inUse = inUse
end)

RegisterNetEvent('xz-vehicleshop:client:setShowroomVehicle')
AddEventHandler('xz-vehicleshop:client:setShowroomVehicle', function(showroomVehicle, k)
    if XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][k].chosenVehicle ~= showroomVehicle then
        local oldVehicle = GetClosestVehicle(XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][k].coords.x, XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][k].coords.y, XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][k].coords.z, 3.0, 0, 70)
        exports['xz-interact']:RemoveTargetEntity(oldVehicle, VehStrings[oldVehicle])
        XZCore.Functions.DeleteVehicle(oldVehicle)
        VehStrings[oldVehicle] = nil
        modelLoaded = false
        Wait(250)
        local model = GetHashKey(showroomVehicle)
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(250)
        end
        local veh = CreateVehicle(model, XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][k].coords.x, XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][k].coords.y, XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][k].coords.z, false, false)
        SetModelAsNoLongerNeeded(model)
        SetVehicleOnGroundProperly(veh)
        SetEntityInvincible(veh,true)
        SetEntityHeading(veh, XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][k].coords.w)
        SetVehicleDoorsLocked(veh, 3)
        FreezeEntityPosition(veh, true)
        SetVehicleNumberPlateText(veh, k .. "CARSALE")
        modelLoaded = true
        XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][k].chosenVehicle = showroomVehicle
        local color1, color2 = GetVehicleColours(veh)
        XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][k].colors = {}
        XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][k].colors["color1"] = color1
        XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][k].colors["color2"] = color2
        local vehPrice = XZCore.Shared.Vehicles[XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][k].chosenVehicle]["price"]
        local vehName = XZCore.Shared.Vehicles[XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][k].chosenVehicle]["name"]
        local vehstring = 'Purchase Vehicle ['..comma_value(vehPrice)..'$]'
        local vehstring2 = 'Change Vehicle ['..vehName..']'
        exports['xz-interact']:AddTargetEntity(veh, {
            options = {
                {
                    event = 'xz-vehicleshop:client:BuyVehicle',
                    label = vehstring,
                    icon = 'fas fa-circle'
                },
                {
                    event = 'xz-vehicleshop:client:openMenu',
                    label = vehstring2,
                    icon = 'fas fa-circle',
                    canInteract = function()
                        return not XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][ClosestVehicle].inUse
                    end,
                },
                {
                    event = 'xz-vehicleshop:client:DoTestrit',
                    label = "Test drive",
                    icon = 'fas fa-circle'
                },
                {
                    event = 'xz-vehicleshop:client:changeColor',
                    label = "Chgane Color",
                    icon = 'fas fa-circle'
                }
            },
            distance = 2.0
        })
        VehStrings[veh] = {vehstring, vehstring2}
    end
end)

RegisterNetEvent('xz-vehicleshop:client:buyShowroomVehicle')
AddEventHandler('xz-vehicleshop:client:buyShowroomVehicle', function(vehicle, plate)
    XZCore.Functions.SpawnVehicle(vehicle, function(veh)
        -- TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        exports['LegacyFuel']:SetFuel(veh, 100)
        SetVehicleNumberPlateText(veh, plate)
        SetEntityHeading(veh, XZ.VehicleShops[ClosestShopIndex]["VehicleSpawn"].w)
        SetVehicleColours(veh, XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][ClosestVehicle].colors.color1, XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][ClosestVehicle].colors.color2)
        SetEntityAsMissionEntity(veh, true, true)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        TriggerServerEvent("xz-vehicleshop:server:SaveVehicleProps", XZCore.Functions.GetVehicleProperties(veh), plate)
    end, XZ.VehicleShops[ClosestShopIndex]["VehicleSpawn"], true)
end)

function comma_value(amount)
    local formatted = amount
    while true do  
      formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
      if (k==0) then
        break
      end
    end
    return formatted
  end
  

RegisterNetEvent('xz-vehicleshop:client:openMenu', function()
    exports["xz-menu"]:openMenu(menuItem);

    -- if not XZ.VehicleShops[ClosestShopIndex]["opened"] then
    --     OpenCreator()
    -- else
    --     CloseCreator()
    -- end
end)

function setClosestShowroomVehicle(i)
    local pos = GetEntityCoords(PlayerPedId(), true)
    local current = nil
    local dist = nil

    for id, veh in pairs(XZ.VehicleShops[i]["ShowroomVehicles"]) do
        local dist2 = #(pos - vector3(XZ.VehicleShops[i]["ShowroomVehicles"][id].coords.x, XZ.VehicleShops[i]["ShowroomVehicles"][id].coords.y, XZ.VehicleShops[i]["ShowroomVehicles"][id].coords.z))
        if current ~= nil then
            if dist2 < dist then
                current = id
                dist = dist2
            end
        else
            dist = dist2
            current = id
        end
    end
    
    if current ~= ClosestVehicle then
        ClosestVehicle = current
        refreshMenu()
    end
end


function isValidMenu(menu)
    local retval = false
    for k, v in pairs(XZ.VehicleShops[ClosestShopIndex]["menu"]["vehicles"]["buttons"]) do
        if menu == v.menu then
            retval = true
        end
    end
    return retval
end

function OpenCreator()
	XZ.VehicleShops[ClosestShopIndex]["currentmenu"] = "main"
	XZ.VehicleShops[ClosestShopIndex]["opened"] = true
    XZ.VehicleShops[ClosestShopIndex]["selectedbutton"] = 1
    TriggerServerEvent('xz-vehicleshop:server:setShowroomCarInUse', ClosestVehicle, false, ClosestShopIndex)
end

function CloseCreator(name, veh, price, financed)
    XZ.VehicleShops[ClosestShopIndex]["opened"] = false
    XZ.VehicleShops[ClosestShopIndex]["menu"]["from"] = 1
    XZ.VehicleShops[ClosestShopIndex]["menu"]["to"] = 10
    XZ.VehicleShops[ClosestShopIndex]["ShowroomVehicles"][ClosestVehicle].inUse = false
    TriggerServerEvent('xz-vehicleshop:server:setShowroomCarInUse', ClosestVehicle, false, ClosestShopIndex)
end

function OpenMenu(menu)
    XZ.VehicleShops[ClosestShopIndex]["lastmenu"] = XZ.VehicleShops[ClosestShopIndex]["currentmenu"]
    fakecar = {model = '', car = nil}
	if menu == "vehicles" then
		XZ.VehicleShops[ClosestShopIndex]["lastmenu"] = "main"
	end
	XZ.VehicleShops[ClosestShopIndex]["menu"]["from"] = 1
	XZ.VehicleShops[ClosestShopIndex]["menu"]["to"] = 10
	XZ.VehicleShops[ClosestShopIndex]["selectedbutton"] = 1
	XZ.VehicleShops[ClosestShopIndex]["currentmenu"] = menu
end

function Back()
	if backlock then
		return
	end
	backlock = true
	if XZ.VehicleShops[ClosestShopIndex]["currentmenu"] == "main" then
		CloseCreator()
	elseif isValidMenu(XZ.VehicleShops[ClosestShopIndex]["currentmenu"]) then
		if DoesEntityExist(fakecar.car) then
			Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(fakecar.car))
		end
		fakecar = {model = '', car = nil}
		OpenMenu(XZ.VehicleShops[ClosestShopIndex]["lastmenu"])
	else
		OpenMenu(XZ.VehicleShops[ClosestShopIndex]["lastmenu"])
	end
end

function ButtonSelected(button)
	local this = XZ.VehicleShops[ClosestShopIndex]["currentmenu"]
    local btn = button["name"]
    local btnindex = nil

    for k, v in pairs(XZ.VehicleShops[ClosestShopIndex]["Categories"]) do
        if btn == XZ.VehicleShops[ClosestShopIndex]["Categories"][k] then
            btnindex = k
            break
        end
    end

	if this == "main" then
		if btn == "Categories" then
			OpenMenu('vehicles')
		end
	elseif this == "vehicles" then
        if btn == XZ.VehicleShops[ClosestShopIndex]["Categories"][btnindex] then
            OpenMenu(btnindex)
        end
	end
end

function CheckJob()
    if PlayerJob ~= nil then
        if XZ.VehicleShops[ClosestShopIndex]["OwnedJob"] == false then
            return true
        elseif type(XZ.VehicleShops[ClosestShopIndex]["OwnedJob"]) == "table" then
            for k, v in pairs(XZ.VehicleShops[ClosestShopIndex]["OwnedJob"]) do
                if PlayerJob.name == v then
                    return true
                end
            end
        elseif PlayerJob.name == XZ.VehicleShops[ClosestShopIndex]["OwnedJob"] then
            return true
        end
    end
    return false
end

function drawMenuButton(button,x,y,selected)
	local menu = XZ.VehicleShops[ClosestShopIndex]["menu"]
	SetTextFont(menu["font"])
	SetTextProportional(0)
	SetTextScale(0.25, 0.25)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(button["name"])
	if selected then
		DrawRect(x,y,menu["width"],menu["height"],255,255,255,255)
	else
		DrawRect(x,y,menu["width"],menu["height"],0, 0, 0,220)
	end
	DrawText(x - menu["width"]/2 + 0.005, y - menu["height"]/2 + 0.0028)
end

function drawMenuRight(txt,x,y,selected)
	local menu = XZ.VehicleShops[ClosestShopIndex]["menu"]
	SetTextFont(menu["font"])
	SetTextProportional(0)
	SetTextScale(0.2, 0.2)
	if selected then
		SetTextColour(0,0,0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawText(x + menu["width"]/2 + 0.025, y - menu["height"]/3 + 0.0002)

	if selected then
		DrawRect(x + menu["width"]/2 + 0.025, y,menu["width"] / 3,menu["height"],255, 255, 255,250)
	else
		DrawRect(x + menu["width"]/2 + 0.025, y,menu["width"] / 3,menu["height"],0, 0, 0,250) 
	end
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end
local maxamount = {}
local StartWork = false
local itempickup, workx, worky, workz, workshop = nil
local Pickedup = false
local NearShop = false
local isLoggedIn = false
local amountwant = 0
local CurrentShop = nil

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

RegisterCommand('restock', function(source, args, rawCommand)
    local itemData = XZCore.Shared.Items[tostring(args[1]):lower()]
    local item = tostring(args[1]):lower()
    amountwant = tonumber(args[2])
    if itemData ~= nil and amountwant ~= nil then
        local PlayerPed = PlayerPedId()
        local PlayerPos = GetEntityCoords(PlayerPed)

        for shop, _ in pairs(Shops.Locations) do
            local shopcoords = Shops.Locations[shop]["coords"]
            local dist = #(PlayerPos - shopcoords)
            if dist < 10 then
                local ShopItems = {}
                ShopItems.items = Shops.Locations[shop]["products"]
                for a, i in pairs(ShopItems.items) do
                    if ShopItems.items[a].name == item then
                        if maxamount[ShopItems.items[a].name] >= (ShopItems.items[a].amount + amountwant) then
                            SetNewWaypoint(-630.867, 152.30085)
                            StartWork = true
                            TriggerEvent("XZCore:Notify", "Go to the waypoint to pickup the package.", "success")
                            itempickup = item
                            workx = shopcoords.x
                            worky = shopcoords.y
                            workz = shopcoords.z
                            workshop = shop
                        else
                            TriggerEvent("XZCore:Notify", "Max item that can be in the store is " .. maxamount[ShopItems.items[a].name], "error")
                        end
                    end
                end
            end
        end
    else
        TriggerEvent("XZCore:Notify", "item does not exists or max item reached.", "error")
    end
end, false)

--[[Citizen.CreateThread(function()
    while true do
        local InRange = false
        local PlayerPed = PlayerPedId()
        local PlayerPos = GetEntityCoords(PlayerPed)

        for shop, _ in pairs(Shops.Locations) do
            local position = Shops.Locations[shop]["coords"]
            for _, loc in pairs(position) do
                local dist = #(PlayerPos - vector3(loc["x"], loc["y"], loc["z"]))
                if dist < 10 then
                    InRange = true
					DrawMarker(27, loc["x"], loc["y"], loc["z"] -0.8, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.001, 1.0001, 0.5001, 0, 25, 165, 100, false, true, 2, false , false, false, false)
                    if dist < 1 then
                        local job = XZCore.Functions.GetPlayerData().job.name
                        if job == 'trevorshop' and not StartWork then
                            DrawText3Ds(loc["x"], loc["y"], loc["z"]+0.1, '[Restock] - /restock "item"')
                        end
                        if StartWork and Pickedup then
                            DrawText3Ds(workx, worky, workz+0.1, '[G] - Delivery ' .. itempickup)
                        end
                        if IsControlJustPressed(0, Shops.Keys["G"]) and Pickedup == true and StartWork == true then
                            TriggerEvent('animations:client:EmoteCommandStart', {"parkingmeter"})
                            XZCore.Functions.Progressbar("delivery", "Delivery Item", 10000, false, true, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }, {}, {}, {}, function() -- success
                                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                                Pickedup = false
                                StartWork = false
                                XZCore.Functions.Notify("Go back to the store to delivery the package", "success")
                                TriggerServerEvent('xz-shops:server:RestockItem', workshop, itempickup, tonumber(amountwant))
                            end, function() -- cancel
                                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                                XZCore.Functions.Notify("Canceled...", "error")
                            end)
                        end
                    end
                end
            end
        end
        if not InRange and not StartWork then
            Citizen.Wait(5000)
        end
        if StartWork and not Pickedup then
            local dist = GetDistanceBetweenCoords(PlayerPos, -630.867, 152.30085, 56.982)
            if dist < 10 then
                local job = XZCore.Functions.GetPlayerData().job.name
                if job == 'trevorshop' then
                    DrawText3Ds(-630.867, 152.30085, 56.982, '[G] Pickup ' .. itempickup)
                end   
    
                if IsControlJustPressed(0, Shops.Keys["G"]) then
                    TriggerEvent('animations:client:EmoteCommandStart', {"parkingmeter"})
                    XZCore.Functions.Progressbar("pickup", "Packing Package", 10000, false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }, {}, {}, {}, function() -- success
                        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                        SetNewWaypoint(workz, worky)
                        Pickedup = true
                        XZCore.Functions.Notify("Go back to the store to delivery the package", "success")
                    end, function() -- cancel
                        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                        XZCore.Functions.Notify("Canceled...", "error")
                    end)
                end  
            end
        end   
        Citizen.Wait(5)
    end     
end)]]

Citizen.CreateThread(function()
    for shop, _ in pairs(Shops.Locations) do
        local ShopItems = {}
        ShopItems.items = Shops.Locations[shop]["products"]
        for a, i in pairs(ShopItems.items) do
            maxamount[ShopItems.items[a].name] = ShopItems.items[a].amount
        end
    end
    while true do
        Citizen.Wait(3)
        if isLoggedIn then
            NearShop = false
            for k, v in pairs(Shops.Locations) do
                local ped = PlayerPedId()
                local PlayerPos = GetEntityCoords(ped)
                local shopcoords = Shops.Locations[k]["coords"]
                local dist = #(PlayerPos - shopcoords)
                if dist < 3.0 then
                    NearShop = true
                    if k ~= CurrentShop then
                        CurrentShop = k
                    end
                end
            end
            if not NearShop then
                Citizen.Wait(1000)
                CurrentShop = nil
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

RegisterNetEvent('xz-shops:client:OpenClosestShop', function()
    local ShopItems = {}
    ShopItems.label = Shops.Locations[CurrentShop]["label"]
    ShopItems.items = Shops.Locations[CurrentShop]["products"]
    ShopItems.slots = 30
    if Shops.Locations[CurrentShop]["type"] == 'dede' then
        TriggerServerEvent("inventory:server:OpenInventory", "dede", "Itemshop_"..CurrentShop, ShopItems)
    else
        TriggerServerEvent("inventory:server:OpenInventory", "shop", "Itemshop_"..CurrentShop, ShopItems)
    end
    TriggerEvent("debug", 'Shops: ' .. Shops.Locations[CurrentShop]["label"], 'success')
end)

RegisterNetEvent('XZCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
end)

RegisterNetEvent('XZCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        isLoggedIn = true
    end
end)

RegisterNetEvent('xz-shops:client:UpdateShop', function(shop, itemData, amount)
    TriggerServerEvent('xz-shops:server:UpdateShopItems', shop, itemData, amount)
    TriggerEvent("debug", 'Shops: Updated', 'success')
end)

RegisterNetEvent('xz-shops:client:SetShopItems', function(shop, shopProducts)
    Shops.Locations[shop]["products"] = shopProducts
end)

RegisterNetEvent('xz-shops:client:RestockShopItems', function(shop, amount)
    if Shops.Locations[shop]["products"] ~= nil then 
        for k, v in pairs(Shops.Locations[shop]["products"]) do 
            Shops.Locations[shop]["products"][k].amount = Shops.Locations[shop]["products"][k].amount + amount
        end
    end
end)

Citizen.CreateThread(function()
    for store,_ in pairs(Shops.Locations) do
        StoreBlip = AddBlipForCoord(Shops.Locations[store]["coords"].x, Shops.Locations[store]["coords"].y, Shops.Locations[store]["coords"].z)
        SetBlipColour(StoreBlip, 0)

        if Shops.Locations[store]["products"] == Shops.Products["normal"] then
            SetBlipSprite(StoreBlip, 52)
            SetBlipScale(StoreBlip, 0.6)
            SetBlipColour(StoreBlip, 0)
        elseif Shops.Locations[store]["products"] == Shops.Products["hardware"] then
            SetBlipSprite(StoreBlip, 544)
            SetBlipScale(StoreBlip, 0.8)
            SetBlipColour(StoreBlip, 0)
        elseif Shops.Locations[store]["products"] == Shops.Products["casinohb"] then
            SetBlipSprite(StoreBlip, 431)
            SetBlipScale(StoreBlip, 0.6)
            SetBlipColour(StoreBlip, 0)
        elseif Shops.Locations[store]["products"] == Shops.Products["casino"] then
            SetBlipSprite(StoreBlip, 207)
            SetBlipScale(StoreBlip, 0.6)
            SetBlipColour(StoreBlip, 0)
        elseif Shops.Locations[store]["products"] == Shops.Products["weapons"] then
            SetBlipSprite(StoreBlip, 110)
            SetBlipScale(StoreBlip, 0.7)
            SetBlipColour(StoreBlip, 0)     
        elseif Shops.Locations[store]["products"] == Shops.Products["gsgasoline"] then
            SetBlipSprite(StoreBlip, 52)
            SetBlipScale(StoreBlip, 0.6)
            SetBlipColour(StoreBlip, 0)           
        elseif Shops.Locations[store]["products"] == Shops.Products["coffeeshop"] then
            SetBlipSprite(StoreBlip, 140)
            SetBlipScale(StoreBlip, 0.6)
        end

        SetBlipDisplay(StoreBlip, 4)
        SetBlipAsShortRange(StoreBlip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Shops.Locations[store]["label"])
        EndTextCommandSetBlipName(StoreBlip)
    end
end)

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
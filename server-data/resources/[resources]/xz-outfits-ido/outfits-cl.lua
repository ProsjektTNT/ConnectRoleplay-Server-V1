XZCore = nil
TriggerEvent("XZCore:GetObject", function(obj) XZCore = obj end)

local charOutfits = GetResourceKvpString("xz-outfits")

if (charOutfits) then charOutfits = json.decode(charOutfits) else charOutfits = {} end


RegisterCommand("outfits", function()
    for k, v in pairs(Config.Zones) do
        if #(GetEntityCoords(PlayerPedId()) - v) < Config.Distance then
            local menuOptions = {}
            for k, v in pairs(charOutfits) do
                local miniTable = {
                    title = v[1], 
                    description = "",
                    sub_menu = {
                        {
                            title = "Wear outfit",
                            description = "",
                            close = true,
                            event = "xz-outfits-ido:client:wearOutfit",
                            eventType = "client",
                            args = k
                        },
                        {
                            title = "Delete outfit",
                            description = "You will no longer have the outfit.",
                            close = true, 
                            event = "xz-outfits-ido:client:deleteOutfit",
                            eventType = "client",
                            args = k,
                        }
                    }
                }
                menuOptions[#menuOptions + 1] = miniTable
            end
            if (#menuOptions >= 1) then
                exports["xz-menu"]:openMenu(menuOptions)
            else
                XZCore.Functions.Notify("You don't have any outfits.", "error", 3500)
            end        
            break 
        end
    end
end)

RegisterNetEvent("xz-outfits-ido:client:openOutfits", function()
    for k, v in pairs(Config.Zones) do
        if #(GetEntityCoords(PlayerPedId()) - v) < Config.Distance then
            local menuOptions = {}
            for k, v in pairs(charOutfits) do
                local miniTable = {
                    title = v[1], 
                    description = "",
                    sub_menu = {
                        {
                            title = "Wear outfit",
                            description = "",
                            close = true,
                            event = "xz-outfits-ido:client:wearOutfit",
                            eventType = "client",
                            args = k
                        },
                        {
                            title = "Delete outfit",
                            description = "You will no longer have the outfit.",
                            close = true, 
                            event = "xz-outfits-ido:client:deleteOutfit",
                            eventType = "client",
                            args = k,
                        }
                    }
                }
                menuOptions[#menuOptions + 1] = miniTable
            end
            if (#menuOptions >= 1) then
                exports["xz-menu"]:openMenu(menuOptions)
            else
                XZCore.Functions.Notify("You don't have any outfits.", "error", 3500)
            end        
            break 
        end
    end

end)

RegisterNetEvent("xz-outfits-ido:client:forceUI", function()
    local menuOptions = {}
    for k, v in pairs(charOutfits) do
        local miniTable = {
            title = v[1], 
            description = "",
            sub_menu = {
                {
                    title = "Wear outfit",
                    description = "",
                    close = true,
                    event = "xz-outfits-ido:client:wearOutfit",
                    eventType = "client",
                    args = k
                },
                {
                    title = "Delete outfit",
                    description = "You will no longer have the outfit.",
                    close = true, 
                    event = "xz-outfits-ido:client:deleteOutfit",
                    eventType = "client",
                    args = k,
                }
            }
        }
        menuOptions[#menuOptions + 1] = miniTable
    end
    if (#menuOptions >= 1) then
        exports["xz-menu"]:openMenu(menuOptions)
    else
        XZCore.Functions.Notify("You don't have any outfits.", "error", 3500)
    end
end)

RegisterNetEvent("xz-outfits-ido:client:wearOutfit", function(index)
    local outfit = charOutfits[index]
    TriggerEvent("raid_clothes:setclothes", charOutfits[index][2])
end)

RegisterNetEvent("xz-outfits-ido:client:deleteOutfit", function(index)
    charOutfits[index] = nil
    SetResourceKvp("xz-outfits", json.encode(charOutfits))
    XZCore.Functions.Notify("Outfit deleted", "success", 2500)
end)

RegisterCommand("saveoutfit", function(source, args)
    if (args) then
        if (args[1]) then
            charOutfits[#charOutfits + 1] = { args[1], exports["xz-clothing"]:GetCurrentPed() }
            SetResourceKvp("xz-outfits", json.encode(charOutfits))
            XZCore.Functions.Notify("Outfit saved", "success", 2500)
        else
            XZCore.Functions.Notify("Name your outfit", "error", 3500)
        end
    else
        XZCore.Functions.Notify("Name your outfit", "error", 3500)
    end
end)

RegisterCommand("resetoutfits", function()
    SetResourceKvp("xz-outfits", "{}")
    charOutfits = {}
    XZCore.Functions.Notify("Your outfits got reseted", "success", 2500)
end)

TriggerEvent('chat:addSuggestion', '/outfits', 'Outfits Menu')
TriggerEvent('chat:addSuggestion', '/resetoutfits', 'Reset saved outfits data')
TriggerEvent('chat:addSuggestion', '/saveoutfit', 'Save your current outfit', {{ name="name", help="Name this outfit."}})

XZCore = nil
Outfits = {}
TriggerEvent(Config.TriggerPrefix .. ':GetObject', function(obj) XZCore = obj end)

CreateThread(function()
    Wait(500)
    local fetch = json.decode(LoadResourceFile(GetCurrentResourceName(), "./database.json"))
    if fetch then
        Outfits = fetch
    end
end)

RegisterServerEvent("xz-outfits:server:create")
AddEventHandler("xz-outfits:server:create", function(slot, name, data)
    local src = source
    local xPlayer = XZCore.Functions.GetPlayer(src)
    local citizenid = xPlayer.PlayerData.citizenid
    local slot = tonumber(slot)
    local char = xPlayer.PlayerData.citizenid

    if not slot then
        return
    end

    if not Outfits[citizenid] then
        print("[Outfits] " .. citizenid .. ' just created.')
        Outfits[citizenid] = {}
    end

    exports.oxmysql:fetch("SELECT * FROM playersTattoos WHERE citizenid = ?", { char }, function(result)
        if(#result > 0) then
            data['tats'] = json.decode(result[1].tattoos)
            exports.oxmysql:execute("UPDATE playersTattoos SET tattoos = '{}' WHERE citizenid = ?", { char })
        else
            data['tats'] = {}
			exports.oxmysql:execute("INSERT INTO playersTattoos (citizenid, tattoos) VALUES (?, '{}')", { char })
        end
    end)

    while not data['tats'] do
        Wait(1)
    end

    if not Outfits[citizenid][slot] then
        Outfits[citizenid][slot] = { name = name, outfit = data }
        TriggerClientEvent("xz-outfits:client:updateUI", src, Outfits[citizenid])
    end

    SaveResourceFile(GetCurrentResourceName(), "./database.json", json.encode(Outfits), -1)
end)

RegisterServerEvent("xz-outfits:server:delete")
AddEventHandler("xz-outfits:server:delete", function(slot)
    local src = source
    local xPlayer = XZCore.Functions.GetPlayer(src)
    local citizenid = xPlayer.PlayerData.citizenid
    local slot = tonumber(slot)

    if not slot then
        return
    end
    
    if not Outfits[citizenid] then
        print("[Outfits] " .. citizenid .. ' just created.')
        Outfits[citizenid] = {}
    end

    if Outfits[citizenid][slot] then
        Outfits[citizenid][slot] = nil
    end

    TriggerClientEvent("xz-outfits:client:updateUI", src, Outfits[citizenid])
    SaveResourceFile(GetCurrentResourceName(), "./database.json", json.encode(Outfits), -1)
end)

RegisterServerEvent("xz-outfits:server:use")
AddEventHandler("xz-outfits:server:use", function(slot)
    local src = source
    local xPlayer = XZCore.Functions.GetPlayer(src)
    local citizenid = xPlayer.PlayerData.citizenid
    local slot = tonumber(slot)

    if not slot then
        return
    end
    
    if not Outfits[citizenid] then
        print("[Outfits] " .. citizenid .. ' just created.')
        Outfits[citizenid] = {}
        TriggerClientEvent("xz-outfits:client:updateUI", src, Outfits[citizenid])
    end

    if Outfits[citizenid][slot] then
        local outfit = Outfits[citizenid][slot]['outfit']
        TriggerClientEvent("xz-outfits:client:SetClothing", src, outfit)
    end

    SaveResourceFile(GetCurrentResourceName(), "./database.json", json.encode(Outfits), -1)
end)

XZCore.Commands.Add("outfits", "Outfits Menu", {}, false, function(source, args)
    local src = source
    local xPlayer = XZCore.Functions.GetPlayer(src)
    local citizenid = xPlayer.PlayerData.citizenid

    if not Outfits[citizenid] then
        print("[Outfits] " .. citizenid .. ' just created.')
        Outfits[citizenid] = {}
        SaveResourceFile(GetCurrentResourceName(), "./database.json", json.encode(Outfits), -1)
    end

    TriggerClientEvent("xz-outfits:client:tryUI", src, Outfits[citizenid])
end)

RegisterNetEvent("xz-outfits:server:openUI")
AddEventHandler("xz-outfits:server:openUI", function(s)
    local src = source
    local xPlayer = XZCore.Functions.GetPlayer(src)
    local citizenid = xPlayer.PlayerData.citizenid

    if not Outfits[citizenid] then
        print("[Outfits] " .. citizenid .. ' just created.')
        Outfits[citizenid] = {}
        SaveResourceFile(GetCurrentResourceName(), "./database.json", json.encode(Outfits), -1)
    end

    TriggerClientEvent("xz-outfits:client:tryUI", src, Outfits[citizenid], s)
end)
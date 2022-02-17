XZCore = nil
TriggerEvent('XZCore:GetObject', function(obj) XZCore = obj end)

-- Code
XZCore.Functions.CreateUseableItem("fitbit", function(source, item)
    local Player = XZCore.Functions.GetPlayer(source)
    TriggerClientEvent('xz-fitbit:use', source)
end)

RegisterServerEvent('xz-fitbit:server:setValue')
AddEventHandler('xz-fitbit:server:setValue', function(type, value)
    local src = source
    local ply = XZCore.Functions.GetPlayer(src)
    local fitbitData = {}

    if type == "thirst" then
        local currentMeta = ply.PlayerData.metadata["fitbit"]
        fitbitData = {
            thirst = value,
            food = currentMeta.food
        }
    elseif type == "food" then
        local currentMeta = ply.PlayerData.metadata["fitbit"]
        fitbitData = {
            thirst = currentMeta.thirst,
            food = value
        }
    end

    ply.Functions.SetMetaData('fitbit', fitbitData)
end)

XZCore.Functions.CreateCallback('xz-fitbit:server:HasFitbit', function(source, cb)
    local Ply = XZCore.Functions.GetPlayer(source)
    local Fitbit = Ply.Functions.GetItemByName("fitbit")

    if Fitbit ~= nil then
        cb(true)
    else
        cb(false)
    end
end)
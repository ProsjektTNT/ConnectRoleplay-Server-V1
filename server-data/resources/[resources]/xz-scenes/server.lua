local scenes = {}

RegisterNetEvent('xz-scenes:fetch', function()
    local src = source
    TriggerClientEvent('xz-scenes:send', src, scenes)
end)

RegisterNetEvent('xz-scenes:add', function(coords, message, color, distance)
    table.insert(scenes, {
        message = message,
        color = color,
        distance = distance,
        coords = coords
    })
    TriggerClientEvent('xz-scenes:send', -1, scenes)
    TriggerEvent('xz-scenes:log', source, message, coords)
end)

RegisterNetEvent('xz-scenes:delete', function(key)
    table.remove(scenes, key)
    TriggerClientEvent('xz-scenes:send', -1, scenes)
end)


RegisterNetEvent('xz-scenes:log', function(id, text, coords)
    local f, err = io.open('sceneLogging.txt', 'a')
    if not f then return print(err) end
    f:write('Player: ['..id..'] Placed Scene: ['..text..'] At Coords = '..coords..'\n')
    f:close()
end)
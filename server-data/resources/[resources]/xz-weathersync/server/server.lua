local CurrentWeather = Config.StartWeather
local baseTime = Config.BaseTime
local timeOffset = Config.TimeOffset
local freezeTime = Config.FreezeTime
local blackout = Config.Blackout
local newWeatherTimer = Config.NewWeatherTimer

RegisterServerEvent('xz-weathersync:server:RequestStateSync', function()
    TriggerClientEvent('xz-weathersync:client:SyncWeather', -1, CurrentWeather, blackout)
    TriggerClientEvent('xz-weathersync:client:SyncTime', -1, baseTime, timeOffset, freezeTime)
end)

RegisterServerEvent('xz-weathersync:server:RequestCommands', function()
    local src = source
    if isAllowedToChange(src) then
        TriggerClientEvent('xz-weathersync:client:RequestCommands', src, true)
    end
end)

RegisterServerEvent('xz-weathersync:server:setWeather', function(weather)
    local validWeatherType = false
    for i,wtype in ipairs(Config.AvailableWeatherTypes) do
        if wtype == string.upper(weather) then
            validWeatherType = true
        end
    end
    if validWeatherType then
        print(_U('weather_updated'))
        CurrentWeather = string.upper(weather)
        newWeatherTimer = Config.NewWeatherTimer
        TriggerEvent('xz-weathersync:server:RequestStateSync')
    else
        print(_U('weather_invalid'))
    end
end)

RegisterServerEvent('xz-weathersync:server:setTime', function(hour, minute)
    if hour ~= nil and minute ~= nil then
        local argh = tonumber(hour)
        local argm = tonumber(minute)
        if argh < 24 then
            ShiftToHour(argh)
        else
            ShiftToHour(0)
        end
        if argm < 60 then
            ShiftToMinute(argm)
        else
            ShiftToMinute(0)
        end
        print(_U('time_change', argh, argm))
        TriggerEvent('xz-weathersync:server:RequestStateSync')
    else
        print(_U('time_invalid'))
    end
end)

function isAllowedToChange(player)
    if XZCore.Functions.HasPermission(player, "admin") then
        return true
    else
        return false
    end
end

RegisterServerEvent('xz-weathersync:server:toggleBlackout', function()
    blackout = not blackout
    TriggerEvent('xz-weathersync:server:RequestStateSync')
end)

RegisterCommand('freezetime', function(source, args)
    if source ~= 0 then
        if isAllowedToChange(source) then
            freezeTime = not freezeTime
            if freezeTime then
                TriggerClientEvent('XZCore:Notify', source, _U('time_frozenc'))
            else
                TriggerClientEvent('XZCore:Notify', source, _U('time_unfrozenc'))
            end
        else
            TriggerClientEvent('XZCore:Notify', source, _U('not_allowed'), 'error')
        end
    else
        freezeTime = not freezeTime
        if freezeTime then
            print(_U('time_now_frozen'))
        else
            print(_U('time_now_unfrozen'))
        end
    end
end)

RegisterCommand('freezeweather', function(source, args)
    if source ~= 0 then
        if isAllowedToChange(source) then
            Config.DynamicWeather = not Config.DynamicWeather
            if not Config.DynamicWeather then
                TriggerClientEvent('XZCore:Notify', source, _U('dynamic_weather_disabled'))
            else
                TriggerClientEvent('XZCore:Notify', source, _U('dynamic_weather_enabled'))
            end
        else
            TriggerClientEvent('XZCore:Notify', source, _U('not_allowed'), 'error')
        end
    else
        Config.DynamicWeather = not Config.DynamicWeather
        if not Config.DynamicWeather then
            print(_U('weather_now_frozen'))
        else
            print(_U('weather_now_unfrozen'))
        end
    end
end)

RegisterCommand('blackout', function(source)
    if source == 0 then
        blackout = not blackout
        if blackout then
            print(_U('blackout_enabled'))
        else
            print(_U('blackout_disabled'))
        end
    else
        if isAllowedToChange(source) then
            blackout = not blackout
            if blackout then
                TriggerClientEvent('XZCore:Notify', source, _U('blackout_enabledc'))
            else
                TriggerClientEvent('XZCore:Notify', source, _U('blackout_disabledc'))
            end
            TriggerEvent('xz-weathersync:server:RequestStateSync')
        end
    end
end)

RegisterCommand('morning', function(source)
    if source == 0 then
        print(_U('time_console'))
        return
    end
    if isAllowedToChange(source) then
        ShiftToMinute(0)
        ShiftToHour(9)
        TriggerClientEvent('XZCore:Notify', source, _U('time_morning'))
        TriggerEvent('xz-weathersync:server:RequestStateSync')
    end
end)

RegisterCommand('noon', function(source)
    if source == 0 then
        print(_U('time_console'))
        return
    end
    if isAllowedToChange(source) then
        ShiftToMinute(0)
        ShiftToHour(12)
        TriggerClientEvent('XZCore:Notify', source, _U('time_noon'))
        TriggerEvent('xz-weathersync:server:RequestStateSync')
    end
end)

RegisterCommand('evening', function(source)
    if source == 0 then
        print(_U('time_console'))
        return
    end
    if isAllowedToChange(source) then
        ShiftToMinute(0)
        ShiftToHour(18)
        TriggerClientEvent('XZCore:Notify', source, _U('time_evening'))
        TriggerEvent('xz-weathersync:server:RequestStateSync')
    end
end)

RegisterCommand('night', function(source)
    if source == 0 then
        print(_U('time_console'))
        return
    end
    if isAllowedToChange(source) then
        ShiftToMinute(0)
        ShiftToHour(23)
        TriggerClientEvent('XZCore:Notify', source, _U('time_night'))
        TriggerEvent('xz-weathersync:server:RequestStateSync')
    end
end)

function ShiftToMinute(minute)
    timeOffset = timeOffset - ( ( (baseTime+timeOffset) % 60 ) - minute )
end

function ShiftToHour(hour)
    timeOffset = timeOffset - ( ( ((baseTime+timeOffset)/60) % 24 ) - hour ) * 60
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local newBaseTime = os.time(os.date("!*t"))/2 + 360
        if freezeTime then
            timeOffset = timeOffset + baseTime - newBaseTime			
        end
        baseTime = newBaseTime
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        TriggerClientEvent('xz-weathersync:client:SyncTime', -1, baseTime, timeOffset, freezeTime)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300000)
        TriggerClientEvent('xz-weathersync:client:SyncWeather', -1, CurrentWeather, blackout)
    end
end)

Citizen.CreateThread(function()
    while true do
        newWeatherTimer = newWeatherTimer - 1
        Citizen.Wait((1000 * 60) * Config.NewWeatherTimer)
        if newWeatherTimer == 0 then
            if Config.DynamicWeather then
                NextWeatherStage()
            end
            newWeatherTimer = Config.NewWeatherTimer
        end
    end
end)

function NextWeatherStage()
    if CurrentWeather == "CLEAR" or CurrentWeather == "CLOUDS" or CurrentWeather == "EXTRASUNNY"  then
        local new = math.random(1,2)
        if new == 1 then
            CurrentWeather = "CLEARING"
        else
            CurrentWeather = "OVERCAST"
        end
    elseif CurrentWeather == "CLEARING" or CurrentWeather == "OVERCAST" then
        local new = math.random(1,6)
        if new == 1 then
            if CurrentWeather == "CLEARING" then CurrentWeather = "FOGGY" else CurrentWeather = "RAIN" end
        elseif new == 2 then
            CurrentWeather = "CLOUDS"
        elseif new == 3 then
            CurrentWeather = "CLEAR"
        elseif new == 4 then
            CurrentWeather = "EXTRASUNNY"
        elseif new == 5 then
            CurrentWeather = "SMOG"
        else
            CurrentWeather = "FOGGY"
        end
    elseif CurrentWeather == "THUNDER" or CurrentWeather == "RAIN" then
        CurrentWeather = "CLEARING"
    elseif CurrentWeather == "SMOG" or CurrentWeather == "FOGGY" then
        CurrentWeather = "CLEAR"
    end
    TriggerEvent("xz-weathersync:server:RequestStateSync")
end

XZCore = nil
Accounts = {}
TriggerEvent('XZCore:GetObject', function(obj) XZCore = obj end)

CreateThread(function()
    Wait(500)
    local result = json.decode(LoadResourceFile(GetCurrentResourceName(), "./database.json"))

    if not result then
        return
    end

    for k,v in pairs(result) do
        local k = tostring(k)
        local v = tonumber(v)

        if k and v then
            Accounts[k] = v
        end
    end
end)

RegisterServerEvent("xz-bossmenu:server:withdrawMoney")
AddEventHandler("xz-bossmenu:server:withdrawMoney", function(amount)
    local src = source
    local xPlayer = XZCore.Functions.GetPlayer(src)
    local job = xPlayer.PlayerData.job.name

    if not Accounts[job] then
        Accounts[job] = 0
    end

    if Accounts[job] >= amount then
        Accounts[job] = Accounts[job] - amount
        xPlayer.Functions.AddMoney("cash", amount, 'xz-bossmenu:server:withdrawMoney')
    else
        TriggerClientEvent('XZCore:Notify', src, "Invaild Amount :/", "error")
        return
    end

    TriggerClientEvent('xz-bossmenu:client:refreshSociety', -1, job, Accounts[job])
    SaveResourceFile(GetCurrentResourceName(), "./database.json", json.encode(Accounts), -1)
    TriggerEvent("xz-logs:server:sendLog", {Boss = source}, "bossmenu", "Boss Action - Withdrew Money", GetPlayerName(source) .. " Succesfully Withdrew " .. amount .. "$ [" .. job .. "]", {}, "red", "xz-bossmenu")
end)

RegisterServerEvent("xz-bossmenu:server:depositMoney")
AddEventHandler("xz-bossmenu:server:depositMoney", function(amount)
    local src = source
    local xPlayer = XZCore.Functions.GetPlayer(src)
    local job = xPlayer.PlayerData.job.name

    if not Accounts[job] then
        Accounts[job] = 0
    end

    if xPlayer.Functions.RemoveMoney("cash", amount) then
        Accounts[job] = Accounts[job] + amount
    else
        TriggerClientEvent('XZCore:Notify', src, "Invaild Amount :/", "error")
        return
    end

    TriggerClientEvent('xz-bossmenu:client:refreshSociety', -1, job, Accounts[job])
    SaveResourceFile(GetCurrentResourceName(), "./database.json", json.encode(Accounts), -1)
    TriggerEvent("xz-logs:server:sendLog", {Boss = source}, "bossmenu", "Boss Action - Deposited Money", GetPlayerName(source) .. " Succesfully Deposited " .. amount .. "$ [" .. job .. "]", {}, "green", "xz-bossmenu")
end)

RegisterServerEvent("xz-bossmenu:server:addAccountMoney")
AddEventHandler("xz-bossmenu:server:addAccountMoney", function(account, amount)
    if not Accounts[account] then
        Accounts[account] = 0
    end
    
    Accounts[account] = Accounts[account] + amount
    TriggerClientEvent('xz-bossmenu:client:refreshSociety', -1, account, Accounts[account])
    SaveResourceFile(GetCurrentResourceName(), "./database.json", json.encode(Accounts), -1)
end)

RegisterServerEvent("xz-bossmenu:server:removeAccountMoney")
AddEventHandler("xz-bossmenu:server:removeAccountMoney", function(account, amount)
    if not Accounts[account] then
        Accounts[account] = 0
    end

    if Accounts[account] >= amount then
        Accounts[account] = Accounts[account] - amount
    end

    TriggerClientEvent('xz-bossmenu:client:refreshSociety', -1, account, Accounts[account])
    SaveResourceFile(GetCurrentResourceName(), "./database.json", json.encode(Accounts), -1)
end)

RegisterServerEvent("xz-bossmenu:server:openMenu")
AddEventHandler("xz-bossmenu:server:openMenu", function()
    local src = source
    local xPlayer = XZCore.Functions.GetPlayer(src)
    local job = xPlayer.PlayerData.job
    local employees = {}

    if job.isboss == true then
        if not Accounts[job.name] then
            Accounts[job.name] = 0
        end


        exports.oxmysql:fetch('SELECT * FROM `players` WHERE `job` LIKE ?', { "%" .. job.name .. "%" }, function(players)
            if players[1] ~= nil then
                for key, value in pairs(players) do
                    local isOnline = XZCore.Functions.GetPlayerByCitizenId(value.citizenid)

                    if isOnline then
                        table.insert(employees, {
                            source = isOnline.PlayerData.citizenid, 
                            grade = isOnline.PlayerData.job.grade,
                            isboss = isOnline.PlayerData.job.isboss,
                            name = isOnline.PlayerData.charinfo.firstname .. ' ' .. isOnline.PlayerData.charinfo.lastname
                        })
                    else
                        table.insert(employees, {
                            source = value.citizenid, 
                            grade =  json.decode(value.job).grade,
                            isboss = json.decode(value.job).isboss,
                            name = json.decode(value.charinfo).firstname .. ' ' .. json.decode(value.charinfo).lastname
                        })
                    end
                end
            end

            TriggerClientEvent('xz-bossmenu:client:openMenu', src, employees, XZCore.Shared.Jobs[job.name])
            TriggerClientEvent('xz-bossmenu:client:refreshSociety', -1, job.name, Accounts[job.name])
        end)
    else
        TriggerClientEvent('XZCore:Notify', src, "You are not the boss, how did you reach here bitch?!", "error")
    end
end)

RegisterServerEvent('xz-bossmenu:server:fireEmployee')
AddEventHandler('xz-bossmenu:server:fireEmployee', function(data)
    local src = source
    local xPlayer = XZCore.Functions.GetPlayer(src)
    local xEmployee = XZCore.Functions.GetPlayerByCitizenId(data.source)

    if xEmployee then
        if xEmployee.Functions.SetJob("unemployed", '0') then
            TriggerEvent('xz-logs:server:createLog', 'bossmenu', 'Job Fire', "Successfully fired " .. GetPlayerName(xEmployee.PlayerData.source) .. ' (' .. xPlayer.PlayerData.job.name .. ')', src)

            TriggerClientEvent('XZCore:Notify', src, "Fired successfully!", "success")
            TriggerClientEvent('XZCore:Notify', xEmployee.PlayerData.source , "You got fired.", "success")

            Wait(500)
            local employees = {}
            exports.oxmysql:fetch('SELECT * FROM `players` WHERE `job` LIKE ?', { "%" .. xPlayer.PlayerData.job.name .. "%" }, function(players)
                if players[1] ~= nil then
                    for key, value in pairs(players) do
                        local isOnline = XZCore.Functions.GetPlayerByCitizenId(value.citizenid)
                    
                        if isOnline then
                            table.insert(employees, {
                                source = isOnline.PlayerData.citizenid, 
                                grade = isOnline.PlayerData.job.grade,
                                isboss = isOnline.PlayerData.job.isboss,
                                name = isOnline.PlayerData.charinfo.firstname .. ' ' .. isOnline.PlayerData.charinfo.lastname
                            })
                        else
                            table.insert(employees, {
                                source = value.citizenid, 
                                grade =  json.decode(value.job).grade,
                                isboss = json.decode(value.job).isboss,
                                name = json.decode(value.charinfo).firstname .. ' ' .. json.decode(value.charinfo).lastname
                            })
                        end
                    end
                    TriggerClientEvent('xz-bossmenu:client:refreshPage', src, 'employee', employees)
                end
            end)
        else
            TriggerClientEvent('XZCore:Notify', src, "Error.", "error")
        end
    else

        exports.oxmysql:fetch('SELECT * FROM `players` WHERE `citizenid` = ?', { data.source }, function(player)
            if player ~= nil then
                xEmployee = player

                local job = {}
	            job.name = "unemployed"
	            job.label = "Unemployed"
	            job.payment = 10
	            job.onduty = true
	            job.isboss = false
	            job.grade = {}
	            job.grade.name = nil
                job.grade.level = 0

                exports.oxmysql:executeSync('UPDATE `players` SET `job` = ? WHERE `citizenid` = ?', { json.encode(job), data.source })
                TriggerClientEvent('XZCore:Notify', src, "Fired successfully!", "success")
                TriggerEvent("xz-logs:server:sendLog", {Boss = source, Player = data.source}, "bossmenu", "Boss Action - Fired Player", GetPlayerName(source) .. " Fired " .. GetPlayerName(data.source) .. "[" .. xPlayer.PlayerData.job.name .. "]", {}, "red", "xz-bossmenu")
                
                Wait(500)
                local employees = {}

                exports.oxmysql:fetch('SELECT * FROM `players` WHERE `job` LIKE ?', { "%" .. xPlayer.PlayerData.job.name .. "%" }, function(players)
                    if players[1] ~= nil then
                        for key, value in pairs(players) do
                            local isOnline = XZCore.Functions.GetPlayerByCitizenId(value.citizenid)
                        
                            if isOnline then
                                table.insert(employees, {
                                    source = isOnline.PlayerData.citizenid, 
                                    grade = isOnline.PlayerData.job.grade,
                                    isboss = isOnline.PlayerData.job.isboss,
                                    name = isOnline.PlayerData.charinfo.firstname .. ' ' .. isOnline.PlayerData.charinfo.lastname
                                })
                            else
                                table.insert(employees, {
                                    source = value.citizenid, 
                                    grade =  json.decode(value.job).grade,
                                    isboss = json.decode(value.job).isboss,
                                    name = json.decode(value.charinfo).firstname .. ' ' .. json.decode(value.charinfo).lastname
                                })
                            end
                        end

                        TriggerClientEvent('xz-bossmenu:client:refreshPage', src, 'employee', employees)
                    end
                end)
            else
                TriggerClientEvent('XZCore:Notify', src, "Error. Could not find player.", "error")
            end
        end)

    end
end)

RegisterServerEvent('xz-bossmenu:server:giveJob')
AddEventHandler('xz-bossmenu:server:giveJob', function(data)
    local src = source
    local xPlayer = XZCore.Functions.GetPlayer(src)
    local xTarget = XZCore.Functions.GetPlayerByCitizenId(data.source)

    if xPlayer.PlayerData.job.isboss == true then
        if xTarget and xTarget.Functions.SetJob(xPlayer.PlayerData.job.name, '0') then
            TriggerClientEvent('XZCore:Notify', src, "You recruit " .. (xTarget.PlayerData.charinfo.firstname .. ' ' .. xTarget.PlayerData.charinfo.lastname) .. " to " .. xPlayer.PlayerData.job.label .. ".", "success")
            TriggerClientEvent('XZCore:Notify', xTarget.PlayerData.source , "You've been recruited to " .. xPlayer.PlayerData.job.label .. ".", "success")
            TriggerEvent("xz-logs:server:sendLog", {Boss = source, Player = data.source}, "bossmenu", "Boss Action - Hired Player", GetPlayerName(source) .. " Succesfully Hired " .. GetPlayerName(data.source) .. "[" .. xPlayer.PlayerData.job.label .. "]", {}, "green", "xz-bossmenu")
        end
    else
        TriggerClientEvent('XZCore:Notify', src, "You are not the boss, how did you reach here bitch?!", "error")
    end
end)

RegisterServerEvent('xz-bossmenu:server:updateGrade')
AddEventHandler('xz-bossmenu:server:updateGrade', function(data)
    local src = source
    local xPlayer = XZCore.Functions.GetPlayer(src)
    local xEmployee = XZCore.Functions.GetPlayerByCitizenId(data.source)

    if xEmployee then
        if xEmployee.Functions.SetJob(xPlayer.PlayerData.job.name, data.grade) then
            TriggerClientEvent('XZCore:Notify', src, "Promoted successfully!", "success")
            TriggerClientEvent('XZCore:Notify', xEmployee.PlayerData.source , "You just got promoted [" .. data.grade .."].", "success")

            Wait(500)
            local employees = {}
            exports.oxmysql:fetch('SELECT * FROM `players` WHERE `job` LIKE ?', { "%" .. xPlayer.PlayerData.job.name .. "%" }, function(players)
                if players[1] ~= nil then
                    for key, value in pairs(players) do
                        local isOnline = XZCore.Functions.GetPlayerByCitizenId(value.citizenid)
                    
                        if isOnline then
                            table.insert(employees, {
                                source = isOnline.PlayerData.citizenid, 
                                grade = isOnline.PlayerData.job.grade,
                                isboss = isOnline.PlayerData.job.isboss,
                                name = isOnline.PlayerData.charinfo.firstname .. ' ' .. isOnline.PlayerData.charinfo.lastname
                            })
                        else
                            table.insert(employees, {
                                source = value.citizenid, 
                                grade =  json.decode(value.job).grade,
                                isboss = json.decode(value.job).isboss,
                                name = json.decode(value.charinfo).firstname .. ' ' .. json.decode(value.charinfo).lastname
                            })
                        end
                    end

                    TriggerClientEvent('xz-bossmenu:client:refreshPage', src, 'employee', employees)
                end
            end)
        else
            TriggerClientEvent('XZCore:Notify', src, "Error.", "error")
        end
    else
        exports.oxmysql:fetch('SELECT * FROM `players` WHERE `citizenid` = ?', { data.source }, function(player)
            if player ~= nil then
                xEmployee = player
                local job = XZCore.Shared.Jobs[xPlayer.PlayerData.job.name]
                local employeejob = json.decode(xEmployee.job)
                employeejob.grade = job.grades[data.grade]
                exports.oxmysql:executeSync('UPDATE `players` SET `job` = ? WHERE `citizenid` = ?', { json.encode(employeejob), data.source })
                TriggerClientEvent('XZCore:Notify', src, "Promoted successfully!", "success")
                
                Wait(500)
                local employees = {}
                exports.oxmysql:fetch('SELECT * FROM `players` WHERE `job` LIKE ?', { xPlayer.PlayerData.job.name }, function(players)
                    if players[1] ~= nil then
                        for key, value in pairs(players) do
                            local isOnline = XZCore.Functions.GetPlayerByCitizenId(value.citizenid)
                        
                            if isOnline then
                                table.insert(employees, {
                                    source = isOnline.PlayerData.citizenid, 
                                    grade = isOnline.PlayerData.job.grade,
                                    isboss = isOnline.PlayerData.job.isboss,
                                    name = isOnline.PlayerData.charinfo.firstname .. ' ' .. isOnline.PlayerData.charinfo.lastname
                                })
                            else
                                table.insert(employees, {
                                    source = value.citizenid, 
                                    grade =  json.decode(value.job).grade,
                                    isboss = json.decode(value.job).isboss,
                                    name = json.decode(value.charinfo).firstname .. ' ' .. json.decode(value.charinfo).lastname
                                })
                            end
                        end

                        TriggerClientEvent('xz-bossmenu:client:refreshPage', src, 'employee', employees)
                    end
                end)
            else
                TriggerClientEvent('XZCore:Notify', src, "Error. Could not find player.", "error")
            end
        end)
    end
end)

RegisterServerEvent('xz-bossmenu:server:updateNearbys')
AddEventHandler('xz-bossmenu:server:updateNearbys', function(data)
    local src = source
    local players = {}
    local xPlayer = XZCore.Functions.GetPlayer(src)
    for _, player in pairs(data) do
        local xTarget = XZCore.Functions.GetPlayer(player)
        if xTarget and xTarget.PlayerData.job.name ~= xPlayer.PlayerData.job.name then
            table.insert(players, {
                source = xTarget.PlayerData.citizenid,
                name = xTarget.PlayerData.charinfo.firstname .. ' ' .. xTarget.PlayerData.charinfo.lastname
            })
        end
    end

    TriggerClientEvent('xz-bossmenu:client:refreshPage', src, 'recruits', players)
end)

function GetAccount(account)
    return Accounts[account] or 0
end
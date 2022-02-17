local XZCore = nil
TriggerEvent('XZCore:GetObject', function(obj) XZCore = obj end)

XZCore.Functions.CreateUseableItem("empy_contract", function(source, item)
    TriggerClientEvent("startcontract", source)
end)

XZCore.Functions.CreateUseableItem("contract", function(source, item)
    local xPlayer = XZCore.Functions.GetPlayer(source)
    if item.info then
        xPlayer.Functions.RemoveItem("contract", item.slot)
        TriggerClientEvent("contract:requestaccept", source, item.info['Amount'],item.info['Information'], item.info['Author'])
    else
        print("[Contracts] No Item Info")
    end
end)

RegisterServerEvent("contract:send")
AddEventHandler("contract:send", function(target, conamount, coninformation)
    local src = source
    local xPlayer = XZCore.Functions.GetPlayer(src)

    if conamount and type(tonumber(conamount)) == 'number' then
        xPlayer.Functions.RemoveItem("empy_contract", 1)
        xPlayer.Functions.AddItem("contract", 1, false, { ['Amount'] = conamount, ["Information"] = coninformation, ["Citizen"] = target, ["Author"] = { cid = xPlayer.PlayerData.citizenid, name = xPlayer.PlayerData.charinfo.firstname .. " " .. xPlayer.PlayerData.charinfo.lastname } })
    else
        TriggerClientEvent('XZCore:Notify', src, 'Invaild contract amount.', 'error')
    end
end)

RegisterServerEvent("contract:accept")
AddEventHandler("contract:accept", function(price,target,accepted)
    local src = source
    local xPlayer = XZCore.Functions.GetPlayer(src)

    exports.oxmysql:fetch('SELECT * FROM `players` WHERE `citizenid` = ?', { target.cid }, function(result)
        local xTarget = XZCore.Functions.GetPlayerByCitizenId(target.cid)

        if accepted then
            if xPlayer['PlayerData']['money']['cash'] >= tonumber(price) then
                if xTarget then
                    TriggerClientEvent('XZCore:Notify', xTarget['PlayerData']['source'], 'The citizen accepted your contract and paid $' .. price .. '.')
                end

                xPlayer.Functions.RemoveMoney('cash', price, 'contract:accept')

                if xTarget then
                    xTarget.Functions.AddMoney('cash',price, 'contract:accept')
                elseif result then
                    local money = json.decode(result.money)
                    money.cash = money.cash + price
                    exports.oxmysql:executeSync('UPDATE `players` SET `money` = ? WHERE `citizenid` = ?', { json.encode(money), target.cid })
                end
            else
                if xTarget then
                    TriggerClientEvent('XZCore:Notify', src, 'You dont have enough money.', 'error')
                end
            end
        else
            if xTarget then
                TriggerClientEvent('XZCore:Notify', xTarget['PlayerData']['source'], 'The citizen denied your contract.', 'error')
            end
        end
    end)
end)
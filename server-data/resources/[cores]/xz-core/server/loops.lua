PaycheckLoop = function()
    local Players = XZCore.Functions.GetPlayers()

    for i=1, #Players, 1 do
        local Player = XZCore.Functions.GetPlayer(Players[i])

        if Player.PlayerData.job ~= nil and Player.PlayerData.job.payment > 0 then
            Player.Functions.AddMoney('bank', Player.PlayerData.job.payment, 'salary-update')
            TriggerClientEvent('XZCore:Notify', Players[i], "You received your salary. [$"..Player.PlayerData.job.payment .. "]")
        end
    end
    SetTimeout(XZCore.Config.Money.PayCheckTimeOut * (60 * 1000), PaycheckLoop)
end

RegisterServerEvent('xz-radialmenu:server:RemoveBrancard', function(PlayerPos, BrancardObject)
    TriggerClientEvent('xz-radialmenu:client:RemoveBrancardFromArea', -1, PlayerPos, BrancardObject)
end)

RegisterServerEvent('xz-radialmenu:Brancard:BusyCheck', function(id, type)
    local MyId = source
    TriggerClientEvent('xz-radialmenu:Brancard:client:BusyCheck', id, MyId, type)
end)

RegisterServerEvent('xz-radialmenu:server:BusyResult', function(IsBusy, OtherId, type)
    TriggerClientEvent('xz-radialmenu:client:Result', OtherId, IsBusy, type)
end)
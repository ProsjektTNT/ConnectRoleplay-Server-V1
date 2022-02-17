local isBusy = false
local Config, PlayerData = load(LoadResourceFile(GetCurrentResourceName(), 'config.lua'))()
local SearchedDumpsters = {}

Citizen.CreateThread(function()
    exports['xz-interact']:AddTargetModel(Config.DumpsterModels, {
        options = {
            {
                event = 'xz-dumpsters:client:Dive',
                icon = Config.TargetIcon,
                label = Config.TargetLabel
            }
        },
        distance = 1.8,
    })

    exports['xz-interact']:AddTargetModel(Config.TrashCanModels, {
        options = {
            {
                event = 'xz-dumpsters:client:openTrash',
                icon = Config.TargetIcon,
                label = 'Open Trash Bin'
            }
        },
        distance = 2.0
    })
end)

RegisterNetEvent('xz-dumpsters:client:openTrash', function(data)
    local bin = {
        label = 'Trash Bin'
    }
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "trashbin_" .. data.entity, bin)
end)

RegisterNetEvent('xz-dumpsters:client:Dive', function(data)
    if isBusy then
        XZCore.Functions.Notify('You cannot perform this action now', 'error')
        CancelEvent()
    end
    local OverLimit, Returned = false, nil
    XZCore.Functions.TriggerCallback('xz-dumpsters:server:checkLimit', function(result)
        if result ~= nil and result <= 0 then
            OverLimit = true
            Returned = true
        else
            Returned = true
        end
    end)
    while Returned == nil do
        Wait(1)
    end
    if OverLimit then
        XZCore.Functions.Notify('You have reached your daily limit', 'error')
        CancelEvent()
    end
    local ped = PlayerPedId()
    isBusy = true
    XZCore.Functions.Progressbar('dive_dumpster', Config.ProgressLabel, Config.ProgressDuration, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = Config.ProgressAnimDict,
        anim = Config.ProgressAnim,
        flag = Config.ProgressAnimFlag
    }, {}, {}, function() -- Finish
        ClearPedTasks(ped)
        TriggerServerEvent('xz-dumpsters:server:onFinish', data.entity, Config.UseLootTable, Config.ItemRewardMessage, Config.LootTable, Config.FullInventoryMessage, Config.DumpsterTimeout, Config.NoLuckMessage, Config.DailyLimit, Config.DailyLimitTimeout, Config.UseMoney, Config.MoneyChance, Config.MoneyAmount)
        isBusy = false
    end, function() -- Cancel
        ClearPedTasks(ped)
        isBusy = false
    end)
end)
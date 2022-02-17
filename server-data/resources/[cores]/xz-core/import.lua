if GetCurrentResourceName() == 'xz-core' then 
    function GetSharedObject()
        return XZCore
    end

    exports('GetSharedObject', GetSharedObject)
end

XZCore = exports['xz-core']:GetSharedObject()
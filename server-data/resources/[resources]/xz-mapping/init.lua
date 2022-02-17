XZ = {};
XZ.Init = {};
XZ.IsReady = false;

RegisterNetEvent("xz:interact:init", function(identifier, ...)
    if not XZ.IsReady then
        XZ.Init[identifier] = {...};
    else
        XZ:Emit(identifier, {...});
    end
end)

function XZ:Emit(identifier, modules)
    local data = {};

    for k, v in next, modules do
        data[v] = self[v];
    end

    TriggerEvent("xz:interact:init:" .. identifier, data);
end

function XZ:Ready(identifier)
    if identifier then
        XZ:Emit(identifier, self.Init[identifier]);
    else
        for identifier in next, self.Init do
            self:Ready(identifier);
        end

        self.IsReady = true;
    end
end

function XZ:GetModule(moduleName)
    return self[moduleName];
end

exports("GetModule", _M(XZ, XZ.GetModule));

CreateThread(function()
    while true do
        Wait(100);

        if exports and exports['xz-interact'] then
            TriggerEvent("xz:interact:ready");
            return XZ:Ready();
        end
    end
end)

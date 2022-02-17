XZCore = nil
TriggerEvent('XZCore:GetObject', function(obj) XZCore = obj end)

XZCore.Functions.CreateUseableItem("tunerlaptop",function(src)
    local source = src
    TriggerClientEvent("tuning:useLaptop", src)
end)
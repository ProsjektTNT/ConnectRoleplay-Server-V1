XZCore = nil
TriggerEvent('XZCore:GetObject', function(obj) XZCore = obj end)

XZCore.Commands.Add('s0', 'Take off your Shirt', {}, false, function(source, args)
    TriggerClientEvent("clothes:shirtoff", source)
end)

XZCore.Commands.Add('s1', 'Put on your Shirt', {}, false, function(source, args)
    TriggerClientEvent("clothes:shirton", source)
end)

XZCore.Commands.Add('j0', 'Take off your Jacket', {}, false, function(source, args)
    TriggerClientEvent("clothes:jacketoff", source)
end)

XZCore.Commands.Add('j1', 'Put on your Jacket', {}, false, function(source, args)
    TriggerClientEvent("clothes:jacketon", source)
end)

XZCore.Commands.Add('j0', 'Take off your Pants', {}, false, function(source, args)
    TriggerClientEvent("clothes:pantsoff", source)
end)

XZCore.Commands.Add('j1', 'Put on your Pants', {}, false, function(source, args)
    TriggerClientEvent("clothes:pantson", source)
end)

XZCore.Commands.Add('s0', 'Take off your Shoes', {}, false, function(source, args)
    TriggerClientEvent("clothes:shoesoff", source)
end)

XZCore.Commands.Add('s1', 'Put on your Shoes', {}, false, function(source, args)
    TriggerClientEvent("clothes:shoeson", source)
end)

XZCore.Commands.Add('g0', 'Take off your Glasses', {}, false, function(source, args)
    TriggerClientEvent("clothes:glassesoff", source)
end)

XZCore.Commands.Add('g1', 'Put on your Glasses', {}, false, function(source, args)
    TriggerClientEvent("clothes:glasseson", source)
end)

XZCore.Commands.Add('n0', 'Take off your Necklece', {}, false, function(source, args)
    TriggerClientEvent("clothes:neckleceoff", source)
end)

XZCore.Commands.Add('n1', 'Put on your Necklece', {}, false, function(source, args)
    TriggerClientEvent("clothes:neckleceon", source)
end)

XZCore.Commands.Add('b0', 'Take off your Bag', {}, false, function(source, args)
    TriggerClientEvent("clothes:bagoff", source)
end)

XZCore.Commands.Add('b1', 'Put on your Bag', {}, false, function(source, args)
    TriggerClientEvent("clothes:bagon", source)
end)

XZCore.Commands.Add('v0', 'Take off your Vest', {}, false, function(source, args)
    TriggerClientEvent("clothes:vestoff", source)
end)

XZCore.Commands.Add('v1', 'Put on your Vest', {}, false, function(source, args)
    TriggerClientEvent("clothes:veston", source)
end)

XZCore.Commands.Add('m0', 'Take off your Mask', {}, false, function(source, args)
    TriggerClientEvent("clothes:maskoff", source)
end)

XZCore.Commands.Add('m1', 'Put on your Mask', {}, false, function(source, args)
    TriggerClientEvent("clothes:maskon", source)
end)

XZCore.Commands.Add('e0', 'Take off your Ear Pieces', {}, false, function(source, args)
    TriggerClientEvent("clothes:earringsoff", source)
end)

XZCore.Commands.Add('e1', 'Put on your Ear Pieces', {}, false, function(source, args)
    TriggerClientEvent("clothes:earringson", source)
end)

XZCore.Commands.Add('w0', 'Take off your Watch', {}, false, function(source, args)
    TriggerClientEvent("clothes:watchoff", source)
end)

XZCore.Commands.Add('w1', 'Put on your Watch', {}, false, function(source, args)
    TriggerClientEvent("clothes:watchon", source)
end)

XZCore.Commands.Add('h0', 'Take off your Hat', {}, false, function(source, args)
    TriggerClientEvent("clothes:hatoff", source)
end)

XZCore.Commands.Add('h1', 'Put on your Hat', {}, false, function(source, args)
    TriggerClientEvent("clothes:haton", source)
end)

XZCore.Commands.Add('Restore', 'Restore your clothing', {}, false, function(source, args)
    TriggerClientEvent("clothes:restore", source)
end)
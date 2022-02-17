XZCore = {}
XZCore.Config = XZConfig
XZCore.Shared = XZShared
XZCore.ServerCallbacks = {}
XZCore.UseableItems = {}

function GetCoreObject()
	return XZCore
end

RegisterServerEvent('XZCore:GetObject', function(cb)
	cb(GetCoreObject())
end)
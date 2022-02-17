XZCore = {}
XZCore.PlayerData = {}
XZCore.Config = XZConfig
XZCore.Shared = XZShared
XZCore.ServerCallbacks = {}

isLoggedIn = false

function GetCoreObject()
	return XZCore
end

RegisterNetEvent('XZCore:GetObject')
AddEventHandler('XZCore:GetObject', function(cb)
	cb(GetCoreObject())
end)

RegisterNetEvent('XZCore:Client:OnPlayerLoaded')
AddEventHandler('XZCore:Client:OnPlayerLoaded', function()
	ShutdownLoadingScreenNui()
	isLoggedIn = true
    SetCanAttackFriendly(PlayerPedId(), true, false)
    NetworkSetFriendlyFireOption(true)
end)

RegisterNetEvent('XZCore:Client:OnPlayerUnload')
AddEventHandler('XZCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

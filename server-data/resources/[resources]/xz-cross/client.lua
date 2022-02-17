local crossEnabled = false
local crossDisabled = false

RegisterCommand("crosshair", function()
    crossDisabled = not crossDisabled
end)

CreateThread(function()
    while true do
        Wait(250)
        if not crossDisabled and not crossEnabled and IsPedArmed(PlayerPedId(), 7) then
            crossEnabled = true
            SendNUIMessage("Show")
        elseif not IsPedArmed(PlayerPedId(), 7) and crossEnabled then
            crossEnabled = false
            SendNUIMessage("shit")
        end
    end
end)

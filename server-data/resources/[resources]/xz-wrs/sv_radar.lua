XZCore = nil
TriggerEvent('XZCore:GetObject', function(obj) XZCore = obj end)

RegisterNetEvent("platecheck:checkLicensePlate")
AddEventHandler("platecheck:checkLicensePlate", function(plate, model)
    local src = source

    if not plate or plate == "No Lock" then
        return
    end


    exports.oxmysql:scalar('SELECT citizenid FROM `xzvehicles` WHERE `plate` = ?', { plate }, function(result)
        local owner = "Unknown"
        if (result) then
            owner = result
        end

        TriggerClientEvent('chat:addMessage', src, {
            template = '<div class="chat-message server"><strong>Vehicle Scanner:</strong> <br>Plate: ' .. plate .. '<br>Model: ' .. model .. '<br>Owner CID: ' .. owner .. '</div>',
            args = {}
        })
    end)
end)
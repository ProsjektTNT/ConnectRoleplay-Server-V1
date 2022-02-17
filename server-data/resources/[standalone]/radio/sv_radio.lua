XZCore = nil
SavedRadio = {}

TriggerEvent('XZCore:GetObject', function(obj) XZCore = obj end)

XZCore.Functions.CreateUseableItem("radio", function(source, item)
	local Player = XZCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName(item.name) ~= nil then
		TriggerClientEvent("radioGui", source)
	end
end)

XZCore.Functions.CreateCallback('radio:server:GetItem', function(source, cb, item)
  local src = source
  local Player = XZCore.Functions.GetPlayer(src)
  if Player ~= nil then 
    local RadioItem = Player.Functions.GetItemByName(item)
    if RadioItem ~= nil then
      cb(true)
    else
      cb(false)
    end
  else
    cb(false)
  end
end)

RegisterServerEvent("XZCore:Player:OnRemovedItem")
AddEventHandler("XZCore:Player:OnRemovedItem", function(source, item)
    if item.name == 'radio' and GetItem(source, item.name).count < 1 then
      TriggerEvent("TokoVoip:removePlayerFromAllRadio", source)
    end
end)

function GetItem(source, item)
	local xPlayer = XZCore.Functions.GetPlayer(source)
	local count = 0

	for k,v in pairs(xPlayer['PlayerData']['items']) do
		if v.name == item then
			count = count + v.amount
		end
	end
	
	return { name = item, count = count }
end
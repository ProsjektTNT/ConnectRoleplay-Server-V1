RegisterServerEvent('badge:open', function(ID, targetID, type)
	local Player = XZCore.Functions.GetPlayer(ID)


	local data = {
		name = Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname,
		dob = Player.PlayerData.charinfo.dob,
		callsign = Player.PlayerData.metadata.callsign
	}

	TriggerClientEvent('badge:open', targetID, data)
	TriggerClientEvent('badge:shot', targetID, source )
end)

XZCore.Functions.CreateUseableItem('pdbadge', function(source, item)
  local Player = XZCore.Functions.GetPlayer(source)
  if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
    TriggerClientEvent('badge:openPD', source, true)
  else
	TriggerClientEvent('XZCore:Notify', source,"You are not a police!", "error")
  end
end)
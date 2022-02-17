local itemInfos = {}

function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local maxDistance = 1.25

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local pos, awayFromObject = GetEntityCoords(PlayerPedId()), true
		local craftObject = GetClosestObjectOfType(pos, 2.0, -573669520, false, false, false)
		if craftObject ~= 0 then
			local objectPos = GetEntityCoords(craftObject)
			if #(pos - objectPos) < 1.5 then
				awayFromObject = false
				DrawText3D(objectPos.x, objectPos.y, objectPos.z + 1.0, "~g~E~w~ - Craft")
				if IsControlJustReleased(0, 38) then
					local crafting = {}
					Config.label = "Crafting"
					Config.items = GetThresholdItems()
					TriggerServerEvent("inventory:server:OpenInventory", "crafting", math.random(1, 99), crafting)
				end
			end
		end

		if awayFromObject then
			Citizen.Wait(1000)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		local pos = GetEntityCoords(PlayerPedId())
		local inRange = false
		local distance = #(pos - vector3(Config.AttachmentCrafting["location"].x, Config.AttachmentCrafting["location"].y, Config.AttachmentCrafting["location"].z))

		if distance < 10 then
			inRange = true
			if distance < 1.5 then
				DrawText3D(Config.AttachmentCrafting["location"].x, Config.AttachmentCrafting["location"].y, Config.AttachmentCrafting["location"].z, "~g~E~w~ - Craft")
				if IsControlJustPressed(0, 38) then
					local crafting = {}
					Config.label = "Attachment Crafting"
					Config.items = GetAttachmentThresholdItems()
					TriggerServerEvent("inventory:server:OpenInventory", "attachment_crafting", math.random(1, 99), crafting)
				end
			end
		end

		if not inRange then
			Citizen.Wait(1000)
		end

		Citizen.Wait(3)
	end
end)

function GetThresholdItems()
	ItemsToItemInfo()
	local items = {}
	for k, item in pairs(Config.CraftingItems) do
		if XZCore.Functions.GetPlayerData().metadata["craftingrep"] >= Config.CraftingItems[k].threshold then
			items[k] = Config.CraftingItems[k]
		end
	end
	return items
end


function SetupAttachmentItemsInfo()
	itemInfos = {
		[1] = {costs = XZCore.Shared.Items["metalscrap"]["label"] .. ": 30x, " .. XZCore.Shared.Items["steel"]["label"] .. ": 30x, " .. XZCore.Shared.Items["rubber"]["label"] .. ": 30x"},
		[2] = {costs = XZCore.Shared.Items["metalscrap"]["label"] .. ": 30x, " .. XZCore.Shared.Items["steel"]["label"] .. ": 30x, " .. XZCore.Shared.Items["rubber"]["label"] .. ": 30x"},
		[3] = {costs = XZCore.Shared.Items["metalscrap"]["label"] .. ": 50x, " .. XZCore.Shared.Items["steel"]["label"] .. ": 50x, " .. XZCore.Shared.Items["rubber"]["label"] .. ": 50x, " .. XZCore.Shared.Items["rifle_extendedclip"]["label"] .. ": 1x"},
		[4] = {costs = XZCore.Shared.Items["metalscrap"]["label"] .. ": 50x, " .. XZCore.Shared.Items["steel"]["label"] .. ": 50x, " .. XZCore.Shared.Items["rubber"]["label"] .. ": 50x, " .. XZCore.Shared.Items["smg_extendedclip"]["label"] .. ": 1x"},
		[5] = {costs = XZCore.Shared.Items["metalscrap"]["label"] .. ": 40x, " .. XZCore.Shared.Items["steel"]["label"] .. ": 40x, " .. XZCore.Shared.Items["rubber"]["label"] .. ": 40x"},
		[6] = {costs = XZCore.Shared.Items["metalscrap"]["label"] .. ": 40x, " .. XZCore.Shared.Items["steel"]["label"] .. ": 40x, " .. XZCore.Shared.Items["rubber"]["label"] .. ": 40x"},
		[7] = {costs = XZCore.Shared.Items["metalscrap"]["label"] .. ": 40x, " .. XZCore.Shared.Items["steel"]["label"] .. ": 40x, " .. XZCore.Shared.Items["rubber"]["label"] .. ": 40x"},
		[8] = {costs = XZCore.Shared.Items["metalscrap"]["label"] .. ": 40x, " .. XZCore.Shared.Items["steel"]["label"] .. ": 40x, " .. XZCore.Shared.Items["rubber"]["label"] .. ": 40x"},
	}

	local items = {}
	for k, item in pairs(Config.AttachmentCrafting["items"]) do
		local itemInfo = XZCore.Shared.Items[item.name:lower()]
		items[item.slot] = {
			name = itemInfo["name"],
			amount = tonumber(item.amount),
			info = itemInfos[item.slot],
			label = itemInfo["label"],
			description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
			weight = itemInfo["weight"], 
			type = itemInfo["type"], 
			unique = itemInfo["unique"], 
			useable = itemInfo["useable"], 
			image = itemInfo["image"],
			slot = item.slot,
			costs = item.costs,
			threshold = item.threshold,
			points = item.points,
		}
	end
	Config.AttachmentCrafting["items"] = items
end

function GetAttachmentThresholdItems()
	SetupAttachmentItemsInfo()
	local items = {}
	for k, item in pairs(Config.AttachmentCrafting["items"]) do
		if XZCore.Functions.GetPlayerData().metadata["attachmentcraftingrep"] >= Config.AttachmentCrafting["items"][k].threshold then
			items[k] = Config.AttachmentCrafting["items"][k]
		end
	end
	return items
end

function ItemsToItemInfo()
	itemInfos = {
		[1] = {costs = XZCore.Shared.Items["metalscrap"]["label"] .. ": 50x, " ..XZCore.Shared.Items["plastic"]["label"] .. ": 40x."},
		[2] = {costs = XZCore.Shared.Items["metalscrap"]["label"] .. ": 90x, " ..XZCore.Shared.Items["plastic"]["label"] .. ": 70x."},
		[3] = {costs = XZCore.Shared.Items["metalscrap"]["label"] .. ": 140x, " ..XZCore.Shared.Items["plastic"]["label"] .. ": 140x, "..XZCore.Shared.Items["aluminum"]["label"] .. ": 140x."},
		[4] = {costs = XZCore.Shared.Items["electronickit"]["label"] .. ": 1x, " ..XZCore.Shared.Items["plastic"]["label"] .. ": 50x, "..XZCore.Shared.Items["steel"]["label"] .. ": 50x."},
		[5] = {costs = XZCore.Shared.Items["metalscrap"]["label"] .. ": 75x, " ..XZCore.Shared.Items["plastic"]["label"] .. ": 100x, "..XZCore.Shared.Items["aluminum"]["label"] .. ": 120x, "..XZCore.Shared.Items["iron"]["label"] .. ": 50x, "..XZCore.Shared.Items["electronickit"]["label"] .. ": 2x."},
		[6] = {costs = XZCore.Shared.Items["steel"]["label"] .. ": 50x, "..XZCore.Shared.Items["aluminum"]["label"] .. ": 30x."},
		[7] = {costs = XZCore.Shared.Items["iron"]["label"] .. ": 200x, " ..XZCore.Shared.Items["steel"]["label"] .. ": 200x, "..XZCore.Shared.Items["screwdriverset"]["label"] .. ": 2x, " ..XZCore.Shared.Items["advancedlockpick"]["label"] .. ": 2x."},
		[8] = {costs = XZCore.Shared.Items["iron"]["label"] .. ": 50x, " ..XZCore.Shared.Items["steel"]["label"] .. ": 10x, "..XZCore.Shared.Items["lockpick"]["label"] .. ": 1x, " ..XZCore.Shared.Items["glass"]["label"] .. ": 150x."},
		[9] = {costs = XZCore.Shared.Items["glass"]["label"] .. ": 50x, " ..XZCore.Shared.Items["steel"]["label"] .. ": 125x, "..XZCore.Shared.Items["copper"]["label"] .. ": 125x."},
		[10] = {costs = XZCore.Shared.Items["glass"]["label"] .. ": 35x, " ..XZCore.Shared.Items["steel"]["label"] .. ": 65x, "..XZCore.Shared.Items["copper"]["label"] .. ": 95x."},
		[11] = {costs = XZCore.Shared.Items["aluminum"]["label"] .. ": 25x, " ..XZCore.Shared.Items["metalscrap"]["label"] .. ": 25x, "..XZCore.Shared.Items["steel"]["label"] .. ": 15x."},
	}

	local items = {}
	for k, item in pairs(Config.CraftingItems) do
		local itemInfo = XZCore.Shared.Items[item.name:lower()]
		items[item.slot] = {
			name = itemInfo["name"],
			amount = tonumber(item.amount),
			info = itemInfos[item.slot],
			label = itemInfo["label"],
			description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
			weight = itemInfo["weight"], 
			type = itemInfo["type"], 
			unique = itemInfo["unique"], 
			useable = itemInfo["useable"], 
			image = itemInfo["image"],
			slot = item.slot,
			costs = item.costs,
			threshold = item.threshold,
			points = item.points,
		}
	end
	Config.CraftingItems = items
end
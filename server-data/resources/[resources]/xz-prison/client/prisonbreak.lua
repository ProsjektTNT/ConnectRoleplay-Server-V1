prisonBreak = false
currentGate = 0

local requiredItemsShowed = false
local requiredItems = {}
local inRange = false
local securityLockdown = false

local Gates = {
    [1] = {
        gatekey = 38,
        coords = {x = 1845.99, y = 2604.7, z = 45.58, h = 94.5},  
        hit = false,
    },
    [2] = {
        gatekey = 39,
        coords = {x = 1819.47, y = 2604.67, z = 45.56, h = 98.5},
        hit = false,
    },
    [3] = {
        gatekey = 40,
        coords = {x = 1804.74, y = 2616.311, z = 45.61, h = 335.5},
        hit = false,
    }
}

Citizen.CreateThread(function()
    Citizen.Wait(500)
    requiredItems = {
        [1] = {name = XZCore.Shared.Items["electronickit"]["name"], image = XZCore.Shared.Items["electronickit"]["image"]},
        [2] = {name = XZCore.Shared.Items["gatecrack"]["name"], image = XZCore.Shared.Items["gatecrack"]["image"]},
    }
    while true do 
        Citizen.Wait(5)
        inRange = false
        currentGate = 0
        if isLoggedIn and XZCore ~= nil then
            if PlayerJob.name ~= "police" then
                local pos = GetEntityCoords(PlayerPedId())
                for k, v in pairs(Gates) do
                    local dist = GetDistanceBetweenCoords(pos, Gates[k].coords.x, Gates[k].coords.y, Gates[k].coords.z, true)
                    if (dist < 1.5) then
                        currentGate = k
                        inRange = true
                        if securityLockdown then
                            XZCore.Functions.DrawText3D(Gates[k].coords.x, Gates[k].coords.y, Gates[k].coords.z, "~r~SYSTEM LOCKDOWN")
                        elseif Gates[k].hit then
                            XZCore.Functions.DrawText3D(Gates[k].coords.x, Gates[k].coords.y, Gates[k].coords.z, "SYSTEM BREACH")
                        elseif not requiredItemsShowed then
                            requiredItemsShowed = true
                            TriggerEvent('inventory:client:requiredItems', requiredItems, true)
                        end
                    end
                end

                if not inRange then
                    if requiredItemsShowed then
                        requiredItemsShowed = false
                        TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                    end
                    Citizen.Wait(1000)
                end
            else
                Citizen.Wait(1000)
            end
        else
            Citizen.Wait(5000)
        end
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(7)
		local pos = GetEntityCoords(PlayerPedId(), true)
		if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["middle"].coords.x, Config.Locations["middle"].coords.y, Config.Locations["middle"].coords.z, false) > 200.0 and inJail) then
			inJail = false
            jailTime = 0
            RemoveBlip(currentBlip)
            RemoveBlip(CellsBlip)
            CellsBlip = nil
            RemoveBlip(TimeBlip)
            TimeBlip = nil
            RemoveBlip(ShopBlip)
            ShopBlip = nil
            TriggerServerEvent("prison:server:SecurityLockdown")
            XZCore.Functions.Notify("You escaped, you better run quick from here...", "error")
		end
	end
end)

RegisterNetEvent('electronickit:UseElectronickit')
AddEventHandler('electronickit:UseElectronickit', function()
    if currentGate ~= 0 and not securityLockdown and not Gates[currentGate].hit then 
        XZCore.Functions.TriggerCallback('XZCore:HasItem', function(result)
            if result then 
                TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                XZCore.Functions.Progressbar("hack_gate", "Connecting Electronic Kit..", math.random(5000, 10000), false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    animDict = "anim@gangops@facility@servers@",
                    anim = "hotwire",
                    flags = 16,
                }, {}, {}, function() -- Done
                    StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
                    TriggerEvent("mhacking:show")
                    TriggerEvent("mhacking:start", math.random(5, 9), math.random(10, 15), OnHackDone)
                end, function() -- Cancel
                    StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
                    XZCore.Functions.Notify("Canceled..", "error")
                end)
            else
                XZCore.Functions.Notify("You are missing an item..", "error")
            end
        end, "gatecrack")
    end
end)

RegisterNetEvent('prison:client:SetLockDown')
AddEventHandler('prison:client:SetLockDown', function(isLockdown)
    securityLockdown = isLockdown
    if securityLockDown and inJail then
        XZCore.Functions.Notify("Highest security level set to active, stick to the cells blocks", 10000)
    end
end)

RegisterNetEvent('prison:client:SetGateHit')
AddEventHandler('prison:client:SetGateHit', function(key, isHit)
    Gates[key].hit = isHit
end)

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

Citizen.CreateThread(function()
	while true do

		local found = false
		local ped = PlayerPedId()
		Citizen.Wait(1)
		local dstscan = 3.0
		local pos = GetEntityCoords(PlayerPedId(), false)

    	if(Vdist(1775.87, 2593.74, 45.72, pos.x, pos.y, pos.z) < 10.0)then
			found = true
			if(Vdist(1775.87, 2593.74, 45.72, pos.x, pos.y, pos.z) < 2.0)then
				DisplayHelpText("Press ~INPUT_CONTEXT~ what dis?")
				if IsControlJustPressed(1, 38) and (Vdist(1775.87, 2593.74, 45.72, pos.x, pos.y, pos.z) < 2.0) then
					Progressbar(60000,"Making a god slushy...")
                            TriggerServerEvent("inventory:server:OpenInventory", "shop", "jail_slushy" , {
                                ['label'] = "Jail",
                                ['items'] = {
                                    [1] = {
                                        name = "slushy",
                                        price = 0,
                                        amount = 1,
                                        info = {},
                                        type = "item",
                                        slot = 1,
                                    },
                                }
                            })
							Wait(1000)
					end
			    end
            end 
			
    	if(Vdist(1774.94, 2590.31, 45.72, pos.x, pos.y, pos.z) < 10.0)then
			found = true
			if(Vdist(1774.94, 2590.31, 45.72, pos.x, pos.y, pos.z) < 2.0)then
				DisplayHelpText("Press ~INPUT_CONTEXT~ what dis?")
				if IsControlJustPressed(1, 38) and (Vdist(1774.94, 2590.31, 45.72, pos.x, pos.y, pos.z) < 2.0) then
						Progressbar(60000,"Searching...")
						local chance = math.random(1,100)
						if chance > 80 then
                            TriggerServerEvent("inventory:server:OpenInventory", "shop", "jail_assphone" , {
                                ['label'] = "Jail",
                                ['items'] = {
                                    [1] = {
                                        name = "assphone",
                                        price = 0,
                                        amount = 1,
                                        info = {},
                                        type = "item",
                                        slot = 1,
                                    },
                                }
                            })
							Wait(1000)
						end
					end
			    end
			end 

        if(Vdist(1652.186, 2564.3872, 45.564895, pos.x, pos.y, pos.z) < 10.0)then
			found = true
			if(Vdist(1652.186, 2564.3872, 45.564895, pos.x, pos.y, pos.z) < 2.0)then
				DisplayHelpText("Press ~INPUT_CONTEXT~ what dis?")
                if IsControlJustPressed(1, 38) and (Vdist(1652.186, 2564.3872, 45.564895, pos.x, pos.y, pos.z) < 2.0) then
                    if HasItem('assphone') then
						Progressbar(30000,"Attempting to fix phone")
						local chance = math.random(1,100)
						if chance > 70 and HasItem('assphone') then
                            TriggerServerEvent('XZCore:Server:RemoveItem', 'assphone', 1)
                            TriggerEvent('inventory:client:ItemBox', XZCore.Shared.Items["assphone"], "remove")
                            TriggerServerEvent("inventory:server:OpenInventory", "shop", "jail_phone" , {
                                ['label'] = "Phone",
                                ['items'] = {
                                    [1] = {
                                        name = "phone",
                                        price = 0,
                                        amount = 1,
                                        info = {},
                                        type = "item",
                                        slot = 1,
                                    },
                                }
                            })
                            Wait(1000)
                        end
                    else
                        XZCore.Functions.Notify("You are missing something...", "error")
                        Wait(500)
                    end
				end
			end
        end 
			
    	if(Vdist(1720.37, 2566.82, 45.56, pos.x, pos.y, pos.z) < 10.0)then
			found = true
			if(Vdist(1720.37, 2566.82, 45.56, pos.x, pos.y, pos.z) < 2.0)then
				DisplayHelpText("Press ~INPUT_CONTEXT~ what dis?")
				if IsControlJustPressed(1, 38) and (Vdist(1720.37, 2566.82, 45.56, pos.x, pos.y, pos.z) < 2.0) then
						Progressbar(60000,"Searching...")
						local chance = math.random(1,100)
						if chance > 80 then
                            TriggerServerEvent("inventory:server:OpenInventory", "shop", "jail_methbag" , {
                                ['label'] = "Jail",
                                ['items'] = {
                                    [1] = {
                                        name = "methbag",
                                        price = 500,
                                        amount = 1,
                                        info = {},
                                        type = "item",
                                        slot = 1,
                                    },
                                }
                            })
							Wait(1000)
						end
					end
			    end
            end 
			
    	if(Vdist(1689.33, 2552.25, 45.56, pos.x, pos.y, pos.z) < 10.0)then
			found = true
			if(Vdist(1689.33, 2552.25, 45.56, pos.x, pos.y, pos.z) < 2.0)then
				DisplayHelpText("Press ~INPUT_CONTEXT~ what dis?")
				if IsControlJustPressed(1, 38) and (Vdist(1689.33, 2552.25, 45.56, pos.x, pos.y, pos.z) < 2.0) then
						Progressbar(60000,"Searching...")
						local chance = math.random(1,100)
						if chance > 80 then
                            TriggerServerEvent("inventory:server:OpenInventory", "shop", "jail_shitlockpick" , {
                                ['label'] = "Jail",
                                ['items'] = {
                                    [1] = {
                                        name = "shitlockpick",
                                        price = 500,
                                        amount = 1,
                                        info = {},
                                        type = "item",
                                        slot = 1,
                                    },
                                }
                            })
							Wait(1000)
						end
					end
			    end
            end

		if not found and dstscan > 2.5 then
			Wait(1200)
		end
	end
end)
                   
function Progressbar(duration, label)
	local retval = nil
	XZCore.Functions.Progressbar("jail", label, duration, false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {}, {}, {}, function()
		retval = true
	end, function()
		retval = false
	end)

	while retval == nil do
		Wait(1)
	end

	return retval
end

function OnHackDone(success, timeremaining)
    if success then
        TriggerServerEvent("prison:server:SetGateHit", currentGate)
		TriggerServerEvent('xz-doorlock:server:updateState', Gates[currentGate].gatekey, false)
		TriggerEvent('mhacking:hide')
    else
        TriggerServerEvent("prison:server:SecurityLockdown")
		TriggerEvent('mhacking:hide')
	end
end

function HasItem(item)
    local retval = nil
    XZCore.Functions.TriggerCallback("XZCore:HasItem", function(data)
        retval = data
    end, item)

    while retval == nil do
        Wait(1)
    end

    return retval
end
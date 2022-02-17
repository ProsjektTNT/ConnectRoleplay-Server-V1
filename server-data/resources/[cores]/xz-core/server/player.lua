XZCore.Players = {}
XZCore.Player = {}

XZCore.Player.Login = function(source, citizenid, newData)
	if source ~= nil then
		if citizenid then
			local result = exports.oxmysql:fetchSync('SELECT * FROM players WHERE citizenid=@citizenid', {['@citizenid'] = citizenid})
			local PlayerData = result[1]
			if PlayerData ~= nil then
				PlayerData.money = json.decode(PlayerData.money)
				PlayerData.job = json.decode(PlayerData.job)
				PlayerData.position = json.decode(PlayerData.position)
				PlayerData.metadata = json.decode(PlayerData.metadata)
				PlayerData.charinfo = json.decode(PlayerData.charinfo)
				if PlayerData.gang ~= nil then
					PlayerData.gang = json.decode(PlayerData.gang)
				else
					PlayerData.gang = {}
				end
			end
			XZCore.Player.CheckPlayerData(source, PlayerData)
		else
			XZCore.Player.CheckPlayerData(source, newData)
		end
		return true
	else
		XZCore.ShowError(GetCurrentResourceName(), "ERROR XZCore.PLAYER.LOGIN - NO SOURCE GIVEN!")
		return false
	end
end

local prefixs = {
	"213",
	"310",
	"661",
	"424",
	"323",
	"818"
}

XZCore.Player.CheckPlayerData = function(source, PlayerData)
	PlayerData = PlayerData ~= nil and PlayerData or {}

	PlayerData.source = source
	PlayerData.citizenid = PlayerData.citizenid ~= nil and PlayerData.citizenid or XZCore.Player.CreateCitizenId()
	PlayerData.license = PlayerData.license ~= nil and PlayerData.license or XZCore.Functions.GetIdentifier(source, 'license')
	PlayerData.discord = PlayerData.discord ~= nil and PlayerData.discord or XZCore.Functions.GetIdentifier(source, 'discord')
	PlayerData.name = GetPlayerName(source)
	PlayerData.cid = PlayerData.cid ~= nil and PlayerData.cid or 1

	PlayerData.money = PlayerData.money ~= nil and PlayerData.money or {}
	for moneytype, startamount in pairs(XZCore.Config.Money.MoneyTypes) do
		PlayerData.money[moneytype] = PlayerData.money[moneytype] ~= nil and PlayerData.money[moneytype] or startamount
	end

	PlayerData.charinfo = PlayerData.charinfo ~= nil and PlayerData.charinfo or {}
	PlayerData.charinfo.firstname = PlayerData.charinfo.firstname ~= nil and PlayerData.charinfo.firstname or "Firstname"
	PlayerData.charinfo.lastname = PlayerData.charinfo.lastname ~= nil and PlayerData.charinfo.lastname or "Lastname"
	PlayerData.charinfo.birthdate = PlayerData.charinfo.birthdate ~= nil and PlayerData.charinfo.birthdate or "00-00-0000"
	PlayerData.charinfo.gender = PlayerData.charinfo.gender ~= nil and PlayerData.charinfo.gender or 0
	PlayerData.charinfo.nationality = PlayerData.charinfo.nationality ~= nil and PlayerData.charinfo.nationality or "Los Santos"
	PlayerData.charinfo.phone = PlayerData.charinfo.phone ~= nil and PlayerData.charinfo.phone or prefixs[math.random(1, #prefixs)] .. math.random(1111111, 9999999)
	PlayerData.charinfo.account = PlayerData.charinfo.account ~= nil and PlayerData.charinfo.account or "US0"..math.random(1,9).."XZ"..math.random(1111,9999)..math.random(1111,9999)..math.random(11,99)
	
	PlayerData.metadata = PlayerData.metadata ~= nil and PlayerData.metadata or {}
	PlayerData.metadata["hunger"] = PlayerData.metadata["hunger"] ~= nil and PlayerData.metadata["hunger"] or 100
	PlayerData.metadata["thirst"] = PlayerData.metadata["thirst"] ~= nil and PlayerData.metadata["thirst"] or 100
	PlayerData.metadata["stress"] = PlayerData.metadata["stress"] ~= nil and PlayerData.metadata["stress"] or 0
	PlayerData.metadata["isdead"] = PlayerData.metadata["isdead"] ~= nil and PlayerData.metadata["isdead"] or false
	PlayerData.metadata["inlaststand"] = PlayerData.metadata["inlaststand"] ~= nil and PlayerData.metadata["inlaststand"] or false
	PlayerData.metadata["armor"]  = PlayerData.metadata["armor"]  ~= nil and PlayerData.metadata["armor"] or 0
	PlayerData.metadata["ishandcuffed"] = PlayerData.metadata["ishandcuffed"] ~= nil and PlayerData.metadata["ishandcuffed"] or false	
	PlayerData.metadata["tracker"] = PlayerData.metadata["tracker"] ~= nil and PlayerData.metadata["tracker"] or false
	PlayerData.metadata["injail"] = PlayerData.metadata["injail"] ~= nil and PlayerData.metadata["injail"] or 0
	PlayerData.metadata["jailitems"] = PlayerData.metadata["jailitems"] ~= nil and PlayerData.metadata["jailitems"] or {}
	PlayerData.metadata["status"] = PlayerData.metadata["status"] ~= nil and PlayerData.metadata["status"] or {}
	PlayerData.metadata["phone"] = PlayerData.metadata["phone"] ~= nil and PlayerData.metadata["phone"] or {}
	PlayerData.metadata["fitbit"] = PlayerData.metadata["fitbit"] ~= nil and PlayerData.metadata["fitbit"] or {}
	PlayerData.metadata["commandbinds"] = PlayerData.metadata["commandbinds"] ~= nil and PlayerData.metadata["commandbinds"] or {}
	PlayerData.metadata["bloodtype"] = PlayerData.metadata["bloodtype"] ~= nil and PlayerData.metadata["bloodtype"] or XZCore.Config.Player.Bloodtypes[math.random(1, #XZCore.Config.Player.Bloodtypes)]
	PlayerData.metadata["dealerrep"] = PlayerData.metadata["dealerrep"] ~= nil and PlayerData.metadata["dealerrep"] or 0
	PlayerData.metadata["craftingrep"] = PlayerData.metadata["craftingrep"] ~= nil and PlayerData.metadata["craftingrep"] or 0
	PlayerData.metadata["attachmentcraftingrep"] = PlayerData.metadata["attachmentcraftingrep"] ~= nil and PlayerData.metadata["attachmentcraftingrep"] or 0
	PlayerData.metadata["currentapartment"] = PlayerData.metadata["currentapartment"] ~= nil and PlayerData.metadata["currentapartment"] or nil
	PlayerData.metadata["jobrep"] = PlayerData.metadata["jobrep"] ~= nil and PlayerData.metadata["jobrep"] or {
		["tow"] = 0,
		["trucker"] = 0,
		["taxi"] = 0,
		["hotdog"] = 0,
	}
	PlayerData.metadata["callsign"] = PlayerData.metadata["callsign"] ~= nil and PlayerData.metadata["callsign"] or "NO TAG"
	PlayerData.metadata["fingerprint"] = PlayerData.metadata["fingerprint"] ~= nil and PlayerData.metadata["fingerprint"] or XZCore.Player.CreateFingerId()
	PlayerData.metadata["walletid"] = PlayerData.metadata["walletid"] ~= nil and PlayerData.metadata["walletid"] or XZCore.Player.CreateWalletId()
	PlayerData.metadata["criminalrecord"] = PlayerData.metadata["criminalrecord"] ~= nil and PlayerData.metadata["criminalrecord"] or {
		["hasRecord"] = false,
		["date"] = nil
	}	
	PlayerData.metadata["licences"] = PlayerData.metadata["licences"] ~= nil and PlayerData.metadata["licences"] or {
		["driver"] = true,
		["business"] = false,
		["weapon"] = false
	}	
	PlayerData.metadata["inside"] = PlayerData.metadata["inside"] ~= nil and PlayerData.metadata["inside"] or {
		house = nil,
		apartment = {
			apartmentType = nil,
			apartmentId = nil,
		}
	}
	PlayerData.metadata["phonedata"] = PlayerData.metadata["phonedata"] ~= nil and PlayerData.metadata["phonedata"] or {
        SerialNumber = XZCore.Player.CreateSerialNumber(),
        InstalledApps = {},
    }

	PlayerData.job = PlayerData.job ~= nil and PlayerData.job or {}
	PlayerData.job.name = PlayerData.job.name ~= nil and PlayerData.job.name or "unemployed"
	PlayerData.job.label = PlayerData.job.label ~= nil and PlayerData.job.label or "Civilian"
	PlayerData.job.payment = PlayerData.job.payment ~= nil and PlayerData.job.payment or 10
	PlayerData.job.onduty = PlayerData.job.onduty ~= nil and PlayerData.job.onduty or true 
	-- Added for grade system
	PlayerData.job.isboss = PlayerData.job.isboss ~= nil and PlayerData.job.isboss or false
	PlayerData.job.grade = PlayerData.job.grade ~= nil and PlayerData.job.grade or {}
	PlayerData.job.grade.name = PlayerData.job.grade.name ~= nil and PlayerData.job.grade.name or "Freelancer"
	PlayerData.job.grade.level = PlayerData.job.grade.level ~= nil and PlayerData.job.grade.level or 0

	PlayerData.gang = PlayerData.gang ~= nil and PlayerData.gang or {}
	PlayerData.gang.name = PlayerData.gang.name ~= nil and PlayerData.gang.name or "none"
	PlayerData.gang.label = PlayerData.gang.label ~= nil and PlayerData.gang.label or "No Gang Affiliaton"
	-- Added for grade system
	PlayerData.gang.isboss = PlayerData.gang.isboss ~= nil and PlayerData.gang.isboss or false
	PlayerData.gang.grade = PlayerData.gang.grade ~= nil and PlayerData.gang.grade or {}
	PlayerData.gang.grade.name = PlayerData.gang.grade.name ~= nil and PlayerData.gang.grade.name or "none"
	PlayerData.gang.grade.level = PlayerData.gang.grade.level ~= nil and PlayerData.gang.grade.level or 0

	PlayerData.position = PlayerData.position ~= nil and PlayerData.position or XZConfig.DefaultSpawn
	PlayerData.LoggedIn = true

	PlayerData = XZCore.Player.LoadInventory(PlayerData)
	XZCore.Player.CreatePlayer(PlayerData)
end

XZCore.Player.CreatePlayer = function(PlayerData)
	local self = {}
	self.Functions = {}
	self.PlayerData = PlayerData

	self.Functions.UpdatePlayerData = function(dontUpdateChat)
		TriggerClientEvent("XZCore:Player:SetPlayerData", self.PlayerData.source, self.PlayerData)
		if dontUpdateChat == nil then
			XZCore.Commands.Refresh(self.PlayerData.source)
		end
	end

	self.Functions.SetJob = function(job, grade)
		local job = job:lower()
		local grade = tostring(grade) ~= nil and tostring(grade) or '0'

		if XZCore.Shared.Jobs[job] ~= nil then
			self.PlayerData.job.name = job
			self.PlayerData.job.label = XZCore.Shared.Jobs[job].label
			self.PlayerData.job.onduty = XZCore.Shared.Jobs[job].defaultDuty
			
			if XZCore.Shared.Jobs[job].grades[grade] then
				local jobgrade = XZCore.Shared.Jobs[job].grades[grade]
				self.PlayerData.job.grade = {}
				self.PlayerData.job.grade.name = jobgrade.name
				self.PlayerData.job.grade.level = tonumber(grade)
				self.PlayerData.job.payment = jobgrade.payment ~= nil and jobgrade.payment or 30
				self.PlayerData.job.isboss = jobgrade.isboss ~= nil and jobgrade.isboss or false
			else
				self.PlayerData.job.grade = {}
				self.PlayerData.job.grade.name = 'No Grades'
				self.PlayerData.job.grade.level = 0
				self.PlayerData.job.payment = 30
				self.PlayerData.job.isboss = false
			end

			self.Functions.UpdatePlayerData()
			TriggerClientEvent("XZCore:Client:OnJobUpdate", self.PlayerData.source, self.PlayerData.job)
			return true
		end

		return false
	end

	self.Functions.SetGang = function(gang, grade)
		local gang = gang:lower()
		local grade = tostring(grade) ~= nil and tostring(grade) or '0'

		if XZCore.Shared.Gangs[gang] ~= nil then
			self.PlayerData.gang.name = gang
			self.PlayerData.gang.label = XZCore.Shared.Gangs[gang].label
			if XZCore.Shared.Gangs[gang].grades[grade] then
				local ganggrade = XZCore.Shared.Gangs[gang].grades[grade]
				self.PlayerData.gang.grade = {}
				self.PlayerData.gang.grade.name = ganggrade.name
				self.PlayerData.gang.grade.level = tonumber(grade)
				self.PlayerData.gang.isboss = ganggrade.isboss ~= nil and ganggrade.isboss or false
			else
				self.PlayerData.gang.grade = {}
				self.PlayerData.gang.grade.name = 'No Grades'
				self.PlayerData.gang.grade.level = 0
				self.PlayerData.gang.isboss = false
			end

			self.Functions.UpdatePlayerData()
			TriggerClientEvent("XZCore:Client:OnGangUpdate", self.PlayerData.source, self.PlayerData.gang)
			return true
		end
		return false
	end

	self.Functions.SetJobDuty = function(onDuty)
		self.PlayerData.job.onduty = onDuty
		self.Functions.UpdatePlayerData()
	end

	self.Functions.SetMetaData = function(meta, val)
		local meta = meta:lower()
		if val ~= nil then
			self.PlayerData.metadata[meta] = val
			self.Functions.UpdatePlayerData()
		end
	end

	self.Functions.AddJobReputation = function(amount)
		local amount = tonumber(amount)
		self.PlayerData.metadata["jobrep"][self.PlayerData.job.name] = self.PlayerData.metadata["jobrep"][self.PlayerData.job.name] + amount
		self.Functions.UpdatePlayerData()
	end

	self.Functions.AddMoney = function(moneytype, amount, reason)
		reason = reason ~= nil and reason or "unkown"
		local moneytype = moneytype:lower()
		local amount = tonumber(amount)
		if amount < 0 then return end
		if self.PlayerData.money[moneytype] ~= nil then
			self.PlayerData.money[moneytype] = self.PlayerData.money[moneytype]+amount
			self.Functions.UpdatePlayerData()
			if amount > 100000 then
				TriggerEvent("xz-logs:server:sendLog", {Player = self.PlayerData.source}, "playermoney", "A Player Received Money", string.format("%s Received `%s$` For Reason `%s`\nType: `%s`", GetPlayerName(self.PlayerData.source), amount, reason, moneytype), {}, "green", "xz-core", true)
			else
				TriggerEvent("xz-logs:server:sendLog", {Player = self.PlayerData.source}, "playermoney", "A Player Received Money", string.format("%s Received `%s$` For Reason `%s`\nType: `%s`", GetPlayerName(self.PlayerData.source), amount, reason, moneytype), {}, "green", "xz-core")
			end
			TriggerClientEvent("hud:client:OnMoneyChange", self.PlayerData.source, moneytype, amount, false)
			return true
		end
		return false
	end

	self.Functions.RemoveMoney = function(moneytype, amount, reason)
		reason = reason ~= nil and reason or "unkown"
		local moneytype = moneytype:lower()
		local amount = tonumber(amount)
		if amount < 0 then return end
		if self.PlayerData.money[moneytype] ~= nil then
			for _, mtype in pairs(XZCore.Config.Money.DontAllowMinus) do
				if mtype == moneytype then
					if self.PlayerData.money[moneytype] - amount < 0 then return false end
				end
			end
			self.PlayerData.money[moneytype] = self.PlayerData.money[moneytype] - amount
			self.Functions.UpdatePlayerData()
			if amount > 100000 then
				TriggerEvent("xz-logs:server:sendLog", {Player = self.PlayerData.source}, "playermoney", "A Player Removed Money", string.format("%s Received `%s$` For Reason `%s`\nType: `%s`", GetPlayerName(self.PlayerData.source), amount, reason, moneytype), {}, "red", "xz-core", true)
			else
				TriggerEvent("xz-logs:server:sendLog", {Player = self.PlayerData.source}, "playermoney", "A Player Removed Money", string.format("%s Received `%s$` For Reason `%s`\nType: `%s`", GetPlayerName(self.PlayerData.source), amount, reason, moneytype), {}, "red", "xz-core")
			end
			TriggerClientEvent("hud:client:OnMoneyChange", self.PlayerData.source, moneytype, amount, true)
			if moneytype == "bank" then
				TriggerClientEvent('xz-phone:client:RemoveBankMoney', self.PlayerData.source, amount)
			end
			return true
		end
		return false
	end

	self.Functions.SetMoney = function(moneytype, amount, reason)
		reason = reason ~= nil and reason or "unkown"
		local moneytype = moneytype:lower()
		local amount = tonumber(amount)
		if amount < 0 then return end
		if self.PlayerData.money[moneytype] ~= nil then
			self.PlayerData.money[moneytype] = amount
			self.Functions.UpdatePlayerData()
			TriggerEvent("xz-logs:server:sendLog", {Player = self.PlayerData.source}, "playermoney", "A Player Removed Money", string.format("%s's Money Has Been Set To `%s$` For Reason `%s`\nMoney Type: `%s`", GetPlayerName(self.PlayerData.source), amount, reason, moneytype), {}, "red", "xz-core")
			return true
		end
		return false
	end

	self.Functions.GetMoney = function(moneytype)
		if moneytype ~= nil then
			local moneytype = moneytype:lower()
			return self.PlayerData.money[moneytype]
		end
		return false
	end

	self.Functions.AddItem = function(item, amount, slot, info)
		local totalWeight = XZCore.Player.GetTotalWeight(self.PlayerData.items)
		local itemInfo = XZCore.Shared.Items[item:lower()]
		if itemInfo == nil then TriggerClientEvent('XZCore:Notify', source, "Item Does Not Exist", "error") return end
		local amount = tonumber(amount)
		local slot = tonumber(slot) ~= nil and tonumber(slot) or XZCore.Player.GetFirstSlotByItem(self.PlayerData.items, item)
		if itemInfo["type"] == "weapon" and info == nil then
			info = {
				serie = tostring(XZCore.Shared.RandomInt(2) .. XZCore.Shared.RandomStr(3) .. XZCore.Shared.RandomInt(1) .. XZCore.Shared.RandomStr(2) .. XZCore.Shared.RandomInt(3) .. XZCore.Shared.RandomStr(4)),
			}
		end
		if (totalWeight + (itemInfo["weight"] * amount)) <= XZCore.Config.Player.MaxWeight then
			if (slot ~= nil and self.PlayerData.items[slot] ~= nil) and (self.PlayerData.items[slot].name:lower() == item:lower()) and (itemInfo["type"] == "item" and not itemInfo["unique"]) then
				self.PlayerData.items[slot].amount = self.PlayerData.items[slot].amount + amount
				self.Functions.UpdatePlayerData()
				local fields = {
					{
						name = "item",
						value = string.format("Item Name: %s\nAmount: %s\nSlot: %s\nWeight (Per 1): %s", item, amount, slot, itemInfo["weight"]),
						inline = true
					}
				}

				TriggerEvent("xz-logs:server:sendLog", {Reciver = self.PlayerData.source}, "inventory", "A Player Received An Item", string.format("%s Received `%s`", GetPlayerName(self.PlayerData.source), item), fields, "default", "xz-core")
				return true
			elseif (not itemInfo["unique"] and slot or slot ~= nil and self.PlayerData.items[slot] == nil) then
				self.PlayerData.items[slot] = {name = itemInfo["name"], amount = amount, info = info ~= nil and info or "", label = itemInfo["label"], description = itemInfo["description"] ~= nil and itemInfo["description"] or "", weight = itemInfo["weight"], type = itemInfo["type"], unique = itemInfo["unique"], useable = itemInfo["useable"], image = itemInfo["image"], shouldClose = itemInfo["shouldClose"], slot = slot, combinable = itemInfo["combinable"]}
				self.Functions.UpdatePlayerData()
				TriggerEvent("xz-log:server:CreateLog", "playerinventory", "AddItem", "green", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** got item: [slot:" ..slot.."], itemname: " .. self.PlayerData.items[slot].name .. ", added amount: " .. amount ..", new total amount: ".. self.PlayerData.items[slot].amount)
				return true
			elseif (itemInfo["unique"]) or (not slot or slot == nil) or (itemInfo["type"] == "weapon") then
				for i = 1, XZConfig.Player.MaxInvSlots, 1 do
					if self.PlayerData.items[i] == nil then
						self.PlayerData.items[i] = {name = itemInfo["name"], amount = amount, info = info ~= nil and info or "", label = itemInfo["label"], description = itemInfo["description"] ~= nil and itemInfo["description"] or "", weight = itemInfo["weight"], type = itemInfo["type"], unique = itemInfo["unique"], useable = itemInfo["useable"], image = itemInfo["image"], shouldClose = itemInfo["shouldClose"], slot = i, combinable = itemInfo["combinable"]}
						self.Functions.UpdatePlayerData()
						local fields = {
							{
								name = "item",
								value = string.format("Item Name: %s\nAmount: %s\nSlot: %s\nWeight (Per 1): %s", item, amount, slot, itemInfo["weight"]),
								inline = true
							}
						}
		
						TriggerEvent("xz-logs:server:sendLog", {Reciver = self.PlayerData.source}, "inventory", "A Player Received An Item", string.format("%s Recived `%s`", GetPlayerName(self.PlayerData.source), item), fields, "default", "xz-core")
						return true
					end
				end
			end
		else
			TriggerClientEvent('XZCore:Notify', self.PlayerData.source, "Your inventory is too heavy!", "error")
		end
		return false
	end

	self.Functions.RemoveItem = function(item, amount, slot)
		local itemInfo = XZCore.Shared.Items[item:lower()]
		local amount = tonumber(amount)
		local slot = tonumber(slot)
		if slot ~= nil then
			if self.PlayerData.items[slot].amount > amount then
				self.PlayerData.items[slot].amount = self.PlayerData.items[slot].amount - amount
				self.Functions.UpdatePlayerData()
				TriggerEvent("xz-log:server:CreateLog", "playerinventory", "RemoveItem", "red", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** lost item: [slot:" ..slot.."], itemname: " .. self.PlayerData.items[slot].name .. ", removed amount: " .. amount ..", new total amount: ".. self.PlayerData.items[slot].amount)
				return true
			else
				self.PlayerData.items[slot] = nil
				self.Functions.UpdatePlayerData()
				TriggerEvent("xz-log:server:CreateLog", "playerinventory", "RemoveItem", "red", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** lost item: [slot:" ..slot.."], itemname: " .. item .. ", removed amount: " .. amount ..", item removed")
				return true
			end
		else
			local slots = XZCore.Player.GetSlotsByItem(self.PlayerData.items, item)
			local amountToRemove = amount
			if slots ~= nil then
				for _, slot in pairs(slots) do
					if self.PlayerData.items[slot].amount > amountToRemove then
						self.PlayerData.items[slot].amount = self.PlayerData.items[slot].amount - amountToRemove
						self.Functions.UpdatePlayerData()
						TriggerEvent("xz-log:server:CreateLog", "playerinventory", "RemoveItem", "red", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** lost item: [slot:" ..slot.."], itemname: " .. self.PlayerData.items[slot].name .. ", removed amount: " .. amount ..", new total amount: ".. self.PlayerData.items[slot].amount)
						return true
					elseif self.PlayerData.items[slot].amount == amountToRemove then
						self.PlayerData.items[slot] = nil
						self.Functions.UpdatePlayerData()
						TriggerEvent("xz-log:server:CreateLog", "playerinventory", "RemoveItem", "red", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** lost item: [slot:" ..slot.."], itemname: " .. item .. ", removed amount: " .. amount ..", item removed")
						return true
					end
				end
			end
		end
		return false
	end

	self.Functions.SetInventory = function(items, dontUpdateChat)
		self.PlayerData.items = items
		self.Functions.UpdatePlayerData(dontUpdateChat)
		TriggerEvent("xz-log:server:CreateLog", "playerinventory", "SetInventory", "blue", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** items set: " .. json.encode(items))
	end

	self.Functions.ClearInventory = function()
		self.PlayerData.items = {}
		self.Functions.UpdatePlayerData()
		TriggerEvent("xz-log:server:CreateLog", "playerinventory", "ClearInventory", "red", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** inventory cleared")
	end

	self.Functions.GetItemByName = function(item)
		local item = tostring(item):lower()
		local slot = XZCore.Player.GetFirstSlotByItem(self.PlayerData.items, item)
		if slot ~= nil then
			return self.PlayerData.items[slot]
		end
		return nil
	end

	self.Functions.GetItemsByName = function(item)
		local item = tostring(item):lower()
		local items = {}
		local slots = XZCore.Player.GetSlotsByItem(self.PlayerData.items, item)
		for _, slot in pairs(slots) do
			if slot ~= nil then
				table.insert(items, self.PlayerData.items[slot])
			end
		end
		return items
	end

	self.Functions.SetCreditCard = function(cardNumber)
		self.PlayerData.charinfo.card = cardNumber
		self.Functions.UpdatePlayerData()
	end

	self.Functions.GetCardSlot = function(cardNumber, cardType)
        local item = tostring(cardType):lower()
        local slots = XZCore.Player.GetSlotsByItem(self.PlayerData.items, item)
        for _, slot in pairs(slots) do
            if slot ~= nil then
                if self.PlayerData.items[slot].info.cardNumber == cardNumber then 
                    return slot
                end
            end
        end
        return nil
    end

	self.Functions.GetItemBySlot = function(slot)
		local slot = tonumber(slot)
		if self.PlayerData.items[slot] ~= nil then
			return self.PlayerData.items[slot]
		end
		return nil
	end

	self.Functions.Save = function()
		XZCore.Player.Save(self.PlayerData.source)
	end

	XZCore.Players[self.PlayerData.source] = self
	XZCore.Player.Save(self.PlayerData.source)

	-- At this point we are safe to emit new instance to third party resource for load handling
	TriggerEvent('XZCore:Server:PlayerLoaded', self)
	self.Functions.UpdatePlayerData()
end

XZCore.Player.Save = function(source)
	local PlayerData = XZCore.Players[source].PlayerData
	if PlayerData ~= nil then
		local result = exports.oxmysql:fetchSync('SELECT * FROM players WHERE citizenid=@citizenid', {['@citizenid'] = PlayerData.citizenid})
		if result[1] == nil then
			exports.oxmysql:insert('INSERT INTO players (citizenid, cid, discord, license, name, money, charinfo, job, gang, position, metadata) VALUES (@citizenid, @cid, @discord, @license, @name, @money, @charinfo, @job, @gang, @position, @metadata)', {
				['@citizenid'] = PlayerData.citizenid,
				['@cid'] = tonumber(PlayerData.cid),
				['@license'] = PlayerData.license,
				['@discord'] = PlayerData.discord,
				['@name'] = PlayerData.name,
				['@money'] = json.encode(PlayerData.money),
				['@charinfo'] = json.encode(PlayerData.charinfo),
				['@job'] = json.encode(PlayerData.job),
				['@gang'] = json.encode(PlayerData.gang),
				['@position'] = json.encode(PlayerData.position),
				['@metadata'] = json.encode(PlayerData.metadata)
			})
		else
			exports.oxmysql:execute('UPDATE players SET discord=@discord, license=@license, name=@name, money=@money, charinfo=@charinfo, job=@job, gang=@gang, position=@position, metadata=@metadata WHERE citizenid=@citizenid', {
				['@citizenid'] = PlayerData.citizenid,
				['@license'] = PlayerData.license,
				['@discord'] = PlayerData.discord,
				['@name'] = PlayerData.name,
				['@money'] = json.encode(PlayerData.money),
				['@charinfo'] = json.encode(PlayerData.charinfo),
				['@job'] = json.encode(PlayerData.job),
				['@gang'] = json.encode(PlayerData.gang),
				['@position'] = json.encode(PlayerData.position),
				['@metadata'] = json.encode(PlayerData.metadata)
			})
		end
		XZCore.Player.SaveInventory(source)
		XZCore.ShowSuccess(GetCurrentResourceName(), PlayerData.name .." PLAYER SAVED!")
	else
		XZCore.ShowError(GetCurrentResourceName(), "ERROR XZCore.PLAYER.SAVE - PLAYERDATA IS EMPTY!")
	end
end

XZCore.Player.Logout = function(source)
	TriggerClientEvent('XZCore:Client:OnPlayerUnload', source)
	TriggerClientEvent("XZCore:Player:UpdatePlayerData", source)
	Citizen.Wait(200)
	XZCore.Players[source] = nil
end

local playertables = {
    {table = "players"},
    {table = "apartments"},
    {table = "bank_accounts"},
    {table = "crypto_transactions"},
    {table = "phone_invoices"},
    {table = "phone_messages"},
    {table = "playerskins"},
    {table = "player_boats"},
    {table = "player_contacts"},
    {table = "player_houses"},
    {table = "player_mails"},
    {table = "player_outfits"},
    {table = "player_vehicles"}
}

XZCore.Player.DeleteCharacter = function(source, citizenid)
	local license = XZCore.Functions.GetIdentifier(source, 'license')
	local result = exports.oxmysql:scalarSync('SELECT license FROM players where citizenid = ?', {citizenid})
	if license == result then
		for k,v in pairs(playertables) do
			exports.oxmysql:execute('DELETE FROM '..v.table..' WHERE citizenid = ?', {citizenid})
		end
		TriggerEvent("xz-log:server:CreateLog", "joinleave", "Character Deleted", "red", "**".. GetPlayerName(source) .. "** ("..XZCore.Functions.GetIdentifier(source, 'license')..") deleted **"..citizenid.."**..")
	else
		DropPlayer(source, 'You Have Been Kicked For Exploitation')
		TriggerEvent("xz-log:server:CreateLog", "anticheat", "Anti-Cheat", "white", GetPlayerName(source).." Has Been Dropped For Character Deletion Exploit", false)
	end
end

XZCore.Player.LoadInventory = function(PlayerData)
	PlayerData.items = {}
	local result = exports.oxmysql:fetchSync('SELECT * FROM players WHERE citizenid=@citizenid', {['@citizenid'] = PlayerData.citizenid})
	if result[1] ~= nil then 
		if result[1].inventory ~= nil then
			plyInventory = json.decode(result[1].inventory)
			if next(plyInventory) ~= nil then 
				for _, item in pairs(plyInventory) do
					if item ~= nil then
						local itemInfo = XZCore.Shared.Items[item.name:lower()]
						if itemInfo ~= nil then
							PlayerData.items[item.slot] = {
								name = itemInfo["name"], 
								amount = item.amount, 
								info = item.info ~= nil and item.info or "", 
								label = itemInfo["label"], 
								description = itemInfo["description"] ~= nil and itemInfo["description"] or "", 
								weight = itemInfo["weight"], 
								type = itemInfo["type"], 
								unique = itemInfo["unique"], 
								useable = itemInfo["useable"], 
								image = itemInfo["image"], 
								shouldClose = itemInfo["shouldClose"], 
								slot = item.slot, 
								combinable = itemInfo["combinable"]
							}
						end
					end
				end
			end
		end
	end
	return PlayerData
end

XZCore.Player.SaveInventory = function(source)
	if XZCore.Players[source] ~= nil then 
		local PlayerData = XZCore.Players[source].PlayerData
		local items = PlayerData.items
		local ItemsJson = {}
		if items ~= nil and next(items) ~= nil then
			for slot, item in pairs(items) do
				if items[slot] ~= nil then
					table.insert(ItemsJson, {
						name = item.name,
						amount = item.amount,
						info = item.info,
						type = item.type,
						slot = slot,
					})
				end
			end
			exports.oxmysql:execute('UPDATE players SET inventory=@inventory WHERE citizenid=@citizenid', {['@inventory'] = json.encode(ItemsJson), ['@citizenid'] = PlayerData.citizenid})
		else
			exports.oxmysql:execute('UPDATE players SET inventory=@inventory WHERE citizenid=@citizenid', {['@inventory'] = '[]', ['@citizenid'] = PlayerData.citizenid})
		end
	end
end

XZCore.Player.GetTotalWeight = function(items)
	local weight = 0
	if items ~= nil then
		for slot, item in pairs(items) do
			weight = weight + (item.weight * item.amount)
		end
	end
	return tonumber(weight)
end

XZCore.Player.GetSlotsByItem = function(items, itemName)
	local slotsFound = {}
	if items ~= nil then
		for slot, item in pairs(items) do
			if item.name:lower() == itemName:lower() then
				table.insert(slotsFound, slot)
			end
		end
	end
	return slotsFound
end

XZCore.Player.GetFirstSlotByItem = function(items, itemName)
	if items ~= nil then
		for slot, item in pairs(items) do
			if item.name:lower() == itemName:lower() then
				return tonumber(slot)
			end
		end
	end
	return nil
end

XZCore.Player.CreateCitizenId = function()
	local UniqueFound = false
	local CitizenId = nil

	while not UniqueFound do
		CitizenId = tostring(XZCore.Shared.RandomStr(3) .. XZCore.Shared.RandomInt(5)):upper()
		local result = exports.oxmysql:fetchSync('SELECT COUNT(*) as count FROM players WHERE citizenid=@citizenid', {['@citizenid'] = CitizenId})
		if result[1].count == 0 then
			UniqueFound = true
		end
	end
	return CitizenId
end

XZCore.Player.CreateFingerId = function()
	local UniqueFound = false
	local FingerId = nil
	while not UniqueFound do
		FingerId = tostring(XZCore.Shared.RandomStr(2) .. XZCore.Shared.RandomInt(3) .. XZCore.Shared.RandomStr(1) .. XZCore.Shared.RandomInt(2) .. XZCore.Shared.RandomStr(3) .. XZCore.Shared.RandomInt(4))
		local query = '%'..FingerId..'%'
		local result = exports.oxmysql:fetchSync('SELECT COUNT(*) as count FROM `players` WHERE `metadata` LIKE @query', {['@query'] = query})
		if result[1].count == 0 then
			UniqueFound = true
		end
	end
	return FingerId
end

XZCore.Player.CreateWalletId = function()
	local UniqueFound = false
	local WalletId = nil
	while not UniqueFound do
		WalletId = "XZ-"..math.random(11111111, 99999999)
		local query = '%'..WalletId..'%'
		local result = exports.oxmysql:fetchSync('SELECT COUNT(*) as count FROM players WHERE metadata LIKE @query', {['@query'] = query})
		if result[1].count == 0 then
			UniqueFound = true
		end
	end
	return WalletId
end

XZCore.Player.CreateSerialNumber = function()
    local UniqueFound = false
    local SerialNumber = nil

    while not UniqueFound do
        SerialNumber = math.random(11111111, 99999999)
		local query = '%'..SerialNumber..'%'
		local result = exports.oxmysql:fetchSync('SELECT COUNT(*) as count FROM players WHERE metadata LIKE @query', {['@query'] = query})
		if result[1].count == 0 then
			UniqueFound = true
		end
    end
    return SerialNumber
end

XZCore.EscapeSqli = function(str)
    local replacements = { ['"'] = '\\"', ["'"] = "\\'" }
    return str:gsub( "['\"]", replacements ) -- or string.gsub( source, "['\"]", replacements )
end

PaycheckLoop()

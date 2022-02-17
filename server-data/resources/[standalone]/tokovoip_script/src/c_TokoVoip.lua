XZCore = nil

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(10)
        if XZCore == nil then
            TriggerEvent("XZCore:GetObject", function(obj) XZCore = obj end)    
            Citizen.Wait(200)
        end
	end
end)

TokoVoip = {};
TokoVoip.__index = TokoVoip;
local lastTalkState = false
local CanTalkOnRadio = true
local chatStatus = false
local resourceName = GetCurrentResourceName();

RegisterNetEvent("chat:activeStatus", function(status)
	chatStatus = status
end)

RegisterNetEvent("tokovoip_script:ToggleRadioTalk", function(bool)
	if not bool then
		CanTalkOnRadio = true
	else
		CanTalkOnRadio = false
	end
end)

function TokoVoip.init(self, config)
	local self = setmetatable(config, TokoVoip);
	self.config = json.decode(json.encode(config));
	self.lastNetworkUpdate = 0;
	self.lastPlayerListUpdate = self.playerListRefreshRate;
	self.playerList = {};
	return (self);
end

function TokoVoip.loop(self)
	Citizen.CreateThread(function()
		while not self.plugin_data.localNamePrefix do Wait(100) end
		while (true) do
			Citizen.Wait(self.refreshRate);
			self:processFunction();
			self:sendDataToTS3();
			self.lastNetworkUpdate = self.lastNetworkUpdate + self.refreshRate;
			self.lastPlayerListUpdate = self.lastPlayerListUpdate + self.refreshRate;
			if (self.lastNetworkUpdate >= self.networkRefreshRate) then
				self.lastNetworkUpdate = 0;
				self:updateTokoVoipInfo();
			end
			if (self.lastPlayerListUpdate >= self.playerListRefreshRate) then
				self.playerList = GetActivePlayers();
				self.lastPlayerListUpdate = 0;
			end
		end
	end);
end

function TokoVoip.sendDataToTS3(self) -- Send usersdata to the Javascript Websocket
	self:updatePlugin("updateTokoVoip", self.plugin_data);
end

function TokoVoip.updateTokoVoipInfo(self, forceUpdate) -- Update the top-left info
	local info = "";
	if (self.mode == 1) then
		info = "Whispering";
	elseif (self.mode == 2) then
		info = "Normal";
	elseif (self.mode == 3) then
		info = "Shouting";
	end

	if (self.plugin_data.radioTalking) then
		info = info .. " on radio ";
	end
	if (self.talking == 1 or self.plugin_data.radioTalking) then
		info = "<font class='talking'>" .. info .. "</font>";
	end
	if (self.plugin_data.radioChannel ~= -1 and self.myChannels[self.plugin_data.radioChannel]) then
		if (string.match(self.myChannels[self.plugin_data.radioChannel].name, "Call")) then
			info = info  .. "<br> [Phone] " .. self.myChannels[self.plugin_data.radioChannel].name.. " 🎧  🎤<br>"
		else
			info = info  .. "<br> " .. self.myChannels[self.plugin_data.radioChannel].name.. " 🎧  🎤<br>"
		end
	end
	if (info == self.screenInfo and not forceUpdate) then return end
	self.screenInfo = info;
	self:updatePlugin("updateTokovoipInfo", "" .. info);
end

function TokoVoip.updatePlugin(self, event, payload)
	exports.tokovoip_script:doSendNuiMessage(event, payload);
end

function TokoVoip.updateConfig(self)
	local data = self.config;
	data.plugin_data = self.plugin_data;
	data.pluginVersion = self.pluginVersion;
	data.pluginStatus = self.pluginStatus;
	data.pluginUUID = self.pluginUUID;
	self:updatePlugin("updateConfig", data);
end

function TokoVoip.initialize(self)
	self:updateConfig();
	self:updatePlugin("initializeSocket", nil);

	RegisterNetEvent("xz:interact:init:" .. resourceName, function(Nevo)
		Nevo.Mapping:Listen("switchstate", "(Voip) Change Proximity", "keyboard", "GRAVE", function(state)
			if(state) then
				if (not self.mode) then
					self.mode = 1;
				end
				self.mode = self.mode + 1;
				if (self.mode > 3) then
					self.mode = 1;
				end
				TriggerEvent("hud:client:settalkingstate", self.mode)
				if self.mode == 1 then
					self._mode = "Whisper"
				elseif self.mode == 2 then
					self._mode = "Normal"
				else
					self._mode = "Shouting"
				end
				setPlayerData(self.serverId, "voip:mode", self.mode, true);
				self:updateTokoVoipInfo();
			end
		end);

		Nevo.Mapping:Listen("radiotalk", "(Voip) Radio Talk", "keyboard", "CAPITAL", function(state)
			if(self.plugin_data.radioChannel == -1 or not self.config.radioEnabled or chatStatus ) then
				return
			end

			local playerPed = PlayerPedId()

			if(state) then
				if CanTalkOnRadio then
					self.plugin_data.radioTalking = true;
					self.plugin_data.localRadioClicks = true;
					if (self.plugin_data.radioChannel > self.config.radioClickMaxChannel) then
						self.plugin_data.localRadioClicks = false;
					end
				end
				if (not getPlayerData(self.serverId, "radio:talking")) then
					setPlayerData(self.serverId, "radio:talking", true, true);
				end
				self:updateTokoVoipInfo();
				if (lastTalkState == false and self.myChannels[self.plugin_data.radioChannel]) then
					if (not string.match(self.myChannels[self.plugin_data.radioChannel].name, "Call") and not IsPedSittingInAnyVehicle(playerPed)) then
						RequestAnimDict("random@arrests");
						while not HasAnimDictLoaded("random@arrests") do
							Wait(5);
						end
						if not IsEntityPlayingAnim(playerPed, "move_crawl", "onfront_fwd", 3) then
							TaskPlayAnim(playerPed,"random@arrests","generic_radio_chatter", 8.0, 0.0, -1, 49, 0, 0, 0, 0)
						end
					end
					lastTalkState = true
				end
			else
				if not rname or (rname and not string.match(rname, "Call")) then
					self.plugin_data.radioTalking = false;
					if (getPlayerData(self.serverId, "radio:talking")) then
						setPlayerData(self.serverId, "radio:talking", false, true);
					end
					self:updateTokoVoipInfo();
					if lastTalkState == true and self.config.radioAnim then
						lastTalkState = false
						StopAnimTask(playerPed, "random@arrests","generic_radio_chatter", -4.0);
					end
				end
			end

		end);
	
	end)

	Citizen.CreateThread(function()
		while (true) do
			Citizen.Wait(5);
			
			local playerPed = PlayerPedId()
			local rname = self.myChannels[self.plugin_data.radioChannel] and self.myChannels[self.plugin_data.radioChannel].name
			if rname and string.match(rname, "Call") then
				if (not getPlayerData(self.serverId, "radio:talking")) then
					setPlayerData(self.serverId, "radio:talking", true, true);
				end
				self:updateTokoVoipInfo();
			end
			
		end
	end);
end


function TokoVoip.disconnect(self)
	self:updatePlugin("disconnect");
end

-- CreateThread(function()
-- 	local playerSId = GetPlayerServerId(PlayerId())
-- 	while true do
		
-- 		for _, v in pairs(TokoVoipConfig.wisperZones) do
-- 			if #(GetEntityCoords(PlayerPedId()) - v) < 20.0 then
-- 				TriggerEvent("hud:client:settalkingstate", 1)
-- 				setPlayerData(playerSId, "voip:mode", 1, true);
-- 			end
-- 		end

-- 		Wait(5000)
-- 	end
-- end)

CreateThread(function()
    TriggerEvent("xz:interact:init", resourceName, "Mapping");
end);

RegisterNetEvent("xz:interact:ready", function()
    TriggerEvent("xz:interact:init", resourceName, "Mapping");
end);
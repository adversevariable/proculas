--
--	Proculas
--	Tells you when things like Mongoose, Clearcasting, etc proc.
--	Created by Clorell/Keruni of Argent Dawn [US]
--	$Id$
--

-------------------------------------------------------
-- Proculas
Proculas = LibStub("AceAddon-3.0"):NewAddon("Proculas", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0", "LibSink-2.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Proculas", false)
local LSM = LibStub("LibSharedMedia-3.0")

-------------------------------------------------------
-- Proculas Version
Proculas.revision = tonumber(("@project-revision@"):match("%d+"))
Proculas.version = GetAddOnMetadata('Proculas', 'Version')
if(Proculas.revision == nil) then
	Proculas.version = "SVN"
end
local VERSION = Proculas.version

-------------------------------------------------------
-- Register some media
LSM:Register("sound", "Rubber Ducky", [[Sound\Doodad\Goblin_Lottery_Open01.wav]])
LSM:Register("sound", "Cartoon FX", [[Sound\Doodad\Goblin_Lottery_Open03.wav]])
LSM:Register("sound", "Explosion", [[Sound\Doodad\Hellfire_Raid_FX_Explosion05.wav]])
LSM:Register("sound", "Shing!", [[Sound\Doodad\PortcullisActive_Closed.wav]])
LSM:Register("sound", "Wham!", [[Sound\Doodad\PVP_Lordaeron_Door_Open.wav]])
LSM:Register("sound", "Simon Chime", [[Sound\Doodad\SimonGame_LargeBlueTree.wav]])
LSM:Register("sound", "War Drums", [[Sound\Event Sounds\Event_wardrum_ogre.wav]])
LSM:Register("sound", "Cheer", [[Sound\Event Sounds\OgreEventCheerUnique.wav]])
LSM:Register("sound", "Humm", [[Sound\Spells\SimonGame_Visual_GameStart.wav]])
LSM:Register("sound", "Short Circuit", [[Sound\Spells\SimonGame_Visual_BadPress.wav]])
LSM:Register("sound", "Fel Portal", [[Sound\Spells\Sunwell_Fel_PortalStand.wav]])
LSM:Register("sound", "Fel Nova", [[Sound\Spells\SeepingGaseous_Fel_Nova.wav]])

-------------------------------------------------------
-- Default options
local defaults = {
	profile = {
		Messages = {
			Post = true,
			PostChatFrame = true,
			PostCT = true,
			PostParty = false,
			PostRW = false,
			PostGuild = false,
			PostRaid = false,
			StickyCT = true,
			SinkOptions = {},
			before = "",
			after = " procced!",
			Flash = true,
		},
		Sound = {
			Playsound = true,
			SoundFile = "Explosion",
		},
		procstats = {
			total = {},
			session = {},
			lastminute = {},
			ppm = {},
		},
		tracked = {},
	},
}
-------------------------------------------------------
-- Procs
Proculas.Procs = {
	Items = {},
	Enchants = {},
	Gems = {},
	PALADIN = {},
	DEATHKNIGHT = {},
	SHAMAN = {},
	HUNTER = {},
	PRIEST = {},
	ROGUE = {},
	DRUID = {},
	WARRIOR = {},
	WARLOCK = {},
	MAGE = {},
}
-------------------------------------------------------
-- Just some required things...
local combatTime
local lastCombatTime = 0
function Proculas:OnInitialize()
	self:Print("v"..VERSION.." running.")
	self.db = LibStub("AceDB-3.0"):New("ProculasDB", defaults)
	self.opt = self.db.profile
	self.procstats = self.db.profile.procstats
	self.procstats.session = {}
	self.procstats.lastminute = {}
	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")
	self:ScheduleRepeatingTimer("resetLastMinuteProc", 60)
	self:SetSinkStorage(self.opt.Messages.SinkOptions)
	self:SetupOptions()
	combatTime = 0
end

function Proculas:OnEnable()
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("UNIT_INVENTORY_CHANGED")
	changed = true
	-- Player stuff
	playerClass0, playerClass1 = UnitClass("player")
	self.playerClass = playerClass1
	self.playerName = UnitName("player")
	-- Check for procs
	self:scanForProcs()
end

-------------------------------------------------------
-- Timer Functions

-- Empties the Procs Last Minute Array.
function Proculas:resetLastMinuteProc()
	self.procstats.lastminute = {}
end

-------------------------------------------------------
-- Profiles Stuff
function Proculas:OnProfileChanged(event, database, newProfileKey)
	self.db = db
	self.opt = db.profile
	self:Print("Profile changed.")
end

-------------------------------------------------------
-- Proc Stuff

-- Adds Procs to the Proc List
function Proculas:addProcList(list,procs)
	for id,info in pairs(procs) do
		self.Procs[list][id] = info
	end
end

-- Scans for Procs
function Proculas:scanForProcs()
	-- Reset tracked Procs
	self.opt.tracked = {}

	-- Find Procs
	self:scanItem(GetInventorySlotInfo("MainHandSlot"))
	self:scanItem(GetInventorySlotInfo("SecondaryHandSlot"))
	self:scanItem(GetInventorySlotInfo("RangedSlot"))
	self:scanItem(GetInventorySlotInfo("Trinket0Slot"))
	self:scanItem(GetInventorySlotInfo("Trinket1Slot"))
	self:scanItem(GetInventorySlotInfo("Finger0Slot"))
	self:scanItem(GetInventorySlotInfo("Finger1Slot"))
	self:scanItem(GetInventorySlotInfo("HeadSlot"))
	self:scanItem(GetInventorySlotInfo("NeckSlot"))
	self:scanItem(GetInventorySlotInfo("ShoulderSlot"))
	self:scanItem(GetInventorySlotInfo("BackSlot"))
	self:scanItem(GetInventorySlotInfo("ChestSlot"))
	self:scanItem(GetInventorySlotInfo("WristSlot"))
	self:scanItem(GetInventorySlotInfo("HandsSlot"))
	self:scanItem(GetInventorySlotInfo("WaistSlot"))
	self:scanItem(GetInventorySlotInfo("LegsSlot"))
	self:scanItem(GetInventorySlotInfo("FeetSlot"))
	
	-- Add Class Procs
	for index,procs in pairs(self.Procs) do
		if(index == self.playerClass) then
			for spellID,procInfo in pairs(procs) do
				procInfo.spellID = spellID
				self:addProc(procInfo)
			end
		end
	end
end

-- Scans an item and checks for procs
function Proculas:scanItem(slotID)
	local itemlink = GetInventoryItemLink("player", slotID)
	if itemlink ~= nil then
		local found, _, itemstring = string.find(itemlink, "^|c%x+|H(.+)|h%[.+%]")
		if(found) then
			local _, itemId, enchantId, jewelId1, jewelId2, jewelId3, jewelId4, suffixId, uniqueId, fromLvl = strsplit(":", itemstring)
			local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture = GetItemInfo(itemlink)
		
			-- Enchants
			if tonumber(enchantId) ~= 0 then
				local enchID = tonumber(enchantId)
				if(self.Procs.Enchants[enchID]) then
					local procInfo = self.Procs.Enchants[enchID]
					self:addProc(procInfo)
				end
			end

			-- Procs
			itemId = tonumber(itemId)
			if (self.Procs.Items[itemId]) then
				local procInfo = self.Procs.Items[itemId];
				procInfo.name = itemName
				self:addProc(procInfo)
			end
		end
	end
end

-- Adds a proc to the tracked procs
function Proculas:addProc(procInfo)
	local proc = {
		spellID = procInfo.spellID,
		name = procInfo.name,
		types = procInfo.types,
		selfOnly = procInfo.selfOnly,
		count = 0,
	}
	table.insert(self.opt.tracked, proc)
end

local combatTickTimer
function Proculas:PLAYER_REGEN_DISABLED()
	combatTickTimer = self:ScheduleRepeatingTimer("combatTick", 1)
end

function Proculas:PLAYER_REGEN_ENABLED()
	self:CancelTimer(combatTickTimer)
	self:updatePPM()
	lastCombatTime = combatTime
	combatTime = 0
end

function Proculas:updatePPM()
	for a,b in pairs(self.procstats.lastminute) do
		local spellID = b[1]
		if(self.procstats.ppm[spellID]) then
			if(b[3] > self.procstats.ppm[spellID][3]) then
				self.procstats.ppm[spellID][3] = self.procstats.lastminute[spellID][3];
			end
		else
			self.procstats.ppm[spellID] = {b[1],b[2],0};
		end
	end
end

function Proculas:combatTick()
	combatTime = combatTime+1;
end

function Proculas:UNIT_INVENTORY_CHANGED(event,unit)
	if unit == "player" then
		self:scanForProcs()
	end
end

function Proculas:COMBAT_LOG_EVENT_UNFILTERED(event,...)
	local msg,type,msg2,name,msg3,msg4,name2 = select(1, ...)
	local spellId, spellName, spellSchool = select(9, ...)
	
	if(name == self.playerName) then
	-- Gems
		if(self.Procs.Gems[spellId]) then
			local procInfo = self.Procs.Gems[spellId]
			local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture = GetItemInfo(procInfo.itemID)
			local isType = false
			for _,proctype in ipairs(procInfo.types) do
				if(type == proctype) then
					isType = true
					break;
				end
			end
			if(isType) then
				if(self.Procs.Gems[spellId].selfOnly and name2 == self.playerName) then
						self:postProc(spellId,itemName)
				else
					self:postProc(spellId,itemName)
				end
			end
		end
		
	-- Everything else
		for _, procInfo in pairs(self.opt.tracked) do
			if(procInfo.spellID == spellId) then
				local isType = false
				for _,proctype in ipairs(procInfo.types) do
					if(type == proctype) then
						isType = true
						break;
					end
				end
				if(isType) then
					if(procInfo.selfOnly) then
						if(name2 == self.playerName) then
							self:postProc(procInfo.spellID,procInfo.name)
						end
					else
						self:postProc(procInfo.spellID,procInfo.name)
					end
				end
			end
		end
	end
end

function Proculas:postProc(spellID,procName)
	spellName = GetSpellInfo(spellID)
	-- Log Proc
	self:logProc(procName,spellID);
	-- Post Proc
	if (self.opt.Messages.Post) then
		-- Chat Frame
		if (self.opt.Messages.PostChatFrame) then
			self:Print(self.opt.Messages.before..procName..self.opt.Messages.after)
		end
		-- Blizzard Combat Text
		if (self.opt.Messages.PostCT) then
			self:Pour(self.opt.Messages.before..procName..self.opt.Messages.after, 2, 96, 206, nil, 24, "OUTLINE", self.opt.Messages.StickyCT);
		end
		-- Party
		if (self.opt.Messages.PostParty and GetNumPartyMembers()>0) then
			SendChatMessage("[Proculas]: "..self.opt.Messages.before..procName..self.opt.Messages.after, "PARTY");
		end
		-- Raid Warining
		if (self.opt.Messages.PostRW and GetNumPartyMembers()>0) then
			SendChatMessage(self.opt.Messages.before..procName..self.opt.Messages.after, "RAID_WARNING");
		end
		-- Guild Chat
		if (self.opt.Messages.PostGuild) then
			SendChatMessage("[Proculas]: "..self.opt.Messages.before..procName..self.opt.Messages.after, "GUILD");
		end
		-- Raid Chat
		if (self.opt.Messages.PostRaid) then
			SendChatMessage("[Proculas]: "..self.opt.Messages.before..procName..self.opt.Messages.after, "RAID");
		end
	end
	-- Play Sound
	if (self.opt.Sound.Playsound) then
		PlaySoundFile(LSM:Fetch("sound", self.opt.Sound.SoundFile))
	end
	-- Flash Screen
	if(self.opt.Messages.Flash) then
		self:Flash()
	end
end

-- Used to Flash the screen
function Proculas:Flash()
	if not self.FlashFrame then
		local flasher = CreateFrame("Frame", "ProculasFlashFrame")
		flasher:SetToplevel(true)
		flasher:SetFrameStrata("FULLSCREEN_DIALOG")
		flasher:SetAllPoints(UIParent)
		flasher:EnableMouse(false)
		flasher:Hide()
		flasher.texture = flasher:CreateTexture(nil, "BACKGROUND")
		flasher.texture:SetTexture("Interface\\FullScreenTextures\\LowHealth")
		flasher.texture:SetAllPoints(UIParent)
		flasher.texture:SetBlendMode("ADD")
		flasher:SetScript("OnShow", function(self)
			self.elapsed = 0
			self:SetAlpha(0)
		end)
		flasher:SetScript("OnUpdate", function(self, elapsed)
			elapsed = self.elapsed + elapsed
			if elapsed < 2.6 then
				local alpha = elapsed % 1.3
				if alpha < 0.15 then
					self:SetAlpha(alpha / 0.15)
				elseif alpha < 0.9 then
					self:SetAlpha(1 - (alpha - 0.15) / 0.6)
				else
					self:SetAlpha(0)
				end
			else
				self:Hide()
			end
			self.elapsed = elapsed
		end)
		self.FlashFrame = flasher
	end
	self.FlashFrame:Show()
end

-- Used to Log the Proc for stats tracking
function Proculas:logProc(procName,spellID)
	-- Total
	if(self.procstats.total[spellID]) then
		self.procstats.total[spellID][3] = self.procstats.total[spellID][3]+1;
	else
		self.procstats.total[spellID] = {spellID,procName,1};
	end
	-- Session
	if(self.procstats.session[spellID]) then
		self.procstats.session[spellID][3] = self.procstats.session[spellID][3]+1;
	else
		self.procstats.session[spellID] = {spellID,procName,1};
	end
	-- Last Minute
	if(self.procstats.lastminute[spellID]) then
		self.procstats.lastminute[spellID][3] = self.procstats.lastminute[spellID][3]+1;
	else
		self.procstats.lastminute[spellID] = {spellID,procName,1};
	end
	-- PPM
	self:updatePPM();
end

-- Used to print the Proc stats
function Proculas:procStats()
	self:Print("-------------------------------");
	self:Print("Proc Stats: Total Procs");
	for _,v in pairs(self.procstats.total) do
		self:Print(v[2]..": "..v[3].." times");
	end
	self:Print("-------------------------------");
	self:Print("Proc Stats: Procs This Session");
	for _,v in pairs(self.procstats.session) do
		self:Print(v[2]..": "..v[3].." times");
	end
	self:Print("-------------------------------");
	self:Print("Proc Stats: Procs Per Minute");
	for _,v in pairs(self.procstats.ppm) do
		self:Print(v[2]..": "..v[3].." ppm");
	end
end

function Proculas:resetProcStats()
	self.procstats = {
		total = {},
		session = {},
		lastminute = {},
		ppm = {},
	}
end

-------------------------------------------------------
-- About Proculas
function Proculas:AboutProculas()
	self:Print("Version "..VERSION)
	self:Print("Created by Clorell/Keruni of Argent Dawn [US]")
end

-------------------------------------------------------
-- Proculas Options Stuff
local options = {
	type = "group",
	name = "Proculas",
	get = function(info) return Proculas.opt[ info[#info] ] end,
	set = function(info, value) Proculas.opt[ info[#info] ] = value end,
	args = {
		General = {
			order = 1,
			type = "group",
			name = L["GENERAL_SETTINGS"],
			desc = L["GENERAL_SETTINGS"],
			get = function(info) return Proculas.opt.Messages[ info[#info] ] end,
			set = function(info, value)
				Proculas.opt.Messages[ info[#info] ] = value
			end,
			args = {
				enablepost = {
					order = 4,
					type = "description",
					name = L["ENABLE_POSTING"],
				},
				Post = {
					order = 5,
					name = L["POST_PROCS"],
					desc = L["POST_PROCS_DESC"],
					type = "toggle",
				},
				postwhere = {
					order = 6,
					type = "description",
					name = L["WHERE_TO_POST"],
				},
				PostChatFrame = {
					order = 7,
					name = L["CHAT_FRAME"],
					desc = L["CHAT_FRAME_DESC"],
					type = "toggle",
				},
				PostParty = {
					order = 8,
					name = L["PARTY_CHAT"],
					desc = L["PARTY_CHAT_DESC"],
					type = "toggle",
				},
				PostCT = {
					order = 9,
					name = L["COMBAT_TEXT"],
					desc = L["COMBAT_TEXT_DESC"],
					type = "toggle",
				},
				StickyCT = {
					order = 10,
					name = L["STICKY_COMBAT_TEXT"],
					desc = L["STICKY_COMBAT_TEXT_DESC"],
					type = "toggle",
				},
				PostRW = {
					order = 11,
					name = L["RAID_WARNING"],
					desc = L["RAID_WARNING_DESC"],
					type = "toggle",
				},
				PostGuild = {
					order = 12,
					name = L["GUILD_CHAT"],
					desc = L["GUILD_CHAT_DESC"],
					type = "toggle",
				},
				PostRaid = {
					order = 13,
					name = L["RAID_CHAT"],
					desc = L["RAID_CHAT_DESC"],
					type = "toggle",
				},
				Flash = {
				order = 14,
					name = L["FLASH_SCREEN"],
					desc = L["FLASH_SCREEN_DESC"],
					type = "toggle",
				}
			},
		}, -- General
		ProcStats = {
			order = 1,
			type = "group",
			name = L["CONFIG_PROC_STATS"],
			desc = L["CONFIG_PROC_STATS_DESC"],
			args = {
				resetstats = {
					type = "execute",
					name = L["RESET_PROC_STATS"],
					desc = L["RESET_PROC_STATS_DESC"],
					func = function()
						Proculas:resetProcStats()
					end,
				},
			},
		}, -- ProcStats
		Messages = {
			order = 2,
			type = "group",
			name = "Messages",
			desc = "Proc Messages",
			get = function(info) return Proculas.opt.Messages[ info[#info] ] end,
			set = function(info, value)
				Proculas.opt.Messages[ info[#info] ] = value
			end,
			args = {
				intro = {
					order = 1,
					type = "description",
					name = L["CONFIG_PROC_MESSAGE"],
				},
				before = {
					type = "input",
					order = 2,
					name = L["BEFORE"],
					desc = L["BEFORE_DESC"],
				},
				after = {
					type = "input",
					order = 3,
					name = L["AFTER"],
					desc = L["AFTER_DESC"],
				},
			},
		}, -- Messages
		Sound = {
			order = 3,
			type = "group",
			name = "Sound Settings",
			desc = "Sound Settings",
			get = function(info) return Proculas.opt.Sound[ info[#info] ] end,
			set = function(info, value)
				Proculas.opt.Sound[ info[#info] ] = value
			end,
			args = {
				intro = {
					order = 1,
					type = "description",
					name = L["CONFIG_PROC_SOUND"],
				},
				Playsound = {
					type = "toggle",
					order = 2,
					name = L["ENABLE_SOUND"],
					desc = L["ENABLE_SOUND_DESC"],
				},
				SoundFile = {
					type = "select", dialogControl = 'LSM30_Sound',
					order = 4,
					name = L["SOUND_TO_PLAY"],
					desc = L["SOUND_TO_PLAY"],
					values = AceGUIWidgetLSMlists.sound,
					disabled = function() return not Proculas.opt.Sound.Playsound end,
				},
			},
		}, -- Sound
	},
}
Proculas.options = options

-- Option table for the slash command only
local optionsSlash = {
	type = "group",
	name = "Slash Command",
	order = -3,
	args = {
		about = {
			type = "execute",
			name = L["ABOUT_CMD"],
			desc = L["ABOUT_CMD_DESC"],
			func = function()
				Proculas:AboutProculas()
			end,
			guiHidden = true,
		},
		config = {
			type = "execute",
			name = L["CONFIGURE_CMD"],
			desc = L["CONFIGURE_CMD_DESC"],
			func = function()
				Proculas:ShowConfig()
			end,
			guiHidden = true,
		},
		stats = {
			type = "execute",
			name = L["STATS_CMD"],
			desc = L["STATS_CMD_DESC"],
			func = function()
				Proculas:procStats()
			end,
			guiHidden = true,
		},
	},
}
Proculas.optionsSlash = optionsSlash

function Proculas:getTrackedProcs()
	return self.opt.tracked
end

function Proculas:getProcStats()
	return self.opt.procstats
end

function Proculas:SetupOptions()
	self.optionsFrames = {}

	-- setup options table
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("Proculas", options)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("Proculas Commands", optionsSlash, "proculas")
	local ACD3 = LibStub("AceConfigDialog-3.0")

	-- The ordering here matters, it determines the order in the Blizzard Interface Options
	self.optionsFrames.Proculas = ACD3:AddToBlizOptions("Proculas", nil, nil, "General")
	self.optionsFrames.Messages = ACD3:AddToBlizOptions("Proculas", "Messages", "Proculas", "Messages")
	self.optionsFrames.Sound = ACD3:AddToBlizOptions("Proculas", "Sound Settings", "Proculas", "Sound")
	self.optionsFrames.ProcStats = ACD3:AddToBlizOptions("Proculas", L["CONFIG_PROC_STATS"], "Proculas", "ProcStats")
	self:RegisterModuleOptions("Profiles", LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db), "Profiles")
end

function Proculas:RegisterModuleOptions(name, optionTbl, displayName)
	options.args[name] = (type(optionTbl) == "function") and optionTbl() or optionTbl
	self.optionsFrames[name] = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Proculas", displayName, "Proculas", name)
end

function Proculas:ShowConfig()
	-- Open the profiles tab before, so the menu expands
	InterfaceOptionsFrame_OpenToCategory(self.optionsFrames.Profiles)
	InterfaceOptionsFrame_OpenToCategory(self.optionsFrames.Proculas)
end

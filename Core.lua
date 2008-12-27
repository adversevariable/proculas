--
-- Proculas
-- Tells you when things like Mongoose, Clearcasting, etc proc.
-- Created by Clorell/Keruni of Argent Dawn [US]
-- $Id$
--

-------------------------------------------------------
-- Proculas
Proculas = LibStub("AceAddon-3.0"):NewAddon("Proculas", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0", "LibSink-2.0", "LibBars-1.0", "LibEffects-1.0")
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
		},
		Effects = {
			Flash = false,
			Shake = false,
		},
		Cooldowns = {
			show = true,
		},
		Sound = {
			Playsound = true,
			SoundFile = "Explosion",
		},
		minimapButton = {
			minimapPos = 200,
			radius = 80,
			hide = false,
			rounding = 10,
		},
		procstats = {},
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

-- Things that need to be defined locally
local combatTime = 0
local lastCombatTime = 0
local combatTickTimer

-- OnInitialize
function Proculas:OnInitialize()
	self:Print("v"..VERSION.." running.")
	self.db = LibStub("AceDB-3.0"):New("ProculasDB", defaults)
	self.opt = self.db.profile
	self.procstats = self.opt.procstats
	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")

	self:CreateCDFrame()
	
	self:SetupOptions()
end

-- OnEnable
function Proculas:OnEnable()
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("UNIT_INVENTORY_CHANGED")
	-- Player stuff
	playerClass0, playerClass1 = UnitClass("player")
	self.playerClass = playerClass1
	self.playerName = UnitName("player")
	-- Check for procs
	self:scanForProcs()
end

-------------------------------------------------------
-- Timer Functions

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
				local name, rank, icon, cost, isFunnel, powerType, castTime, minRange, maxRange = GetSpellInfo(spellID)
				procInfo.icon = icon
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
					local name, rank, icon, cost, isFunnel, powerType, castTime, minRange, maxRange = GetSpellInfo(procInfo.spellID)
					procInfo.icon = icon
					self:addProc(procInfo)
				end
			end

			-- Items
			itemId = tonumber(itemId)
			if (self.Procs.Items[itemId]) then
				local procInfo = self.Procs.Items[itemId];
				procInfo.name = itemName
				procInfo.icon = itemTexture
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
		icon = procInfo.icon,
	}
	self.opt.tracked[procInfo.spellID] = proc
end

-- Posts procs to the selected frames
function Proculas:postProc(spellID,procName)
	spellName = GetSpellInfo(spellID)
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
	if(self.opt.Effects.Flash) then
		self:Flash()
	end
	-- Shake Screen
	if(self.opt.Effects.Shake) then
		self:Shake()
	end
end

-- Used to build the GameTooltip
function Proculas:procStatsTooltip()
	for a,proc in pairs(self.procstats) do
		if(proc.name) then
			GameTooltip:AddLine(proc.name, 0, 1, 0)
			GameTooltip:AddTexture(proc.icon)
			if proc.count > 0 then
				GameTooltip:AddDoubleLine(L["PROCS"], proc.count, nil, nil, nil, 1,1,1)
			else
				GameTooltip:AddDoubleLine(L["PROCS"], "N/A", nil, nil, nil, 1,1,1)
			end
			
			local ppm = 0
			if proc.count > 0 then
				ppm = proc.count / (proc.totaltime / 60)
			end
			
			if ppm > 0 then
				GameTooltip:AddDoubleLine(L["PPM"], string.format("%.2f", ppm), nil, nil, nil, 1,1,1)
			else
				GameTooltip:AddDoubleLine(L["PPM"], "N/A", nil, nil, nil, 1,1,1)
			end
			
			if proc.cooldown > 0 then
				GameTooltip:AddDoubleLine(L["COOLDOWN"], proc.cooldown.."s", nil, nil, nil, 1,1,1)
			else
				GameTooltip:AddDoubleLine(L["COOLDOWN"], "N/A", nil, nil, nil, 1,1,1)
			end
			
			GameTooltip:AddLine(" ")
		end
	end
end

-- Does the required things when something procs
function Proculas:handleProc(spellID,procName)
	-- Check if the procstats record exists or not
	if not self.procstats[spellID] then
		self.procstats[spellID] = {
			spellID = spellID,
			name = procName,
			count = 0,
			totaltime = 0, 
			cooldown = 0, 
			lastprocced = 0,
			icon = self.opt.tracked[spellID].icon,
		}
	end
	
	-- Get the proc info
	local proc = self.procstats[spellID]
	
	-- Check Cooldown
	if proc.lastprocced > 0 and (proc.cooldown == 0 or (time() - proc.lastprocced < proc.cooldown)) then
		proc.cooldown = time() - proc.lastprocced
		if self.opt.Messages.Post and proc.cooldown < 300 and proc.cooldown > 4 then
			self:Print("New cooldown found for "..proc.name..": "..proc.cooldown.."s")
		end
	end

	-- Reset cooldown bar
	if proc.cooldown > 0 then
		local bar = self.procCooldowns:GetBar(proc.name)
		if not bar then
			bar = self.procCooldowns:NewTimerBar(proc.name, proc.name, proc.cooldown, proc.cooldown, proc.icon)
		end
		bar:SetTimer(proc.cooldown, proc.cooldown)
	end
	
	-- set the lastprocced time and increment the proc count
	proc.lastprocced = time()
	proc.count = proc.count+1
	
	-- Calls the postProc function, duh?
	self:postProc(proc.spellID,proc.name)
end

-------------------------------------------------------
-- Proc CD Frame

function Proculas:CreateCDFrame()
	self.procCooldowns = self:NewBarGroup("Proc Cooldowns", nil, 150, 18, "ProculasProcCD")
	self.procCooldowns:SetTexture(LSM:Fetch('statusbar', "Blizzard"))
	self.procCooldowns:SetColorAt(1.00, 1.0, 0.2, 0.2, 0.8)
	self.procCooldowns:SetColorAt(0.25, 0.30, 0.8, 0.1, 0.8)
	self.procCooldowns:SetUserPlaced(true)
		
	local bar = self.procCooldowns:NewTimerBar("Test Bar", "Test Bar", 10, 10)
	bar:SetHeight(18)
	bar:SetTimer(0, 0)
	
	if(self.opt.Cooldowns.show) then
		self.procCooldowns:Show()
	else
		self.procCooldowns:Hide()
	end
	
	self.procCooldowns:ShowAnchor()
end

-------------------------------------------------------
-- Event Functions

-- Does the required things for when the player enters combat
function Proculas:PLAYER_REGEN_DISABLED()
	combatTickTimer = self:ScheduleRepeatingTimer("combatTick", 1)
end

-- Does the required things for when the player leaves combat
function Proculas:PLAYER_REGEN_ENABLED()
	self:CancelTimer(combatTickTimer)
	lastCombatTime = combatTime
	combatTime = 0
end

-- Increments the combatTime variable by 1
function Proculas:combatTick()
	combatTime = combatTime+1;
	for key,proc in pairs(self.procstats) do
		proc.totaltime = proc.totaltime + 1
	end
end

-- Rescans the players gear when they change an item
function Proculas:UNIT_INVENTORY_CHANGED(event,unit)
	if unit == "player" then
		self:scanForProcs()
	end
end
local function checktype(types,type)
	for _,thisType in pairs(types) do
		if(thisType == type) then
			return true
		end
	end
	return false
end
-- The Proc scanner, scans the combat log for proc spells
function Proculas:COMBAT_LOG_EVENT_UNFILTERED(event,...)
	local msg,type,msg2,name,msg3,msg4,name2 = select(1, ...)
	local spellId, spellName, spellSchool = select(9, ...)

	-- Gems else
	if(self.Procs.Gems[spellId]) then
		local procInfo = self.Procs.Gems[spellId]
		local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture = GetItemInfo(procInfo.itemID)
		procInfo.icon = itemTexture
		if(checktype(procInfo.types,type)) then
			if(name == self.playerName) then
				if(procInfo.selfOnly and name == self.playerName and name2 == self.playerName) then
					self:handleProc(spellId,procInfo.name)
				elseif procInfo.selfOnly == 0 then
					self:handleProc(spellId,procInfo.name)
				end
			elseif(name == nil and name2 == self.playerName) then
				self:handleProc(spellId,procInfo.name)
			end
		end
	end
	
	-- Everything else
	if(self.opt.tracked[spellId]) then
		local procInfo = self.opt.tracked[spellId]
		if(checktype(procInfo.types,type)) then
			if(name == self.playerName) then
				if(procInfo.selfOnly and name2 == self.playerName) then
					self:handleProc(spellId,procInfo.name)
				elseif procInfo.selfOnly == 0 then
					self:handleProc(spellId,procInfo.name)
				end
			elseif(name == nil and name2 == self.playerName) then
				self:handleProc(spellId,procInfo.name)
			end
		end
	end
end
-------------------------------------------------------
-- Other/Misc Functions

--[[ Used to Flash the screen - Deprecated due to LibEffects-1.0 intergration providing this function
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
end]]

-- Resets the proc stats
function Proculas:resetProcStats()
	self.opt.procstats = {}
	self.procstats = {}
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
					get = function(info) return Proculas.opt.Effects[ info[#info] ] end,
					set = function(info, value)
						Proculas.opt.Effects[ info[#info] ] = value
					end,
				},
				Shake = {
					order = 14,
					name = L["SHAKE_SCREEN"],
					desc = L["SHAKE_SCREEN_DESC"],
					type = "toggle",
					get = function(info) return Proculas.opt.Effects[ info[#info] ] end,
					set = function(info, value)
						Proculas.opt.Effects[ info[#info] ] = value
					end,
				},
				minimapButtonDesc = {
					order = 15,
					type = "description",
					name = L["MINIMAPBUTTONSETTINGS"],
				},
				minimapButtonHide = {
					order = 16,
					name = L["HIDEMINIMAPBUTTON"],
					desc = L["HIDEMINIMAPBUTTON"],
					type = "toggle",
					get = function(info) return Proculas.opt.minimapButton.hide end,
					set = function(info, value)
						Proculas:GetModule("ProculasLDB"):ToggleMMButton(value)
						Proculas.opt.minimapButton.hide = value
					end,
				},
				procCooldownsDesc = {
					order = 17,
					type = "description",
					name = L["COOLDOWNSETTINGS"],
				},
				procCooldownsShow = {
					order = 18,
					name = L["SHOWCOOLDOWNS"],
					desc = L["SHOWCOOLDOWNS"],
					type = "toggle",
					get = function(info) return Proculas.opt.Cooldowns.show end,
					set = function(info, value)
						if value then Proculas.procCooldowns:Show() else Proculas.procCooldowns:Hide() end
						Proculas.opt.Cooldowns.show = value
					end,
				},
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
	},
}
Proculas.optionsSlash = optionsSlash

-- Used to get the tracked procs
function Proculas:getTrackedProcs()
	return self.opt.tracked
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

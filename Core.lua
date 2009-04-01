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
Proculas.version = GetAddOnMetadata('Proculas', 'Version').." r@project-revision@"
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
-- Procs
Proculas.Procs = {
	Items = {},
	Enchants = {},
	Embroideries = {},
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
	self:Print(VERSION.." running.")
	self.db = LibStub("AceDB-3.0"):New("ProculasDB", self.defaults)
	self.dbpc = LibStub("AceDB-3.0"):New("ProculasDBPC", self.defaultsPC)
	self.opt = self.db.profile
	self.optpc = self.dbpc.profile
	self.procstats = self.dbpc.profile.procstats or {}
	self.tracked = self.opt.tracked
	self.procopts = self.optpc.procoptions
	self.activeprocs = {}
	
	-- DB Updater
	if not self.opt.lastver then
		for a,b in pairs(self.procopts) do
			if not b.updatecd then
				b.updatecd = true
			end
		end
		self.opt.lastver = 1
	end
	if(self.opt.lastver < 2) then
		for a,b in pairs(self.procstats) do
			b.started = 0
			b.uptime = 0
		end
		self.opt.lastver = 2
	end
	
	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")

	-- Create the Cooldown bars frame.
	self:CreateCDFrame()
	
	-- Set the Sink options.
	self:SetSinkStorage(self.opt.SinkOptions)
	
	-- Player stuff
	self.playerClass = select(2,UnitClass("player"))
	self.playerName = UnitName("player")
	
	-- Register Custom Sounds
	for name,info in pairs(self.opt.customSounds) do
		LSM:Register("sound", info.name, info.location)
	end
end

-- OnEnable
function Proculas:OnEnable()
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("UNIT_INVENTORY_CHANGED")
	-- Check for procs
	self:scanForProcs()
end

-- Add Custom Sound
function Proculas:addCustomSound(sname,slocation)
	self.opt.customSounds[sname] = {name = sname,location = slocation}
	LSM:Register("sound", sname, slocation)
end

-- Delete Custom Sound
function Proculas:deleteCustomSound(sname)
	self.opt.customSounds[sname] = nil
end

-------------------------------------------------------
-- Timer Functions

-- Increments the combatTime variable by 1
function Proculas:combatTick()
	combatTime = combatTime+1;
	for key,proc in pairs(self.procstats) do
		-- Update Seconds for Update Calculation
		if proc.started > 0 then
			proc.uptime = proc.uptime + 1
		end
		-- Update Total Time
		proc.totaltime = proc.totaltime + 1
	end
end

-------------------------------------------------------
-- Profiles Stuff
function Proculas:OnProfileChanged(event, database, newProfileKey)
	self.db = database
	self.opt = database.profile
	self:updateCooldownsFrame()
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
				procInfo.name = name
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
		
			-- Enchants and Embroideries
			if tonumber(enchantId) ~= 0 then
				local enchID = tonumber(enchantId)
				if(self.Procs.Enchants[enchID]) then
					local procInfo = self.Procs.Enchants[enchID]
					local name, rank, icon, cost, isFunnel, powerType, castTime, minRange, maxRange = GetSpellInfo(procInfo.spellID)
					procInfo.icon = icon
					procInfo.name = name
					self:addProc(procInfo)
				end
			end
			
			-- Items
			itemId = tonumber(itemId)
			if self.Procs.Items[itemId] then
				if type(self.Procs.Items[itemId].spellID) == "table" then
					for _,spell in pairs(self.Procs.Items[itemId].spellID) do
						local procInfo = self.Procs.Items[itemId];
						procInfo.name = itemName
						procInfo.icon = itemTexture
						procInfo.itemID = itemId
						procInfo.spellID = spell
						self:addProc(procInfo)
					end
				else
					local procInfo = self.Procs.Items[itemId];
					procInfo.name = itemName
					procInfo.icon = itemTexture
					procInfo.itemID = itemId
					self:addProc(procInfo)
				end
			end
		end
	end
end

-- Adds a proc to the tracked procs
function Proculas:addProc(procInfo)
	if not procInfo.itemID then procInfo.itemID = 0 end
	local proc = {
		spellID = procInfo.spellID,
		name = procInfo.name,
		types = procInfo.types,
		selfOnly = procInfo.selfOnly,
		icon = procInfo.icon,
		itemID = procInfo.itemID,
	}
	self.opt.tracked[procInfo.spellID] = proc
end

-- Posts procs to the selected frames
function Proculas:postProc(proc)
	local procOpt = self.procopts[proc.spellID]
	spellName = GetSpellInfo(proc.spellID)
	
	-- Sink
	local pourBefore = ""
	if(self.opt.SinkOptions.sink20OutputSink == "Channel") then
		pourBefore = "[Proculas]: "
	end
	if procOpt.postproc or (self.opt.postprocs and (procOpt.postproc ~= false or procOpt.postproc == nil)) then
		local procMessage
		if procOpt.custommessage then
			procMessage = procOpt.message
		else
			procMessage = self.opt.Messages.message
		end
		local color = nil
		if not procOpt.color then
			color = self.opt.Messages.color
		else
			color = procOpt.color
		end
		self:Pour(pourBefore..procMessage:format(proc.name),color.r,color.g,color.b);
	end
	
	-- Sound
	if procOpt.soundfile ~= nil then
		PlaySoundFile(LSM:Fetch("sound", procOpt.soundfile)) 
	elseif self.opt.Sound.SoundFile then
		PlaySoundFile(LSM:Fetch("sound", self.opt.Sound.SoundFile))
	end

	-- Flash Screen
	if procOpt.flash or (self.opt.Effects.Flash and (procOpt.flash ~= false or procOpt.flash == nil)) then
		self:Flash()
	end

	-- Shake Screen
	if procOpt.shake or (self.opt.Effects.Shake and (procOpt.shake ~= false or procOpt.shake == nil)) then
		self:Shake()
	end
end

-- Used to setup the default proc options.
function Proculas:insertProcOpts(id)
	self.optpc.procoptions[id] = {
		name = self.opt.tracked[id].name,
		spellID = self.opt.tracked[id].spellID,
		enabled = true,
		custommessage = false,
		message = self.opt.Messages.message,
		updatecd = true,
	}
end

-- Used to get the proc options.
function Proculas:GetProcOptions(id)
	if not self.optpc.procoptions[id] then
		self:insertProcOpts(id)
	end
	local procInfo = self.optpc.procoptions[id]
	return procInfo;
end

-- Does the required things when something procs
function Proculas:processProc(spellID,procName,isaura)
	-- Check if the procstats record exists or not
	if not self.procstats[spellID] then
		local theIcon = ''
		if self.opt.tracked[spellID] then
			theIcon = self.opt.tracked[spellID].icon
		end
		self.procstats[spellID] = {
			spellID = spellID,
			name = procName,
			count = 0,
			totaltime = 0, 
			cooldown = 0, 
			lastprocced = 0,
			started = 0,
			uptime = 0,
			icon = theIcon,
		}
	end
	if not self.procopts[spellID] then
		self:insertProcOpts(spellID)
	end
		
	-- Get the proc info
	local proc = self.procstats[spellID]
	local procOpt = self.procopts[spellID]
	
	-- Check if its enabled or not.
	if not procOpt.enabled then
		return nil
	end
	
	-- Check Cooldown
	if procOpt.updatecd and proc.lastprocced > 0 and ((proc.cooldown == 0) or (time() - proc.lastprocced < proc.cooldown)) then
		local proccd = time() - proc.lastprocced
		if(proccd == 0) then
			proc.zerocd = true
		end
		if(proc.zerocd) then
			proc.cooldown = 0
		else
			proc.cooldown = time() - proc.lastprocced
			if self.opt.postprocs and time() - proc.lastprocced < 600 and time() - proc.lastprocced > 4 then
				self:Print("New cooldown found for "..proc.name..": "..proc.cooldown.."s")
			end
		end
	end

	-- Update Calculation
	if(isaura) then
		if proc.started == 0 then
			proc.started = time()
			self.activeprocs[spellID] = spellID
		end
	end
	
	-- Reset cooldown bar
	if (procOpt.cooldown or (self.opt.Cooldowns.cooldowns and (procOpt.cooldown ~= false or procOpt.cooldown == nil))) and proc.cooldown > 0 then
		local bar = self.procCooldowns:GetBar(proc.name)
		if not bar then
			bar = self.procCooldowns:NewTimerBar(proc.name, proc.name, proc.cooldown, proc.cooldown, proc.icon, self.opt.Cooldowns.flashTimer)
		end
		bar:SetTimer(proc.cooldown, proc.cooldown)
	end

	-- Set the lastprocced time and increment the proc count
	proc.lastprocced = time()
	proc.count = proc.count+1
	
	-- Calls the postProc function, duh?
	self:postProc(proc)
end
function Proculas:testBars()
	self.procCooldowns:NewTimerBar("Test", "test", 10, 10, "Interface\\Icons\\Spell_Holy_WordFortitude", self.opt.Cooldowns.flashTimer)
end
-------------------------------------------------------
-- Proc CD Frame
function Proculas:CreateCDFrame()
	self.procCooldowns = self:NewBarGroup("Proc Cooldowns", nil, self.opt.Cooldowns.barWidth, self.opt.Cooldowns.barHeight, "ProculasProcCD")
	self.procCooldowns:SetFont(LSM:Fetch('font', self.opt.Cooldowns.barFont), self.opt.Cooldowns.barFontSize)
	self.procCooldowns:SetTexture(LSM:Fetch('statusbar', self.opt.Cooldowns.barTexture))
	self.procCooldowns:SetColorAt(1.00, self.opt.Cooldowns.colorStart.r, self.opt.Cooldowns.colorStart.g, self.opt.Cooldowns.colorStart.b, self.opt.Cooldowns.colorStart.a) --1.0, 0.2, 0.2, 0.8)
	self.procCooldowns:SetColorAt(0.25, self.opt.Cooldowns.colorEnd.r, self.opt.Cooldowns.colorEnd.g, self.opt.Cooldowns.colorEnd.b, self.opt.Cooldowns.colorEnd.a) --0.30, 0.8, 0.1, 0.8)
	self.procCooldowns.RegisterCallback(self, "AnchorClicked")
	self.procCooldowns:SetUserPlaced(true)
	self.procCooldowns:ReverseGrowth(self.opt.Cooldowns.reverseGrowth)
		
	local bar = self.procCooldowns:NewTimerBar("Test Cooldown", "Test Cooldown", 10, 10)
	bar:SetHeight(20)
	bar:SetTimer(0, 0)
	
	if(self.opt.Cooldowns.show) then
		self.procCooldowns:Show()
	else
		self.procCooldowns:Hide()
	end
	
	self:setMovableCooldownsFrame(self.opt.Cooldowns.movableFrame)
end
function Proculas:AnchorClicked(...)
	local button = select(3,...)
	if button == "RightButton" then
		self:setMovableCooldownsFrame(false)
	end
end
function Proculas:setMovableCooldownsFrame(movable)
	self.opt.Cooldowns.movableFrame = movable
	if movable then
		self.procCooldowns:ShowAnchor()
	else
		self.procCooldowns:HideAnchor()
	end
end
function Proculas:updateCooldownsFrame()
	self.procCooldowns:SetFont(LSM:Fetch('font', self.opt.Cooldowns.barFont), self.opt.Cooldowns.barFontSize)
	self.procCooldowns:SetWidth(self.opt.Cooldowns.barWidth)
	self.procCooldowns:SetHeight(self.opt.Cooldowns.barHeight)
	self.procCooldowns:SetTexture(LSM:Fetch('statusbar', self.opt.Cooldowns.barTexture))
	self.procCooldowns:SetColorAt(1.00, self.opt.Cooldowns.colorStart.r, self.opt.Cooldowns.colorStart.g, self.opt.Cooldowns.colorStart.b, self.opt.Cooldowns.colorStart.a)
	self.procCooldowns:SetColorAt(0.25, self.opt.Cooldowns.colorEnd.r, self.opt.Cooldowns.colorEnd.g, self.opt.Cooldowns.colorEnd.b, self.opt.Cooldowns.colorEnd.a)
	self.procCooldowns:ReverseGrowth(self.opt.Cooldowns.reverseGrowth)
	self:setMovableCooldownsFrame(self.opt.Cooldowns.movableFrame)
	if(self.opt.Cooldowns.show) then
		self.procCooldowns:Show()
	else
		self.procCooldowns:Hide()
	end
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


-- Rescans the players gear when they change an item
function Proculas:UNIT_INVENTORY_CHANGED(event,unit)
	if unit == "player" then
		self:scanForProcs()
	end
end

-- Used to check if the Combat Log Event Type (type) is in the types array.
local function checktype(types,type)
	for _,thisType in pairs(types) do
		if(thisType == type) then
			return true
		end
	end
	return false
end

-- The Proc scanner, scans the combat log for proc spells
-- This sweet little Proc Tracker here is Copyright (c) Clorell
function Proculas:COMBAT_LOG_EVENT_UNFILTERED(event,...)
	local msg,type,msg2,name,msg3,msg4,name2 = select(1, ...)
	local spellId, spellName, spellSchool = select(9, ...)
	
	-- Check if the type is SPELL_AURA_APPLIED
	local isaura = false
	if(type == "SPELL_AURA_APPLIED") then
		isaura = true
	end
	
	-- Gems
	-- Done like this because finding the GemID isn't easy.
	if(self.Procs.Gems[spellId]) then
		local procInfo = self.Procs.Gems[spellId]
		local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture = GetItemInfo(procInfo.itemID)
		procInfo.icon = itemTexture
		if(checktype(procInfo.types,type)) then
			if(name == self.playerName) then
				if(procInfo.selfOnly and name == self.playerName and name2 == self.playerName) then
					self:processProc(spellId,procInfo.name,isaura)
				elseif procInfo.selfOnly == 0 then
					self:processProc(spellId,procInfo.name,isaura)
				end
			elseif(name == nil and name2 == self.playerName) then
				self:processProc(spellId,procInfo.name,isaura)
			end
		end
	end
	
	-- Everything else
	if(self.opt.tracked[spellId]) then
		local procInfo = self.opt.tracked[spellId]
		if(checktype(procInfo.types,type)) then
			if(name == self.playerName) then
				if(procInfo.selfOnly and name2 == self.playerName) then
					self:processProc(spellId,procInfo.name,isaura)
				elseif procInfo.selfOnly == 0 then
					self:processProc(spellId,procInfo.name,isaura)
				end
			elseif(name == nil and name2 == self.playerName) then
				self:processProc(spellId,procInfo.name,isaura)
			end
		end
	end
	
	-- Aura Removed/Expired
	if(self.opt.tracked[spellId]) then
		local procInfo = self.opt.tracked[spellId]
		if(type == "SPELL_AURA_REMOVED") then
			if(name == self.playerName) then
				for index,spellid in pairs(self.activeprocs) do
					local proc = self.procstats[spellid]
					proc.started = 0
					self.activeprocs[index] = nil
				end
			end
		end
	end
end

-------------------------------------------------------
-- Other/Misc Functions

-- Used to put item proc stats into the items tooltip.
function Proculas:OnTooltipSetItem(tooltip, ...)
	local itemName, itemLink = tooltip:GetItem()
	if not itemLink then return nil end -- possibly fixes "bad argument #1 to find: string expected got nil"
	local found, _, itemString = string.find(itemLink, "^|c%x+|H(.+)|h%[.*%]")
	local itemId = select(2, strsplit(":", itemString))
	
	-- Tracked items
	for index,proc in pairs(self.opt.tracked) do
		if proc.itemID ~= nil and tostring(proc.itemID) == itemId then
			self:addProcInfoToTooltip(self.procstats[proc.spellID])
		end
	end
end

-- Prints a detailed version string
function Proculas:debugVersion()
	print("---------------------------------------------")
	print("Please submit the following line with bug reports:")
	print("Proculas "..self.version.." / Core.lua $Rev$")
	print("---------------------------------------------")
end

-- Resets the proc stats
function Proculas:resetProcStats()
	self.dbpc.profile.procstats = {}
	self.procstats = {}
end

-- Used to get the tracked procs
function Proculas:getTrackedProcs()
	return self.opt.tracked
end

-- About Proculas
function Proculas:AboutProculas()
	self:Print("Version "..VERSION)
	self:Print("Created by Clorell/Keruni of Argent Dawn [US]")
end

-- Used to bring up the Config/Options window
function Proculas:ShowConfig()
	-- Open the profiles tab before, so the menu expands
	local Options = self:GetModule("ProculasOptions")
	InterfaceOptionsFrame_OpenToCategory(Options.optionsFrames.Profiles)
	InterfaceOptionsFrame_OpenToCategory(Options.optionsFrames.Proculas)
end

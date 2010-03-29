--
-- Proculas
-- Tracks and gatheres stats on Procs.
-- Created by Clorell of Hellscream [US]
-- $Id$
--

-------------------------------------------------------
-- Proculas
Proculas = LibStub("AceAddon-3.0"):NewAddon("Proculas", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0", "LibSink-2.0", "LibEffects-1.0", "LibBars-1.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Proculas", false)
local LSM = LibStub("LibSharedMedia-3.0")

Proculas.enabled = true

-------------------------------------------------------
-- Proculas Version
Proculas.revision = tonumber(("@project-revision@"):match("%d+"))
Proculas.version = GetAddOnMetadata('Proculas', 'Version').." r@project-revision@"
if(Proculas.revision == nil) then
	Proculas.version = "DEV"
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
Proculas.procs = {
	ITEMS = {},
	ENCHANTS = {},
	GEMS = {},
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
-- Things that need to be defined locally
local playerClass = select(2,UnitClass("player"))
local playerName = UnitName("player")
local combatTickTimer

-------------------------------------------------------
-- Startup stuff

-- OnInitialize
function Proculas:OnInitialize()
	self:Print(VERSION.." running.")
	
	-- Database stuff
	self.db = LibStub("AceDB-3.0"):New("ProculasDB", self.defaults)
	self.dbpc = LibStub("AceDB-3.0"):New("ProculasDBPC", self.defaultsPC)
	self.opt = self.db.profile
	self.optpc = self.dbpc.profile
	
	-- Tracked procs
	self.tracked = self.optpc.tracked
	
	-- Active procs
	self.active = {}
	
	-- Create the Cooldown bars frame.
	self:CreateCDFrame()
	
	-- Set the Sink options.
	self:SetSinkStorage(self.opt.sinkOptions)
	
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
	self:scanForProcs();
end

-------------------------------------------------------
-- Custom Sounds

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
-- Time Functions

-- Increments the proc uptime count
function Proculas:combatTick()
	for key,proc in pairs(self.optpc.tracked) do
		-- Update seconds for uptime calculation
		if self.active[proc.spellID] then
			proc.uptime = proc.uptime+1
		end
		-- Update Total Time
		proc.time = proc.time+1
	end
end

-- Does the required things for when the player enters combat
function Proculas:PLAYER_REGEN_DISABLED()
	combatTickTimer = self:ScheduleRepeatingTimer("combatTick", 1)
end

-- Does the required things for when the player leaves combat
function Proculas:PLAYER_REGEN_ENABLED()
	self:CancelTimer(combatTickTimer)
end

-------------------------------------------------------
-- Proc Functions

-- Adds Procs to the Proc List
function Proculas:addProcList(list,procs)
	for id,info in pairs(procs) do
		self.procs[list][id] = info
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
				if(self.procs.ENCHANTS[enchID]) then
					if not self.optpc.tracked[enchID] then
						local procInfo = self.Procs.Enchants[enchID]
						local name, rank, icon, cost, isFunnel, powerType, castTime, minRange, maxRange = GetSpellInfo(procInfo.spellID)
						procInfo.icon = icon
						procInfo.name = name
						self:addProc(procInfo)
					end
				end
			end
			
			-- Items
			itemId = tonumber(itemId)
			if self.procs.ITEMS[itemId] then
				for _,spell in pairs(self.procs.ITEMS[itemId].spellIds) do
					if not self.optpc.tracked[spell] then
						local procInfo = self.procs.ITEMS[itemId];
						procInfo.name = itemName
						procInfo.icon = itemTexture
						procInfo.itemID = itemId
						procInfo.spellID = spell
						self:addProc(procInfo)
					end
				end
			end
		end
	end
end

-- Scans for Procs
function Proculas:scanForProcs()
	self:Print("Scanning for procs");
	
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
	for index,procs in pairs(self.procs) do
		if(index == playerClass) then
			for spellID,procInfo in pairs(procs) do
				procInfo.spellID = spellID
				local name, rank, icon = GetSpellInfo(spellID)
				procInfo.icon = icon
				procInfo.name = name
				procInfo.rank = rank
				self:addProc(procInfo)
			end
		end
	end
end

-- Adds a proc to the tracked procs
function Proculas:addProc(procInfo)
	if not self.optpc.tracked[procInfo.spellID] then
		procInfo.count = 0
		procInfo.started = 0
		procInfo.uptime = 0
		procInfo.cooldown = 0
		procInfo.lastProc = 0
		procInfo.updateCD = true
		procInfo.enabled = true
		procInfo.time = 0
		self.optpc.tracked[procInfo.spellID] = procInfo
		self:Print("Added proc: "..procInfo.name);
	end
end

-- Resets the proc stats
function Proculas:resetProcStats()
	-- some kind of loop here to reset tracked proc stats.
end

-------------------------------------------------------
-- Proc Cooldown Frame

-- Create Frame
function Proculas:CreateCDFrame()
	self.procCooldowns = self:NewBarGroup(L["Proc Cooldowns"], nil, self.opt.cooldowns.barWidth, self.opt.cooldowns.barHeight, "ProculasProcCD")
	self.procCooldowns:SetFont(LSM:Fetch('font', self.opt.cooldowns.barFont), self.opt.cooldowns.barFontSize)
	self.procCooldowns:SetTexture(LSM:Fetch('statusbar', self.opt.cooldowns.barTexture))
	self.procCooldowns:SetColorAt(1.00, self.opt.cooldowns.colorStart.r, self.opt.cooldowns.colorStart.g, self.opt.cooldowns.colorStart.b, self.opt.cooldowns.colorStart.a)
	self.procCooldowns:SetColorAt(0.25, self.opt.cooldowns.colorEnd.r, self.opt.cooldowns.colorEnd.g, self.opt.cooldowns.colorEnd.b, self.opt.cooldowns.colorEnd.a)
	self.procCooldowns.RegisterCallback(self, "AnchorClicked")
	self.procCooldowns:SetUserPlaced(true)
	self.procCooldowns:ReverseGrowth(self.opt.cooldowns.reverseGrowth)
		
	if(self.opt.cooldowns.show) then
		self.procCooldowns:Show()
	else
		self.procCooldowns:Hide()
	end
	
	self:setMovableCooldownsFrame(self.opt.cooldowns.movableFrame)
end

-- Anchor Clicked
function Proculas:AnchorClicked(...)
	local button = select(3,...)
	if button == "RightButton" then
		self:setMovableCooldownsFrame(false)
	end
end

-- Set Movable
function Proculas:setMovableCooldownsFrame(movable)
	self.opt.cooldowns.movableFrame = movable
	if movable then
		self.procCooldowns:ShowAnchor()
	else
		self.procCooldowns:HideAnchor()
	end
end

-- Update Frame
function Proculas:updateCooldownsFrame()
	self.procCooldowns:SetFont(LSM:Fetch('font', self.opt.cooldowns.barFont), self.opt.cooldowns.barFontSize)
	self.procCooldowns:SetWidth(self.opt.cooldowns.barWidth)
	self.procCooldowns:SetHeight(self.opt.cooldowns.barHeight)
	self.procCooldowns:SetTexture(LSM:Fetch('statusbar', self.opt.cooldowns.barTexture))
	self.procCooldowns:SetColorAt(1.00, self.opt.cooldowns.colorStart.r, self.opt.cooldowns.colorStart.g, self.opt.cooldowns.colorStart.b, self.opt.cooldowns.colorStart.a)
	self.procCooldowns:SetColorAt(0.25, self.opt.cooldowns.colorEnd.r, self.opt.cooldowns.colorEnd.g, self.opt.cooldowns.colorEnd.b, self.opt.cooldowns.colorEnd.a)
	self.procCooldowns:ReverseGrowth(self.opt.cooldowns.reverseGrowth)
	self:setMovableCooldownsFrame(self.opt.cooldowns.movableFrame)
	if(self.opt.cooldowns.show) then
		self.procCooldowns:Show()
	else
		self.procCooldowns:Hide()
	end
end

-------------------------------------------------------
-- Event Functions

-- Rescans the players gear when they change an item
function Proculas:UNIT_INVENTORY_CHANGED(event,unit)
	if unit == "player" then
		self:scanForProcs()
	end
end

-------------------------------------------------------
-- Local Functions

-- Used to check if the Combat Log Event Type (type) is in the types array.
local function checkType(types,type)
	for _,thisType in pairs(types) do
		if(thisType == type) then
			return true
		end
	end
	return false
end

function Proculas:postProc(spellID)
	local procInfo = self.optpc.tracked[spellID]
	
	-- Sink
	local pourBefore = ""
	if(self.opt.sinkOptions.sink20OutputSink == "Channel") then
		pourBefore = "[Proculas]: "
	end
	if procInfo.postProc or (self.opt.postProcs and (procInfo.postProc ~= false or procInfo.postProc == nil)) then
		local procMessage
		if procInfo.customMessage then
			procMessage = procInfo.message
		else
			procMessage = self.opt.announce.message
		end
		local color = nil
		if not procInfo.color then
			color = self.opt.announce.color
		else
			color = procInfo.color
		end
		self:Pour(pourBefore..procMessage:format(procInfo.name),color.r,color.g,color.b);
	end
	
	-- Sound
	if procInfo.soundFile ~= nil then
		PlaySoundFile(LSM:Fetch("sound", procInfo.soundFile)) 
	elseif self.opt.sound.soundFile then
		PlaySoundFile(LSM:Fetch("sound", self.opt.sound.soundFile))
	end
end

function Proculas:processProc(spellID,isAura)
	if isAura then
		self.active[spellID] = spellID
	end
	
	local procInfo = self.optpc.tracked[spellID]
	
	-- Post Proc
	self:postProc(spellID)
	
	-- Check Cooldown
	if procInfo.updateCD and procInfo.lastProc > 0 and ((procInfo.cooldown == 0) or (time() - procInfo.lastProc < procInfo.cooldown)) then
		local proccd = time() - procInfo.lastProc
		if(proccd == 0) then
			procInfo.zeroCD = true
		end
		if(procInfo.zeroCD) then
			procInfo.cooldown = 0
		else
			procInfo.cooldown = time() - procInfo.lastProc
		end
	end

	-- Uptime Calculation
	if isAura and procInfo.started == 0 then
			procInfo.started = time()
			self.active[spellID] = spellID
		
	end
	
	-- Reset cooldown bar
	if (procInfo.cooldown or (self.opt.cooldowns.cooldowns and (procInfo.cooldown ~= false or procInfo.cooldown == nil))) and procInfo.cooldown > 0 then
		local bar = self.procCooldowns:GetBar(procInfo.name)
		if not bar then
			bar = self.procCooldowns:NewTimerBar(procInfo.spellID, procInfo.name, procInfo.cooldown, procInfo.cooldown, procInfo.icon, self.opt.cooldowns.flashTimer)
		end
		bar:SetTimer(procInfo.cooldown, procInfo.cooldown)
	end
	
	-- Count
	procInfo.count = procInfo.count+1
	procInfo.lastProc = time()
end

-------------------------------------------------------
-- The Proc scanner, scans the combat log for proc spells
-- This sweet little Proc Tracker here is Copyright (c) Xocide
function Proculas:COMBAT_LOG_EVENT_UNFILTERED(event,...)
	local msg,type,msg2,name,msg3,msg4,name2 = select(1, ...)
	local spellId, spellName, spellSchool = select(9, ...)
	
	-- Check if the type is SPELL_AURA_APPLIED
	local isaura = false
	if(type == "SPELL_AURA_APPLIED") then
		isaura = true
	end
	
	-- Check if its a proc
	if(self.optpc.tracked[spellId]) then
		-- Fetch procInfo
		local procInfo = self.optpc.tracked[spellId]
		
		-- Check if this is the right combat event for the proc
		if(checkType(procInfo.types,type)) then
			-- Check if its from the right player
			if(name == playerName) then
				if(procInfo.onSelfOnly and name2 == playerName) then
					self:processProc(spellId,isaura)
				elseif procInfo.onSelfOnly == 0 then
					self:processProc(spellId,isaura)
				end
			elseif(name == nil and name2 == playerName) then
				self:processProc(spellId,isaura)
			end
		end
	end
	
	-- Aura Removed/Expired
	if self.optpc.tracked[spellId] and type == "SPELL_AURA_REMOVED" then
		if name == playerName and self.active[spellId] then
			local procInfo = self.optpc.tracked[spellId]
			for index,spID in pairs(self.active) do
				procInfo.started = 0
				self.active[spellId] = nil
			end
		end
	end
end

-------------------------------------------------------
-- Misc. Functions

-- About Proculas
function Proculas:AboutProculas()
	self:Print("Version "..VERSION)
	self:Print("Created by Clorell/Mcstabin/Shift of US Hellscream")
end

-------------------------------------------------------
-- Used to bring up the Config/Options window
function Proculas:ShowConfig()
	local Options = self:GetModule("Options")
	InterfaceOptionsFrame_OpenToCategory(Options.optionsFrames.Profiles)
	InterfaceOptionsFrame_OpenToCategory(Options.optionsFrames.Proculas)
end
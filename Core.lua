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
	self.db = LibStub("AceDB-3.0"):New("ProculasDB", self.defaults)
	self.opt = self.db.profile
	self.procstats = self.opt.procstats
	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")
	
	GameTooltip:HookScript("OnTooltipSetItem", function(tooltip, item) Proculas:OnTooltipSetItem(tooltip,item) end)
	
	self:CreateCDFrame()
	
	self:SetSinkStorage(self.opt.SinkOptions)
	--self:SetupOptions()
end

function Proculas:OnTooltipSetItem(tooltip, ...)
	local itemName, itemLink = tooltip:GetItem()
	local found, _, itemString = string.find(itemLink, "^|c%x+|H(.+)|h%[.*%]")
	local itemId = select(2, strsplit(":", itemString))
	
	-- Tracked items
	for index,proc in pairs(self.opt.tracked) do
		if proc.itemID ~= nil and tostring(proc.itemID) == itemId then
			self:addProcInfoToTooltip(self.procstats[proc.spellID])
		end
	end
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
				procInfo.itemID = itemId
				self:addProc(procInfo)
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
function Proculas:postProc(spellID,procName)
	spellName = GetSpellInfo(spellID)
	-- Post Proc
	if (self.opt.postprocs) then
		-- Chat Frame
		if (self.opt.PostChatFrame) then
			self:Print(self.opt.Messages.before..procName..self.opt.Messages.after)
		end
		local pourBefore = ""
		if(self.opt.SinkOptions.sink20OutputSink == "Channel") then
			pourBefore = "[Proculas]: "
		end
		self:Pour(pourBefore..self.opt.Messages.before..procName..self.opt.Messages.after);
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
			
			self:addProcInfoToTooltip(proc)
			
			GameTooltip:AddLine(" ")
		end
	end
end

function Proculas:addProcInfoToTooltip(procInfo)
	if procInfo.count > 0 then
		GameTooltip:AddDoubleLine(L["PROCS"], procInfo.count, nil, nil, nil, 1,1,1)
	else
		GameTooltip:AddDoubleLine(L["PROCS"], "N/A", nil, nil, nil, 1,1,1)
	end
	
	local ppm = 0
	if procInfo.count > 0 then
		ppm = procInfo.count / (procInfo.totaltime / 60)
	end
	
	if ppm > 0 then
		GameTooltip:AddDoubleLine(L["PPM"], string.format("%.2f", ppm), nil, nil, nil, 1,1,1)
	else
		GameTooltip:AddDoubleLine(L["PPM"], "N/A", nil, nil, nil, 1,1,1)
	end
	
	if procInfo.cooldown > 0 then
		GameTooltip:AddDoubleLine(L["COOLDOWN"], procInfo.cooldown.."s", nil, nil, nil, 1,1,1)
	else
		GameTooltip:AddDoubleLine(L["COOLDOWN"], "N/A", nil, nil, nil, 1,1,1)
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
		if self.opt.postprocs and proc.cooldown < 300 and proc.cooldown > 4 then
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
	self.procCooldowns = self:NewBarGroup("Proc Cooldowns", nil, self.opt.Cooldowns.barWidth, self.opt.Cooldowns.barHeight, "ProculasProcCD")
	self.procCooldowns:SetFont(LSM:Fetch('font', self.opt.Cooldowns.barFont), self.opt.Cooldowns.barFontSize)
	self.procCooldowns:SetTexture(LSM:Fetch('statusbar', self.opt.Cooldowns.barTexture))
	self.procCooldowns:SetColorAt(1.00, 1.0, 0.2, 0.2, 0.8)
	self.procCooldowns:SetColorAt(0.25, 0.30, 0.8, 0.1, 0.8)
	self.procCooldowns.RegisterCallback(self, "AnchorClicked")
	self.procCooldowns:SetUserPlaced(true)
	self.procCooldowns:ReverseGrowth(self.opt.Cooldowns.reverseGrowth or false)
		
	local bar = self.procCooldowns:NewTimerBar("Test Bar", "Test Bar", 10, 10)
	bar:SetHeight(18)
	bar:SetTimer(0, 0)
	
	if(self.opt.Cooldowns.show) then
		self.procCooldowns:Show()
	else
		self.procCooldowns:Hide()
	end
	
	self:setMovableCooldownsFrame(self.opt.Cooldowns.movableFrame)
end
function Proculas:AnchorClicked(cbk, group, button)
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
	self.procCooldowns:ReverseGrowth(self.opt.Cooldowns.reverseGrowth)
	self:setMovableCooldownsFrame(self.opt.Cooldowns.movableFrame)
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

-- Resets the proc stats
function Proculas:resetProcStats()
	self.opt.procstats = {}
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

--
-- Proculas
-- Tracks and gatheres stats on Procs.
--
-- Copyright (c) Xocide, who is:
--  - Idunno of US Nagrand
--

local playerName = UnitName("player")

-------------------------------------------------------
-- The Proc scanner, scans the combat log for proc spells
-- This sweet little Proc Tracker here is Copyright (c) Xocide

local untrackedTypes = {
	SPELL_AURA_REMOVED = true,
	SPELL_CAST_FAILED = true,
	SPELL_CAST_SUCCESS = true
}

function Proculas:COMBAT_LOG_EVENT_UNFILTERED()
	local timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool = CombatLogGetCurrentEventInfo()

	-- self:Print( timestamp, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool)
	-- self:Print('timestamp', timestamp)
	-- self:Print('eventType', eventType)
	-- self:Print('hideCaster', hideCaster)
	-- self:Print('sourceGUID', sourceGUID)
	-- self:Print('sourceName', sourceName)
	-- self:Print('sourceFlags', sourceFlags)
	-- self:Print('sourceRaidFlags', sourceRaidFlags)
	-- self:Print('destGUID', destGUID)
	-- self:Print('destName', destName)
	-- self:Print('destFlags', destFlags)
	-- self:Print('destRaidFlags', destRaidFlags)
	-- self:Print('spellId', spellId)
	-- self:Print('spellName', spellName)
	-- self:Print('spellSchool', spellSchool)

	if self.opt.debug.mySpellInfoInChat and sourceName == playerName and untrackedTypes[event] == nil then
		self:Print(spellName .. ": " .. spellId .. " - event: " .. event)
	end

	-- Check if the type is SPELL_AURA_APPLIED
	local isAura = false
	if(event == "SPELL_AURA_APPLIED") then
		isAura = true
	end

	if self.optpc.tracked[spellId] and untrackedTypes[event] == nil then
		-- Fetch procInfo
		local procInfo = self.optpc.tracked[spellId]
		local procData = self.optpc.procs[procInfo.procId]

		self:debug("Tracked proc found: "..procInfo.name)
		self:debug("Event not in untracked list ("..event..")")

		if sourceName == playerName
		or (sourceName ~= nil and sourceName == UNKNOWN and destName == playerName)
		or (sourceName == nil and destName ~= nil and destName == playerName) then
			self:debug("Event is related to player ("..playerName..")")
			if (procInfo.onSelfOnly == 0 or procInfo.onSelfOnly == false) then
				self:debug("Sending tracked proc to processProc(): "..procInfo.name)
				self:processProc(spellId, isAura)
			elseif(procInfo.onSelfOnly and destName == playerName) then
				self:debug("Sending tracked proc to processProc(): "..procInfo.name)
				self:processProc(spellId, isAura)
			end
		end
	end

	-- Aura Removed/Expired
	if self.optpc.tracked[spellId] and event == "SPELL_AURA_REMOVED" then
		local procInfo = self.optpc.tracked[spellId]
		if sourceName == playerName and self.active[procInfo.procId] then
			local procData = self.optpc.procs[procInfo.procId]
			for index,spID in pairs(self.active) do
				procData.started = 0
				self.active[procInfo.procId] = nil
			end
		end
	end
end

--
-- Proculas: Rogue Procs
-- Created by Clorell of US Hellscream
--
-- Generated by ProcDB 2.0
--

if select(2, UnitClass("player")) ~= "ROGUE" then return end

local Proculas = LibStub("AceAddon-3.0"):GetAddon("Proculas")
local RogueProcs = Proculas:NewModule("RogueProcs")

if not Proculas.enabled then
	return nil
end

local PROCS = {
	[66923] = {types={"SPELL_EXTRA_ATTACKS"},onSelfOnly=0}, -- Proc #7: Hack and Slash
}

function RogueProcs:OnInitialize()
	Proculas:addProcList('ROGUE',PROCS)
end
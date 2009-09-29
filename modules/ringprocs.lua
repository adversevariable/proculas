--
-- Proculas: Ring Procs
-- Created by Clorell of Hellscream [US]
--
-- Generated by Proculas ProcDB Manager 1.3
--

local Proculas = LibStub("AceAddon-3.0"):GetAddon("Proculas")
local ProculasRing = Proculas:NewModule("RingProcs")

if not Proculas.enabled then
	return nil
end

local PROCS = {
	[44308] = {
		spellID = 60318,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 41 
		-- name: Signet of Edward the Odd 
		-- type: ring 
	},
}

function ProculasRing:OnInitialize()
	Proculas:addProcList('Items',PROCS)
end

local Proculas = LibStub("AceAddon-3.0"):GetAddon("Proculas")
ProculasRing = Proculas:NewModule("ProculasRing")

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
	Proculas:Print("Ring Procs Loaded")
end

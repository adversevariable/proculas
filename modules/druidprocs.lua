local Proculas = LibStub("AceAddon-3.0"):GetAddon("Proculas")
ProculasDruid = Proculas:NewModule("ProculasDruid")

local PROCS = {
	[16870] = {
		name = "Clearcasting",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 133 
		-- name: Clearcasting 
		-- type: DRUID 
	},
	[48518] = {
		name = "Eclipse",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 134 
		-- name: Eclipse 
		-- type: DRUID 
	},
	[48517] = {
		name = "Eclipse",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 135 
		-- name: Eclipse 
		-- type: DRUID 
	},
}

function ProculasDruid:OnInitialize()
	Proculas:addProcList('DRUID',PROCS)
	Proculas:Print("Druid Procs Loaded")
end

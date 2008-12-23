local Proculas = LibStub("AceAddon-3.0"):GetAddon("Proculas")
ProculasWarlock = Proculas:NewModule("ProculasWarlock")

local PROCS = {
	[17941] = {
		name = "Nightfall",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 108 
		-- name: Nightfall 
		-- type: WARLOCK 
	},
	[54274] = {
		name = "Backdraft",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 109 
		-- name: Backdraft 
		-- type: WARLOCK 
	},
	[54276] = {
		name = "Backdraft",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 110 
		-- name: Backdraft 
		-- type: WARLOCK 
	},
	[54277] = {
		name = "Backdraft",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 111 
		-- name: Backdraft 
		-- type: WARLOCK 
	},
}

function ProculasWarlock:OnInitialize()
	Proculas:addProcList('WARLOCK',PROCS)
	Proculas:Print("Warlock Procs Loaded")
end

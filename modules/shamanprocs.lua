local Proculas = LibStub("AceAddon-3.0"):GetAddon("Proculas")
ProculasShaman = Proculas:NewModule("ProculasShaman")

local PROCS = {
	[16246] = {
		name = "Clearcasting",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 136 
		-- name: Clearcasting 
		-- type: SHAMAN 
	},
	[16257] = {
		name = "Flurry",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 137 
		-- name: Flurry 
		-- type: SHAMAN 
	},
	[16281] = {
		name = "Flurry",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 138 
		-- name: Flurry 
		-- type: SHAMAN 
	},
	[16282] = {
		name = "Flurry",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 139 
		-- name: Flurry 
		-- type: SHAMAN 
	},
	[16283] = {
		name = "Flurry",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 140 
		-- name: Flurry 
		-- type: SHAMAN 
	},
	[16284] = {
		name = "Flurry",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 141 
		-- name: Flurry 
		-- type: SHAMAN 
	},
	[16280] = {
		name = "Flurry",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 142 
		-- name: Flurry 
		-- type: SHAMAN 
	},
}

function ProculasShaman:OnInitialize()
	Proculas:addProcList('SHAMAN',PROCS)
	Proculas:Print("Shaman Procs Loaded")
end

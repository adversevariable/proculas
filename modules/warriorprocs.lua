local Proculas = LibStub("AceAddon-3.0"):GetAddon("Proculas")
ProculasWarrior = Proculas:NewModule("ProculasWarrior")

local PROCS = {
	[12966] = {
		name = "Flurry",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 118 
		-- name: Flurry 
		-- type: WARRIOR 
	},
	[12967] = {
		name = "Flurry",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 119 
		-- name: Flurry 
		-- type: WARRIOR 
	},
	[12968] = {
		name = "Flurry",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 120 
		-- name: Flurry 
		-- type: WARRIOR 
	},
	[12969] = {
		name = "Flurry",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 121 
		-- name: Flurry 
		-- type: WARRIOR 
	},
	[12970] = {
		name = "Flurry",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 122 
		-- name: Flurry 
		-- type: WARRIOR 
	},
	[12880] = {
		name = "Enrage",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 123 
		-- name: Enrage 
		-- type: WARRIOR 
	},
	[14201] = {
		name = "Enrage",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 124 
		-- name: Enrage 
		-- type: WARRIOR 
	},
	[14202] = {
		name = "Enrage",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 125 
		-- name: Enrage 
		-- type: WARRIOR 
	},
	[14203] = {
		name = "Enrage",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 126 
		-- name: Enrage 
		-- type: WARRIOR 
	},
	[14204] = {
		name = "Enrage",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 127 
		-- name: Enrage 
		-- type: WARRIOR 
	},
	[46916] = {
		name = "Bloodsurge",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 128 
		-- name: Bloodsurge 
		-- type: WARRIOR 
	},
}

function ProculasWarrior:OnInitialize()
	Proculas:addProcList('WARRIOR',PROCS)
	Proculas:Print("Warrior Procs Loaded")
end
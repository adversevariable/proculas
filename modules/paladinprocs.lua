local Proculas = LibStub("AceAddon-3.0"):GetAddon("Proculas")
ProculasPaladin = Proculas:NewModule("ProculasPaladin")

local PROCS = {
	[31930] = {
		name = "Judgements of the Wise",
		types = {"SPELL_ENERGIZE"},
		selfOnly = 1,
		-- Proc Info
		-- ID: 87 
		-- name: Judgements of the Wise 
		-- type: PALADIN 
	},
	[53489] = {
		name = "The Art of War",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 131 
		-- name: The Art of War 
		-- type: PALADIN 
	},
	[59578] = {
		name = "The Art of War",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 132 
		-- name: The Art of War 
		-- type: PALADIN 
	},
	[54203] = {
		name = "Sheath of Light",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 149 
		-- name: Sheath of Light 
		-- type: PALADIN 
	},
	[20050] = {
		name = "Vengeance",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 150 
		-- name: Vengeance 
		-- type: PALADIN 
	},
	[20052] = {
		name = "Vengeance",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 151 
		-- name: Vengeance 
		-- type: PALADIN 
	},
	[20053] = {
		name = "Vengeance",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 152 
		-- name: Vengeance 
		-- type: PALADIN 
	},
	[61840] = {
		name = "Righteous Vengeance",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 153 
		-- name: Righteous Vengeance 
		-- type: PALADIN 
	},
}

function ProculasPaladin:OnInitialize()
	Proculas:addProcList('PALADIN',PROCS)
	Proculas:Print("Paladin Procs Loaded")
end

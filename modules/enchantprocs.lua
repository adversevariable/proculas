local Proculas = LibStub("AceAddon-3.0"):GetAddon("Proculas")
ProculasEnchant = Proculas:NewModule("ProculasEnchant")

local PROCS = {
	[803] = {
		spellID = 50265,
		name = "Fiery Weapon",
		types = {"SPELL_DAMAGE"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 103
		-- name: Fiery Weapon
		-- type: enchant
	},
	[2673] = {
		spellID = 28093,
		name = "Mongoose",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 145
		-- name: Mongoose
		-- type: enchant
	},
	[2674] = {
		spellID = 27996,
		name = "Spellsurge",
		types = {"SPELL_ENERGIZE"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 146
		-- name: Spellsurge
		-- type: enchant
	},
	[1900] = {
		spellID = 20007,
		name = "Crusader",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 147
		-- name: Crusader
		-- type: enchant
	},
	[3225] = {
		spellID = 42976,
		name = "Executioner",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 148
		-- name: Executioner
		-- type: enchant
	},
	[0] = {
		spellID = 44578,
		name = "Lifeward",
		types = {"SPELL_HEAL"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 154
		-- name: Lifeward
		-- type: enchant
	},
	[0] = {
		spellID = 59626,
		name = "Black Magic",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 155
		-- name: Black Magic
		-- type: enchant
	},
	[0] = {
		spellID = 59620,
		name = "Berserking",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 156
		-- name: Berserking
		-- type: enchant
	},
}

function ProculasEnchant:OnInitialize()
	Proculas:addProcList('Enchants',PROCS)
	Proculas:Print("Enchant Procs Loaded")
end
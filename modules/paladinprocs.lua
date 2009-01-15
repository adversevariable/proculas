--
-- Proculas: Paladin Procs
-- Created by Clorell/Keruni of Argent Dawn [US]
--
-- Generated by Proculas ProcDB Manager 1.3
--

if select(2, UnitClass("player")) ~= "PALADIN" then return end

local Proculas = LibStub("AceAddon-3.0"):GetAddon("Proculas")
local ProculasPaladin = Proculas:NewModule("PaladinProcs")

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
	[20424] = {
		name = "Seal of Command",
		types = {"SPELL_DAMAGE"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 192 
		-- name: Seal of Command 
		-- type: PALADIN 
	},
	[20168] = {
		name = "Seal of Wisdom",
		types = {"SPELL_PERIODIC_ENERGIZE"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 223 
		-- name: Seal of Wisdom 
		-- type: PALADIN 
	},
	[54149] = {
		name = "Infusion of Light",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 224 
		-- name: Infusion of Light 
		-- type: PALADIN 
	},
}

function ProculasPaladin:OnInitialize()
	Proculas:addProcList('PALADIN',PROCS)
end

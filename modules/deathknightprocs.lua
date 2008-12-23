local Proculas = LibStub("AceAddon-3.0"):GetAddon("Proculas")
ProculasDeathKnight = Proculas:NewModule("ProculasDeathKnight")

local PROCS = {
	[50466] = {
		name = "Death Trance!",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 1 
		-- name: Death Trance! 
		-- type: DEATHKNIGHT 
	},
	[50447] = {
		name = "Bloody Vengeance",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 2 
		-- name: Bloody Vengeance 
		-- type: DEATHKNIGHT 
	},
	[50448] = {
		name = "Bloody Vengeance",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 3 
		-- name: Bloody Vengeance 
		-- type: DEATHKNIGHT 
	},
	[50449] = {
		name = "Bloody Vengeance",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 4 
		-- name: Bloody Vengeance 
		-- type: DEATHKNIGHT 
	},
	[52424] = {
		name = "Retaliation",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 5 
		-- name: Retaliation 
		-- type: DEATHKNIGHT 
	},
	[50421] = {
		name = "Scent of Blood",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 6 
		-- name: Scent of Blood 
		-- type: DEATHKNIGHT 
	},
	[51789] = {
		name = "Blade Barrier",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 7 
		-- name: Blade Barrier 
		-- type: DEATHKNIGHT 
	},
	[55744] = {
		name = "The Dead Walk",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 8 
		-- name: The Dead Walk 
		-- type: DEATHKNIGHT 
	},
	[53136] = {
		name = "Abominable Might",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 1,
		-- Proc Info
		-- ID: 86 
		-- name: Abominable Might 
		-- type: DEATHKNIGHT 
	},
}

function ProculasDeathKnight:OnInitialize()
	Proculas:addProcList('DEATHKNIGHT',PROCS)
	Proculas:Print("Death Knight Procs Loaded")
end

local Proculas = LibStub("AceAddon-3.0"):GetAddon("Proculas")
ProculasRelic = Proculas:NewModule("ProculasRelic")

local PROCS = {
	[33510] = {
		spellID = 43740,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 43 
		-- name: Idol of the Unseen Moon 
		-- type: idol 
	},
	[38295] = {
		spellID = 52021,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 44 
		-- name: Idol of the Wastes 
		-- type: idol 
	},
	[40706] = {
		spellID = 60819,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 45 
		-- name: Libram of Reciprocation 
		-- type: libram 
	},
	[33503] = {
		spellID = 43747,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 46 
		-- name: Libram of Divine Judgement 
		-- type: libram 
	},
	[40715] = {
		spellID = 60828,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 50 
		-- name: Sigil of Haunted Dreams 
		-- type: sigil 
	},
	[33506] = {
		spellID = 43751,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 47 
		-- name: Skycall Totem 
		-- type: totem 
	},
	[33507] = {
		spellID = 43749,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 48 
		-- name: Stonebreaker's Totem 
		-- type: totem 
	},
	[37575] = {
		spellID = 48838,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 49 
		-- name: Totem of the Tundra 
		-- type: totem 
	},
}

function ProculasRelic:OnInitialize()
	Proculas:addProcList('Items',PROCS)
	Proculas:Print("Relic Procs Loaded")
end

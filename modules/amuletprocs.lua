local Proculas = LibStub("AceAddon-3.0"):GetAddon("Proculas")
ProculasAmulet = Proculas:NewModule("ProculasAmulet")

local PROCS = {
	[34677] = {
		spellID = 45478,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 51 
		-- name: Shattered Sun Pendant of Restoration 
		-- type: neck 
	},
	[34677] = {
		spellID = 45430,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 52 
		-- name: Shattered Sun Pendant of Restoration 
		-- type: neck 
	},
	[34680] = {
		spellID = 45432,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 53 
		-- name: Shattered Sun Pendant of Resolve 
		-- type: neck 
	},
	[34680] = {
		spellID = 45431,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 54 
		-- name: Shattered Sun Pendant of Resolve 
		-- type: neck 
	},
	[34679] = {
		spellID = 45480,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 55 
		-- name: Shattered Sun Pendant of Might 
		-- type: neck 
	},
	[34679] = {
		spellID = 45428,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 56 
		-- name: Shattered Sun Pendant of Might 
		-- type: neck 
	},
	[34678] = {
		spellID = 45479,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 57 
		-- name: Shattered Sun Pendant of Acumen 
		-- type: neck 
	},
	[34678] = {
		spellID = 45429,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 72 
		-- name: Shattered Sun Pendant of Acumen 
		-- type: neck 
	},
}

function ProculasAmulet:OnInitialize()
	Proculas:addProcList('Items',PROCS)
	Proculas:Print("Amulet Procs Loaded")
end
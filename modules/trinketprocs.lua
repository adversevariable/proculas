local Proculas = LibStub("AceAddon-3.0"):GetAddon("Proculas")
ProculasTrinkets = Proculas:NewModule("ProculasTrinkets")

local PROCS = {
	[28034] = {
		spellID = 33649,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 9 
		-- name: Hourglass of the Unraveller 
		-- type: trinket 
	},
	[32771] = {
		spellID = 41263,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 10 
		-- name: Airman's Ribbon of Gallantry 
		-- type: trinket 
	},
	[32488] = {
		spellID = 40483,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 11 
		-- name: Ashtongue Talisman of Insight 
		-- type: trinket 
	},
	[32493] = {
		spellID = 40480,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 12 
		-- name: Ashtongue Talisman of Shadows 
		-- type: trinket 
	},
	[32487] = {
		spellID = 40487,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 13 
		-- name: Ashtongue Talisman of Swiftness 
		-- type: trinket 
	},
	[32485] = {
		spellID = 40459,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 14 
		-- name: Ashtongue Talisman of Valor 
		-- type: trinket 
	},
	[34427] = {
		spellID = 45040,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 15 
		-- name: Blackened Naaru Sliver 
		-- type: trinket 
	},
	[28830] = {
		spellID = 34775,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 16 
		-- name: Dragonspine Trophy 
		-- type: trinket 
	},
	[32505] = {
		spellID = 40477,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 17 
		-- name: Madness of the Betrayer 
		-- type: trinket 
	},
	[32496] = {
		spellID = 37656,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 18 
		-- name: Memento of Tyrande 
		-- type: trinket 
	},
	[30626] = {
		spellID = 38348,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 19 
		-- name: Sextant of Unstable Currents 
		-- type: trinket 
	},
	[32770] = {
		spellID = 41261,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 20 
		-- name: Skyguard Silver Cross 
		-- type: trinket 
	},
	[30447] = {
		spellID = 37198,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 21 
		-- name: Tome of Fiery Redemption 
		-- type: trinket 
	},
	[30627] = {
		spellID = 42084,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 22 
		-- name: Tsunami Talisman 
		-- type: trinket 
	},
	[30450] = {
		spellID = 37174,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 23 
		-- name: Warp-Spring Coil 
		-- type: trinket 
	},
	[28370] = {
		spellID = 38346,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 24 
		-- name: Bangle of Endless Blessings 
		-- type: trinket 
	},
	[27683] = {
		spellID = 33370,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 25 
		-- name: Quagmirran's Eye 
		-- type: trinket 
	},
	[28418] = {
		spellID = 34321,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 26 
		-- name: Shiffar's Nexus-Horn 
		-- type: trinket 
	},
	[28785] = {
		spellID = 37658,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 27 
		-- name: The Lightning Capacitor 
		-- type: trinket 
	},
	[40685] = {
		spellID = 60062,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 28 
		-- name: The Egg of Mortal Essence 
		-- type: trinket 
	},
	[40684] = {
		spellID = 60065,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 29 
		-- name: Mirror of Truth 
		-- type: trinket 
	},
	[40682] = {
		spellID = 60064,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 30 
		-- name: Sundial of the Exiled 
		-- type: trinket 
	},
	[39229] = {
		spellID = 60494,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 31 
		-- name: Embrace of the Spider 
		-- type: trinket 
	},
	[40431] = {
		spellID = 60314,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 32 
		-- name: Fury of the Five Flights 
		-- type: trinket 
	},
	[40256] = {
		spellID = 60437,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 33 
		-- name: Grim Toll 
		-- type: trinket 
	},
	[37835] = {
		spellID = 49623,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 34 
		-- name: Je'Tze's Bell 
		-- type: trinket 
	},
	[37220] = {
		spellID = 60218,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 35 
		-- name: Essence of Gossamer 
		-- type: trinket 
	},
	[37660] = {
		spellID = 60479,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 36 
		-- name: Forge Ember 
		-- type: trinket 
	},
	[37390] = {
		spellID = 60302,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 37 
		-- name: Meteorite Whetstone 
		-- type: trinket 
	},
	[37657] = {
		spellID = 60520,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 38 
		-- name: Spark of Life 
		-- type: trinket 
	},
	[39889] = {
		spellID = 55748,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 39 
		-- name: Horn of Argent Fury 
		-- type: trinket 
	},
	[28190] = {
		spellID = 60062,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 40 
		-- name: Scarab of the Infinite Cycle 
		-- type: trinket 
	},
}

function ProculasTrinkets:OnInitialize()
	Proculas:addProcList('Items',PROCS)
	Proculas:Print("Trinket Procs Loaded")
end

local Proculas = LibStub("AceAddon-3.0"):GetAddon("Proculas")
ProculasWeapons = Proculas:NewModule("ProculasWeapons")

local PROCS = {
	[12798] = {
		spellID = 16928,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 73 
		-- name: Annihilator 
		-- type: 1haxe 
	},
	[12621] = {
		spellID = 16603,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 74 
		-- name: Demonfork 
		-- type: 1haxe 
	},
	[13408] = {
		spellID = 17506,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 75 
		-- name: Soul Breaker 
		-- type: 1haxe 
	},
	[811] = {
		spellID = 18104,
		types = {"SPELL_DAMAGE"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 99 
		-- name: Axe of the Deep Woods 
		-- type: 1haxe 
	},
	[19908] = {
		spellID = 24254,
		types = {"SPELL_DAMAGE"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 100 
		-- name: Sceptre of Smiting 
		-- type: 1haxe 
	},
	[12792] = {
		spellID = 18082,
		types = {"SPELL_DAMAGE"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 101 
		-- name: Volcanic Hammer 
		-- type: 1haxe 
	},
	[9419] = {
		spellID = 18083,
		types = {"SPELL_DAMAGE"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 102 
		-- name: Galgann's Firehammer 
		-- type: 1haxe 
	},
	[11920] = {
		spellID = 16414,
		types = {"SPELL_LEECH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 105 
		-- name: Wraith Scythe 
		-- type: 1haxe 
	},
	[32262] = {
		spellID = 40293,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 76 
		-- name: Syphon of the Nathrezim 
		-- type: 1hmace 
	},
	[30317] = {
		spellID = 36483,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 77 
		-- name: Cosmic Infuser 
		-- type: 1hmace 
	},
	[32500] = {
		spellID = 40972,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 78 
		-- name: Crystal Spire of Karabor 
		-- type: 1hmace 
	},
	[27901] = {
		spellID = 33489,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 79 
		-- name: Blackout Truncheon 
		-- type: 1hmace 
	},
	[2243] = {
		spellID = 18803,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 80 
		-- name: Hand of Edward the Odd 
		-- type: 1hmace 
	},
	[11684] = {
		spellID = 15494,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 81 
		-- name: Ironfoe 
		-- type: 1hmace 
	},
	[13183] = {
		spellID = 18203,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 82 
		-- name: Venomspitter 
		-- type: 1hmace 
	},
	[7954] = {
		spellID = 13534,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 83 
		-- name: The Shatterer 
		-- type: 1hmace 
	},
	[4090] = {
		spellID = 13496,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 84 
		-- name: Mug O' Hurt 
		-- type: 1hmace 
	},
	[17943] = {
		spellID = 21951,
		types = {"SPELL_ENERGIZE"},
		selfOnly = 1,
		-- Proc Info
		-- ID: 88 
		-- name: Fist of Stone 
		-- type: 1hmace 
	},
	[17733] = {
		spellID = 21951,
		types = {"SPELL_ENERGIZE"},
		selfOnly = 1,
		-- Proc Info
		-- ID: 89 
		-- name: Fist of Stone 
		-- type: 1hmace 
	},
	[10804] = {
		spellID = 18084,
		types = {"SPELL_LEECH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 106 
		-- name: Fist of the Damned 
		-- type: 1hmace 
	},
	[12781] = {
		spellID = 16908,
		types = {"SPELL_DISPEL"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 107 
		-- name: Serenity 
		-- type: 1hmace 
	},
	[7717] = {
		spellID = 9632,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 85 
		-- name: Ravager 
		-- type: 2haxe 
	},
	[9453] = {
		spellID = 11790,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 58 
		-- name: Toxic Revenger 
		-- type: dagger 
	},
	[9467] = {
		spellID = 3742,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 59 
		-- name: Gahz'rilla Fang 
		-- type: dagger 
	},
	[10625] = {
		spellID = 12685,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 60 
		-- name: Stealthblade 
		-- type: dagger 
	},
	[6660] = {
		spellID = 8348,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 61 
		-- name: Julie's Dagger 
		-- type: dagger 
	},
	[12590] = {
		spellID = 16551,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 62 
		-- name: Felstriker 
		-- type: dagger 
	},
	[31331] = {
		spellID = 38307,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 63 
		-- name: The Night Blade 
		-- type: dagger 
	},
	[43613] = {
		spellID = 59043,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 64 
		-- name: The Dusk Blade 
		-- type: dagger 
	},
	[30312] = {
		spellID = 36478,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 65 
		-- name: Infinity Blade 
		-- type: dagger 
	},
	[29182] = {
		spellID = 35353,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 66 
		-- name: Riftmaker 
		-- type: dagger 
	},
	[13218] = {
		spellID = 17331,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 67 
		-- name: Fang of the Crystal Spider 
		-- type: dagger 
	},
	[14024] = {
		spellID = 19755,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 68 
		-- name: Frightalon 
		-- type: dagger 
	},
	[12582] = {
		spellID = 16528,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 69 
		-- name: Keris of Zul'Serak 
		-- type: dagger 
	},
	[11635] = {
		spellID = 13526,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 70 
		-- name: Hookfang Shanker 
		-- type: dagger 
	},
	[6909] = {
		spellID = 13526,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 71 
		-- name: Strike of the Hydra 
		-- type: dagger 
	},
	[18816] = {
		spellID = 23267,
		types = {"SPELL_DAMAGE"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 90 
		-- name: Perdition's Blade 
		-- type: dagger 
	},
	[20578] = {
		spellID = 24993,
		types = {"SPELL_DAMAGE"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 91 
		-- name: Emerald Dragonfang 
		-- type: dagger 
	},
	[17071] = {
		spellID = 21151,
		types = {"SPELL_DAMAGE"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 92 
		-- name: Gutgore Ripper 
		-- type: dagger 
	},
	[19324] = {
		spellID = 24388,
		types = {"SPELL_DAMAGE"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 93 
		-- name: The Lobotomizer 
		-- type: dagger 
	},
	[19100] = {
		spellID = 23592,
		types = {"SPELL_DAMAGE"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 94 
		-- name: Electrified Dagger 
		-- type: dagger 
	},
	[14555] = {
		spellID = 18833,
		types = {"SPELL_DAMAGE"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 95 
		-- name: Alcor's Sunrazor 
		-- type: dagger 
	},
	[17780] = {
		spellID = 21978,
		types = {"SPELL_DAMAGE"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 96 
		-- name: Blade of Eternal Darkness 
		-- type: dagger 
	},
	[12531] = {
		spellID = 16454,
		types = {"SPELL_DAMAGE"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 97 
		-- name: Searing Needle 
		-- type: dagger 
	},
	[2164] = {
		spellID = 18107,
		types = {"SPELL_DAMAGE"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 98 
		-- name: Gut Ripper 
		-- type: dagger 
	},
	[32471] = {
		spellID = 40393,
		types = {"SPELL_SUMMON"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 104 
		-- name: Shard of Azzinoth 
		-- type: dagger 
	},
}

function ProculasWeapons:OnInitialize()
	Proculas:addProcList('Items',PROCS)
	Proculas:Print("Weapon Procs Loaded")
end

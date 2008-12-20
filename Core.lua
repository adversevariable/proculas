--
--	Proculas
--	Tells you when things like Mongoose, Clearcasting, etc proc.
--	Created by Clorell/Keruni of Argent Dawn [US]
--	$Id$
--

-------------------------------------------------------
-- Proculas
Proculas = LibStub("AceAddon-3.0"):NewAddon("Proculas", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0", "LibSink-2.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Proculas", false)
local LSM = LibStub("LibSharedMedia-3.0")

-------------------------------------------------------
-- Proculas Version
Proculas.revision = tonumber(("@project-revision@"):match("%d+"))
Proculas.version = GetAddOnMetadata('Proculas', 'Version')
if(Proculas.revision == nil) then
	Proculas.version = string.gsub(Proculas.version, "@".."project--revision@", "dev")
end
local VERSION = Proculas.version

-------------------------------------------------------
-- Register some media
LSM:Register("sound", "Rubber Ducky", [[Sound\Doodad\Goblin_Lottery_Open01.wav]])
LSM:Register("sound", "Cartoon FX", [[Sound\Doodad\Goblin_Lottery_Open03.wav]])
LSM:Register("sound", "Explosion", [[Sound\Doodad\Hellfire_Raid_FX_Explosion05.wav]])
LSM:Register("sound", "Shing!", [[Sound\Doodad\PortcullisActive_Closed.wav]])
LSM:Register("sound", "Wham!", [[Sound\Doodad\PVP_Lordaeron_Door_Open.wav]])
LSM:Register("sound", "Simon Chime", [[Sound\Doodad\SimonGame_LargeBlueTree.wav]])
LSM:Register("sound", "War Drums", [[Sound\Event Sounds\Event_wardrum_ogre.wav]])
LSM:Register("sound", "Cheer", [[Sound\Event Sounds\OgreEventCheerUnique.wav]])
LSM:Register("sound", "Humm", [[Sound\Spells\SimonGame_Visual_GameStart.wav]])
LSM:Register("sound", "Short Circuit", [[Sound\Spells\SimonGame_Visual_BadPress.wav]])
LSM:Register("sound", "Fel Portal", [[Sound\Spells\Sunwell_Fel_PortalStand.wav]])
LSM:Register("sound", "Fel Nova", [[Sound\Spells\SeepingGaseous_Fel_Nova.wav]])

-------------------------------------------------------
-- Default options
local defaults = {
	profile = {
		Post = true,
		PostChatFrame = true,
		PostCT = true,
		PostParty = false,
		PostRW = false,
		PostGuild = false,
		PostRaid = false,
		StickyCT = true,
		SinkOptions = {},
		Messages = {
			before = "",
			after = " procced!",
		},
		Sound = {
			Playsound = true,
			SoundFile = "Explosion",
		},
		procstats = {
			total = {},
			session = {},
			lastminute = {},
			ppm = {},
		},
		tracked = {},
	},
}
-------------------------------------------------------
-- Procs
Proculas.Procs = {
	Enchants = {},
	Trinkets = {},
	Rings = {},
	Weapons = {},
	Gems = {},
	Class = {},
	Items = {},
}
Proculas.Procs.Enchants = {
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
	[3241] = {
		spellID = 44578,
		name = "Lifeward",
		types = {"SPELL_HEAL"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 154 
		-- name: Lifeward 
		-- type: enchant 
	},
	[3790] = {
		spellID = 59626,
		name = "Black Magic",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 155 
		-- name: Black Magic 
		-- type: enchant 
	},
	[3790] = {
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
Proculas.Procs.Items = {
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

	[44308] = {
		spellID = 60318,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 41 
		-- name: Signet of Edward the Odd 
		-- type: ring 
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
Proculas.Procs.Class.PALADIN = {
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
Proculas.Procs.Class.DEATHKNIGHT = {
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
Proculas.Procs.Class.HUNTER = {
	[6150] = {
		name = "Quick Shots",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 143 
		-- name: Quick Shots 
		-- type: HUNTER 
	},
	[53257] = {
		name = "Cobra Strikes",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 144 
		-- name: Cobra Strikes 
		-- type: HUNTER 
	},
}
Proculas.Procs.Class.SHAMAN = {
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
Proculas.Procs.Class.DRUID = {
	[16870] = {
		name = "Clearcasting",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 133 
		-- name: Clearcasting 
		-- type: DRUID 
	},
	[48518] = {
		name = "Eclipse",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 134 
		-- name: Eclipse 
		-- type: DRUID 
	},
	[48517] = {
		name = "Eclipse",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 135 
		-- name: Eclipse 
		-- type: DRUID 
	},
}
Proculas.Procs.Class.PRIEST = {
	[33151] = {
		name = "Surge of Light",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 129 
		-- name: Surge of Light 
		-- type: PRIEST 
	},
	[34754] = {
		name = "Clearcasting",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 130 
		-- name: Clearcasting 
		-- type: PRIEST 
	},
}
Proculas.Procs.Class.WARRIOR = {
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
Proculas.Procs.Class.MAGE = {
	[44401] = {
		name = "Missile Barrage",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 112 
		-- name: Missile Barrage 
		-- type: MAGE 
	},
	[44544] = {
		name = "Fingers of Frost",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 113 
		-- name: Fingers of Frost 
		-- type: MAGE 
	},
	[57761] = {
		name = "Brain Freeze",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 114 
		-- name: Brain Freeze 
		-- type: MAGE 
	},
	[12536] = {
		name = "Clearcasting",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 115 
		-- name: Clearcasting 
		-- type: MAGE 
	},
	[48108] = {
		name = "Hot Streak",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 116 
		-- name: Hot Streak 
		-- type: MAGE 
	},
	[54741] = {
		name = "Firestarter",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 117 
		-- name: Firestarter 
		-- type: MAGE 
	},
}
Proculas.Procs.Class.WARLOCK = {
	[17941] = {
		name = "Nightfall",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 108 
		-- name: Nightfall 
		-- type: WARLOCK 
	},
	[54274] = {
		name = "Backdraft",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 109 
		-- name: Backdraft 
		-- type: WARLOCK 
	},
	[54276] = {
		name = "Backdraft",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 110 
		-- name: Backdraft 
		-- type: WARLOCK 
	},
	[54277] = {
		name = "Backdraft",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 111 
		-- name: Backdraft 
		-- type: WARLOCK 
	},
}
Proculas.Procs.Gems = {
	[55382] = {
		itemID = 41401,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 42 
		-- name: Insightful Earthsiege Diamond 
		-- type: gem 
	},
}
-------------------------------------------------------
-- Just some required things...
function Proculas:OnInitialize()
	self:Print("v"..VERSION.." running.")
	self.db = LibStub("AceDB-3.0"):New("ProculasDB", defaults)
	self.opt = self.db.profile
	self.procstats = self.db.profile.procstats
	self.procstats.session = {}
	self.procstats.lastminute = {}
	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")
	self:ScheduleRepeatingTimer("resetLastMinuteProc", 60)
	self:SetSinkStorage(self.opt.SinkOptions)
	self:SetupOptions()
	self.combatTime = 0
	self.lastCombatTime = 0
end

function Proculas:OnEnable()
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("UNIT_INVENTORY_CHANGED")
	changed = true
	-- Player stuff
	playerClass0, playerClass1 = UnitClass("player")
	self.playerClass = playerClass1
	self.playerName = UnitName("player")
	-- Check for procs
	self:scanForProcs()
end

-------------------------------------------------------
-- Timer Functions

-- Empties the Procs Last Minute Array.
function Proculas:resetLastMinuteProc()
	self.procstats.lastminute = {}
end

-------------------------------------------------------
-- Profiles Stuff
function Proculas:OnProfileChanged(event, database, newProfileKey)
	self.db = db
	self.opt = db.profile
	self:Print("Profile changed.")
end

function Proculas:scanForProcs()
	-- Reset tracked Procs
	self.opt.tracked = {}

	-- Find Procs
	self:scanItem(GetInventorySlotInfo("MainHandSlot"))
	self:scanItem(GetInventorySlotInfo("SecondaryHandSlot"))
	self:scanItem(GetInventorySlotInfo("RangedSlot"))
	self:scanItem(GetInventorySlotInfo("Trinket0Slot"))
	self:scanItem(GetInventorySlotInfo("Trinket1Slot"))
	self:scanItem(GetInventorySlotInfo("Finger0Slot"))
	self:scanItem(GetInventorySlotInfo("Finger1Slot"))
	self:scanItem(GetInventorySlotInfo("HeadSlot"))
	self:scanItem(GetInventorySlotInfo("NeckSlot"))
	self:scanItem(GetInventorySlotInfo("ShoulderSlot"))
	self:scanItem(GetInventorySlotInfo("BackSlot"))
	self:scanItem(GetInventorySlotInfo("ChestSlot"))
	self:scanItem(GetInventorySlotInfo("WristSlot"))
	self:scanItem(GetInventorySlotInfo("HandsSlot"))
	self:scanItem(GetInventorySlotInfo("WaistSlot"))
	self:scanItem(GetInventorySlotInfo("LegsSlot"))
	self:scanItem(GetInventorySlotInfo("FeetSlot"))
	
	-- Add Class Procs
	for index,procs in pairs(self.Procs.Class) do
		if(index == self.playerClass) then
			for spellID,procInfo in pairs(procs) do
				procInfo.spellID = spellID
				self:addProc(procInfo)
			end
		end
	end
end

function Proculas:scanItem(slotID)
	local itemlink = GetInventoryItemLink("player", slotID)
	if itemlink ~= nil then
		local found, _, itemstring = string.find(itemlink, "^|c%x+|H(.+)|h%[.+%]")
		local _, itemId, enchantId, jewelId1, jewelId2, jewelId3, jewelId4, suffixId, uniqueId, fromLvl = strsplit(":", itemstring)
		local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture = GetItemInfo(itemlink)
		
		-- Gems
		--print("Gems for "..itemName..": "..jewelId1.."-"..jewelId2.."-"..jewelId3.."-"..jewelId4)
		--[[
		Finding the GemID is fraking hard, I've decided to try another way.
		self:checkGemID(jewelId1)
		self:checkGemID(jewelId2)
		self:checkGemID(jewelId3)
		self:checkGemID(jewelId4)
		]]--
		
		-- Enchants
		if tonumber(enchantId) ~= 0 then
			local enchID = tonumber(enchantId)
			if(self.Procs.Enchants[enchID]) then
				local procInfo = self.Procs.Enchants[enchID]
				self:addProc(procInfo)
			end
		end

		-- Procs
		itemId = tonumber(itemId)
		if (self.Procs.Items[itemId]) then
			local procInfo = self.Procs.Items[itemId];
			procInfo.name = itemName
			self:addProc(procInfo)
		end
	end
end

function Proculas:checkGemID(ID)
	if tonumber(ID) ~= 0 then
			local gemID = tonumber(ID)
			if(self.Procs.Gems[gemID]) then
				local procInfo = self.Procs.Gems[gemID]
				procInfo.name = GetItemInfo(procInfo.itemID)
				self:addProc(procInfo)
				--print("Gem Found: "..procInfo.name)
			end
		end
end

function Proculas:addProc(procInfo)
	local proc = {
		spellID = procInfo.spellID,
		name = procInfo.name,
		types = procInfo.types,
		selfOnly = procInfo.selfOnly,
		count = 0,
	}
	table.insert(self.opt.tracked, proc)
end

function Proculas:PLAYER_REGEN_DISABLED()
	combatTickTimer = self:ScheduleRepeatingTimer("combatTick", 1)
end

function Proculas:PLAYER_REGEN_ENABLED()
	self:CancelTimer(combatTickTimer)
	self:updatePPM()
	self.lastCombatTime = self.combatTime
	self.combatTime = 0
end

function Proculas:updatePPM()
	for a,b in pairs(self.procstats.lastminute) do
		local spellID = b[1]
		if(self.procstats.ppm[spellID]) then
			if(b[3] > self.procstats.ppm[spellID][3]) then
				self.procstats.ppm[spellID][3] = self.procstats.lastminute[spellID][3];
			end
		else
			self.procstats.ppm[spellID] = {b[1],b[2],0};
		end
	end
end

function Proculas:combatTick()
	self.combatTime = self.combatTime+1;
end

function Proculas:UNIT_INVENTORY_CHANGED(event,unit)
	if unit == "player" then
		self:scanForProcs()
	end
end

function Proculas:COMBAT_LOG_EVENT_UNFILTERED(event,...)
	local msg,type,msg2,name,msg3,msg4,name2 = select(1, ...)
	local spellId, spellName, spellSchool = select(9, ...)
	-- Gems
	if(name == self.playerName) then
		if(self.Procs.Gems[spellId]) then
			local procInfo = self.Procs.Gems[spellId]
			local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture = GetItemInfo(procInfo.itemID)
			local isType = false
			for _,proctype in ipairs(procInfo.types) do
				if(type == proctype) then
					isType = true
					break;
				end
			end
			if(isType) then
				if(self.Procs.Gems[spellId].selfOnly and name2 == self.playerName) then
						self:postProc(spellId,itemName)
				else
					self:postProc(spellId,itemName)
				end
			end
		end
	end
	
	-- Everything else
	if(name == self.playerName) then
		for _, procInfo in pairs(self.opt.tracked) do
			if(procInfo.spellID == spellId) then
				local isType = false
				for _,proctype in ipairs(procInfo.types) do
					if(type == proctype) then
						isType = true
						break;
					end
				end
				if(isType) then
					if(procInfo.selfOnly) then
						if(name2 == self.playerName) then
							self:postProc(procInfo.spellID,procInfo.name)
						end
					else
						self:postProc(procInfo.spellID,procInfo.name)
					end
				end
			end
		end
	end
end

function Proculas:postProc(spellID,procName)
	spellName = GetSpellInfo(spellID)
	-- Log Proc
	self:logProc(procName,spellID);
	-- Post Proc
	if (self.opt.Post) then
		-- Chat Frame
		if (self.opt.PostChatFrame) then
			--self:Print(procName.." Procced! (\124cff71d5ff\124Hspell:"..spellId.."\124h["..spellName.."]\124h\124r)")
			self:Print(self.opt.Messages.before..procName..self.opt.Messages.after)
		end
		-- Blizzard Combat Text
		if (self.opt.PostCT) then
			--CombatText_AddMessage(procName.." procced", "", 2, 96, 206, "crit", false);
			self:Pour(self.opt.Messages.before..procName..self.opt.Messages.after, 2, 96, 206, nil, 24, "OUTLINE", self.opt.StickyCT);
		end
		-- Party
		if (self.opt.PostParty and GetNumPartyMembers()>0) then
			SendChatMessage("[Proculas]: "..self.opt.Messages.before..procName..self.opt.Messages.after, "PARTY");
		end
		-- Raid Warining
		if (self.opt.PostRW and GetNumPartyMembers()>0) then
			SendChatMessage(self.opt.Messages.before..procName..self.opt.Messages.after, "RAID_WARNING");
		end
		-- Guild Chat
		if (self.opt.PostGuild) then
			SendChatMessage("[Proculas]: "..self.opt.Messages.before..procName..self.opt.Messages.after, "GUILD");
		end
		-- Raid Chat
		if (self.opt.PostRaid) then
			SendChatMessage("[Proculas]: "..self.opt.Messages.before..procName..self.opt.Messages.after, "RAID");
		end
	end
	-- Play Sound
	if (self.opt.Sound.Playsound) then
		PlaySoundFile(LSM:Fetch("sound", self.opt.Sound.SoundFile))
	end
end

-- Used to Log the Proc for stats tracking
function Proculas:logProc(procName,spellID)
	-- Total
	if(self.procstats.total[spellID]) then
		self.procstats.total[spellID][3] = self.procstats.total[spellID][3]+1;
	else
		self.procstats.total[spellID] = {spellID,procName,1};
	end
	-- Session
	if(self.procstats.session[spellID]) then
		self.procstats.session[spellID][3] = self.procstats.session[spellID][3]+1;
	else
		self.procstats.session[spellID] = {spellID,procName,1};
	end
	-- Last Minute
	if(self.procstats.lastminute[spellID]) then
		self.procstats.lastminute[spellID][3] = self.procstats.lastminute[spellID][3]+1;
	else
		self.procstats.lastminute[spellID] = {spellID,procName,1};
	end
	-- PPM
	--self:updatePPM();
end

-- Used to print the Proc stats
function Proculas:procStats()
	self:Print("-------------------------------");
	self:Print("Proc Stats: Total Procs");
	for _,v in pairs(self.procstats.total) do
		self:Print(v[2]..": "..v[3].." times");
	end
	self:Print("-------------------------------");
	self:Print("Proc Stats: Procs This Session");
	for _,v in pairs(self.procstats.session) do
		self:Print(v[2]..": "..v[3].." times");
	end
	--[[self:Print("-------------------------------");
	self:Print("Proc Stats: Procs Per Minute");
	for _,v in pairs(self.procstats.ppm) do
		self:Print(v[2]..": "..v[3].." ppm");
	end]]--
end

-------------------------------------------------------
-- About Proculas
function Proculas:AboutProculas()
	self:Print("Version "..VERSION)
	self:Print("Created by Clorell/Keruni of Argent Dawn [US]")
end

-------------------------------------------------------
-- Proculas Options Stuff
local options = {
	type = "group",
	name = "Proculas",
	get = function(info) return Proculas.opt[ info[#info] ] end,
	set = function(info, value) Proculas.opt[ info[#info] ] = value end,
	args = {
		General = {
			order = 1,
			type = "group",
			name = L["GENERAL_SETTINGS"],
			desc = L["GENERAL_SETTINGS"],
			args = {
				enablepost = {
					order = 1,
					type = "description",
					name = L["ENABLE_POSTING"],
				},
				Post = {
					order = 2,
					name = L["POST_PROCS"],
					desc = L["POST_PROCS_DESC"],
					type = "toggle",
				},
				postwhere = {
					order = 3,
					type = "description",
					name = L["WHERE_TO_POST"],
				},
				PostChatFrame = {
					order = 4,
					name = L["CHAT_FRAME"],
					desc = L["CHAT_FRAME_DESC"],
					type = "toggle",
				},
				PostParty = {
					order = 5,
					name = L["PARTY_CHAT"],
					desc = L["PARTY_CHAT_DESC"],
					type = "toggle",
				},
				PostCT = {
					order = 6,
					name = L["COMBAT_TEXT"],
					desc = L["COMBAT_TEXT_DESC"],
					type = "toggle",
				},
				StickyCT = {
					order = 7,
					name = L["STICKY_COMBAT_TEXT"],
					desc = L["STICKY_COMBAT_TEXT_DESC"],
					type = "toggle",
				},
				PostRW = {
					order = 8,
					name = L["RAID_WARNING"],
					desc = L["RAID_WARNING_DESC"],
					type = "toggle",
				},
				PostGuild = {
					order = 9,
					name = L["GUILD_CHAT"],
					desc = L["GUILD_CHAT_DESC"],
					type = "toggle",
				},
				PostRaid = {
					order = 10,
					name = L["RAID_CHAT"],
					desc = L["RAID_CHAT_DESC"],
					type = "toggle",
				},
				--Output = Proculas:GetSinkAce3OptionsDataTable(),
			},
		}, -- General
		Messages = {
			order = 2,
			type = "group",
			name = "Messages",
			desc = "Proc Messages",
			get = function(info) return Proculas.opt.Messages[ info[#info] ] end,
			set = function(info, value)
				Proculas.opt.Messages[ info[#info] ] = value
			end,
			args = {
				intro = {
					order = 1,
					type = "description",
					name = L["CONFIG_PROC_MESSAGE"],
				},
				before = {
					type = "input",
					order = 2,
					name = L["BEFORE"],
					desc = L["BEFORE_DESC"],
				},
				after = {
					type = "input",
					order = 3,
					name = L["AFTER"],
					desc = L["AFTER_DESC"],
				},
			},
		}, -- Messages
		Sound = {
			order = 3,
			type = "group",
			name = "Sound Settings",
			desc = "Sound Settings",
			get = function(info) return Proculas.opt.Sound[ info[#info] ] end,
			set = function(info, value)
				Proculas.opt.Sound[ info[#info] ] = value
			end,
			args = {
				intro = {
					order = 1,
					type = "description",
					name = L["CONFIG_PROC_SOUND"],
				},
				Playsound = {
					type = "toggle",
					order = 2,
					name = L["ENABLE_SOUND"],
					desc = L["ENABLE_SOUND_DESC"],
				},
				SoundFile = {
					type = "select", dialogControl = 'LSM30_Sound',
					order = 4,
					name = L["SOUND_TO_PLAY"],
					desc = L["SOUND_TO_PLAY"],
					values = AceGUIWidgetLSMlists.sound,
					disabled = function() return not Proculas.opt.Sound.Playsound end,
				},
			},
		}, -- Sound
	},
}
Proculas.options = options
--options.args.General.args.Output.order = 10
--options.args.General.args.Output.inline = true


-- Option table for the slash command only
local optionsSlash = {
	type = "group",
	name = "Slash Command",
	order = -3,
	args = {
		about = {
			type = "execute",
			name = L["ABOUT_CMD"],
			desc = L["ABOUT_CMD_DESC"],
			func = function()
				Proculas:AboutProculas()
			end,
			guiHidden = true,
		},
		config = {
			type = "execute",
			name = L["CONFIGURE_CMD"],
			desc = L["CONFIGURE_CMD_DESC"],
			func = function()
				Proculas:ShowConfig()
			end,
			guiHidden = true,
		},
		stats = {
			type = "execute",
			name = L["STATS_CMD"],
			desc = L["STATS_CMD_DESC"],
			func = function()
				Proculas:procStats()
			end,
			guiHidden = true,
		},
	},
}
Proculas.optionsSlash = optionsSlash

function Proculas:trackedProcs()
	return self.opt.tracked
end

function Proculas:getProcStats()
	return self.opt.procstats
end

function Proculas:SetupOptions()
	self.optionsFrames = {}

	-- setup options table
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("Proculas", options)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("Proculas Commands", optionsSlash, "proculas")
	local ACD3 = LibStub("AceConfigDialog-3.0")

	-- The ordering here matters, it determines the order in the Blizzard Interface Options
	self.optionsFrames.Proculas = ACD3:AddToBlizOptions("Proculas", nil, nil, "General")
	self.optionsFrames.Sound = ACD3:AddToBlizOptions("Proculas", "Messages", "Proculas", "Messages")
	self.optionsFrames.Sound = ACD3:AddToBlizOptions("Proculas", "Sound Settings", "Proculas", "Sound")
	self:RegisterModuleOptions("Profiles", LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db), "Profiles")
end

function Proculas:RegisterModuleOptions(name, optionTbl, displayName)
	options.args[name] = (type(optionTbl) == "function") and optionTbl() or optionTbl
	self.optionsFrames[name] = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Proculas", displayName, "Proculas", name)
end

function Proculas:ShowConfig()
	-- Open the profiles tab before, so the menu expands
	InterfaceOptionsFrame_OpenToCategory(self.optionsFrames.Profiles)
	InterfaceOptionsFrame_OpenToCategory(self.optionsFrames.Proculas)
end

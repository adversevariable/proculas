--
--	Proculas
--	Tells you when things like Mongoose, Clearcasting, etc proc.
--	Created by Clorell/Keruni of Argent Dawn [US]
--	$Id$
--

-------------------------------------------------------
-- Proculas
Proculas = LibStub("AceAddon-3.0"):NewAddon("Proculas", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0", "LibSink-2.0")
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
		Sound = {
			Playsound = true,
			SoundFile = "Explosion",
		},
		Procs = {
			Enchants = true,
			Trinkets = true,
			Rings = true,
			Relics = true,
			Class = true,
			Amulets = true,
			Weapons = true,
			Gems= true,
		},
		procstats = {
			procs = {
				total = {},
			},
		},
	},
}
-------------------------------------------------------
-- Procs that give buffs
Proculas.Procs = {}
Proculas.Procs.Buffs = {
	{'Enchants',
		{
			{28093,"Mongoose"},
		},
	},
	{'HUNTER',
		{
			{6150,"Quick Shots"},
			{53257,"Cobra Strikes"},
		},
	},
	{'SHAMAN',
		{
			{16246,"Clearcasting"},
			{16257,"Flurry"},
			{16281,"Flurry"},
			{16282,"Flurry"},
			{16283,"Flurry"},
			{16284,"Flurry"},
			{16280,"Flurry"},
		},
	},
	{'DRUID',
		{
			{16870,"Clearcasting"},
			{48518,"Eclipse"},
			{48517,"Eclipse"},
		},
	},
	{'PRIEST',
		{
			{33151,"Surge of Light"},
			{34754,"Clearcasting"},
		},
	},
	{'WARRIOR',
		{
			{12966,"Flurry"},
			{12967,"Flurry"},
			{12968,"Flurry"},
			{12969,"Flurry"},
			{12970,"Flurry"},
			{12880,"Enrage"},
			{14201,"Enrage"},
			{14202,"Enrage"},
			{14203,"Enrage"},
			{14204,"Enrage"},
			{46916,"Bloodsurge"},
		},
	},
	{'MAGE',
		{
			{44401,"Missile Barrage"},
			{44544,"Fingers of Frost"},
			{57761,"Brain Freeze"},
			{12536,"Clearcasting"},
			{48108,"Hot Streak"},
			{54741,"Firestarter"},
		},
	},
	{'PALADIN',
		{
			{53489,"The Art of War"},
			{59578,"The Art of War"},
			{54203,"Sheath of Light"},
		},
	},
	{'WARLOCK',
		{
			{17941,"Nightfall"},
			{54274,"Backdraft"},
			{54276,"Backdraft"},
			{54277,"Backdraft"},
		},
	},
	{'DEATHKNIGHT',
		{
			{50466,"Death Trance!"},
			{50447,"Bloody Vengeance"},
			{50448,"Bloody Vengeance"},
			{50449,"Bloody Vengeance"},
			{52424,"Retaliation"},
			{50421,"Scent of Blood"},
			{51789,"Blade Barrier"},
			
			{55744,"The Dead Walk"},
		},
	},
	{'Trinkets',
		{
			{33649,"Hourglass of the Unraveller"},
			{41263,"Airman's Ribbon of Gallantry"},
			{40483,"Ashtongue Talisman of Insight"},
			{40480,"Ashtongue Talisman of Shadows"},
			{40487,"Ashtongue Talisman of Swiftness"},
			{40459,"Ashtongue Talisman of Valor"},
			{45040,"Blackened Naaru Sliver"},
			{34775,"Dragonspine Trophy"},
			{40477,"Madness of the Betrayer"},
			{37656,"Memento of Tyrande"},
			{38348,"Sextant of Unstable Currents"},
			{41261,"Skyguard Silver Cross"},
			{37198,"Tome of Fiery Redemption"},
			{42084,"Tsunami Talisman"},
			{37174,"Warp-Spring Coil"},
			{38346,"Bangle of Endless Blessings"},
			{33370,"Quagmirran's Eye"},
			{34321,"Shiffar's Nexus-Horn"},
			{37658,"The Lightning Capacitor"},
	
			{60062,"Essence of Life"},
			{60065,"Mirror of Truth"},
			{60064,"Sundial of the Exiled"},
	
			{60494,"Dying Curse"},
			{60492,"Embrace of the Spider"},
			{60314,"Fury of the Five Flights"},
			{60436,"Grim Toll"},
			{49623,"Je'Tze's Bell"},
			{60218,"Essence of Gossamer"},
			{60479,"Forge Ember"},
			{60302,"Meteorite Whetstone"},
			{60520,"Spark of Life"},
			
			{55748,"Horn of Argent Fury"},
		},
	},
	{'Gems',
		{
			{55382,"Insightful Earthsiege Diamond"},
		},
	},
	{'Rings',
		{
			{60318,"Signet of Edward the Odd"},
		},
	},
	{'Idols',
		{
			{43740,"Idol of the Unseen Moon"},
			{52021,"Idol of the Wastes"},
		},
	},
	{'Librams',
		{
			{60819,"Libram of Reciprocation"},
			{43747,"Libram of Divine Judgement"},
		},
	},
	{'Totems',
		{
			{43751,"Skycall Totem"},
			{43749,"Stonebreaker's Totem"},
			{48838,"Totem of the Tundra"},
		},
	},
	{'Sigils',
		{
			{60828,"Sigil of Haunted Dreams"},
		}
	},
	{'Amulets',
		{
			{45478,"Shattered Sun Pendant of Restoration"},
			{45430,"Shattered Sun Pendant of Restoration"},
			{45432,"Shattered Sun Pendant of Resolve"},
			{45431,"Shattered Sun Pendant of Resolve"},
			{45480,"Shattered Sun Pendant of Might"},
			{45428,"Shattered Sun Pendant of Might"},
			{45479,"Shattered Sun Pendant of Acumen"},
			{45429,"Shattered Sun Pendant of Acumen"},
		},
	},
	{'Weapons',
		{
			-- Daggers
			{11790,"Toxic Revenger"},
			{3742,"Gahz'rilla Fang"},
			{12685,"Stealthblade"},
			{8348,"Julie's Dagger"},
			{16551,"Felstriker"},
			{38307,"The Night Blade"},
			{59043,"The Dusk Blade"},
			{36478,"Infinity Blade"},
			{35353,"Riftmaker"},
			{17331,"Fang of the Crystal Spider"},
			{19755,"Frightalon"},
			{16528,"Keris of Zul'Serak"},
			{13526,"Corrosive Poison"},
			
			-- 1H Axes
			{16928,"Annihilator"},
			{16603,"Demonfork"},
			{17506,"Soul Breaker"},
			
			-- 1H Maces
			{40293,"Syphon of the Nathrezim"},
			{36483,"Cosmic Infuser"},
			{40972,"Crystal Spire of Karabor"},
			{33489,"Blackout Truncheon"},
			{18803,"Hand of Edward the Odd"},
			{15494,"Ironfoe"},
			{18203,"Venomspitter"},
			{13534,"The Shatterer"},
			{13496,"Mug O' Hurt"},
			
			-- 2H Axes
			{9632,"Ravager"},
		},
	},
}
-- Procs that buff the group
Proculas.Procs.GroupBuffs = {
	{'DEATHKNIGHT',
		{
			{53136,"Abominable Might"},
		},
	},
}
-- Procs that energize
Proculas.Procs.Energize = {
	{'PALADIN',
		{
			{31930,"Judgements of the Wise"},
		},
	},
	{'Weapons',
		{
			-- 1H Maces
			{21951,"Fist of Stone"},
		},
	},
}
-- Procs that do damage
Proculas.Procs.Damage = {
	{'Weapons',
		{
			-- Daggers
			{23267,"Perdition's Blade"},
			{24993,"Emerald Dragonfang"},
			{21151,"Gutgore Ripper"},
			{24388,"The Lobotomizer"},
			{23592,"Electrified Dagger"},
			{18833,"Alcor's Sunrazor"},
			{21978,"Blade of Eternal Darkness"},
			{16454,"Searing Needle"},
			{18107,"Gut Ripper"},
			
			-- 1H Axes
			{18104,"Axe of the Deep Woods"},
			
			-- 1H Maces
			{24254,"Sceptre of Smiting"},
			{18082,"Volcanic Hammer"},
			{18083,"Galgann's Firehammer"},
			
			-- Enchants
			{50265,"Fiery Weapon"},
		},
	},
}
-- Procs that summon things!
Proculas.Procs.Summon = {
	{'Weapons',
		{
			-- Daggers
			{40393,"Shard of Azzinoth"},
		},
	},
}
-- Procs that Leech or Drain from people
Proculas.Procs.LeechDrain = {
	{'Weapons',
		{
			-- 1H Axes
			{16414,"Wraith Scythe"},
			
			-- 1H Maces
			{18084,"Fist of the Damned"},
		},
	},
}
-- Procs that Dispel things
Proculas.Procs.Dispel = {
	{'Weapons',
		{
			-- 1H Maces
			{16908,"Serenity"},
		},
	},
}

-------------------------------------------------------
-- Just some required things...
function Proculas:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("ProculasDB", defaults)
	self.opt = self.db.profile
	self.procstats = self.db.profile.procstats
	self.procstats.procs.session = {}
	self.procstats.procs.lastminute = {}
	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")
	self:ScheduleRepeatingTimer("resetLastMinuteProc", 60)
	self:SetupOptions()
end

-------------------------------------------------------
-- Timer Functions

-- Empties the Procs Last Minute Array.
function Proculas:resetLastMinuteProc()
	self.procstats.procs.lastminute = {}
end

function Proculas:OnEnable()
	self:Print("v"..VERSION.." running.")
	self:RegisterEvent("COMBAT_LOG_EVENT")
	-- Player stuff
	playerClass0, playerClass1 = UnitClass("player")
	self.playerClass = playerClass1
	self.playerName = UnitName("player")
	if (self.playerClass == "WARRIOR") then
		self.opt.Procs.WARRIOR = true
	elseif (self.playerClass == "MAGE") then
		self.opt.Procs.MAGE = true
	elseif (self.playerClass == "SHAMAN") then
		self.opt.Procs.SHAMAN = true
		if (self.opt.Procs.Relics) then
			self.opt.Procs.Totem = true
		end
	elseif (self.playerClass == "DRUID") then
		self.opt.Procs.DRUID = true
		if (self.opt.Procs.Relics) then
			self.opt.Procs.Idol = true
		end
	elseif (self.playerClass == "PRIEST") then
		self.opt.Procs.PRIEST = true
	elseif (self.playerClass == "HUNTER") then
		self.opt.Procs.HUNTER = true
	elseif (self.playerClass == "PALADIN") then
		self.opt.Procs.PALADIN = true
		if (self.opt.Procs.Relics) then
			self.opt.Procs.Libram = true
		end
	elseif (self.playerClass == "WARLOCK") then
		self.opt.Procs.WARLOCK = true
	elseif (self.playerClass == "ROGUE") then
		self.opt.Procs.ROGUE = true
	elseif (self.playerClass == "DEATHKNIGHT") then
		self.opt.Procs.DEATHKNIGHT = true
		self.opt.Procs.Sigil = true
	elseif (self.opt.Procs.Relics == false) then
		self.opt.Procs.Totem = false
		self.opt.Procs.Idol = false
		self.opt.Procs.Libram = false
		self.opt.Procs.Sigil = false
	end
	if (self.opt.Procs.Class == false) then
		self.opt.Procs.WARRIOR = false
		self.opt.Procs.MAGE = false
		self.opt.Procs.PRIEST = false
		self.opt.Procs.PALADIN = false
		self.opt.Procs.DRUID = false
		self.opt.Procs.SHAMAN = false
		self.opt.Procs.HUNTER = false
		self.opt.Procs.ROGUE = false
		self.opt.Procs.WARLOCK = false
		self.opt.Procs.DEATHKNIGHT = false
	end
end

-------------------------------------------------------
-- Proculas Profiles Stuff
function Proculas:OnProfileChanged(event, database, newProfileKey)
	self.db = db
	self.opt = db.profile
	self:Print("Profile changed.")
end

-------------------------------------------------------
-- Time to check for some Procs!
function Proculas:COMBAT_LOG_EVENT(event,...)
	local msg,type,msg2,name,msg3,msg4,name2 = select(1, ...)
	local spellId, spellName, spellSchool = select(9, ...)
	-- Proc Buffs
	if(type == "SPELL_AURA_APPLIED" and name == self.playerName
	or type == "SPELL_AURA_REFRESH" and name == self.playerName) then
		self:checkProcs(self.Procs.Buffs,...)
	end
	-- Proc Group Buffs - self
	if(type == "SPELL_AURA_APPLIED" and name == self.playerName and name2 == self.playerName
	or type == "SPELL_AURA_REFRESH" and name == self.playerName and name2 == self.playerName) then
		self:checkProcs(self.Procs.GroupBuffs,...)
	end
	-- Energize Procs
	if (type == "SPELL_ENERGIZE" and name == self.playerName) then
		self:checkProcs(self.Procs.Energize,...)
	end
	-- Damage Procs
	if(type == "SPELL_DAMAGE" and name == self.playerName) then
		self:checkProcs(self.Procs.Damage,...)
	end
	-- Summon Procs
	if(type == "SPELL_SUMMON" and name == self.playerName) then
		self:checkProcs(self.Procs.Summon,...)
	end
	-- Leech and Drain Procs
	if(type == "SPELL_LEECH" and name == self.playerName
	or type == "SPELL_DRAIN" and name == self.playerName) then
		self:checkProcs(self.Procs.LeechDrain,...)
	end
	-- Dispel procs
	if(type == "SPELL_DISPEL" and name == self.playerName) then
		self:checkProcs(self.Procs.Dispel,...)
	end
end
function Proculas:checkProcs(procs,...)
	local spellId, spellName, spellSchool = select(9, ...)
	for _,v in ipairs(procs) do
		if (self.opt.Procs[v[1]] == true) then
			for _,v in ipairs(v[2]) do
				if (spellId == v[1]) then
					self:Postproc(v[2],spellId)
				end
			end -- loop through procs
		end -- check if Proc category is enabled
	end	-- loop through categories
end

-------------------------------------------------------
-- Used to post procs to chat, play sounds, etc
function Proculas:Postproc(procName,spellId)
	spellName = GetSpellInfo(spellId)
	-- Log Proc
	self:logProc(procName,spellId);
	self:logLastMinuteProc(procName,spellId);
	-- Post Proc
	if (self.opt.Post) then
		-- Chat Frame
		if (self.opt.PostChatFrame) then
			--self:Print(procName.." Procced! (\124cff71d5ff\124Hspell:"..spellId.."\124h["..spellName.."]\124h\124r)")
			self:Print(procName.." procced!")
		end
		-- Blizzard Combat Text
		if (self.opt.PostCT) then
			--CombatText_AddMessage(procName.." procced", "", 2, 96, 206, "crit", false);
			self:Pour(procName.." procced", 2, 96, 206, nil, 24, "OUTLINE", true);
		end
		-- Party
		if (self.opt.PostParty and GetNumPartyMembers()>0) then
			SendChatMessage("[Proculas]: "..procName.." procced!", "PARTY");
		end
		-- Raid Warining
		if (self.opt.PostRW and GetNumPartyMembers()>0) then
			SendChatMessage(procName.." procced!", "RAID_WARNING");
		end
		-- Guild Chat
		if (self.opt.PostGuild) then
			SendChatMessage("[Proculas]: "..procName.." procced!", "GUILD");
		end
		-- Raid Chat
		if (self.opt.PostRaid) then
			SendChatMessage("[Proculas]: "..procName.." procced!", "RAID");
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
	if(self.procstats.procs.total[spellID]) then
		self.procstats.procs.total[spellID][3] = self.procstats.procs.total[spellID][3]+1;
	else
		self.procstats.procs.total[spellID] = {spellID,procName,1};
	end
	-- Session
	if(self.procstats.procs.session[spellID]) then
		self.procstats.procs.session[spellID][3] = self.procstats.procs.session[spellID][3]+1;
	else
		self.procstats.procs.session[spellID] = {spellID,procName,1};
	end
end

-- Used to log procs for the last minute
function Proculas:logLastMinuteProc(procName,spellID)
	if(self.procstats.procs.lastminute[spellID]) then
		self.procstats.procs.lastminute[spellID][3] = self.procstats.procs.lastminute[spellID][3]+1;
	else
		self.procstats.procs.lastminute[spellID] = {spellID,procName,1};
	end
end

-- Used to print the Proc stats
function Proculas:procStats()
	self:Print("-------------------------------");
	self:Print("Proc Stats: Total Procs");
	for _,v in pairs(self.procstats.procs.total) do
		self:Print(v[2]..": "..v[3].." times");
	end
	self:Print("-------------------------------");
	self:Print("Proc Stats: Procs This Session");
	for _,v in pairs(self.procstats.procs.session) do
		self:Print(v[2]..": "..v[3].." times");
	end
	self:Print("-------------------------------");
	self:Print("Proc Stats: Procs Last Minute");
	for _,v in pairs(self.procstats.procs.lastminute) do
		self:Print(v[2]..": "..v[3].." times");
	end
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
			name = "General Settings",
			desc = "General Settings",
			args = {
				enablepost = {
					order = 1,
					type = "description",
					name = "Enable posting procs?",
				},
				Post = {
					order = 2,
					name = "Post Procs",
					desc = "Post procs?",
					type = "toggle",
				},
				postwhere = {
					order = 3,
					type = "description",
					name = "Where should Proculas post procs?",
				},
				PostChatFrame = {
					order = 4,
					name = "Chat Frame",
					desc = "Post procs to the chat frame?",
					type = "toggle",
				},
				PostParty = {
					order = 4,
					name = "Party Chat",
					desc = "Post procs to party chat?",
					type = "toggle",
				},
				PostCT = {
					order = 4,
					name = "Combat Text",
					desc = "Post procs to combat text?",
					type = "toggle",
				},
				PostRW = {
					order = 4,
					name = "Raid Warning",
					desc = "Post procs to raid warning?",
					type = "toggle",
				},
				PostGuild = {
					order = 4,
					name = "Guild Chat",
					desc = "Post procs to guild chat?",
					type = "toggle",
				},
				PostRaid = {
					order = 4,
					name = "Raid Chat",
					desc = "Post procs to raid chat?",
					type = "toggle",
				},
			},
		}, -- General
		Sound = {
			order = 2,
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
					name = "Configure the sound settings for Proculas.",
				},
				Playsound = {
					type = "toggle",
					order = 2,
					name = "Enable Sound",
					desc = "Causes Proculas to play a chosen sound effect when you proc.",
				},
				SoundFile = {
					type = "select", dialogControl = 'LSM30_Sound',
					order = 4,
					name = "Sound to play",
					desc = "Sound to play",
					values = AceGUIWidgetLSMlists.sound,
					disabled = function() return not Proculas.opt.Sound.Playsound end,
				},
			},
		}, -- Sound
		Procs = {
			order = 3,
			type = "group",
			name = "Proc Settings",
			desc = "Proc Settings",
			get = function(info) return Proculas.opt.Procs[ info[#info] ] end,
			set = function(info, value)
				Proculas.opt.Procs[ info[#info] ] = value
			end,
			args = {
				intro = {
					order = 1,
					type = "description",
					name = "Configure what procs to enable or disable.",
				},
				Class = {
					type = "toggle",
					order = 2,
					name = "Class Procs",
					desc = "If enabled, Proculas will display procs specific to your players class.",
				},
				Enchants = {
					type = "toggle",
					order = 2,
					name = "Enchant Procs",
					desc = "If enabled, Proculas will display Enchant procs.",
				},
				Trinkets = {
					type = "toggle",
					order = 2,
					name = "Trinket Procs",
					desc = "If enabled, Proculas will display Trinket procs.",
				},
				Gems = {
					type = "toggle",
					order = 2,
					name = "Gem Procs",
					desc = "If enabled, Proculas will display Gem procs.",
				},
				Rings = {
					type = "toggle",
					order = 2,
					name = "Ring Procs",
					desc = "If enabled, Proculas will display Ring procs.",
				},
				Amulets = {
					type = "toggle",
					order = 2,
					name = "Neck/Amulet Procs",
					desc = "Enable to display Neck/Amulet procs.",
				},
				Weapons = {
					type = "toggle",
					order = 2,
					name = "Weapon Procs",
					desc = "Enable to display Weapon procs.",
				},
				Relics = {
					type = "toggle",
					order = 2,
					name = "Relic Procs",
					desc = "If enabled, Proculas will display Libram, Idol, Totem, Sigil procs.",
				},
			},
		}
	},
}
Proculas.options = options

-- Option table for the slash command only
local optionsSlash = {
	type = "group",
	name = "Slash Command",
	order = -3,
	args = {
		about = {
			type = "execute",
			name = "About",
			desc = "About Proculas (/proculas about)",
			func = function()
				Proculas:AboutProculas()
			end,
			guiHidden = true,
		},
		config = {
			type = "execute",
			name = "Configure",
			desc = "Open the configuration dialog (/proculas config)",
			func = function()
				Proculas:ShowConfig()
			end,
			guiHidden = true,
		},
		procstats = {
			type = "execute",
			name = "Proc Stats",
			desc = "Show Proc Stats (/proculas procstats)",
			func = function()
				Proculas:procStats()
			end,
			guiHidden = true,
		},
	},
}
Proculas.optionsSlash = optionsSlash

function Proculas:SetupOptions()
	self.optionsFrames = {}

	-- setup options table
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("Proculas", options)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("Proculas Commands", optionsSlash, "proculas")
	local ACD3 = LibStub("AceConfigDialog-3.0")

	-- The ordering here matters, it determines the order in the Blizzard Interface Options
	self.optionsFrames.Proculas = ACD3:AddToBlizOptions("Proculas", nil, nil, "General")
	self.optionsFrames.Sound = ACD3:AddToBlizOptions("Proculas", "Sound Settings", "Proculas", "Sound")
	self.optionsFrames.Procs = ACD3:AddToBlizOptions("Proculas", "Proc Settings", "Proculas", "Procs")
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

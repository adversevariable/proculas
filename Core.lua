--
--	Proculas
--	Tells you when things like Mongoose, Clearcasting, etc proc.
--	Created by Clorell/Keruni of Argent Dawn [US]
--	$Id$
--

-------------------------------------------------------
-- Proculas
Proculas = LibStub("AceAddon-3.0"):NewAddon("Proculas", "AceConsole-3.0", "AceEvent-3.0")
local LSM = LibStub("LibSharedMedia-3.0")
local db

-------------------------------------------------------
-- Proculas Version
Proculas.revision = tonumber(("$Rev$"):match("%d+"))
Proculas.version = "0.8 r" .. (Proculas.revision or 0)
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
LSM:Register("sound", "You Will Die!", [[Sound\Creature\CThun\CThunYouWillDie.wav]])

-------------------------------------------------------
-- Default options
local defaults = {
	profile = {
		Post = true,
		PostCT = true,
		Postparty = false,
		Postrw = false,
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
		},
	},
}

-------------------------------------------------------
-- Proc buffs
local active = {}
Proculas.ProcBuffs = {
	{'Enchants',
		{
			{28093,"Mongoose"},
		},
	},
	{'Hunter',
		{
			{6150,"Quick Shots"},
			{53257,"Cobra Strikes"},
		},
	},
	{'Shaman',
		{
			{16246,"Clearcasting"},
		},
	},
	{'Druid',
		{
			{16870,"Clearcasting"},
		},
	},
	{'Priest',
		{
			{33151,"Surge of Light"},
			{34754,"Clearcasting"},
		},
	},
	{'Warrior',
		{
			{12966,"Flurry"},
			{12880,"Enrage"},
		},
	},
	{'Mage',
		{
			{44401,"Missile Barrage"},
			{44544,"Fingers of Frost"},
			{57761,"Brain Freeze"},
			{12536,"Clearcasting"},
			{48108,"Hot Streak"},
		},
	},
	{'Warlock',
		{
			{17941,"Nightfall"},
		}
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
		}
	},
	{'Totems',
		{
			{43751,"Skycall Totem"},
			{43749,"Stonebreaker's Totem"},
			{48838,"Totem of the Tundra"},
		}
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
		}
	},
}

-------------------------------------------------------
-- Just some required things...
function Proculas:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("ProculasDB", defaults)
	self.opt = self.db.profile
	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")
	db = self.db.profile
	self:SetupOptions()
end

function Proculas:OnEnable()
	self:Print("v"..VERSION.." running.")
	self:RegisterEvent("COMBAT_LOG_EVENT")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	-- Player stuff
	self.playerClass = UnitClass("player")
	if (self.playerClass == "Warrior") then
		self.opt.Procs.Warrior = true
	elseif (self.playerClass == "Mage") then
		self.opt.Procs.Mage = true
	elseif (self.playerClass == "Shaman") then
		self.opt.Procs.Shaman = true
		if (self.opt.Procs.Relics) then
			self.opt.Procs.Totem = true
		end
	elseif (self.playerClass == "Druid") then
		self.opt.Procs.Druid = true
		if (self.opt.Procs.Relics) then
			self.opt.Procs.Idol = true
		end
	elseif (self.playerClass == "Priest") then
		self.opt.Procs.Priest = true
	elseif (self.playerClass == "Hunter") then
		self.opt.Procs.Hunter = true
	elseif (self.playerClass == "Paladin") then
		if (self.opt.Procs.Relics) then
			self.opt.Procs.Libram = true
		end
	elseif (self.opt.Procs.Relics == false) then
		self.opt.Procs.Totem = false
		self.opt.Procs.Idol = false
		self.opt.Procs.Libram = false
		self.opt.Procs.Sigil = false
	end
	if (self.opt.Procs.Class == false) then
		self.opt.Procs.Warrior = false
		self.opt.Procs.Mage = false
		self.opt.Procs.Priest = false
		self.opt.Procs.Paladin = false
		self.opt.Procs.Druid = false
		self.opt.Procs.Shaman = false
		self.opt.Procs.Hunter = false
		self.opt.Procs.Rogue = false
		self.opt.Procs.Warlock = false
	end
end

function Proculas:PLAYER_REGEN_ENABLED()
	self.track = false
end

function Proculas:PLAYER_REGEN_DISABLED()
	self.track = true
end

function Proculas:HasBuff(buff)
	local name = UnitBuff("player", buff) or nil
	return name ~= nil
end

-------------------------------------------------------
-- Proculas Profiles Stuff
function Proculas:OnProfileChanged(event, database, newProfileKey)
	db = database.profile
	self.opt = db
	self.db = db
	self:Print("Profile changed.")
end

-------------------------------------------------------
-- Buff Monitoring to check for when procs buff the player
function Proculas:COMBAT_LOG_EVENT()
	if (self.track == true) then
		for _,v in ipairs(self.ProcBuffs) do
			if (self.opt.Procs[v[1]] == true) then
				for _,v in ipairs(v[2]) do
					if (self:HasBuff(GetSpellInfo(v[1])) and active[v[1]] == nil) then
						self:Postproc(v[2])
						active[v[1]] = true
					elseif (not self:HasBuff(GetSpellInfo(v[1]))) then
						active[v[1]] = nil
					end
				end
			end
		end
	end
end

-------------------------------------------------------
-- Used to post procs to chat, play sounds, etc
function Proculas:Postproc(proc)
	if (db.Post) then
		-- Chat Frame
		self:Print(proc.." Procced!")
		-- Blizzard Combat Text
		if (db.PostCT) then
			CombatText_AddMessage(proc.." procced", "", 2, 96, 206, "crit", false);
		end
		-- Party
		if (db.Postparty and GetNumPartyMembers()>0) then
			SendChatMessage("[Proculas]: "..proc.." Procced!", "PARTY");
		end
		-- Raid Warining
		if (db.Postrw and GetNumPartyMembers()>0) then
			SendChatMessage(proc.." Procced!", "RAID_WARNING");
		end
		-- Guild Chat
		if (db.PostGuild) then
			SendChatMessage("[Proculas]: "..proc.." Procced!", "GUILD");
		end
		-- Raid Chat
		if (db.PostRaid) then
			SendChatMessage("[Proculas]: "..proc.." Procced!", "RAID");
		end
	end
	if (db.Sound.Playsound) then
		PlaySoundFile(LSM:Fetch("sound", db.Sound.SoundFile))
	end
end
-------------------------------------------------------
-- Proculas Chat Commands
--Proculas:RegisterChatCommand("proculas", "AboutProculas")
function Proculas:AboutProculas()
	DEFAULT_CHAT_FRAME:AddMessage("Proculas "..VERSION)
	DEFAULT_CHAT_FRAME:AddMessage("Created by Clorell/Keruni of Argent Dawn [US]")
end

-------------------------------------------------------
-- Proculas Options Stuff
local options = {
	type = "group",
	name = "Proculas",
	get = function(info) return db[ info[#info] ] end,
	set = function(info, value) db[ info[#info] ] = value end,
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
				Postparty = {
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
				Postrw = {
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
			get = function(info) return db.Sound[ info[#info] ] end,
			set = function(info, value)
				db.Sound[ info[#info] ] = value
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
					disabled = function() return not db.Sound.Playsound end,
				},
			},
		}, -- Sound
		Procs = {
			order = 3,
			type = "group",
			name = "Proc Settings",
			desc = "Proc Settings",
			get = function(info) return db.Procs[ info[#info] ] end,
			set = function(info, value)
				db.Procs[ info[#info] ] = value
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

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
Proculas.version = "0.7 r" .. (Proculas.revision or 0)
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
		Sound = {
			Playsound = true,
			SoundFile = "Explosion",
		},
	},
}

-------------------------------------------------------
-- Proc buffs
local active = {}
local ProcBuffs = {
			{28093,"Mongoose"},
			{6150,"Quick Shots"},
			{53257,"Cobra Strikes"},
			{12536,"Clearcasting"},
			{16246,"Clearcasting"},
			{16870,"Clearcasting"},
			{34754,"Clearcasting"},
			{33151,"Surge of Light"},
			{12966,"Flurry"},
			{12880,"Enrage"},
			
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
			{44401,"Missile Barrage"},
			{44544,"Fingers of Frost"},
			{57761,"Brain Freeze"},
			{60494,"Dying Curse"},
			{60492,"Embrace of the Spider"},
			{60314,"Fury of the Five Flights"},
			{60436,"Grim Toll"},
			{49623,"Je'Tze's Bell"},
			{60218,"Essence of Gossamer"},
			{60479,"Forge Ember"},
			{60302,"Meteorite Whetstone"},
			{60520,"Spark of Life"},
			
			{60318,"Signet of Edward the Odd"},
			
			{43740,"Idol of the Unseen Moon"},
			{52021,"Idol of the Wastes"},
			
			{60819,"Libram of Reciprocation"},
			{43747,"Libram of Divine Judgement"},
			
			{43751,"Skycall Totem"},
			{43749,"Stonebreaker's Totem"},
			{48838,"Totem of the Tundra"},
			
			{60828,"Sigil of Haunted Dreams"},
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
	self:Print("Profile changed.")
end

-------------------------------------------------------
-- Buff Monitoring to check for when procs buff the player
function Proculas:COMBAT_LOG_EVENT()
	if (self.track == true) then
		for _,v in ipairs(ProcBuffs) do
			if (self:HasBuff(GetSpellInfo(v[1])) and active[v[1]] == nil) then
				self:Postproc(v[2])
				active[v[1]] = true
			elseif (not self:HasBuff(GetSpellInfo(v[1]))) then
				active[v[1]] = nil
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
	end
	if (db.Sound.Playsound) then
		PlaySoundFile(LSM:Fetch("sound", db.Sound.SoundFile))
	end
end
-------------------------------------------------------
-- Proculas Chat Commands
Proculas:RegisterChatCommand("proculas", "AboutProculas")
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
	},
}
Proculas.options = options

function Proculas:SetupOptions()
	self.optionsFrames = {}

	-- setup options table
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("Proculas", options)
	local ACD3 = LibStub("AceConfigDialog-3.0")

	-- The ordering here matters, it determines the order in the Blizzard Interface Options
	self.optionsFrames.Proculas = ACD3:AddToBlizOptions("Proculas", nil, nil, "General")
	self.optionsFrames.Sound = ACD3:AddToBlizOptions("Proculas", "Sound Settings", "Proculas", "Sound")
	self:RegisterModuleOptions("Profiles", LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db), "Profiles")
end

function Proculas:RegisterModuleOptions(name, optionTbl, displayName)
	options.args[name] = (type(optionTbl) == "function") and optionTbl() or optionTbl
	self.optionsFrames[name] = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Proculas", displayName, "Proculas", name)
end

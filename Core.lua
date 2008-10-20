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
Proculas.version = "0.6 r" .. (Proculas.revision or 0)
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
local buffMongoose = GetSpellInfo(28093)
local buffCobraStrikes = GetSpellInfo(53257)
local buffClearcastMage = GetSpellInfo(12536)
local buffClearcastShaman = GetSpellInfo(16246)
local buffClearcastDruid = GetSpellInfo(16870)
local buffClearcastPriest = GetSpellInfo(34754)
local buffQuickShots = GetSpellInfo(6150)
local buffRotU = GetSpellInfo(33649) -- Rage of the Unraveller
local buffSoL = GetSpellInfo(33151) -- Surge of Light
local buffWFlurry = GetSpellInfo(12966) -- Warrior Flurry
local buffWEnrage1 = GetSpellInfo(12880) -- Warrior Enrage Rank 1
local buffWEnrage2 = GetSpellInfo(12880) -- Warrior Enrage Rank 2
local buffWEnrage3 = GetSpellInfo(12880) -- Warrior Enrage Rank 3
local buffWEnrage4 = GetSpellInfo(12880) -- Warrior Enrage Rank 4
local buffWEnrage5 = GetSpellInfo(12880) -- Warrior Enrage Rank 5

local active = {}

-------------------------------------------------------
-- Proc names
local PROC = {
			mongoose = "Mongoose",
			quickshots = "Quick Shots",
			cobrastrikes = "Cobra Strikes",
			clearcasting = "Clearcasting",
			rotu = "Rage of the Unraveller",
			sol = "Surge of Light",
			flurry = "Flurry",
			enrage = "Enrage",
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
	---------------------------------------------------
	-- Mongoose
	if (self:HasBuff(buffMongoose) and active["mongoose"] == nil) then
		self:Postproc("mongoose")
		active["mongoose"] = true
	elseif (not self:HasBuff(buffMongoose)) then
		active["mongoose"] = nil
	end
	---------------------------------------------------
	-- Cobra Strikes
	if (self:HasBuff(buffCobraStrikes) and active["cobrastrikes"] == nil) then
		self:Postproc("cobrastrikes")
		active["cobrastrikes"] = true
	elseif (not self:HasBuff(buffCobraStrikes)) then
		active["cobrastrikes"] = nil
	end
	---------------------------------------------------
	-- Quick Strikes
	if (self:HasBuff(buffQuickShots) and active["quickshots"] == nil) then
		self:Postproc("quickshots")
		active["quickshots"] = true
	elseif (not self:HasBuff(buffQuickShots)) then
		active["quickshots"] = nil
	end
	---------------------------------------------------
	-- Clearcasting [Mage]
	if (self:HasBuff(buffClearcastMage) and active["ccmage"] == nil) then
		self:Postproc("clearcasting")
		active["ccmage"] = true
	elseif (not self:HasBuff(buffClearcastMage)) then
		active["ccmage"] = nil
	end
	---------------------------------------------------
	-- Clearcasting [Shaman]
	if (self:HasBuff(buffClearcastShaman) and active["ccshaman"] == nil) then
		self:Postproc("clearcasting")
		active["ccshaman"] = true
	elseif (not self:HasBuff(buffClearcastShaman)) then
		active["ccshaman"] = nil
	end
	---------------------------------------------------
	-- Clearcasting [Druid]
	if (self:HasBuff(buffClearcastDruid) and active["ccdruid"] == nil) then
		self:Postproc("clearcasting")
		active["ccdruid"] = true
	elseif (not self:HasBuff(buffClearcastDruid)) then
		active["ccdruid"] = nil
	end
	---------------------------------------------------
	-- Clearcasting [Priest]
	if (self:HasBuff(buffClearcastPriest) and active["ccpriest"] == nil) then
		self:Postproc("clearcasting")
		active["ccpriest"] = true
	elseif (not self:HasBuff(buffClearcastPriest)) then
		active["ccpriest"] = nil
	end
	---------------------------------------------------
	-- Rage of the Unraveller [Trinket]
	if (self:HasBuff(buffRotU) and active["rotu"] == nil) then
		self:Postproc("rotu")
		active["rotu"] = true
	elseif (not self:HasBuff(buffRotU)) then
		active["rotu"] = nil
	end
	---------------------------------------------------
	-- Surge of Light
	if (self:HasBuff(buffSoL) and active["sol"] == nil) then
		self:Postproc("sol")
		active["sol"] = true
	elseif (not self:HasBuff(buffSoL)) then
		active["sol"] = nil
	end
	---------------------------------------------------
	-- Warrior Flurry
	if (self:HasBuff(buffWFlurry) and active["wflurry"] == nil) then
		self:Postproc("flurry")
		active["wflurry"] = true
	elseif (not self:HasBuff(buffWFlurry)) then
		active["wflurry"] = nil
	end
	---------------------------------------------------
	-- Warrior Enrage Rank 1
	if (self:HasBuff(buffWEnrage1) and active["wenrage"] == nil) then
		self:Postproc("enrage")
		active["wenrage"] = true
	elseif (not self:HasBuff(buffWEnrage1)) then
		active["wenrage"] = nil
	end
	-- Warrior Enrage Rank 2
	if (self:HasBuff(buffWEnrage2) and active["wenrage"] == nil) then
		self:Postproc("enrage")
		active["wenrage"] = true
	elseif (not self:HasBuff(buffWEnrage2)) then
		active["wenrage"] = nil
	end
	-- Warrior Enrage Rank 3
	if (self:HasBuff(buffWEnrage3) and active["wenrage"] == nil) then
		self:Postproc("enrage")
		active["wenrage"] = true
	elseif (not self:HasBuff(buffWEnrage3)) then
		active["wenrage"] = nil
	end
	-- Warrior Enrage Rank 4
	if (self:HasBuff(buffWEnrage4) and active["wenrage"] == nil) then
		self:Postproc("enrage")
		active["wenrage"] = true
	elseif (not self:HasBuff(buffWEnrage4)) then
		active["wenrage"] = nil
	end
	-- Warrior Enrage Rank 5
	if (self:HasBuff(buffWEnrage5) and active["wenrage"] == nil) then
		self:Postproc("enrage")
		active["wenrage"] = true
	elseif (not self:HasBuff(buffWEnrage5)) then
		active["wenrage"] = nil
	end
end

-------------------------------------------------------
-- Used to post procs to chat, play sounds, etc
function Proculas:Postproc(proc)
	if (db.Post) then
		-- Chat Frame
		self:Print(PROC[proc].." Procced!")
		-- Error Frame
		UIErrorsFrame:AddMessage("|cff00ffff".. PROC[proc] .. " procced!", 1.0, 1.0, 1.0, 1.0, 2);
		-- Party
		if (db.Postparty) then
			SendChatMessage("[Proculas]: "..PROC[proc].." Procced!", "PARTY");
		end
		-- Raid Warining
		if (db.Postrw) then
			SendChatMessage(PROC[proc].." Procced!", "RAID_WARNING");
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

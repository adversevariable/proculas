--
-- Proculas
-- Created by Clorell/Keruni of Argent Dawn [US]
-- $Id$
--

local Proculas = LibStub("AceAddon-3.0"):GetAddon("Proculas")
local ProculasOptions = Proculas:NewModule("ProculasOptions")
local L = LibStub("AceLocale-3.0"):GetLocale("Proculas", false)
local LSM = LibStub("LibSharedMedia-3.0")

-------------------------------------------------------
-- Proculas Options Stuff

-- Default options
local defaults = {
	profile = {
		postprocs = true,
		PostChatFrame = false,
		Messages = {
			message = "%s procced",
		},
		Effects = {
			Flash = false,
			Shake = false,
		},
		Cooldowns = {
			cooldowns = true,
			show = true,
			movableFrame = true,
			reverseGrowth = false,
			barFont = "Arial Narrow",
			barFontSize = 12,
			barHeight = 20,
			barWidth = 150,
			barTexture = "Blizzard",
		},
		SinkOptions = {
			sink20OutputSink = "Default",
		},
		Sound = {
			Playsound = true,
			SoundFile = "Explosion",
		},
		minimapButton = {
			minimapPos = 200,
			radius = 80,
			hide = false,
			rounding = 10,
		},
		procstats = {},
		tracked = {},
	},
}
Proculas.defaults = defaults

local defaultsPC = {
	profile = {
		procstats = {},
		procoptions = {},
		tracked = {}
	}
}
Proculas.defaultsPC = defaultsPC

-- Options array from config window
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
			get = function(info) return Proculas.opt[ info[#info] ] end,
			set = function(info, value)
				Proculas.opt[ info[#info] ] = value
			end,
			args = {
				enablepost = {
					order = 1,
					type = "description",
					name = L["ENABLE_POSTING"],
				},
				postprocs = {
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
				--[[PostChatFrame = {
					order = 4,
					name = L["CHAT_FRAME"],
					desc = L["CHAT_FRAME_DESC"],
					type = "toggle",
					disabled = function() return not Proculas.opt.postprocs end
				},]]
				Sink = Proculas:GetSinkAce3OptionsDataTable(),
				screenEffectsDesc = {
					order = 6,
					type = "description",
					name = L["SCREEN_EFFECTS"],
				},
				Flash = {
					order = 7,
					name = L["FLASH_SCREEN"],
					desc = L["FLASH_SCREEN_DESC"],
					type = "toggle",
					get = function(info) return Proculas.opt.Effects[ info[#info] ] end,
					set = function(info, value)
						Proculas.opt.Effects[ info[#info] ] = value
					end,
				},
				Shake = {
					order = 8,
					name = L["SHAKE_SCREEN"],
					desc = L["SHAKE_SCREEN_DESC"],
					type = "toggle",
					get = function(info) return Proculas.opt.Effects[ info[#info] ] end,
					set = function(info, value)
						Proculas.opt.Effects[ info[#info] ] = value
					end,
				},
				minimapButtonDesc = {
					order = 9,
					type = "description",
					name = L["MINIMAPBUTTONSETTINGS"],
				},
				minimapButtonHide = {
					order = 10,
					name = L["HIDEMINIMAPBUTTON"],
					desc = L["HIDEMINIMAPBUTTON"],
					type = "toggle",
					get = function(info) return Proculas.opt.minimapButton.hide end,
					set = function(info, value)
						Proculas:GetModule("ProculasLDB"):ToggleMMButton(value)
						Proculas.opt.minimapButton.hide = value
					end,
				},
			},
		}, -- General
		ProcStats = {
			order = 1,
			type = "group",
			name = L["CONFIG_PROC_STATS"],
			desc = L["CONFIG_PROC_STATS_DESC"],
			args = {
				resetstats = {
					type = "execute",
					name = L["RESET_PROC_STATS"],
					desc = L["RESET_PROC_STATS_DESC"],
					func = function()
						Proculas:resetProcStats()
					end,
				},
			},
		}, -- ProcStats
		Messages = {
			order = 2,
			type = "group",
			name = L["CONFIG_MESSAGES"],
			desc = L["CONFIG_MESSAGES_DESC"],
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
				--[[before = {
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
				},]]
				message = {
					type = "input",
					order = 2,
					name = L["MESSAGE"],
					desc = L["MESSAGE_DESC"],
				},
			},
		}, -- Messages
		Cooldowns = {
			type = "group",
			name = L["CONFIG_COOLDOWNS"],
			order = 1,
			get = function(info) return Proculas.opt.Cooldowns[ info[#info] ] end,
			set = function(info, value)
				Proculas.opt.Cooldowns[ info[#info] ] = value
				Proculas:updateCooldownsFrame()
			end,
			args = {
				procCooldownsDesc = {
					order = 1,
					type = "description",
					name = L["COOLDOWN_SETTINGS"],
				},
				barOptions = {
					type = "group",
					guiInline = true,
					name = L["BAR_OPTIONS"],
					args = {
						cooldowns = {
							order =2,
							name = L["ENABLE_COOLDOWNS"],
							desc = L["ENABLE_COOLDOWNS_DESC"],
							type = "toggle",
						},
						show = {
							order =2,
							name = L["SHOWCOOLDOWNS"],
							desc = L["SHOWCOOLDOWNS"],
							type = "toggle",
						},
						movableFrame = {
							type = "toggle",
							name = L["MOVABLEFRAME"],
							desc = L["MOVABLEFRAME"],
							order = 3,

						},
						barTexture = {
							type = "select", dialogControl = 'LSM30_Background',
							name = L["BAR_TEXTURE"],
							desc = L["BAR_TEXTURE"],
							order = 4,
							values = AceGUIWidgetLSMlists.statusbar,
						}, 
						barFont = {
							type = "select", dialogControl = 'LSM30_Font',
							name = L["BAR_FONT"],
							desc = L["BAR_FONT"],
							order = 5,
							values = AceGUIWidgetLSMlists.font,
						},                        		
						barFontSize = {
							type = "range",
							name = L["BAR_FONT_SIZE"],
							desc = L["BAR_FONT_SIZE"],
							min = 4, max = 30, step = 1,
						},
						barWidth = {
							type = "range",
							name = L["BAR_WIDTH"],
							desc = L["BAR_WIDTH"],
							min = 40,
							max = 300,
							step = 1,
							order = 7,
						},
						barHeight = {
							type = "range",
							name = L["BAR_HEIGHT"],
							desc = L["BAR_HEIGHT"],
							min = 8,
							max = 60,
							step = 1,
							order = 8,
						},
						reverseGrowth = {
							type = "toggle",
							name = L["GROW_UPWARDS"],
							desc = L["GROW_UPWARDS"],
							order = 9,
						},
					}
				}
			}
		}, -- Cooldown Frame/Bars options
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
				--[[Playsound = {
					type = "toggle",
					order = 2,
					name = L["ENABLE_SOUND"],
					desc = L["ENABLE_SOUND_DESC"],
				},]]
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
		Procs = {
			type="group",
			name = L["PROC_SETTINGS"],
			order = 1,
			get = function(info) return Proculas.editingproc ~= nil and Proculas.editingproc[ info[#info] ] end,
			set = function(info, value)
				if not Proculas.editingproc then return nil end
				Proculas.editingproc[ info[#info] ] = value
			end,
			args = {
				intro = {
					type = "description",
					name = L["PROC_SETTINGS_DESC"],
					order = 0,
				},
				proc = {
					type = "select",
					width = "full",
					order = 1,
					name = L["SELECT_PROC"],
					desc = L["SELECT_PROC_DESC"],
					values = function()
						local procs = {}
						for index, proc in pairs(Proculas.procstats) do
							procs[proc.spellID] = proc.name
						end
						return procs
					end,
					get = function() 
						if Proculas.editingproc ~= nil then
							 return Proculas.editingproc.spellID
						end
					end,
					set = function(info,value) 
						Proculas.editingproc = Proculas:GetProcOptions(value) 
					end
				},
				enabled = {
					type = "toggle",
					name = L["ENABLE"],
					desc = L["ENABLE_DESC"],
					order = 2,
					disabled = function() return Proculas.editingproc == nil end,
				},
				cooldown = {
					type = "toggle",
					name = L["ENABLE_COOLDOWN"],
					desc = L["ENABLE_COOLDOWN_DESC"],
					order = 3,
					tristate = true,
					disabled = function() return Proculas.editingproc == nil end,
				},               									
			},
		},
	},
}
options.args.General.args.Sink.order = 5
options.args.General.args.Sink.inline = true
options.args.General.args.Sink.disabled = function() return not Proculas.opt.postprocs end
--Proculas.options = options

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
	},
}
--Proculas.optionsSlash = optionsSlash

function ProculasOptions:OnInitialize()
	self:SetupOptions()
end

function ProculasOptions:SetupOptions()
	self.optionsFrames = {}

	-- setup options table
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("Proculas", options)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("Proculas Commands", optionsSlash, "proculas")
	local ACD3 = LibStub("AceConfigDialog-3.0")

	-- The ordering here matters, it determines the order in the Blizzard Interface Options
	self.optionsFrames.Proculas = ACD3:AddToBlizOptions("Proculas", nil, nil, "General")
	self.optionsFrames.Messages = ACD3:AddToBlizOptions("Proculas", L["PROC_SETTINGS"], "Proculas", "Procs")
	self.optionsFrames.Messages = ACD3:AddToBlizOptions("Proculas", "Messages", "Proculas", "Messages")
	self.optionsFrames.Cooldowns = ACD3:AddToBlizOptions("Proculas", "Cooldowns", "Proculas", "Cooldowns")
	self.optionsFrames.Sound = ACD3:AddToBlizOptions("Proculas", "Sound Settings", "Proculas", "Sound")
	self.optionsFrames.ProcStats = ACD3:AddToBlizOptions("Proculas", L["CONFIG_PROC_STATS"], "Proculas", "ProcStats")
	self:RegisterModuleOptions("Profiles", LibStub("AceDBOptions-3.0"):GetOptionsTable(Proculas.db), "Profiles")
end

function ProculasOptions:RegisterModuleOptions(name, optionTbl, displayName)
	options.args[name] = (type(optionTbl) == "function") and optionTbl() or optionTbl
	self.optionsFrames[name] = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Proculas", displayName, "Proculas", name)
end

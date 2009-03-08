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
			message = L["DEFAULT_PROC_MESSAGE"],
			color = {r = 1, g = 1, b = 1},
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
			colorStart = {r = 1.0, g = 0.2, b = 0.2, a = 0.8},
			colorEnd = {r = 0.30, g = 0.8, b = 0.1, a = 0.8},
			flashTimer = 4,
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
		customSounds = {},
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
	name = L["Proculas"],
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
					type = "header",
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
					type = "header",
					name = L["WHERE_TO_POST"],
				},
				Sink = Proculas:GetSinkAce3OptionsDataTable(),
				screenEffectsDesc = {
					order = 6,
					type = "header",
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
					type = "header",
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
				message = {
					type = "input",
					order = 2,
					name = L["MESSAGE"],
					desc = L["MESSAGE_DESC"],
				},
				color = {
					type = "color",
					order = 3,
					name = L["COLOR"],
					desc = L["COLOR_DESC"],
					hasAlpha = true,
					get = function(info)
						local c = Proculas.opt.Messages.color
						return c.r, c.g, c.b
					end,
					set = function(info, r, g, b, a)
						local c = Proculas.opt.Messages.color
						c.r, c.g, c.b = r, g, b
					end,
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
							order = 2,
							name = L["SHOWCOOLDOWNS"],
							desc = L["SHOWCOOLDOWNS"],
							type = "toggle",
						},
						show = {
							order = 2,
							name = L["ENABLE_COOLDOWNS"],
							desc = L["ENABLE_COOLDOWNS_DESC"],
							type = "toggle",
						},
						movableFrame = {
							type = "toggle",
							name = L["MOVABLEFRAME"],
							desc = L["MOVABLEFRAME"],
							order = 3,
						},
						barTexture = {
							type = "select", dialogControl = 'LSM30_Statusbar',
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
							order = 7,
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
						--divider = {order = 10, type = "header", name = ""},
						colorStart = {
							type = "color",
							order = 9,
							name = L["START_COLOR"],
							desc = L["START_COLOR_DESC"],
							hasAlpha = true,
							get = function(info)
								local c = Proculas.opt.Cooldowns.colorStart
								return c.r, c.g, c.b, c.a
							end,
							set = function(info, r, g, b, a)
								local c = Proculas.opt.Cooldowns.colorStart
								c.r, c.g, c.b, c.a = r, g, b, a
							end,
						},
						colorEnd = {
							type = "color",
							order = 10,
							name = L["END_COLOR"],
							desc = L["END_COLOR_DESC"],
							hasAlpha = true,
							get = function(info)
								local c = Proculas.opt.Cooldowns.colorEnd
								return c.r, c.g, c.b, c.a
							end,
							set = function(info, r, g, b, a)
								local c = Proculas.opt.Cooldowns.colorEnd
								c.r, c.g, c.b, c.a = r, g, b, a
							end,
						},
						reverseGrowth = {
							type = "toggle",
							name = L["GROW_UPWARDS"],
							desc = L["GROW_UPWARDS"],
							order = 11,
						},
						flashTimer = {
							type = "toggle",
							name = L["FLASH_BAR"],
							desc = L["FLASH_BAR_DESC"],
							order = 12,
							get = function(info)
								if Proculas.opt.Cooldowns.flashTimer == 4 then 
									return true
								else
									return false
								end
							end,
							set = function(info,value)
								if value then 
									Proculas.opt.Cooldowns.flashTimer = 4
								else
									Proculas.opt.Cooldowns.flashTimer = 0
								end
							end,
						},
					}
				}
			}
		}, -- Cooldown Frame/Bars options
		Sound = {
			order = 3,
			type = "group",
			name = L["CONFIG_SOUND"],
			desc = L["CONFIG_SOUND"],
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
				SoundFile = {
					type = "select", dialogControl = 'LSM30_Sound',
					order = 2,
					name = L["SOUND_TO_PLAY"],
					desc = L["SOUND_TO_PLAY"],
					values = AceGUIWidgetLSMlists.sound,
				},
				newCustomSoundHeader = {order = 3, type = "header", name = L["NEW_CUSTOM_SOUND"]},
				csName = {
					type = "input",
					name = L["NAME"],
					desc = L["NAME"],
					order = 4,
				},
				csFile = {
					type = "input",
					name = L["LOCATION"],
					desc = L["CUSTOMSOUND_LOCATION_DESC"],
					order = 5,
				},
				csAdd = {
					type = "execute",
					name = L["ADD"],
					desc = L["ADD_SOUND"],
					func = function()
						Proculas:addCustomSound(Proculas.opt.Sound.csName,Proculas.opt.Sound.csFile);
						Proculas.opt.Sound.csName = ""
						Proculas.opt.Sound.csFile = ""
					end,
					order = 6,
				},
				deleteCustomSoundHeader = {order = 7, type = "header", name = "Delete Custom Sounds"},
				customsound = {
					type = "select",
					order = 8,
					name = L["SELECT_SOUND"],
					desc = L["CUSTOMSOUND_SELECT_SOUND_DESC"],
					values = function()
						local sounds = {}
						for name,location in pairs(Proculas.opt.customSounds) do
							sounds[name] = name
						end
						return sounds
					end,
					get = function() 
						if Proculas.editingsound ~= nil then
							 return Proculas.editingsound
						end
					end,
					set = function(info,value) 
						Proculas.editingsound = value
					end
				},
				csDelete = {
					type = "execute",
					name = L["DELETE"],
					desc = L["DELETE_SOUND"],
					func = function()
						Proculas:deleteCustomSound(Proculas.editingsound);
					end,
					order = 9,
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
				headerCooldown = {order = 3, type = "header", name = L["COOLDOWN_OPTIONS"]},
				cooldown = {
					type = "toggle",
					name = L["ENABLE_COOLDOWN"],
					desc = L["ENABLE_COOLDOWN_DESC"],
					order = 4,
					tristate = true,
					disabled = function() return Proculas.editingproc == nil end,
				},
				cooldowntime = {
					type = "range",
					name = L["COOLDOWN_TIME"],
					desc = L["COOLDOWN_TIME_DESC"],
					order = 5,
					min = 0,
					max = 600,
					step = 1,
					get = function() 
						if Proculas.editingproc ~= nil then
							return Proculas.procstats[Proculas.editingproc.spellID].cooldown 
						end
					end,
					set = function(info,value) Proculas.procstats[Proculas.editingproc.spellID].cooldown = value end,
					disabled = function() return Proculas.editingproc == nil end,
				},
				updatecd = {
					type = "toggle",
					name = L["UPDATE_COOLDOWN"],
					desc = L["UPDATE_COOLDOWN_DESC"],
					order = 6,
					disabled = function() return Proculas.editingproc == nil end,
				},
				headerMessage = {order = 10, type = "header", name = L["PROC_MESSAGE"]},
				custommessage = {
					type="toggle",
					name = L["CUSTOM_MESSAGE"],
					desc = L["CUSTOM_MESSAGE_DESC"],
					order = 11,
					disabled = function() return Proculas.editingproc == nil end,
				},
				message = {
					type = "input",
					name = L["MESSAGE"],
					desc = L["MESSAGE_DESC"],
					order = 12,
					disabled = function() return Proculas.editingproc == nil end,
				},
				color = {
					type = "color",
					order = 13,
					name = L["COLOR"],
					desc = L["COLOR_DESC"],
					hasAlpha = true,
					get = function(info)
						if not Proculas.editingproc then return nil end
						local c
						if not Proculas.editingproc.color then c = Proculas.opt.Messages.color else c = Proculas.editingproc.color end
						return c.r, c.g, c.b
					end,
					set = function(info, r, g, b, a)
						if not Proculas.editingproc then return nil end
						if not Proculas.editingproc.color then Proculas.editingproc.color = {r = 1,g = 1,b = 1} end
						local c = Proculas.editingproc.color
						c.r, c.g, c.b = r, g, b
					end,
					disabled = function() return Proculas.editingproc == nil end,
				},
				headerAnnounce = {order=20, type="header", name=L["PROC_ANNOUNCEMENTS"]},
				postproc = {
					type="toggle",
					name = L["ANNOUNCE_PROC"],
					desc = L["ANNOUNCE_PROC_DESC"],
					order = 22,
					tristate = true,
					disabled = function() return Proculas.editingproc == nil end,
				},
				flash = {
					type = "toggle",
					name = L["FLASH_SCREEN"],
					desc = L["FLASH_SCREEN_DESC"],
					order = 23,
					tristate = true,
					disabled = function() return Proculas.editingproc == nil end,
				},                            
				shake = {
					type = "toggle",
					name = L["SHAKE_SCREEN"],
					desc = L["SHAKE_SCREEN_DESC"],
					order = 24,
					tristate = true,
					disabled = function() return Proculas.editingproc == nil end,
				},
				headerSound = {order=30, type="header", name=L["SOUND_SETTINGS"]},
				soundfile = {
					type = "select", dialogControl = 'LSM30_Sound',
					order = 31,
					name = L["SOUND_TO_PLAY"],
					desc = L["SOUND_TO_PLAY"],
					values = AceGUIWidgetLSMlists.sound,
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
		debugver = {
			type = "execute",
			name = L["DEBUGVER_CMD"],
			desc = L["DEBUGVER_CMD"],
			func = function()
				Proculas:debugVersion()
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
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable(L["Proculas"], options)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("Proculas Commands", optionsSlash, "proculas")
	local ACD3 = LibStub("AceConfigDialog-3.0")

	-- The ordering here matters, it determines the order in the Blizzard Interface Options
	self.optionsFrames.Proculas = ACD3:AddToBlizOptions(L["Proculas"], nil, nil, "General")
	self.optionsFrames.Messages = ACD3:AddToBlizOptions(L["Proculas"], L["PROC_SETTINGS"], L["Proculas"], "Procs")
	self.optionsFrames.Messages = ACD3:AddToBlizOptions(L["Proculas"], L["CONFIG_MESSAGES"], L["Proculas"], "Messages")
	self.optionsFrames.Cooldowns = ACD3:AddToBlizOptions(L["Proculas"], L["CONFIG_COOLDOWNS"], L["Proculas"], "Cooldowns")
	self.optionsFrames.Sound = ACD3:AddToBlizOptions(L["Proculas"], L["CONFIG_SOUND"], L["Proculas"], "Sound")
	self.optionsFrames.ProcStats = ACD3:AddToBlizOptions(L["Proculas"], L["CONFIG_PROC_STATS"], L["Proculas"], "ProcStats")
	self:RegisterModuleOptions("Profiles", LibStub("AceDBOptions-3.0"):GetOptionsTable(Proculas.db), L["PROFILES"])
end

function ProculasOptions:RegisterModuleOptions(name, optionTbl, displayName)
	options.args[name] = (type(optionTbl) == "function") and optionTbl() or optionTbl
	self.optionsFrames[name] = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(L["Proculas"], displayName, L["Proculas"], name)
end

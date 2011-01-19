--
-- Proculas
-- Created by Clorell of Hellscream [US]
-- $Id$
--

local Proculas = LibStub("AceAddon-3.0"):GetAddon("Proculas")
local Options = Proculas:NewModule("Options")
local L = LibStub("AceLocale-3.0"):GetLocale("Proculas", false)
local LSM = LibStub("LibSharedMedia-3.0")

if not Proculas.enabled then
	return nil
end

-------------------------------------------------------
-- Proculas Default Options

-- Default options
local defaults = {
	profile = {
		postProcs = true,
		announce = {
			message = L["x_procced"],
			color = {r = 1, g = 1, b = 1},
		},
		effects = {
			flash = false,
			shake = false,
		},
		cooldowns = {
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
		sinkOptions = {
			sink20OutputSink = "Default",
		},
		sound = {
			playSound = true,
			soundFile = "Explosion",
		},
		minimapButton = {
			minimapPos = 200,
			radius = 80,
			hide = false,
			rounding = 10,
		},
		customSounds = {},
	},
}
Proculas.defaults = defaults

local defaultsPC = {
	profile = {
		tracked = {},
		procs = {}
	}
}
Proculas.defaultsPC = defaultsPC

-------------------------------------------------------
-- Proculas Options
local options = {
	type = "group",
	name = L["Proculas"],
	get = function(info) return Proculas.opt[ info[#info] ] end,
	set = function(info, value) Proculas.opt[ info[#info] ] = value end,
	args = {
		general = {
			order = 1,
			type = "group",
			name = L["General Options"],
			desc = L["General Options"],
			get = function(info) return Proculas.opt[ info[#info] ] end,
			set = function(info, value)
				Proculas.opt[ info[#info] ] = value
			end,
			args = {
				postProcs = {
					order = 1,
					name = L["Announce Procs"],
					desc = L["Toggle the announcing of Procs."],
					type = "toggle",
				},
				screenEffectsDesc = {
					order = 2,
					type = "header",
					name = L["Screen Effects"],
				},
				flash = {
					order = 3,
					name = L["Flash Screen"],
					desc = L["Toggle Screen Flashing."],
					type = "toggle",
					get = function(info) return Proculas.opt.effects[ info[#info] ] end,
					set = function(info, value)
						Proculas.opt.effects[ info[#info] ] = value
					end,
				},
				soundDesc = {
					order = 4,
					type = "header",
					name = L['Sound Settings'],
				},
				playSound = {
					order = 5,
					name = L["Play Sound"],
					desc = L["Play Sound"],
					type = "toggle",
					get = function(info) return Proculas.opt.sound[ info[#info] ] end,
					set = function(info, value)
						Proculas.opt.sound[ info[#info] ] = value
					end,
				},
				soundFile = {
					type = "select", dialogControl = 'LSM30_Sound',
					order = 6,
					name = L["Sound to play"],
					desc = L["Sound to play"],
					values = AceGUIWidgetLSMlists.sound,
					get = function(info) return Proculas.opt.sound[ info[#info] ] end,
					set = function(info, value)
						Proculas.opt.sound[ info[#info] ] = value
					end,
				},
				--[[shake = {
					order = 4,
					name = L["Shake Screen"],
					desc = L["Toggle Screen Shaking."],
					type = "toggle",
					get = function(info) return Proculas.opt.effects[ info[#info] ] end,
					set = function(info, value)
						Proculas.opt.effects[ info[#info] ] = value
					end,
				},]]
				miscellaneous = {
					order = 8,
					type = "header",
					name = L["Miscellaneous"],
				},
				minimapButtonHide = {
					order = 9,
					name = L["Hide Minimap Button"],
					desc = L["Toggle the visiblity of the Minimap Button."],
					type = "toggle",
					get = function(info) return Proculas.opt.minimapButton.hide end,
					set = function(info, value)
						Proculas:GetModule("ProculasLDB"):ToggleMMButton(value)
						Proculas.opt.minimapButton.hide = value
					end,
				},
			}
		}, -- General
		announce = {
			order = 2,
			type = "group",
			name = L["Announce Options"],
			desc = L["Announce Options"],
			get = function(info) return Proculas.opt[ info[#info] ] end,
			set = function(info, value)
				Proculas.opt[ info[#info] ] = value
			end,
			args = {
				messageOpt = {
					order = 1,
					type = "header",
					name = L["Announce Options"],
				},
				message = {
					type = "input",
					order = 2,
					name = L["Message"],
					desc = L["The Announce Message."],
				},
				color = {
					type = "color",
					order = 3,
					name = L["Color"],
					desc = L["The color of the message."],
					hasAlpha = true,
					get = function(info)
						local c = Proculas.opt.announce.color
						return c.r, c.g, c.b
					end,
					set = function(info, r, g, b, a)
						local c = Proculas.opt.announce.color
						c.r, c.g, c.b = r, g, b
					end,
				},
				messageLocation = {
					order = 4,
					type = "header",
					name = L["Announce Location"],
				},
				Sink = Proculas:GetSinkAce3OptionsDataTable(),
			}
		}, -- Announce
		cooldowns = {
			type = "group",
			name = L["Cooldown Bars"],
			order = 1,
			get = function(info) return Proculas.opt.cooldowns[ info[#info] ] end,
			set = function(info, value)
				Proculas.opt.cooldowns[ info[#info] ] = value
				Proculas:updateCooldownsFrame()
			end,
			args = {
				--[[procCooldownsDesc = {
					order = 1,
					type = "description",
					name = L["Cooldown Settigns"],
				},]]
				barOptions = {
					type = "group",
					guiInline = true,
					name = L["Bar Options"],
					args = {
						cooldowns = {
							order = 2,
							name = L["Show Cooldowns"],
							desc = L["Show Cooldowns"],
							type = "toggle",
						},
						show = {
							order = 2,
							name = L["Enable"],
							desc = L["Enable showing cooldown bars."],
							type = "toggle",
						},
						movableFrame = {
							type = "toggle",
							name = L["Movable"],
							desc = L["Show the anchor to allow moving."],
							order = 3,
						},
						barTexture = {
							type = "select", dialogControl = 'LSM30_Statusbar',
							name = L["Texture"],
							desc = L["Bar texture."],
							order = 4,
							values = AceGUIWidgetLSMlists.statusbar,
						}, 
						barFont = {
							type = "select", dialogControl = 'LSM30_Font',
							name = L["Font"],
							desc = L["Font used for the bars."],
							order = 5,
							values = AceGUIWidgetLSMlists.font,
						},                        		
						barFontSize = {
							type = "range",
							name = L["Font Size"],
							desc = L["Size of the font."],
							min = 4, max = 30, step = 1,
							order = 7,
						},
						barWidth = {
							type = "range",
							name = L["Bar Width"],
							desc = L["Width of the bar."],
							min = 40,
							max = 300,
							step = 1,
							order = 7,
						},
						barHeight = {
							type = "range",
							name = L["Bar Height"],
							desc = L["Height of the bar."],
							min = 8,
							max = 60,
							step = 1,
							order = 8,
						},
						--divider = {order = 10, type = "header", name = ""},
						colorStart = {
							type = "color",
							order = 9,
							name = L["Start Color"],
							desc = L["Color the bar starts as."],
							hasAlpha = true,
							get = function(info)
								local c = Proculas.opt.cooldowns.colorStart
								return c.r, c.g, c.b, c.a
							end,
							set = function(info, r, g, b, a)
								local c = Proculas.opt.cooldowns.colorStart
								c.r, c.g, c.b, c.a = r, g, b, a
							end,
						},
						colorEnd = {
							type = "color",
							order = 10,
							name = L["End Color"],
							desc = L["Color the bar fades to."],
							hasAlpha = true,
							get = function(info)
								local c = Proculas.opt.cooldowns.colorEnd
								return c.r, c.g, c.b, c.a
							end,
							set = function(info, r, g, b, a)
								local c = Proculas.opt.cooldowns.colorEnd
								c.r, c.g, c.b, c.a = r, g, b, a
							end,
						},
						reverseGrowth = {
							type = "toggle",
							name = L["Grow Upwards"],
							desc = L["Grow bars upwards."],
							order = 11,
						},
						flashTimer = {
							type = "toggle",
							name = L["Flash Bar"],
							desc = L["Check to flash the cooldown bar when its close to ending."],
							order = 12,
							get = function(info)
								if Proculas.opt.cooldowns.flashTimer == 4 then 
									return true
								else
									return false
								end
							end,
							set = function(info,value)
								if value then 
									Proculas.opt.cooldowns.flashTimer = 4
								else
									Proculas.opt.cooldowns.flashTimer = 0
								end
							end,
						},
					}
				}
			}
		}, -- Cooldown Frame/Bars options
		procs = {
			order = 3,
			type = "group",
			name = L["Proc Options"],
			desc = L["Proc Options"],
			get = function(info) return Proculas.editingproc ~= nil and Proculas.editingproc[ info[#info] ] end,
			set = function(info, value)
				if not Proculas.editingproc then return nil end
				Proculas.editingproc[ info[#info] ] = value
			end,
			args = {
				proc = {
					type = "select",
					width = "full",
					order = 1,
					name = L["Select Proc"],
					desc = L["Select a proc to see it's options."],
					values = function()
						local procs = {}
						for index, proc in pairs(Proculas.optpc.procs) do
							procs[proc.procId] = proc.name
						end
						return procs
					end,
					get = function() 
						if Proculas.editingproc ~= nil then
							 return Proculas.editingprocIdent
						end
					end,
					set = function(info,value) 
						Proculas.editingproc = Proculas.optpc.procs[value]
						--Proculas.editingprocIdent = Proculas.optpc.procs[value].name..Proculas.optpc.procs[value].rank
						Proculas.editingprocIdent = Proculas.editingproc.procId
					end
				},
				enabled = {
					type = "toggle",
					name = L["Enabled"],
					desc = L["Enable tracking of this proc."],
					order = 2,
					disabled = function() return Proculas.editingproc == nil end,
				},
				headerCooldown = {order = 3, type = "header", name = L["Cooldown Options"]},
				updateCD = {
					type = "toggle",
					name = L["Update Cooldown"],
					desc = L["Check to enable updating the cooldown time."],
					order = 4,
					disabled = function() return Proculas.editingproc == nil end,
				},
				cooldownTime = {
					type = "range",
					name = L["Cooldown Time"],
					desc = L["The proc cooldown time in seconds."],
					order = 5,
					min = 0,
					max = 600,
					step = 1,
					get = function() 
						if Proculas.editingproc ~= nil then
							return Proculas.optpc.procs[Proculas.editingprocIdent].cooldown 
						end
					end,
					set = function(info,value)
						if(value == 0) then
							Proculas.optpc.procs[Proculas.editingprocIdent].zeroCD = true
							Proculas.optpc.procs[Proculas.editingprocIdent].cooldown = 0
						else
							Proculas.optpc.procs[Proculas.editingprocIdent].zeroCD = nil
							Proculas.optpc.procs[Proculas.editingprocIdent].cooldown = value
						end
					end,
					disabled = function() return Proculas.editingproc == nil end,
				},
				headerMessage = {order = 10, type = "header", name = L["Announce Message"]},
				customMessage = {
					type="toggle",
					name = L["Custom Message"],
					desc = L["Use a custom message for the proc."],
					order = 11,
					disabled = function() return Proculas.editingproc == nil end,
				},
				message = {
					type = "input",
					name = L["Message"],
					desc = L["Enter a custom message."],
					order = 12,
					disabled = function() return Proculas.editingproc == nil end,
				},
				color = {
					type = "color",
					order = 13,
					name = L["Color"],
					desc = L["Proc message color"],
					hasAlpha = true,
					get = function(info)
						if not Proculas.editingproc then return nil end
						local c
						if not Proculas.editingproc.color then c = Proculas.opt.announce.color else c = Proculas.editingproc.color end
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
				headerAnnounce = {order=20, type="header", name=L["Proc Announcements"]},
				postProc = {
					type="toggle",
					name = L["Announce Proc"],
					desc = L["Announce Proc"],
					order = 22,
					tristate = true,
					disabled = function() return Proculas.editingproc == nil end,
				},
				flash = {
					type = "toggle",
					name = L["Flash Screen"],
					desc = L["Flash the screen."],
					order = 23,
					tristate = true,
					disabled = function() return Proculas.editingproc == nil end,
				},                            
				--[[shake = {
					type = "toggle",
					name = L["Shake Screen"],
					desc = L["Shake the screen."],
					order = 24,
					tristate = true,
					disabled = function() return Proculas.editingproc == nil end,
				},]]
				headerSound = {order=30, type="header", name=L["Sound Settings"]},
				soundFile = {
					type = "select", dialogControl = 'LSM30_Sound',
					order = 31,
					name = L["Sound to play"],
					desc = L["Sound to play"],
					values = AceGUIWidgetLSMlists.sound,
					disabled = function() return Proculas.editingproc == nil end,
				},
				headerSound = {order=40, type="header", name=L["Actions"]},
				deleteIt = {
					type = "execute",
					name = L["Delete Proc"],
					desc = L["Delete proc from Proculas"],
					func = function()
						local delProcId = Proculas.editingproc.procId
						Proculas.editingproc = nil
						Proculas:deleteProc(delProcId)
						
					end,
					order = 41,
					disabled = function() return Proculas.editingproc == nil end,
				},
			},
		}, -- Procs
		addProc = {
			order = 3,
			type = "group",
			name = L["Add Proc"],
			desc = L["Add Proc"],
			get = function(info)
				if not Proculas.newproc then return nil end
				return Proculas.newproc[ info[#info] ]
			end,
			set = function(info, value)
				if not Proculas.newproc then return nil end
				Proculas.newproc[ info[#info] ] = value
			end,
			args = {
				addProcHeader = {
					order = 1,
					type = "header",
					name = L["Add Proc"],
				},
				name = {
					type = "input",
					name = L["Name"],
					desc = L["Name of the proc."],
					order = 1,
				},
				spellId = {
					type = "input",
					name = L["Spell IDs"],
					desc = L["IDs of the spells to look for, for example: 2415,2451,5241"],
					order = 2,
				},
				item = {
					type = "toggle",
					name = L["Item"],
					desc = L["Check if this proc is from an item."],
					order = 3,
				},
				itemId = {
					type = "input",
					name = L["Item ID"],
					desc = L["Enter the ID of the item."],
					order = 4,
				},
				eventHeader = {
					order = 10,
					type = "header",
					name = L["Combat Log Events."],
				},
				SPELL_AURA_APPLIED = {
					type = "toggle",
					name = "SPELL_AURA_APPLIED",
					desc = "SPELL_AURA_APPLIED",
					order = 11,
					get = function(info)
						if not Proculas.newproc then return nil end
						return Proculas.newproc.types[ info[#info] ]
					end,
					set = function(info, value)
						if not Proculas.newproc then return nil end
						Proculas.newproc.types[ info[#info] ] = value
					end,
				},
				SPELL_AURA_REFRESH = {
					type = "toggle",
					name = "SPELL_AURA_REFRESH",
					desc = "SPELL_AURA_REFRESH",
					order = 12,
					get = function(info)
						if not Proculas.newproc then return nil end
						return Proculas.newproc.types[ info[#info] ]
					end,
					set = function(info, value)
						if not Proculas.newproc then return nil end
						Proculas.newproc.types[ info[#info] ] = value
					end,
				},
				SPELL_EXTRA_ATTACKS = {
					type = "toggle",
					name = "SPELL_EXTRA_ATTACKS",
					desc = "SPELL_EXTRA_ATTACKS",
					order = 13,
					get = function(info)
						if not Proculas.newproc then return nil end
						return Proculas.newproc.types[ info[#info] ]
					end,
					set = function(info, value)
						if not Proculas.newproc then return nil end
						Proculas.newproc.types[ info[#info] ] = value
					end,
				},
				SPELL_PERIODIC_DAMAGE = {
					type = "toggle",
					name = "SPELL_PERIODIC_DAMAGE",
					desc = "SPELL_PERIODIC_DAMAGE",
					order = 14,
					get = function(info)
						if not Proculas.newproc then return nil end
						return Proculas.newproc.types[ info[#info] ]
					end,
					set = function(info, value)
						if not Proculas.newproc then return nil end
						Proculas.newproc.types[ info[#info] ] = value
					end,
				},
				SPELL_ENERGIZE = {
					type = "toggle",
					name = "SPELL_ENERGIZE",
					desc = "SPELL_ENERGIZE",
					order = 15,
					get = function(info)
						if not Proculas.newproc then return nil end
						return Proculas.newproc.types[ info[#info] ]
					end,
					set = function(info, value)
						if not Proculas.newproc then return nil end
						Proculas.newproc.types[ info[#info] ] = value
					end,
				},
				SPELL_DAMAGE = {
					type = "toggle",
					name = "SPELL_DAMAGE",
					desc = "SPELL_DAMAGE",
					order = 16,
					get = function(info)
						if not Proculas.newproc then return nil end
						return Proculas.newproc.types[ info[#info] ]
					end,
					set = function(info, value)
						if not Proculas.newproc then return nil end
						Proculas.newproc.types[ info[#info] ] = value
					end,
				},
				SPELL_SUMMON = {
					type = "toggle",
					name = "SPELL_SUMMON",
					desc = "SPELL_SUMMON",
					order = 17,
					get = function(info)
						if not Proculas.newproc then return nil end
						return Proculas.newproc.types[ info[#info] ]
					end,
					set = function(info, value)
						if not Proculas.newproc then return nil end
						Proculas.newproc.types[ info[#info] ] = value
					end,
				},
				SPELL_LEECH = {
					type = "toggle",
					name = "SPELL_LEECH",
					desc = "SPELL_LEECH",
					order = 18,
					get = function(info)
						if not Proculas.newproc then return nil end
						return Proculas.newproc.types[ info[#info] ]
					end,
					set = function(info, value)
						if not Proculas.newproc then return nil end
						Proculas.newproc.types[ info[#info] ] = value
					end,
				},
				SPELL_DRAIN = {
					type = "toggle",
					name = "SPELL_DRAIN",
					desc = "SPELL_DRAIN",
					order = 19,
					get = function(info)
						if not Proculas.newproc then return nil end
						return Proculas.newproc.types[ info[#info] ]
					end,
					set = function(info, value)
						if not Proculas.newproc then return nil end
						Proculas.newproc.types[ info[#info] ] = value
					end,
				},
				SPELL_DISPEL = {
					type = "toggle",
					name = "SPELL_DISPEL",
					desc = "SPELL_DISPEL",
					order = 20,
					get = function(info)
						if not Proculas.newproc then return nil end
						return Proculas.newproc.types[ info[#info] ]
					end,
					set = function(info, value)
						if not Proculas.newproc then return nil end
						Proculas.newproc.types[ info[#info] ] = value
					end,
				},
				SPELL_HEAL = {
					type = "toggle",
					name = "SPELL_HEAL",
					desc = "SPELL_HEAL",
					order = 21,
					get = function(info)
						if not Proculas.newproc then return nil end
						return Proculas.newproc.types[ info[#info] ]
					end,
					set = function(info, value)
						if not Proculas.newproc then return nil end
						Proculas.newproc.types[ info[#info] ] = value
					end,
				},
				SWING_EXTRA_ATTACKS = {
					type = "toggle",
					name = "SWING_EXTRA_ATTACKS",
					desc = "SWING_EXTRA_ATTACKS",
					order = 22,
					get = function(info)
						if not Proculas.newproc then return nil end
						return Proculas.newproc.types[ info[#info] ]
					end,
					set = function(info, value)
						if not Proculas.newproc then return nil end
						Proculas.newproc.types[ info[#info] ] = value
					end,
				},
				optionsHeader = {
					order = 40,
					type = "header",
					name = L["Options"],
				},
				selfOnly = {
					type = "toggle",
					name = L['Self Only'],
					desc = L['Only track this proc on myself.'],
					order = 41,
				},
				addIt = {
					type = "execute",
					name = L["Add Proc"],
					desc = L["Add to tracked procs."],
					func = function()
						Proculas:addNewProc()
					end,
				},
			},
		}, -- Add Proc
		sound = {
			order = 3,
			type = "group",
			name = L["Sound"],
			desc = L["Sound"],
			get = function(info) return Proculas.opt.sound[ info[#info] ] end,
			set = function(info, value)
				Proculas.opt.sound[ info[#info] ] = value
			end,
			args = {
				intro = {
					order = 1,
					type = "description",
					name = L["Proculas Sound Options"],
				},
				--[[soundFile = {
					type = "select", dialogControl = 'LSM30_Sound',
					order = 2,
					name = L["Sound to play"],
					desc = L["Sound to play"],
					values = AceGUIWidgetLSMlists.sound,
				},]]
				newCustomSoundHeader = {order = 3, type = "header", name = L["New Custom Sound"]},
				csName = {
					type = "input",
					name = L["Name"],
					desc = L["Name"],
					order = 4,
				},
				csFile = {
					type = "input",
					name = L["Location"],
					desc = L["Custom sound location."],
					order = 5,
				},
				csAdd = {
					type = "execute",
					name = L["Add"],
					desc = L["Add Sound"],
					func = function()
						Proculas:addCustomSound(Proculas.opt.sound.csName,Proculas.opt.sound.csFile);
						Proculas.opt.sound.csName = ""
						Proculas.opt.sound.csFile = ""
					end,
					order = 6,
				},
				deleteCustomSoundHeader = {order = 7, type = "header", name = L["Delete Custom Sounds"]},
				customsound = {
					type = "select",
					order = 8,
					name = L["Select Sound"],
					desc = L["Select custom sound."],
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
					name = L["Delete"],
					desc = L["Delete sound"],
					func = function()
						Proculas:deleteCustomSound(Proculas.editingsound);
					end,
					order = 9,
				},
			},
		}, -- Sound
	}
}
options.args.announce.args.Sink.order = 5
options.args.announce.args.Sink.inline = true
options.args.announce.args.Sink.disabled = function() return not Proculas.opt.postProcs end

function Options:OnInitialize()
	self:SetupOptions()
end

function Options:SetupOptions()
	self.optionsFrames = {}

	-- setup options table
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("Proculas", options)
	--LibStub("AceConfig-3.0"):RegisterOptionsTable("Proculas Commands", optionsSlash, "proculas")
	local ACD3 = LibStub("AceConfigDialog-3.0")

	-- The ordering here matters, it determines the order in the Blizzard Interface Options
	self.optionsFrames.Proculas = ACD3:AddToBlizOptions("Proculas", nil, nil, "general")
	self.optionsFrames.Announce = ACD3:AddToBlizOptions("Proculas", L["Announce Options"], "Proculas", "announce")
	self.optionsFrames.CooldownBars = ACD3:AddToBlizOptions("Proculas", L["Cooldown Bars"], "Proculas", "cooldowns")
	self.optionsFrames.Procs = ACD3:AddToBlizOptions("Proculas", L["Proc Options"], "Proculas", "procs")
	self.optionsFrames.AddProc = ACD3:AddToBlizOptions("Proculas", L["Add Proc"], "Proculas", "addProc")
	self.optionsFrames.Sounds = ACD3:AddToBlizOptions("Proculas", L["Sound"], "Proculas", "sound")
	self:RegisterModuleOptions("Profiles", LibStub("AceDBOptions-3.0"):GetOptionsTable(Proculas.db), L["Profiles"])
end

function Options:RegisterModuleOptions(name, optionTbl, displayName)
	options.args[name] = (type(optionTbl) == "function") and optionTbl() or optionTbl
	self.optionsFrames[name] = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Proculas", displayName, "Proculas", name)
end
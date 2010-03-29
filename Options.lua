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
		tracked = {}
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
				shake = {
					order = 4,
					name = L["Shake Screen"],
					desc = L["Toggle Screen Shaking."],
					type = "toggle",
					get = function(info) return Proculas.opt.effects[ info[#info] ] end,
					set = function(info, value)
						Proculas.opt.effects[ info[#info] ] = value
					end,
				},
				miscellaneous = {
					order = 5,
					type = "header",
					name = L["Miscellaneous"],
				},
				minimapButtonHide = {
					order = 6,
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
						for index, proc in pairs(Proculas.optpc.tracked) do
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
						Proculas.editingproc = Proculas.optpc.tracked[value]
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
			},
		}, -- Procs
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
	self.optionsFrames.Procs = ACD3:AddToBlizOptions("Proculas", L["Proc Options"], "Proculas", "procs")
	self:RegisterModuleOptions("Profiles", LibStub("AceDBOptions-3.0"):GetOptionsTable(Proculas.db), L["Profiles"])
end

function Options:RegisterModuleOptions(name, optionTbl, displayName)
	options.args[name] = (type(optionTbl) == "function") and optionTbl() or optionTbl
	self.optionsFrames[name] = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Proculas", displayName, "Proculas", name)
end
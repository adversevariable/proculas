--
-- ProculasLDB
-- Sends the Proc Stats to DataBroker
-- Created by Clorell/Keruni of Argent Dawn [US]
-- $Id$
--

local Proculas = LibStub("AceAddon-3.0"):GetAddon("Proculas")
local L = LibStub("AceLocale-3.0"):GetLocale("Proculas", false)

ProculasLDB = Proculas:NewModule("ProculasLDB")

local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local dataobj = ldb:NewDataObject("Proculas", {
		type = "data source",
		icon = "Interface\\Icons\\Spell_Holy_Aspiration",
		text = "Proculas",
		OnTooltipShow = function() ProculasLDB:doTooltip() end,
		})

function ProculasLDB:OnInitialize()
	self.opt = Proculas.opt
	self.icon = LibStub("LibDBIcon-1.0")
	self.icon:Register("Proculas", dataobj, self.opt.minimapButton)
end

function ProculasLDB:UpdateText(enabled)
	if enabled then
		dataobj.text = "Enabled"
	else
		dataobj.text = "Disabled"
	end
end

function ProculasLDB:ToggleMMButton(value)
	if value then
		self.icon:Hide("Proculas")
	else
		self.icon:Show("Proculas")
	end
end

function dataobj:OnEnter()
    --[[GameTooltip:SetOwner(self, "ANCHOR_NONE")
	GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT")
    GameTooltip:ClearLines()
	
	GameTooltip:AddLine("Proculas")
	GameTooltip:AddLine(" ")

	Proculas:procStatsTooltip()
	
	GameTooltip:AddLine(L["RC2OPENOPTIONS"], 0, 1, 0)
    GameTooltip:AddLine(L["ALTCLICK2RESET"], 0, 1, 0)
    
    GameTooltip:Show()]]
end

function ProculasLDB:doTooltip()
	GameTooltip:AddLine("Proculas")
	GameTooltip:AddLine(" ")

	Proculas:procStatsTooltip()
	
	GameTooltip:AddLine(L["RC2OPENOPTIONS"], 0, 1, 0)
    GameTooltip:AddLine(L["ALTCLICK2RESET"], 0, 1, 0)
end

function dataobj:OnLeave()
    GameTooltip:Hide()
end

function dataobj:OnClick(button)
	if button == "LeftButton" and IsAltKeyDown() then
		Proculas:resetProcStats()
	elseif button == "RightButton" then
		Proculas:ShowConfig()
	end
end

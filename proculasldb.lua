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
		text = "Proculas"
		})
Proculas.ldbobj = dataobj		

function ProculasLDB:UpdateText(enabled)
	if enabled then
		dataobj.text = "Enabled"
	else
		dataobj.text = "Disabled"
	end
end

function dataobj:OnEnter()
    GameTooltip:SetOwner(self, "ANCHOR_NONE")
	GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT")
    GameTooltip:ClearLines()

	Proculas:procStatsTooltip()
	
	GameTooltip:AddLine(L["RC2OPENOPTIONS"], 0, 1, 0)
    GameTooltip:AddLine(L["ALTCLICK2RESET"], 0, 1, 0)
    
    GameTooltip:Show()
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

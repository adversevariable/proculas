--
-- ProculasLDB
-- Sends the Proc Stats to DataBroker
-- Created by Clorell/Keruni of Argent Dawn [US]
-- $Id$
--

local Proculas = LibStub("AceAddon-3.0"):GetAddon("Proculas")
local L = LibStub("AceLocale-3.0"):GetLocale("Proculas", false)
local tooltip
local LibQTip = LibStub:GetLibrary( "LibQTip-1.0" )
ProculasLDB = Proculas:NewModule("ProculasLDB")

local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local dataobj = ldb:NewDataObject("Proculas", {
		type = "data source",
		icon = "Interface\\Icons\\Spell_Holy_Aspiration",
		text = "Proculas",
	})

function ProculasLDB:OnInitialize()
	self.opt = Proculas.opt
	self.icon = LibStub("LibDBIcon-1.0")
	tooltip = LibQTip:Acquire("ProculasProcStats", 4, "LEFT", "CENTER", "CENTER", "RIGHT")
	
	self.icon:Register("Proculas", dataobj, self.opt.minimapButton)
end

function ProculasLDB:ToggleMMButton(value)
	if value then
		self.icon:Hide("Proculas")
	else
		self.icon:Show("Proculas")
	end
end

local function Yellow(text) return "|cffffd200"..text.."|r" end
local function Green(text) return "|cff00ff00"..text.."|r" end
function dataobj:OnEnter()
	tooltip:Hide()
	tooltip:Clear()

	tooltip:AddHeader(Yellow(L["Proculas"]))
	tooltip:AddLine(" ")
	
	--Proculas:procStatsTooltip(tooltip)
	tooltip:AddLine(Yellow(L["PROC"].." "),Yellow(" "..L["TOTAL_PROCS"].." "),Yellow(" "..L["PPM"].." "),Yellow(" "..L["COOLDOWN"].." "))
	for a,proc in pairs(Proculas.procstats) do
		if Proculas.procopts[proc.spellID] then
			local procOpt = Proculas.procopts[proc.spellID]
			if not procOpt.enabled then
				break
			end
		end
		if(proc.name) then
			if proc.count > 0 then
				procCount = proc.count
			else
				procCount = "N/A"
			end
			if proc.cooldown > 0 then
				procCooldown = proc.cooldown
			else
				procCooldown = "N/A"
			end
			
			local ppm = 0
			if proc.count > 0 then
				ppm = proc.count / (proc.totaltime / 60)
			end
			
			if ppm > 0 then
				procPPM = string.format("%.2f", ppm)
			else
				procPPM = "N/A"
			end
			
			tooltip:AddLine(Green(proc.name), procCount, procPPM, procCooldown)
		end
	end
	tooltip:AddLine(" ")
	
	local lineNumA = tooltip:AddLine("a")
	tooltip:SetCell(lineNumA, 1, Green(L["RC2OPENOPTIONS"]), "LEFT", 4)
	local lineNumB = tooltip:AddLine("b")
	tooltip:SetCell(lineNumB, 1, Green(L["ALTCLICK2RESET"]), "LEFT", 4)
	
	tooltip:SmartAnchorTo(self)
	tooltip:Show()
end

function dataobj:OnLeave()
	tooltip:Hide()
end

function dataobj:OnClick(button)
	if button == "LeftButton" and IsAltKeyDown() then
		Proculas:resetProcStats()
	elseif button == "RightButton" then
		Proculas:ShowConfig()
	end
end

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
	tooltip = LibQTip:Acquire("ProculasProcStats", 5, "LEFT", "CENTER", "CENTER", "CENTER","RIGHT")
	tooltip:Hide()
	tooltip:Clear()

	tooltip:AddHeader(L["Proculas"])
	tooltip:AddLine(" ")
	
	--Proculas:procStatsTooltip(tooltip)
	tooltip:AddLine(Yellow(L["PROC"].." "),Yellow(" "..L["TOTAL_PROCS"].." "),Yellow(" "..L["PPM"].." "),Yellow(" "..L["COOLDOWN"].." "),Yellow(" "..L["UPTIME"]))
	for a,proc in pairs(Proculas.procstats) do
		if Proculas.procopts[proc.spellID] then
			local procOpt = Proculas.procopts[proc.spellID]
			if not procOpt.enabled then
				break
			end
		end
		if(proc.name) then
			-- Proc Count
			if proc.count > 0 then
				procCount = proc.count
			else
				procCount = "N/A"
			end
			
			-- Proc Cooldown
			if proc.cooldown > 0 then
				procCooldown = proc.cooldown
			elseif proc.cooldown == 0 and proc.count > 1 then
				procCooldown = 0
			else
				procCooldown = "N/A"
			end
			
			-- Procs Per Minute
			local ppm = 0
			if proc.count > 0 then
				ppm = proc.count / (proc.totaltime / 60)
			end
			if ppm > 0 then
				procPPM = string.format("%.2f", ppm)
			else
				procPPM = "N/A"
			end
			
			-- Proc Uptime
			if not proc.seconds then
				proc.seconds = 0
			end
			local uptime = 0
			if proc.seconds > 0 and proc.totaltime > 0 then
				uptime = proc.seconds / proc.totaltime * 100
			end
			if(uptime > 0) then
				procUptime = string.format("%.2f", uptime).."%";
			else
				procUptime = "N/A"
			end
			tooltip:AddLine(Green(proc.name), procCount, procPPM, procCooldown, procUptime)
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
	LibQTip:Release(self.tooltip)
	tooltip = nil
end

function dataobj:OnClick(button)
	if button == "LeftButton" and IsAltKeyDown() then
		Proculas:resetProcStats()
	elseif button == "RightButton" then
		Proculas:ShowConfig()
	end
end

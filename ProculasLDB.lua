--
-- ProculasLDB
-- Sends the Proc Stats to DataBroker
-- Created by Clorell of Hellscream [US]
-- $Id$
--

local Proculas = LibStub("AceAddon-3.0"):GetAddon("Proculas")
local L = LibStub("AceLocale-3.0"):GetLocale("Proculas", false)
local tooltip
local LibQTip = LibStub:GetLibrary( "LibQTip-1.0")
ProculasLDB = Proculas:NewModule("ProculasLDB")

if not Proculas.enabled then
	return nil
end

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
	tooltip:AddLine(Yellow(L["Proc"].." "),Yellow(" "..L["Total"].." "),Yellow(" "..L["PPM"].." "),Yellow(" "..L["CD"].." "),Yellow(" "..L["Uptime"]))
	for a,proc in pairs(Proculas.optpc.procs) do
		if not proc.enabled then
			break
		end
		if(proc.name) then
			if proc.count > 0 then
				-- Proc Count
				if proc.count > 0 then
					procCount = proc.count
				else
					procCount = L["NA"]
				end
				
				-- Proc Cooldown
				if proc.cooldown > 0 then
					procCooldown = proc.cooldown
				elseif proc.cooldown == 0 and proc.count > 1 then
					procCooldown = 0
				else
					procCooldown = L["NA"]
				end
				
				-- Procs Per Minute
				local ppm = 0
				if proc.count > 0 then
					ppm = proc.count / (proc.time / 60)
				end
				if ppm > 0 then
					procPPM = string.format("%.2f", ppm)
				else
					procPPM = L["NA"]
				end
				
				-- Proc Uptime
				if not proc.uptime then
					proc.uptime = 0
				end
				local uptime = 0
				if proc.uptime > 0 and proc.time > 0 then
					uptime = proc.uptime / proc.time * 100
				end
				if(uptime > 0) then
					procUptime = string.format("%.2f", uptime).."%";
				else
					procUptime = L["NA"]
				end
				
				-- Proc Name
				if not proc.rank == "" then
					procName = proc.name.." "..proc.rank
				else
					procName = proc.name
				end
				tooltip:AddLine(Green(procName), procCount, procPPM, procCooldown, procUptime)
			end
		end
	end
	tooltip:AddLine(" ")
	
	local lineNumA = tooltip:AddLine("a")
	tooltip:SetCell(lineNumA, 1, Green(L["Right click to open config"]), "LEFT", 4)
	local lineNumB = tooltip:AddLine("b")
	tooltip:SetCell(lineNumB, 1, Green(L["Alt click to reset stats"]), "LEFT", 4)
	
	tooltip:SmartAnchorTo(self)
	tooltip:Show()
end

function dataobj:OnLeave()
	tooltip:Hide()
	LibQTip:Release(tooltip)
	tooltip = nil
end

function dataobj:OnClick(button)
	if button == "LeftButton" and IsAltKeyDown() then
		Proculas:resetProcStats()
	elseif button == "RightButton" then
		Proculas:ShowConfig()
	end
end

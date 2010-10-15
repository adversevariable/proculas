--
-- Proculas: Druid Procs
-- Created by Clorell of US Hellscream
--
-- Generated by ProcDB 2.0
--

if select(2, UnitClass("player")) ~= "DRUID" then return end

local Proculas = LibStub("AceAddon-3.0"):GetAddon("Proculas")
local DruidProcs = Proculas:NewModule("DruidProcs")

if not Proculas.enabled then
	return nil
end

local PROCS = {
}

function DruidProcs:OnInitialize()
	Proculas:addProcList('DRUID',PROCS)
end
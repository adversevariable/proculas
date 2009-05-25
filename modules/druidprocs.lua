--
-- Proculas: Druid Procs
-- Created by Clorell/Keruni of Argent Dawn [US]
--
-- Generated by Proculas ProcDB Manager 1.3
--

if select(2, UnitClass("player")) ~= "DRUID" then return end

local Proculas = LibStub("AceAddon-3.0"):GetAddon("Proculas")
local ProculasDruid = Proculas:NewModule("DruidProcs")

local PROCS = {
	[16870] = {
		name = "Clearcasting",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 133 
		-- name: Clearcasting 
		-- type: DRUID 
	},
	[48518] = {
		name = "Eclipse",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 134 
		-- name: Eclipse 
		-- type: DRUID 
	},
	[48517] = {
		name = "Eclipse",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 135 
		-- name: Eclipse 
		-- type: DRUID 
	},
	[46833] = {
		name = "Wrath of Elune",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 262 
		-- name: Wrath of Elune 
		-- type: DRUID 
	},
	[62606] = {
		name = "Savage Defense",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 295 
		-- name: Savage Defense 
		-- type: DRUID 
	},
	[64823] = {
		name = "Elune's Wrath",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 297 
		-- name: Elune's Wrath 
		-- type: DRUID 
	},
}

function ProculasDruid:OnInitialize()
	Proculas:addProcList('DRUID',PROCS)
end

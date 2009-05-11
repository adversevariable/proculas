--
-- Proculas: Mage Procs
-- Created by Clorell/Keruni of Argent Dawn [US]
--
-- Generated by Proculas ProcDB Manager 1.3
--

if select(2, UnitClass("player")) ~= "MAGE" then return end

local Proculas = LibStub("AceAddon-3.0"):GetAddon("Proculas")
local ProculasMage = Proculas:NewModule("MageProcs")

local PROCS = {
	[44401] = {
		name = "Missile Barrage",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 112 
		-- name: Missile Barrage 
		-- type: MAGE 
	},
	[44544] = {
		name = "Fingers of Frost",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 113 
		-- name: Fingers of Frost 
		-- type: MAGE 
	},
	[57761] = {
		name = "Brain Freeze",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 114 
		-- name: Brain Freeze 
		-- type: MAGE 
	},
	[12536] = {
		name = "Clearcasting",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 115 
		-- name: Clearcasting 
		-- type: MAGE 
	},
	[48108] = {
		name = "Hot Streak",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 116 
		-- name: Hot Streak 
		-- type: MAGE 
	},
	[54741] = {
		name = "Firestarter",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 117 
		-- name: Firestarter 
		-- type: MAGE 
	},
	[12355] = {
		name = "Impact",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 260 
		-- name: Impact 
		-- type: MAGE 
	},
	[12497] = {
		name = "Frostbite",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 261 
		-- name: Frostbite 
		-- type: MAGE 
	},
	[64868] = {
		name = "Praxis",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 1,
		-- Proc Info
		-- ID: 281 
		-- name: Praxis 
		-- type: MAGE 
	},
}

function ProculasMage:OnInitialize()
	Proculas:addProcList('MAGE',PROCS)
end

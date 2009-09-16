--
-- Proculas: Embroidery Procs
-- Created by Clorell of Hellscream [US]
--
-- Generated by Proculas ProcDB Manager 1.3
--

local Proculas = LibStub("AceAddon-3.0"):GetAddon("Proculas")
local ProculasEmbroidery = Proculas:NewModule("EmbroideryProcs")

local PROCS = {
	[3728] = {
		spellID = 55767,
		name = "Darkglow Embroidery",
		types = {"SPELL_ENERGIZE"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 193 
		-- name: Darkglow Embroidery 
		-- type: embroidery 
	},
	[3722] = {
		spellID = 55637,
		name = "Lightweave Embroidery",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 221 
		-- name: Lightweave Embroidery 
		-- type: embroidery 
	},
	[3730] = {
		spellID = 55775,
		name = "Swordguard Embroidery",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 222 
		-- name: Swordguard Embroidery 
		-- type: embroidery 
	},
}

function ProculasEmbroidery:OnInitialize()
	Proculas:addProcList('Enchants',PROCS)
end

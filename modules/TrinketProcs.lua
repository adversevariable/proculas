--
-- Proculas: Trinket Procs
-- Created by Clorell of US Hellscream
--
-- Generated by ProcDB 2.0
--

local Proculas = LibStub("AceAddon-3.0"):GetAddon("Proculas")
local TrinketProcs = Proculas:NewModule("TrinketProcs")

if not Proculas.enabled then
	return nil
end

local PROCS = {
	[47216] = {spellIds={"67631"},types={"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},onSelfOnly=0}, -- Proc #5: The Black Heart
	[50362] = {spellIds={"71484","71485","71486","71487","71491","71492"},types={"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},onSelfOnly=0}, -- Proc #8: Deathbringers Will
	[50363] = {spellIds={"71484","71485","71486","71487","71491","71492"},types={"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},onSelfOnly=0}, -- Proc #9: Heroic Deathbringers Will
	[50342] = {spellIds={"71401"},types={"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},onSelfOnly=0}, -- Proc #12: Whispering Fanged Skull
	[50343] = {spellIds={"71541"},types={"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},onSelfOnly=0}, -- Proc #13: Heroic Whispering Fanged Skull
}

function TrinketProcs:OnInitialize()
	Proculas:addProcList('ITEMS',PROCS)
end
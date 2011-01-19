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
	[59520] = {spellIds={"92108"},types={"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},onSelfOnly=0,procId="1"}, -- Proc #1: Unheeded Warning
	[59326] = {spellIds={"91007"},types={"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},onSelfOnly=0,procId="2"}, -- Proc #2: Bell of Enraging Resonance
	[59224] = {spellIds={"91816"},types={"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},onSelfOnly=0,procId="3"}, -- Proc #3: Heart of Rage
	[59441] = {spellIds={"92124"},types={"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},onSelfOnly=0,procId="4"}, -- Proc #4: Prestor's Talisman of Machination
}

function TrinketProcs:OnInitialize()
	Proculas:addProcList('ITEMS',PROCS)
end
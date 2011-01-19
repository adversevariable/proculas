--
-- Proculas: Ring Procs
-- Created by Clorell of US Hellscream
--
-- Generated by ProcDB 2.0
--

local Proculas = LibStub("AceAddon-3.0"):GetAddon("Proculas")
local RingProcs = Proculas:NewModule("RingProcs")

if not Proculas.enabled then
	return nil
end

local PROCS = {
	[50402] = {spellIds={"72412"},types={"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},onSelfOnly=0,procId="5"}, -- Proc #5: Ashen Band of Endless Vengeance
	[50404] = {spellIds={"72414"},types={"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},onSelfOnly=0,procId="6"}, -- Proc #6: Ashen Band of Endless Courage
	[50398] = {spellIds={"72416"},types={"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},onSelfOnly=0,procId="7"}, -- Proc #7: Ashen Band of Endless Destruction
	[52572] = {spellIds={"72412"},types={"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},onSelfOnly=0,procId="8"}, -- Proc #8: Ashen Band of Endless Might
	[50400] = {spellIds={"72418"},types={"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},onSelfOnly=0,procId="9"}, -- Proc #9: Ashen Band of Endless Wisdom
}

function RingProcs:OnInitialize()
	Proculas:addProcList('ITEMS',PROCS)
end
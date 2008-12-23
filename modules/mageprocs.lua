local Proculas = LibStub("AceAddon-3.0"):GetAddon("Proculas")
ProculasMage = Proculas:NewModule("ProculasMage")

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
}

function ProculasMage:OnInitialize()
	Proculas:addProcList('MAGE',PROCS)
	Proculas:Print("Mage Procs Loaded")
end

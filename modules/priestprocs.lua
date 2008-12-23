local Proculas = LibStub("AceAddon-3.0"):GetAddon("Proculas")
ProculasPriest = Proculas:NewModule("ProculasPriest")

local PROCS = {
	[33151] = {
		name = "Surge of Light",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 129 
		-- name: Surge of Light 
		-- type: PRIEST 
	},
	[34754] = {
		name = "Clearcasting",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 130 
		-- name: Clearcasting 
		-- type: PRIEST 
	},
}

function ProculasPriest:OnInitialize()
	Proculas:addProcList('PRIEST',PROCS)
	Proculas:Print("Priest Procs Loaded")
end

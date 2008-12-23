local Proculas = LibStub("AceAddon-3.0"):GetAddon("Proculas")
ProculasHunter = Proculas:NewModule("ProculasHunter")

local PROCS = {
	[6150] = {
		name = "Quick Shots",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 143 
		-- name: Quick Shots 
		-- type: HUNTER 
	},
	[53257] = {
		name = "Cobra Strikes",
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 144 
		-- name: Cobra Strikes 
		-- type: HUNTER 
	},
}

function ProculasHunter:OnInitialize()
	Proculas:addProcList('HUNTER',PROCS)
	Proculas:Print("Hunter Procs Loaded")
end

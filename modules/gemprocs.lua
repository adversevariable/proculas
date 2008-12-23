local Proculas = LibStub("AceAddon-3.0"):GetAddon("Proculas")
ProculasGem = Proculas:NewModule("ProculasGem")

local PROCS = {
	[55382] = {
		itemID = 41401,
		types = {"SPELL_AURA_APPLIED","SPELL_AURA_REFRESH"},
		selfOnly = 0,
		-- Proc Info
		-- ID: 42 
		-- name: Insightful Earthsiege Diamond 
		-- type: gem 
	},
}

function ProculasGem:OnInitialize()
	Proculas:addProcList('Gems',PROCS)
	Proculas:Print("Gem Procs Loaded")
end

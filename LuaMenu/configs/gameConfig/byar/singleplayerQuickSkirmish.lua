local skirmishSetupData = {
	pages = {
		{
			humanName = "Select Game Type",
			name = "gameType",
			options = {
				"1v1",
				"2v2",
				"3v3",
				"Scavengers",
				"Raptors",
			},
			optionTooltip = {
				"1 vs 1 against AI",
				"2 vs 2 with an AI ally and enemies",
				"3 vs 3 with AI allies and enemies",
				"PvE: Defend against waves of Scavenger units",
				"PvE: Face hordes of alien Raptors",
			}
		},
		{
			humanName = "Select Difficulty",
			name = "difficulty",
			options = {
				"Easy",
				"Medium",
				"Hard",
			},
			optionTooltip = {
				"For players new to RTS games.",
				"For players familiar with RTS games.",
				"For veteran RTS players.",
			}
		},
		{
			humanName = "Select Map",
			name = "map",
			minimap = true,
			tipText = "Click 'Advanced' for more maps and options.",
			options = {
				"Archsimkats_Valley_V1",
				"Eye Of Horus 1.7.1",
				"Ditched_V1",
				"Otago 1.43",
				"Altair_Crossing_V4.1",
				"Isidis crack 1.1",
			},
		},
	},
}

function skirmishSetupData.ApplyFunction(battleLobby, pageChoices)
	local difficulty = pageChoices.difficulty or 2
	local gameType = pageChoices.gameType or 1
	local map = pageChoices.map or 1

	local pageConfig = skirmishSetupData.pages
	battleLobby:SelectMap(pageConfig[3].options[map])

	battleLobby:SetBattleStatus({
		allyNumber = 0,
		isSpectator = false,
	})

	-- Handle PvE modes
	local pveDifficultyMap = {
		["Easy"] = "easy",
		["Medium"] = "normal",
		["Hard"] = "hard"
	}

	if gameType == 4 then -- Scavengers
		battleLobby:AddAi("ScavengersDefenseAI(1)", "ScavengersAI", 1)
		battleLobby:SetModOptions({scav_difficulty = pveDifficultyMap[pageConfig[2].options[difficulty]]})
		return
	elseif gameType == 5 then -- Raptors
		battleLobby:AddAi("RaptorsDefenseAI(1)", "RaptorsAI", 1)
		battleLobby:SetModOptions({raptor_difficulty = pveDifficultyMap[pageConfig[2].options[difficulty]]})
		return
	end

	-- Regular AI games
	local aiName = "BARbarianAI"
	local displayName = aiName
	local aiNumber = 1
	local allies = gameType - 1

	for i = 1, allies do
		local aiOptions = {
			profile = pageConfig[2].options[difficulty]
		}
		local battleStatusOptions = {
			allyNumber = 0,
			side = math.random(0, 1),
		}
		battleLobby:AddAi(displayName .. "(" .. aiNumber .. ")", "BARb", 0, nil, aiOptions, battleStatusOptions)
		aiNumber = aiNumber + 1
	end

	local enemies = gameType
	for i = 1, enemies do
		local aiOptions = {
			profile = pageConfig[2].options[difficulty]
		}
		local battleStatusOptions = {
			allyNumber = 1,
			side = math.random(0, 1),
		}
		battleLobby:AddAi(displayName .. "(" .. aiNumber .. ")", "BARb", 1, nil, aiOptions, battleStatusOptions)
		aiNumber = aiNumber + 1
	end
end

return skirmishSetupData

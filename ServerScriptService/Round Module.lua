local status : StringValue = game:GetService("ReplicatedStorage").Status
local serverStorage = game:GetService("ServerStorage")
local infectionBarGui = serverStorage:WaitForChild("InfectionBarGUI")

local module = {}

module.Intermission = function (GAME_TIME)
	for i = GAME_TIME, 1, -1 do
		status.Value = i
		wait(1)
	end
end

module.ChooseMap = function (maps)
	return maps[math.random(1, #maps)]
end

module.LoadMap = function (map)
	local mapClone = map:Clone()
	mapClone.Parent = game.workspace
	mapClone.Name = "Map"
	return mapClone
end

module.ChooseInfectedPlayer = function (players)
	return players[math.random(#players)]
end

module.GiveTags = function (players, tagName)
	for _, player in pairs(players) do
		local tag = Instance.new("StringValue")
		tag.Name = tagName
		tag.Parent = player
	end
end 

module.TeleportPlayers = function (players, map: Model)
	local mapSpawns = map:WaitForChild("Spawns"):GetChildren()

	for _, player in pairs(players) do
		local character = player.Character
		if character then
			local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
			if humanoidRootPart then
				local randomSpawn = mapSpawns[math.random(1, #mapSpawns)]
				humanoidRootPart.CFrame = randomSpawn.CFrame + Vector3.new(0, 5, 0)
			end
		end
	end
end

module.SetupInfectedPlayer = function (infectedPlayer)
	-- Wait for the character to load if it doesn't exist
	local character = infectedPlayer.Character or infectedPlayer.CharacterAdded:Wait()

	local humanoid = character:WaitForChild("Humanoid")
	humanoid.WalkSpeed = 25

	local infection = Instance.new("IntValue")
	infection.Name = "Infection"
	infection.Value = 100
	infection.Parent = infectedPlayer

	-- Assuming infectionBarGui is defined somewhere in your module
	local infectionBarClone = infectionBarGui:Clone()
	infectionBarClone:WaitForChild("InfectionBar"):WaitForChild("Player").Value = infectedPlayer
	humanoid.HealthDisplayDistance = 0
	infectionBarClone.Parent = character:WaitForChild("Head")

	-- You might want to return the infection value for further use
	return infection
end

module.InfectedPlayersDamage = function (infectedPlayers)
	while task.wait(1) do
		local playersToRemove = {}
		for i, v in pairs(infectedPlayers) do
			local infectionValue = v:WaitForChild("Infection")
			infectionValue.Value = infectionValue.Value - 1
			if (infectionValue.Value <= 0) then
				local character = v.Character or v.CharacterAdded:Wait()
				local humanoid = character:WaitForChild("Humanoid")
				humanoid.Health = 0
				table.insert(playersToRemove, i)
			end
		end
		for i = #playersToRemove, 1, -1 do
			table.remove(infectedPlayers, playersToRemove[i])
		end
	end
end

-- Timer function
module.Timer = function (GAME_TIME)
	for i = GAME_TIME, 0, -1  do
		status.Value = i
		wait(1)
	end
end

module.CleanupPlayer = function (player)
	for _, child in pairs(player:GetChildren()) do
		if child:IsA("StringValue") or child:IsA("IntValue") then
			child:Destroy()
		end
	end
	local character = player.Character
	if character then
		local head = character:FindFirstChild("Head")
		if head then
			local infectionBar = head:FindFirstChild("InfectionBarGUI")
			if infectionBar then
				infectionBar:Destroy()
			end
		end
	end
end


return module

local status : StringValue = game:GetService("ReplicatedStorage").Status

local module = {}

module.Intermission = function (GAME_TIME)
	for i = GAME_TIME, 1, -1 do
		status.Value = i
		wait(1)
	end
end

module.ChooseMap = function (maps)
	local randomNum = math.random(1, #maps)
	local randomMap = maps[randomNum]
	if randomMap then
		return randomMap
	end
end

module.LoadMap = function (map)
	local mapClone = map:Clone()
	mapClone.Parent = game.workspace
	mapClone.Name = "Map"
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


return module

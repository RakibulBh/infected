local roundModule = require(script.RoundModule)
local maps = game:GetService("ServerStorage").Maps:GetChildren()
local ReplicatedStorage  = game:GetService("ReplicatedStorage")
local status = ReplicatedStorage:FindFirstChild("Status")
local lobby = game.Workspace.Lobby

while true do
	roundModule.Intermission(15)
	status.Value = "Choosing map..."
	task.wait(2)
	local chosenMap = roundModule.ChooseMap(maps)
	status.Value = "Map chosen: "..chosenMap.Name
	local mapClone = roundModule.LoadMap(chosenMap)
	task.wait(1)
	local infectedPlayer : Player = roundModule.ChooseInfectedPlayer(game.Players:GetPlayers())
	roundModule.GiveTags({infectedPlayer}, "Infected")
	status.Value = infectedPlayer.Name.." has been infected!"
	task.wait(0.5)

	local players = {}
	local infectedPlayers = {}
	local uninfectedPlayers = {}
	
	for i, v in game.Players:GetPlayers() do
		local character = v.Character or v.CharacterAdded:Wait()
		if not v:FindFirstChild("Infected") then
			table.insert(uninfectedPlayers, v)
			for _, char in pairs(character:GetChildren()) do
				if char:IsA("BasePart") then
					char.Touched:Connect(function(hit)
						local player = game.Players:GetPlayerFromCharacter(hit.Parent)
						if player and player:FindFirstChild("Infected") and not v:FindFirstChild("Infected") then
							roundModule.SetupInfectedPlayer(v)
							table.insert(infectedPlayers, v)
							table.remove(uninfectedPlayers, table.find(uninfectedPlayers, v))
							roundModule.GiveTags({v}, "Infected")
							v:FindFirstChild("Uninfected"):Destroy()
						end
					end)
				end
			end
		else
			table.insert(infectedPlayers, v)
		end
		table.insert(players, v)
		character:WaitForChild("Humanoid").Died:Connect(function()
			if v:FindFirstChild("Infected") then
				table.remove(infectedPlayers, table.find(infectedPlayers, v))
			elseif v:FindFirstChild("Uninfected") then
				table.remove(uninfectedPlayers, table.find(players, v))
			end
			table.remove(players, table.find(players, v))
			roundModule.CleanupPlayer(v)
		end)
	end
	
	local outcome
	
	roundModule.GiveTags(uninfectedPlayers, "Uninfected")
	roundModule.TeleportPlayers(uninfectedPlayers, chosenMap)
	task.wait(2)
	
	roundModule.SetupInfectedPlayer(infectedPlayer)
	roundModule.TeleportPlayers({infectedPlayer}, chosenMap)
	local taskToDo = coroutine.create(roundModule.InfectedPlayersDamage)
	coroutine.resume(taskToDo, infectedPlayers)
	
	local timerEnded = false
	local timer = coroutine.create(function()
		roundModule.Timer(20)
		timerEnded = true
	end)
	coroutine.resume(timer)

	task.wait(2)
	
	while true do
		if #uninfectedPlayers == 0 then
			outcome = "The virus has won"
			coroutine.close(timer)
			break
		end
		if timerEnded then
			outcome = "Time's up, players have won"
			coroutine.close(timer)
			break
		end
		if #infectedPlayers == 0 then
			outcome = "Not enough infected players"
			coroutine.close(timer)
			break
		end
		task.wait()
	end
	

	for _, player in pairs(players) do
		roundModule.CleanupPlayer(player)
		local character = player.Character or player.CharacterAdded:Wait()
		local humanoid = character:WaitForChild("Humanoid")
		humanoid.WalkSpeed = 16
	end
	
	roundModule.TeleportPlayers(players, lobby)
	
	status.Value = outcome
	task.wait(5)
	
	mapClone:Destroy()
	

end




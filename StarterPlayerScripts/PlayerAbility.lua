local UIS = game:GetService("UserInputService")
local AbilityEvent = game:GetService("ReplicatedStorage").AbilityEvent
local player: Player = game.Players.LocalPlayer

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local HRP = character:FindFirstChild("HumanoidRootPart")

local GroundRollAnimation = humanoid:WaitForChild("Animator"):LoadAnimation(script.GroundRoll)

-- settings
COOLDOWN = false

UIS.InputBegan:Connect(function (input, processed)
	if processed then return end
	if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.E and not COOLDOWN then
		
		print("Input began!")
		
		COOLDOWN = true
		
		local Velocity  = Instance.new("LinearVelocity", HRP)
		local Attachment  = Instance.new("Attachment", HRP)
		
		Velocity.MaxForce = math.huge
		Velocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
		Velocity.Attachment0 = Attachment
		Velocity.RelativeTo = Enum.ActuatorRelativeTo.Attachment0
		Attachment.WorldPosition = character:FindFirstChild("HumanoidRootPart").AssemblyCenterOfMass
		
		Velocity:Destroy()
		Attachment:Destroy()
		
		task.wait(3)
		COOLDOWN = false
		
	end	
end)

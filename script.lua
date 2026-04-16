local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

local flying = false
local speed = 50

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local velocity = Instance.new("BodyVelocity")
velocity.MaxForce = Vector3.new(0,0,0)
velocity.Parent = root

-- Ativar/desativar voo (tecla F)
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	
	if input.KeyCode == Enum.KeyCode.F then
		flying = not flying
		
		if flying then
			velocity.MaxForce = Vector3.new(999999,999999,999999)
			humanoid.PlatformStand = true
		else
			velocity.MaxForce = Vector3.new(0,0,0)
			humanoid.PlatformStand = false
			velocity.Velocity = Vector3.zero
		end
	end
end)

-- Controle do voo
RunService.RenderStepped:Connect(function()
	if flying then
		local cam = workspace.CurrentCamera
		local moveDir = Vector3.zero

		if UIS:IsKeyDown(Enum.KeyCode.W) then
			moveDir = moveDir + cam.CFrame.LookVector
		end
		if UIS:IsKeyDown(Enum.KeyCode.S) then
			moveDir = moveDir - cam.CFrame.LookVector
		end
		if UIS:IsKeyDown(Enum.KeyCode.A) then
			moveDir = moveDir - cam.CFrame.RightVector
		end
		if UIS:IsKeyDown(Enum.KeyCode.D) then
			moveDir = moveDir + cam.CFrame.RightVector
		end
		if UIS:IsKeyDown(Enum.KeyCode.Space) then
			moveDir = moveDir + Vector3.new(0,1,0)
		end
		if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
			moveDir = moveDir - Vector3.new(0,1,0)
		end

		velocity.Velocity = moveDir.Unit * speed
	end
end)

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

local flying = false
local speed = 50

local bodyGyro
local bodyVelocity

-- Ativar/Desativar voo (tecla F)
game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
	if gp then return end
	
	if input.KeyCode == Enum.KeyCode.F then
		flying = not flying
		
		if flying then
			bodyGyro = Instance.new("BodyGyro", root)
			bodyGyro.P = 9e4
			bodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
			bodyGyro.cframe = root.CFrame

			bodyVelocity = Instance.new("BodyVelocity", root)
			bodyVelocity.velocity = Vector3.new(0,0,0)
			bodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
		else
			if bodyGyro then bodyGyro:Destroy() end
			if bodyVelocity then bodyVelocity:Destroy() end
		end
	end
end)

-- Movimento
game:GetService("RunService").RenderStepped:Connect(function()
	if flying and bodyVelocity then
		local cam = workspace.CurrentCamera
		local direction = Vector3.new(0,0,0)

		if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
			direction = direction + cam.CFrame.LookVector
		end
		if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
			direction = direction - cam.CFrame.LookVector
		end
		if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
			direction = direction - cam.CFrame.RightVector
		end
		if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
			direction = direction + cam.CFrame.RightVector
		end

		bodyVelocity.velocity = direction * speed
	end
end)

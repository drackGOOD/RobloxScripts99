local player = game.Players.LocalPlayer

local function setup(char)
	local humanoid = char:WaitForChild("Humanoid")
	local root = char:WaitForChild("HumanoidRootPart")

	local flying = false
	local invis = false
	local speed = 50

	local bodyGyro
	local bodyVelocity

	local UIS = game:GetService("UserInputService")
	local RunService = game:GetService("RunService")

	-- FUNÇÃO INVISÍVEL
	local function setInvisible(state)
		for _, obj in pairs(char:GetDescendants()) do
			if obj:IsA("BasePart") then
				obj.Transparency = state and 1 or 0
			elseif obj:IsA("Decal") then
				obj.Transparency = state and 1 or 0
			end
		end
	end

	-- TECLAS
	UIS.InputBegan:Connect(function(input, gp)
		if gp then return end

		-- VOAR (F)
		if input.KeyCode == Enum.KeyCode.F then
			flying = not flying

			if flying then
				bodyGyro = Instance.new("BodyGyro", root)
				bodyGyro.P = 9e4
				bodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
				bodyGyro.CFrame = root.CFrame

				bodyVelocity = Instance.new("BodyVelocity", root)
				bodyVelocity.Velocity = Vector3.new(0,0,0)
				bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
			else
				if bodyGyro then bodyGyro:Destroy() end
				if bodyVelocity then bodyVelocity:Destroy() end
			end
		end

		-- INVISÍVEL (G)
		if input.KeyCode == Enum.KeyCode.G then
			invis = not invis
			setInvisible(invis)
		end
	end)

	-- MOVIMENTO DO VOO
	RunService.RenderStepped:Connect(function()
		if flying and bodyVelocity then
			local cam = workspace.CurrentCamera
			local direction = Vector3.new(0,0,0)

			if UIS:IsKeyDown(Enum.KeyCode.W) then
				direction += cam.CFrame.LookVector
			end
			if UIS:IsKeyDown(Enum.KeyCode.S) then
				direction -= cam.CFrame.LookVector
			end
			if UIS:IsKeyDown(Enum.KeyCode.A) then
				direction -= cam.CFrame.RightVector
			end
			if UIS:IsKeyDown(Enum.KeyCode.D) then
				direction += cam.CFrame.RightVector
			end

			bodyVelocity.Velocity = direction * speed
		end
	end)
end

-- reaplicar ao respawn
if player.Character then
	setup(player.Character)
end

player.CharacterAdded:Connect(setup)

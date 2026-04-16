local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- cria Remote automaticamente
local remote = ReplicatedStorage:FindFirstChild("ControlEvent")
if not remote then
	remote = Instance.new("RemoteEvent")
	remote.Name = "ControlEvent"
	remote.Parent = ReplicatedStorage
end

-- invisível REAL
local function setInvisible(char, state)
	for _, obj in pairs(char:GetDescendants()) do
		if obj:IsA("BasePart") then
			obj.Transparency = state and 1 or 0
			obj.CanCollide = not state
		elseif obj:IsA("Decal") then
			obj.Transparency = state and 1 or 0
		end
	end
end

remote.OnServerEvent:Connect(function(player, action, value)
	if not player.Character then return end
	
	if action == "invis" then
		setInvisible(player.Character, value)
	end
end)

-- cria painel + voo no jogador
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(char)

		local scriptLocal = Instance.new("LocalScript")
		scriptLocal.Parent = player:WaitForChild("PlayerGui")

		scriptLocal.Source = [[

		local player = game.Players.LocalPlayer
		local remote = game.ReplicatedStorage:WaitForChild("ControlEvent")

		local UIS = game:GetService("UserInputService")
		local RunService = game:GetService("RunService")

		local char = player.Character or player.CharacterAdded:Wait()
		local root = char:WaitForChild("HumanoidRootPart")

		local flying = false
		local invis = false
		local speed = 60

		local bodyGyro, bodyVelocity

		-- GUI
		local gui = Instance.new("ScreenGui", player.PlayerGui)
		gui.Name = "PainelSupremo"

		local frame = Instance.new("Frame", gui)
		frame.Size = UDim2.new(0, 250, 0, 260)
		frame.Position = UDim2.new(0, 50, 0.5, -130)
		frame.BackgroundColor3 = Color3.fromRGB(20,20,25)
		frame.Active = true
		frame.Draggable = true

		Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

		local function criarBotao(txt, y, cor)
			local b = Instance.new("TextButton", frame)
			b.Size = UDim2.new(0.9,0,0,45)
			b.Position = UDim2.new(0.05,0,y,0)
			b.Text = txt
			b.BackgroundColor3 = cor
			b.TextScaled = true
			b.TextColor3 = Color3.new(1,1,1)
			Instance.new("UICorner", b)
			return b
		end

		local flyBtn = criarBotao("✈️ VOO: OFF", 0.2, Color3.fromRGB(0,170,90))
		local invisBtn = criarBotao("👻 INVISÍVEL: OFF", 0.45, Color3.fromRGB(90,0,160))
		local speedBtn = criarBotao("⚡ SPEED: 60", 0.7, Color3.fromRGB(200,120,0))

		-- VOO
		local function toggleFly()
			flying = not flying
			
			if flying then
				bodyGyro = Instance.new("BodyGyro", root)
				bodyGyro.P = 9e4
				bodyGyro.maxTorque = Vector3.new(9e9,9e9,9e9)

				bodyVelocity = Instance.new("BodyVelocity", root)
				bodyVelocity.maxForce = Vector3.new(9e9,9e9,9e9)
			else
				if bodyGyro then bodyGyro:Destroy() end
				if bodyVelocity then bodyVelocity:Destroy() end
			end
			
			flyBtn.Text = "✈️ VOO: "..(flying and "ON" or "OFF")
		end

		-- INVIS
		local function toggleInvis()
			invis = not invis
			invisBtn.Text = "👻 INVISÍVEL: "..(invis and "ON" or "OFF")
			remote:FireServer("invis", invis)
		end

		-- SPEED
		local speeds = {30,60,100,150,300}
		local index = 2

		local function changeSpeed()
			index += 1
			if index > #speeds then index = 1 end
			
			speed = speeds[index]
			speedBtn.Text = "⚡ SPEED: "..speed
		end

		flyBtn.MouseButton1Click:Connect(toggleFly)
		invisBtn.MouseButton1Click:Connect(toggleInvis)
		speedBtn.MouseButton1Click:Connect(changeSpeed)

		RunService.RenderStepped:Connect(function()
			if flying and bodyVelocity then
				local cam = workspace.CurrentCamera
				local dir = Vector3.new()

				if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
				if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
				if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
				if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end

				bodyVelocity.Velocity = dir * speed
			end
		end)

		]]
	end)
end)

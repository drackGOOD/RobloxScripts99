local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local flying = false
local speed = 50

-- BodyVelocity
local velocity = Instance.new("BodyVelocity")
velocity.MaxForce = Vector3.new(0,0,0)
velocity.Velocity = Vector3.zero
velocity.Parent = root

------------------------------------------------
-- 🖥️ GUI (Painel)
------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "FlyPanel"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 180, 0, 100)
frame.Position = UDim2.new(0, 20, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "FLY SYSTEM"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = frame

local button = Instance.new("TextButton")
button.Size = UDim2.new(0.8, 0, 0, 40)
button.Position = UDim2.new(0.1, 0, 0.45, 0)
button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
button.Text = "OFF"
button.TextColor3 = Color3.fromRGB(255,255,255)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 18
button.Parent = frame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = button

------------------------------------------------
-- 🛫 Função de ligar/desligar voo
------------------------------------------------
local function toggleFly()
	flying = not flying

	if flying then
		velocity.MaxForce = Vector3.new(999999,999999,999999)
		humanoid.PlatformStand = true
		button.Text = "ON"
		button.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
	else
		velocity.MaxForce = Vector3.new(0,0,0)
		humanoid.PlatformStand = false
		velocity.Velocity = Vector3.zero
		button.Text = "OFF"
		button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	end
end

button.MouseButton1Click:Connect(toggleFly)

------------------------------------------------
-- 🎮 Controle de movimento
------------------------------------------------
RunService.RenderStepped:Connect(function()
	if flying then
		local cam = workspace.CurrentCamera
		local moveDir = Vector3.zero

		if UIS:IsKeyDown(Enum.KeyCode.W) then
			moveDir += cam.CFrame.LookVector
		end
		if UIS:IsKeyDown(Enum.KeyCode.S) then
			moveDir -= cam.CFrame.LookVector
		end
		if UIS:IsKeyDown(Enum.KeyCode.A) then
			moveDir -= cam.CFrame.RightVector
		end
		if UIS:IsKeyDown(Enum.KeyCode.D) then
			moveDir += cam.CFrame.RightVector
		end
		if UIS:IsKeyDown(Enum.KeyCode.Space) then
			moveDir += Vector3.new(0,1,0)
		end
		if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
			moveDir -= Vector3.new(0,1,0)
		end

		if moveDir.Magnitude > 0 then
			velocity.Velocity = moveDir.Unit * speed
		else
			velocity.Velocity = Vector3.zero
		end
	end
end)

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

------------------------------------------------
-- VARIÁVEIS
------------------------------------------------
local flying = false
local speed = 50
local hoverForce = 0

local char, humanoid, root
local velocity, att

------------------------------------------------
-- PERSONAGEM (ANTI-RESPAWN BUG)
------------------------------------------------
local function setupCharacter(c)
	char = c
	humanoid = char:WaitForChild("Humanoid")
	root = char:WaitForChild("HumanoidRootPart")

	-- limpeza
	if velocity then velocity:Destroy() end
	if att then att:Destroy() end

	att = Instance.new("Attachment")
	att.Parent = root

	velocity = Instance.new("LinearVelocity")
	velocity.Attachment0 = att
	velocity.RelativeTo = Enum.ActuatorRelativeTo.World
	velocity.MaxForce = math.huge
	velocity.Enabled = false
	velocity.Parent = root
end

player.CharacterAdded:Connect(setupCharacter)
if player.Character then setupCharacter(player.Character) end

------------------------------------------------
-- GUI
------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "FlyPro"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 150)
frame.Position = UDim2.new(0, 20, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

------------------------------------------------
-- BOTÃO ON/OFF
------------------------------------------------
local button = Instance.new("TextButton")
button.Size = UDim2.new(0.8,0,0,35)
button.Position = UDim2.new(0.1,0,0.1,0)
button.Text = "FLY: OFF"
button.BackgroundColor3 = Color3.fromRGB(60,60,60)
button.TextColor3 = Color3.fromRGB(255,255,255)
button.Parent = frame
Instance.new("UICorner", button).CornerRadius = UDim.new(0,8)

------------------------------------------------
-- SLIDER DE VELOCIDADE
------------------------------------------------
local sliderBar = Instance.new("Frame")
sliderBar.Size = UDim2.new(0.8,0,0,8)
sliderBar.Position = UDim2.new(0.1,0,0.5,0)
sliderBar.BackgroundColor3 = Color3.fromRGB(80,80,80)
sliderBar.Parent = frame
Instance.new("UICorner", sliderBar).CornerRadius = UDim.new(1,0)

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(0.5,0,1,0)
sliderFill.BackgroundColor3 = Color3.fromRGB(0,170,0)
sliderFill.Parent = sliderBar
Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1,0)

local dragging = false

sliderBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local x = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
		sliderFill.Size = UDim2.new(x,0,1,0)
		speed = math.floor(10 + (x * 200))
	end
end)

------------------------------------------------
-- FUNÇÃO TOGGLE
------------------------------------------------
local function toggleFly()
	flying = not flying

	if velocity then
		velocity.Enabled = flying
	end

	if humanoid then
		humanoid.PlatformStand = flying
	end

	button.Text = flying and "FLY: ON" or "FLY: OFF"
	button.BackgroundColor3 = flying and Color3.fromRGB(0,170,0)
		or Color3.fromRGB(60,60,60)
end

button.MouseButton1Click:Connect(toggleFly)

------------------------------------------------
-- TECLA G
------------------------------------------------
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.G then
		toggleFly()
	end
end)

------------------------------------------------
-- MOVIMENTO + HOVER + ANTI-BUG
------------------------------------------------
RunService.RenderStepped:Connect(function()
	if not flying or not root then return end

	local cam = workspace.CurrentCamera
	local dir = Vector3.zero

	if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
	if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
	if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
	if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end

	if UIS:IsKeyDown(Enum.KeyCode.Space) then
		dir += Vector3.new(0,1,0)
	elseif UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
		dir -= Vector3.new(0,1,0)
	else
		-- 🪶 HOVER AUTOMÁTICO
		dir += Vector3.new(0, hoverForce, 0)
	end

	-- 🧠 ANTI BUG (não divide zero + estabilidade)
	if dir.Magnitude > 0 then
		velocity.VectorVelocity = dir.Unit * speed
	else
		velocity.VectorVelocity = Vector3.zero
	end

	-- hover leve constante pra não cair
	hoverForce = 0.2
end)

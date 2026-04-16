local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

------------------------------------------------
-- VARIÁVEIS
------------------------------------------------
local flying = false
local speed = 60

local char, humanoid, root
local att, force

------------------------------------------------
-- SETUP PERSONAGEM (ANTI BUG)
------------------------------------------------
local function setupCharacter(c)
	char = c
	humanoid = char:WaitForChild("Humanoid")
	root = char:WaitForChild("HumanoidRootPart")

	if force then force:Destroy() end
	if att then att:Destroy() end

	att = Instance.new("Attachment")
	att.Parent = root

	force = Instance.new("VectorForce")
	force.Attachment0 = att
	force.RelativeTo = Enum.ActuatorRelativeTo.World
	force.Enabled = false
	force.Force = Vector3.zero
	force.Parent = root
end

player.CharacterAdded:Connect(setupCharacter)
if player.Character then setupCharacter(player.Character) end

------------------------------------------------
-- GUI
------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "FlySystem"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 140)
frame.Position = UDim2.new(0, 20, 0.5, -70)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)

------------------------------------------------
-- BOTÃO ON/OFF
------------------------------------------------
local button = Instance.new("TextButton")
button.Size = UDim2.new(0.8,0,0,35)
button.Position = UDim2.new(0.1,0,0.1,0)
button.Text = "FLY: OFF"
button.Parent = frame

------------------------------------------------
-- SLIDER SIMPLES
------------------------------------------------
local bar = Instance.new("Frame")
bar.Size = UDim2.new(0.8,0,0,8)
bar.Position = UDim2.new(0.1,0,0.55,0)
bar.BackgroundColor3 = Color3.fromRGB(70,70,70)
bar.Parent = frame
Instance.new("UICorner", bar)

local fill = Instance.new("Frame")
fill.Size = UDim2.new(0.4,0,1,0)
fill.BackgroundColor3 = Color3.fromRGB(0,170,0)
fill.Parent = bar
Instance.new("UICorner", fill)

local dragging = false

bar.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
	end
end)

UIS.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UIS.InputChanged:Connect(function(i)
	if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
		local x = math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
		fill.Size = UDim2.new(x,0,1,0)
		speed = math.floor(20 + x * 180)
	end
end)

------------------------------------------------
-- TOGGLE
------------------------------------------------
local function toggleFly()
	flying = not flying

	if force then
		force.Enabled = flying
	end

	if humanoid then
		humanoid.PlatformStand = flying
	end

	button.Text = flying and "FLY: ON" or "FLY: OFF"
end

button.MouseButton1Click:Connect(toggleFly)

UIS.InputBegan:Connect(function(i, gp)
	if gp then return end
	if i.KeyCode == Enum.KeyCode.G then
		toggleFly()
	end
end)

------------------------------------------------
-- MOVIMENTO + HOVER + ANTI BUG
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
		-- 🪶 hover automático
		dir += Vector3.new(0,0.2,0)
	end

	if dir.Magnitude > 0 then
		force.Force = dir.Unit * speed * 200
	else
		force.Force = Vector3.zero
	end
end)

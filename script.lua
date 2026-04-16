local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local flying = false
local speed = 50

local char, humanoid, root
local velocity

------------------------------------------------
-- 🔁 Recria personagem corretamente
------------------------------------------------
local function setupCharacter(c)
	char = c
	humanoid = char:WaitForChild("Humanoid")
	root = char:WaitForChild("HumanoidRootPart")

	if velocity then
		velocity:Destroy()
	end

	velocity = Instance.new("LinearVelocity")
	velocity.Attachment0 = Instance.new("Attachment", root)
	velocity.MaxForce = math.huge
	velocity.Enabled = false
	velocity.Parent = root
end

player.CharacterAdded:Connect(setupCharacter)
if player.Character then
	setupCharacter(player.Character)
end

------------------------------------------------
-- 🖥️ GUI
------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "FlySystem"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 180, 0, 100)
frame.Position = UDim2.new(0, 20, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local button = Instance.new("TextButton")
button.Size = UDim2.new(0.8,0,0,40)
button.Position = UDim2.new(0.1,0,0.45,0)
button.Text = "OFF"
button.BackgroundColor3 = Color3.fromRGB(60,60,60)
button.TextColor3 = Color3.fromRGB(255,255,255)
button.Parent = frame

Instance.new("UICorner", button).CornerRadius = UDim.new(0,8)

------------------------------------------------
-- ✈️ Toggle voo
------------------------------------------------
local function toggleFly()
	flying = not flying

	if velocity then
		velocity.Enabled = flying
	end

	if humanoid then
		humanoid.PlatformStand = flying
	end

	button.Text = flying and "ON" or "OFF"
	button.BackgroundColor3 = flying and Color3.fromRGB(0,170,0)
		or Color3.fromRGB(60,60,60)
end

button.MouseButton1Click:Connect(toggleFly)

------------------------------------------------
-- 🎮 Movimento
------------------------------------------------
RunService.RenderStepped:Connect(function()
	if not flying or not root then return end

	local cam = workspace.CurrentCamera
	local dir = Vector3.zero

	if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
	if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
	if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
	if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
	if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
	if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then dir -= Vector3.new(0,1,0) end

	velocity.VectorVelocity = dir.Magnitude > 0 and dir.Unit * speed or Vector3.zero
end)

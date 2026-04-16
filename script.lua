local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

local flying = false
local invis = false
local speed = 60
local panelOpen = true

local bodyGyro, bodyVelocity

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "PainelLocal"
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 230, 0, 230)
frame.Position = UDim2.new(0, 40, 0.5, -115)
frame.BackgroundColor3 = Color3.fromRGB(20,20,25)
frame.Visible = true
frame.Active = true
frame.Draggable = true

Instance.new("UICorner", frame)

local function criarBtn(txt, y)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(0.9,0,0,40)
	b.Position = UDim2.new(0.05,0,y,0)
	b.Text = txt
	b.BackgroundColor3 = Color3.fromRGB(50,50,50)
	b.TextColor3 = Color3.new(1,1,1)
	b.TextScaled = true
	Instance.new("UICorner", b)
	return b
end

local flyBtn = criarBtn("VOO: OFF", 0.2)
local invisBtn = criarBtn("INVIS: OFF", 0.45)
local speedBtn = criarBtn("SPEED: 60", 0.7)

-- invisível LOCAL
local function setInvisible(state)
	for _, v in pairs(char:GetDescendants()) do
		if v:IsA("BasePart") then
			v.LocalTransparencyModifier = state and 1 or 0
		elseif v:IsA("Decal") then
			v.Transparency = state and 1 or 0
		end
	end
end

-- voo
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
	
	flyBtn.Text = "VOO: "..(flying and "ON" or "OFF")
end

-- invisível
local function toggleInvis()
	invis = not invis
	setInvisible(invis)
	invisBtn.Text = "INVIS: "..(invis and "ON" or "OFF")
end

-- speed
local speeds = {30,60,100,150,250}
local index = 2

local function changeSpeed()
	index += 1
	if index > #speeds then index = 1 end
	
	speed = speeds[index]
	speedBtn.Text = "SPEED: "..speed
end

-- botões
flyBtn.MouseButton1Click:Connect(toggleFly)
invisBtn.MouseButton1Click:Connect(toggleInvis)
speedBtn.MouseButton1Click:Connect(changeSpeed)

-- tecla abrir/fechar painel (F5)
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	
	if input.KeyCode == Enum.KeyCode.F5 then
		panelOpen = not panelOpen
		frame.Visible = panelOpen
	end
end)

-- movimento voo
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

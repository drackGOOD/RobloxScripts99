--[[
    🔥 ADMIN FRAMEWORK V3 - GITHUB EDITION
    Recursos: Radar Circular, Tabs, Blur, ESP, Combat & Fly
    Atalhos: [K] Menu | [F] Fly | [L-Shift] Sprint
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()
local Camera = workspace.CurrentCamera

-- ========================================================
-- CONFIGURAÇÕES INICIAIS (TUDO OFF)
-- ========================================================
local State = {
	Menu = false,
	Fly = false,
	ESP = false,
	Radar = false,
	NoSpread = false,
	Tab = "Combat"
}

-- ========================================================
-- UI: DESIGN & BLUR & ANIMAÇÃO
-- ========================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FrameworkV3"
ScreenGui.Parent = LP:WaitForChild("PlayerGui")

-- Blur de Fundo
local Blur = Instance.new("BlurEffect")
Blur.Size = 0
Blur.Parent = Lighting

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 550, 0, 350)
Main.Position = UDim2.new(0.5, -275, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.BackgroundTransparency = 0.1
Main.Visible = false
Main.Parent = ScreenGui

local function Style(obj, rad)
	local c = Instance.new("UICorner")
	c.CornerRadius = rad or UDim.new(0, 10)
	c.Parent = obj
end

Style(Main)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(40, 40, 40)

-- Sidebar (Abas)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 140, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Sidebar.Parent = Main
Style(Sidebar)

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -150, 1, -20)
TabContainer.Position = UDim2.new(0, 150, 0, 10)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = Main

-- ========================================================
-- 📡 RADAR CIRCULAR (ESTILO GTA 5)
-- ========================================================
local RadarFrame = Instance.new("Frame")
RadarFrame.Size = UDim2.new(0, 150, 0, 150)
RadarFrame.Position = UDim2.new(0, 20, 1, -170)
RadarFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
RadarFrame.Visible = false
RadarFrame.Parent = ScreenGui
Style(RadarFrame, UDim.new(1, 0))
Instance.new("UIStroke", RadarFrame).Thickness = 2

local function UpdateRadar()
	if not State.Radar then return end
	RadarFrame.ClearAllChildren()
	Style(RadarFrame, UDim.new(1, 0)) -- Mantém circular
	
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			local pos = p.Character.HumanoidRootPart.Position
			local lppos = LP.Character.HumanoidRootPart.Position
			local dist = (pos - lppos)
			
			if dist.Magnitude < 200 then
				local dot = Instance.new("Frame")
				dot.Size = UDim2.new(0, 6, 0, 6)
				dot.BackgroundColor3 = (p.Team ~= LP.Team) and Color3.new(1, 0, 0) or Color3.new(0, 1, 0)
				dot.Position = UDim2.new(0.5, (dist.X / 4), 0.5, (dist.Z / 4))
				dot.Parent = RadarFrame
				Style(dot, UDim.new(1, 0))
			end
		end
	end
end

-- ========================================================
-- 👁️ ESP SYSTEM
-- ========================================================
local function DoESP()
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LP and p.Character then
			local h = p.Character:FindFirstChild("Highlight") or Instance.new("Highlight", p.Character)
			h.Enabled = State.ESP
			h.FillColor = (p.Team ~= LP.Team) and Color3.new(1, 0, 0) or Color3.new(0, 1, 0)
		end
	end
end

-- ========================================================
-- 🚀 SISTEMA DE TABS E BOTÕES
-- ========================================================
local function CreateTabBtn(name, y)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0.9, 0, 0, 35)
	b.Position = UDim2.new(0.05, 0, 0, y)
	b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	b.Text = name
	b.TextColor3 = Color3.new(1, 1, 1)
	b.Font = Enum.Font.GothamBold
	b.Parent = Sidebar
	Style(b)
	return b
end

local function CreateToggle(name, y, callback)
	local t = Instance.new("TextButton")
	t.Size = UDim2.new(1, 0, 0, 40)
	t.Position = UDim2.new(0, 0, 0, y)
	t.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	t.Text = "  " .. name .. ": OFF"
	t.TextColor3 = Color3.new(0.6, 0.6, 0.6)
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.Font = Enum.Font.Gotham
	t.Parent = TabContainer
	Style(t)

	local active = false
	t.MouseButton1Click:Connect(function()
		active = not active
		t.Text = "  " .. name .. (active and ": ON" or ": OFF")
		t.TextColor3 = active and Color3.new(0, 1, 0.5) or Color3.new(0.6, 0.6, 0.6)
		callback(active)
	end)
end

-- Abas de Exemplo
CreateToggle("Radar GTA V", 0, function(v) State.Radar = v RadarFrame.Visible = v end)
CreateToggle("ESP Wallhack", 50, function(v) State.ESP = v DoESP() end)
CreateToggle("Fly (F)", 100, function(v) State.Fly = v end)
CreateToggle("No Spread", 150, function(v) State.NoSpread = v end)

-- ========================================================
-- CONTROLES & LOOPS
-- ========================================================

-- Abrir Menu [K]
UserInputService.InputBegan:Connect(function(i, g)
	if g then return end
	if i.KeyCode == Enum.KeyCode.K then
		State.Menu = not State.Menu
		Main.Visible = State.Menu
		TweenService:Create(Blur, TweenInfo.new(0.3), {Size = State.Menu and 20 or 0}):Play()
	end
end)

-- Loop de Radar e Fly
RunService.RenderStepped:Connect(function()
	if State.Radar then UpdateRadar() end
	if State.Fly and LP.Character then
		local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			hrp.Velocity = Vector3.new(0, 1, 0)
			local move = Vector3.zero
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += Camera.CFrame.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= Camera.CFrame.LookVector end
			hrp.CFrame = hrp.CFrame + (move * 1.5)
		end
	end
end)

print("✅ Framework V3 Profissional Carregado!")

-- =============================================
--  PAINEL DE CONTROLE DE TEMPO - 99 Nights in the Forest
--  LocalScript - Execute com seu executor (Delta, Wave, etc.)
-- =============================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- Tenta encontrar o RemoteEvent de várias formas
local remote = nil
local possibleNames = {"SetTimeSpeed", "TimeSpeed", "SetDaySpeed", "ChangeTimeScale", "SetTimeScale", "TimeController", "SetTime"}

for _, name in ipairs(possibleNames) do
    remote = ReplicatedStorage:FindFirstChild(name, true)
    if remote and remote:IsA("RemoteEvent") then
        print("✅ Remote encontrado: " .. name)
        break
    end
end

if not remote then
    warn("❌ Nenhum Remote de tempo encontrado! O painel pode não funcionar.")
end

-- ====================== CRIAÇÃO DA GUI ======================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TimeControlPanel"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 290, 0, 380)
frame.Position = UDim2.new(0, 70, 0.5, -190)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 14)
uiCorner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 55)
title.BackgroundTransparency = 1
title.Text = "⚡ CONTROLE DE TEMPO ⚡"
title.TextColor3 = Color3.fromRGB(0, 255, 120)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.92, 0, 0, 45)
speedLabel.Position = UDim2.new(0.04, 0, 0.17, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Velocidade Atual: x1"
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.GothamSemibold
speedLabel.Parent = frame

local speeds = {1, 2, 5, 10, 20, 50, 100, 200}
local currentIndex = 1

-- Botão Acelerar
local accelerateBtn = Instance.new("TextButton")
accelerateBtn.Size = UDim2.new(0.92, 0, 0, 55)
accelerateBtn.Position = UDim2.new(0.04, 0, 0.32, 0)
accelerateBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
accelerateBtn.Text = "🚀 ACELERAR NOITE"
accelerateBtn.TextColor3 = Color3.new(1,1,1)
accelerateBtn.TextScaled = true
accelerateBtn.Font = Enum.Font.GothamBold
accelerateBtn.Parent = frame

local accCorner = Instance.new("UICorner")
accCorner.CornerRadius = UDim.new(0, 12)
accCorner.Parent = accelerateBtn

-- Botão Forçar Noite
local forceNightBtn = Instance.new("TextButton")
forceNightBtn.Size = UDim2.new(0.92, 0, 0, 55)
forceNightBtn.Position = UDim2.new(0.04, 0, 0.50, 0)
forceNightBtn.BackgroundColor3 = Color3.fromRGB(90, 0, 160)
forceNightBtn.Text = "🌙 FORÇAR NOITE"
forceNightBtn.TextColor3 = Color3.new(1,1,1)
forceNightBtn.TextScaled = true
forceNightBtn.Font = Enum.Font.GothamBold
forceNightBtn.Parent = frame

local nightCorner = Instance.new("UICorner")
nightCorner.CornerRadius = UDim.new(0, 12)
nightCorner.Parent = forceNightBtn

-- Botão Reset
local resetBtn = Instance.new("TextButton")
resetBtn.Size = UDim2.new(0.92, 0, 0, 50)
resetBtn.Position = UDim2.new(0.04, 0, 0.68, 0)
resetBtn.BackgroundColor3 = Color3.fromRGB(190, 40, 40)
resetBtn.Text = "🔄 Resetar para x1"
resetBtn.TextColor3 = Color3.new(1,1,1)
resetBtn.TextScaled = true
resetBtn.Font = Enum.Font.GothamSemibold
resetBtn.Parent = frame

local resetCorner = Instance.new("UICorner")
resetCorner.CornerRadius = UDim.new(0, 12)
resetCorner.Parent = resetBtn

-- ====================== FUNÇÕES ======================
local function updateSpeed(speed)
    currentIndex = table.find(speeds, speed) or 1
    speedLabel.Text = "Velocidade Atual: x" .. speed
    
    if remote then
        pcall(function()
            remote:FireServer(speed)
        end)
    end
end

local function forceNight()
    if not remote then 
        speedLabel.Text = "❌ Remote não encontrado"
        return 
    end
    
    speedLabel.Text = "🌙 Tentando forçar noite..."
    
    pcall(function()
        remote:FireServer("Night")
        remote:FireServer(9999)
        remote:FireServer(-1)
        for i = 1, 5 do
            remote:FireServer(200)
            task.wait(0.05)
        end
    end)
    
    task.wait(1.2)
    speedLabel.Text = "Velocidade Atual: x" .. speeds[currentIndex]
end

-- Conexões
accelerateBtn.MouseButton1Click:Connect(function()
    currentIndex += 1
    if currentIndex > #speeds then currentIndex = 1 end
    updateSpeed(speeds[currentIndex])
end)

forceNightBtn.MouseButton1Click:Connect(forceNight)

resetBtn.MouseButton1Click:Connect(function()
    updateSpeed(1)
end)

-- Efeito hover
local function hoverEffect(btn, normalColor, hoverColor)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = hoverColor}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = normalColor}):Play()
    end)
end

hoverEffect(accelerateBtn, Color3.fromRGB(0, 180, 90), Color3.fromRGB(0, 220, 110))
hoverEffect(forceNightBtn, Color3.fromRGB(90, 0, 160), Color3.fromRGB(120, 30, 200))
hoverEffect(resetBtn, Color3.fromRGB(190, 40, 40), Color3.fromRGB(230, 60, 60))

print("✅ Painel de Controle de Tempo carregado com sucesso!")
print("Use o botão 'Forçar Noite' ou acelere para x100/x200 para tentar pular a noite mais rápido.")

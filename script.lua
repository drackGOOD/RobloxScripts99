-- LocalScript (coloque em StarterPlayer > StarterPlayerScripts)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local remote = ReplicatedStorage:WaitForChild("SetTimeSpeed")

-- === GUI ===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TimeSpeedPanel"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 280, 0, 340)  -- aumentei um pouco a altura
frame.Position = UDim2.new(0, 60, 0.5, -170)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "⚡ CONTROLE DE TEMPO ⚡"
title.TextColor3 = Color3.fromRGB(0, 255, 100)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

-- Velocidade atual
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.9, 0, 0, 40)
speedLabel.Position = UDim2.new(0.05, 0, 0.18, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Velocidade: x1"
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.GothamSemibold
speedLabel.Parent = frame

local speeds = {1, 2, 5, 10, 20, 50, 100}
local currentIndex = 1

-- Botão Acelerar Noite
local accelerateButton = Instance.new("TextButton")
accelerateButton.Size = UDim2.new(0.9, 0, 0, 50)
accelerateButton.Position = UDim2.new(0.05, 0, 0.32, 0)
accelerateButton.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
accelerateButton.Text = "ACELERAR NOITE"
accelerateButton.TextColor3 = Color3.new(1, 1, 1)
accelerateButton.TextScaled = true
accelerateButton.Font = Enum.Font.GothamBold
accelerateButton.Parent = frame

local accCorner = Instance.new("UICorner")
accCorner.CornerRadius = UDim.new(0, 10)
accCorner.Parent = accelerateButton

-- Novo botão: Forçar Noite
local forceNightButton = Instance.new("TextButton")
forceNightButton.Size = UDim2.new(0.9, 0, 0, 50)
forceNightButton.Position = UDim2.new(0.05, 0, 0.50, 0)
forceNightButton.BackgroundColor3 = Color3.fromRGB(100, 0, 180)  -- roxo escuro
forceNightButton.Text = "🌙 FORÇAR NOITE"
forceNightButton.TextColor3 = Color3.new(1, 1, 1)
forceNightButton.TextScaled = true
forceNightButton.Font = Enum.Font.GothamBold
forceNightButton.Parent = frame

local nightCorner = Instance.new("UICorner")
nightCorner.CornerRadius = UDim.new(0, 10)
nightCorner.Parent = forceNightButton

-- Botão Reset
local resetButton = Instance.new("TextButton")
resetButton.Size = UDim2.new(0.9, 0, 0, 45)
resetButton.Position = UDim2.new(0.05, 0, 0.68, 0)
resetButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
resetButton.Text = "Resetar para x1 (Normal)"
resetButton.TextColor3 = Color3.new(1, 1, 1)
resetButton.TextScaled = true
resetButton.Font = Enum.Font.GothamSemibold
resetButton.Parent = frame

local resetCorner = Instance.new("UICorner")
resetCorner.CornerRadius = UDim.new(0, 10)
resetCorner.Parent = resetButton

-- Função para atualizar velocidade
local function updateSpeed(speed)
    currentIndex = table.find(speeds, speed) or 1
    speedLabel.Text = "Velocidade: x" .. speed
    accelerateButton.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
    
    pcall(function()
        remote:FireServer(speed)
    end)
end

-- Função para forçar noite
local function forceNight()
    pcall(function()
        remote:FireServer("Night")   -- tenta enviar string "Night"
        -- Alguns jogos aceitam número alto ou valor especial. Se não funcionar, tente outro valor:
        -- remote:FireServer(9999)   -- descomente se quiser testar
    end)
    
    speedLabel.Text = "🌙 Forçando Noite..."
    wait(1)
    speedLabel.Text = "Velocidade: x" .. speeds[currentIndex]
end

-- Conexões dos botões
accelerateButton.MouseButton1Click:Connect(function()
    currentIndex = currentIndex + 1
    if currentIndex > #speeds then currentIndex = 1 end
    local newSpeed = speeds[currentIndex]
    updateSpeed(newSpeed)
end)

forceNightButton.MouseButton1Click:Connect(forceNight)

resetButton.MouseButton1Click:Connect(function()
    updateSpeed(1)
end)

-- Efeito de hover
local function addHover(btn, normal, hover)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = hover}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = normal}):Play()
    end)
end

addHover(accelerateButton, Color3.fromRGB(0, 170, 80), Color3.fromRGB(0, 200, 100))
addHover(forceNightButton, Color3.fromRGB(100, 0, 180), Color3.fromRGB(130, 30, 220))
addHover(resetButton, Color3.fromRGB(180, 40, 40), Color3.fromRGB(220, 60, 60))

print("✅ Painel de Tempo atualizado com botão 'Forçar Noite'!")

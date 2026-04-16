-- PAINEL 99 NOITES (COM CONTADOR DE DIAS)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

-- --- VARIÁVEIS DE CONTROLE ---
local timeSpeed = 1
local diaAtual = 1
local ultimaHora = Lighting.ClockTime
local remote = ReplicatedStorage:FindFirstChild("SetTimeSpeed")

-- --- LÓGICA DE CONTAGEM DE DIA ---
RunService.Heartbeat:Connect(function(dt)
    -- Acelera o relógio
    Lighting.ClockTime += dt * timeSpeed
    
    -- Detecta se passou da meia-noite (Ciclo de dia)
    if Lighting.ClockTime < ultimaHora then
        diaAtual = diaAtual + 1
        print("Novo dia iniciado: Dia " .. diaAtual)
    end
    ultimaHora = Lighting.ClockTime
end)

-- --- INTERFACE ---
local sg = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
sg.Name = "NightsPanel"
sg.ResetOnSpawn = false

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 220, 0, 250)
frame.Position = UDim2.new(0, 50, 0.5, -125)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
Instance.new("UICorner", frame)

-- Label para mostrar o Dia atual na UI
local dayLabel = Instance.new("TextLabel", frame)
dayLabel.Size = UDim2.new(1, 0, 0, 30)
dayLabel.Text = "DIA ATUAL: " .. diaAtual
dayLabel.TextColor3 = Color3.new(1, 1, 0)
dayLabel.BackgroundTransparency = 1
dayLabel.Font = Enum.Font.GothamBold

local function createBtn(name, pos, action)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(0.9, 0, 0, 45)
    b.Position = pos
    b.Text = name
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b)
    
    local active = false
    b.MouseButton1Click:Connect(function()
        active = not active
        b.BackgroundColor3 = active and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(40, 40, 60)
        action(active, b)
    end)
end

-- Botões
createBtn("VISÃO NOTURNA (ESP)", UDim2.new(0.05, 0, 0.2, 0), function(state)
    _G.ESP = state
end)

createBtn("VELOCIDADE", UDim2.new(0.05, 0, 0.45, 0), function(state)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = state and 80 or 16
    end
end)

createBtn("ACELERAR NOITES", UDim2.new(0.05, 0, 0.7, 0), function(state, btn)
    if state then
        timeSpeed = 50 
        btn.Text = "VELOCIDADE: x50"
    else
        timeSpeed = 1
        btn.Text = "VELOCIDADE: x1"
    end
    if remote then remote:FireServer(timeSpeed) end
end)

-- Loop de atualização da Label de Dia e ESP
RunService.RenderStepped:Connect(function()
    dayLabel.Text = "DIA ATUAL: " .. diaAtual
    
    if _G.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                if not p.Character:FindFirstChild("Highlight") then
                    Instance.new("Highlight", p.Character).FillColor = Color3.new(1,1,1)
                end
            end
        end
    end
end)

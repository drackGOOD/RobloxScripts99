-- PAINEL 99 NOITES (ESP + SPEED + TIME CONTROL)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

-- --- CONFIGURAÇÃO DE TEMPO ---
local timeSpeed = 1
local remote = ReplicatedStorage:FindFirstChild("SetTimeSpeed")

-- Loop que faz o tempo correr (Funciona localmente mesmo sem Remote no Servidor)
RunService.Heartbeat:Connect(function(dt)
    Lighting.ClockTime += dt * timeSpeed
end)

-- --- INTERFACE ---
local sg = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
sg.Name = "NightsPanel"
sg.ResetOnSpawn = false

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 220, 0, 220) -- Menor e mais limpo
frame.Position = UDim2.new(0, 50, 0.5, -110)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 25) -- Tom azul escuro "noite"
frame.BorderSizePixel = 0
Instance.new("UICorner", frame)

local function createBtn(name, pos, action)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(0.9, 0, 0, 45)
    b.Position = pos
    b.Text = name
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    Instance.new("UICorner", b)
    
    local active = false
    b.MouseButton1Click:Connect(function()
        active = not active
        b.BackgroundColor3 = active and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(30, 30, 50)
        action(active, b)
    end)
end

-- 1. ESP (Ver onde os outros estão na escuridão)
createBtn("VISÃO NOTURNA (ESP)", UDim2.new(0.05, 0, 0.1, 0), function(state)
    _G.ESP = state
end)

-- 2. SPEED (Para fugir ou explorar rápido)
createBtn("VELOCIDADE RÁPIDA", UDim2.new(0.05, 0, 0.35, 0), function(state)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = state and 80 or 16
    end
end)

-- 3. TIME CONTROL (Avançar as 99 noites mais rápido)
createBtn("ACELERAR NOITES: x1", UDim2.new(0.05, 0, 0.6, 0), function(state, btn)
    if state then
        timeSpeed = 20 -- Ajuste aqui a velocidade das noites
        btn.Text = "ACELERAR NOITES: x20"
    else
        timeSpeed = 1
        btn.Text = "ACELERAR NOITES: x1"
    end
    -- Tenta avisar o servidor se houver o Remote que você criou antes
    if remote then remote:FireServer(timeSpeed) end
end)

-- --- LOOP ESP ---
RunService.RenderStepped:Connect(function()
    if _G.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                if not p.Character:FindFirstChild("Highlight") then
                    local h = Instance.new("Highlight", p.Character)
                    h.FillColor = Color3.fromRGB(255, 255, 255) -- Branco para destacar no escuro
                    h.OutlineColor = Color3.fromRGB(0, 255, 255)
                end
            end
        end
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("Highlight") then
                p.Character.Highlight:Destroy()
            end
        end
    end
end)

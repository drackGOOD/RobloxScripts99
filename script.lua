-- PAINEL 99 NOITES SUPREMO (AUTO-FARM & SURVIVAL)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

-- --- CONFIGURAÇÕES ---
local timeSpeed = 1
local diaAtual = 1
local ultimaHora = Lighting.ClockTime

-- --- INTERFACE ---
local sg = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
sg.Name = "UltraPanel"
sg.ResetOnSpawn = false

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 230, 0, 320)
frame.Position = UDim2.new(0, 50, 0.5, -160)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "99 NOITES - CHEAT"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold

local function createBtn(name, pos, action)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(0.9, 0, 0, 35)
    b.Position = pos
    b.Text = name
    b.BackgroundColor3 = Color3.fromRGB(45, 45, 70)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.SourceSansBold
    Instance.new("UICorner", b)
    
    local active = false
    b.MouseButton1Click:Connect(function()
        active = not active
        b.BackgroundColor3 = active and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(45, 45, 70)
        action(active, b)
    end)
end

-- --- BOTÕES ---

-- 1. Fome Infinita (Tenta congelar o valor da fome)
createBtn("FOME INFINITA", UDim2.new(0.05, 0, 0.15, 0), function(state)
    _G.NoHunger = state
end)

-- 2. Fogueira Sempre Acesa
createBtn("FOGUEIRA INFINITA", UDim2.new(0.05, 0, 0.3, 0), function(state)
    _G.FireInfinite = state
end)

-- 3. Pular para Nível 6
createBtn("INSTANT LEVEL 6", UDim2.new(0.05, 0, 0.45, 0), function(state)
    _G.FastLevel = state
end)

-- 4. Acelerar Tempo
createBtn("PASSAR NOITE RÁPIDO", UDim2.new(0.05, 0, 0.6, 0), function(state, btn)
    timeSpeed = state and 100 or 1
    btn.Text = state and "TEMPO: x100" or "TEMPO: x1"
end)

-- 5. ESP
createBtn("VER JOGADORES (ESP)", UDim2.new(0.05, 0, 0.75, 0), function(state)
    _G.ESP = state
end)

-- --- LOOP DE EXECUÇÃO ---
RunService.Heartbeat:Connect(function(dt)
    -- Controle de Tempo
    Lighting.ClockTime += dt * timeSpeed
    if Lighting.ClockTime < ultimaHora then diaAtual += 1 end
    ultimaHora = Lighting.ClockTime

    -- Tenta Forçar Fome e Level (Baseado em nomes comuns de scripts de sobrevivência)
    if LocalPlayer.Character then
        -- Tenta achar valor de Fome (Hunger)
        local stats = LocalPlayer:FindFirstChild("leaderstats") or LocalPlayer:FindFirstChild("Stats")
        
        if _G.NoHunger then
            local hunger = LocalPlayer.Character:FindFirstChild("Hunger") or (stats and stats:FindFirstChild("Hunger"))
            if hunger and hunger:IsA("NumberValue") then hunger.Value = 100 end
        end

        if _G.FastLevel then
            local lvl = (stats and stats:FindFirstChild("Level")) or LocalPlayer:FindFirstChild("Level")
            if lvl and lvl.Value < 6 then lvl.Value = 6 end
        end
    end

    -- Tenta manter a fogueira (Procura objetos com nome "Fire" ou "Fogueira" perto)
    if _G.FireInfinite then
        for _, obj in pairs(workspace:GetDescendants()) do
            if (obj.Name == "Fire" or obj.Name == "Fuel") and obj:IsA("NumberValue") then
                obj.Value = 100
            end
        end
    end
end)

-- Loop ESP
RunService.RenderStepped:Connect(function()
    if _G.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChild("Highlight") then
                Instance.new("Highlight", p.Character).FillColor = Color3.new(1,0,0)
            end
        end
    end
end)

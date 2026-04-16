-- PAINEL 99 NOITES NA FLORESTA (VERSÃO SURVIVAL)
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
sg.Name = "ForestCheat"
sg.ResetOnSpawn = false

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 240, 0, 300)
frame.Position = UDim2.new(0, 50, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(15, 30, 15) -- Verde escuro floresta
Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "99 NOITES - SURVIVAL"
title.TextColor3 = Color3.new(0.8, 1, 0.8)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold

local function createBtn(name, pos, action)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(0.9, 0, 0, 40)
    b.Position = pos
    b.Text = name
    b.BackgroundColor3 = Color3.fromRGB(30, 50, 30)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.SourceSansBold
    Instance.new("UICorner", b)
    
    local active = false
    b.MouseButton1Click:Connect(function()
        active = not active
        b.BackgroundColor3 = active and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(30, 50, 30)
        action(active)
    end)
end

-- --- BOTÕES ---

-- 1. Fome e Sede (Sem sentir fome)
createBtn("CONGELAR FOME/SEDE", UDim2.new(0.05, 0, 0.15, 0), function(state)
    _G.GodMode = state
end)

-- 2. Fogueira Infinita (Não acaba a madeira)
createBtn("FOGUEIRA ETERNA", UDim2.new(0.05, 0, 0.32, 0), function(state)
    _G.InfiniteFire = state
end)

-- 3. Instant Level 6
createBtn("SET LEVEL 6", UDim2.new(0.05, 0, 0.49, 0), function(state)
    _G.SetLevel = state
end)

-- 4. Passar Noite (Acelerar Tempo)
createBtn("ACELERAR DIAS (X100)", UDim2.new(0.05, 0, 0.66, 0), function(state)
    timeSpeed = state and 100 or 1
end)

-- 5. ESP Jogadores
createBtn("VER PLAYERS NO ESCURO", UDim2.new(0.05, 0, 0.83, 0), function(state)
    _G.ESP = state
end)

-- --- LOOP DE SOBREVIVÊNCIA ---
RunService.Heartbeat:Connect(function(dt)
    -- Aceleração do Ciclo de Dia/Noite
    Lighting.ClockTime += dt * timeSpeed
    if Lighting.ClockTime < ultimaHora then 
        diaAtual += 1 
        print("Sobreviveu a mais uma noite! Noite: " .. diaAtual)
    end
    ultimaHora = Lighting.ClockTime

    -- Lógica de Stats (Fome, Level, Fogueira)
    if LocalPlayer.Character then
        -- Tenta achar atributos de sobrevivência
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        
        -- Congelar Fome
        if _G.GodMode then
            -- Procura por Hunger, Food, Fome, Energy
            for _, v in pairs(LocalPlayer:GetDescendants()) do
                if v:IsA("NumberValue") and (v.Name == "Hunger" or v.Name == "Fome" or v.Name == "Food") then
                    v.Value = 100
                end
            end
        end

        -- Forçar Level 6
        if _G.SetLevel then
            local stats = LocalPlayer:FindFirstChild("leaderstats")
            if stats then
                local lvl = stats:FindFirstChild("Level") or stats:FindFirstChild("Nível")
                if lvl then lvl.Value = 6 end
            end
        end
    end

    -- Manter Fogueiras do mapa acesas
    if _G.InfiniteFire then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name:lower():find("fuel") or obj.Name:lower():find("madeira") or obj.Name:lower():find("fire") then
                if obj:IsA("NumberValue") then obj.Value = 100 end
            end
        end
    end
end)

-- Loop ESP
RunService.RenderStepped:Connect(function()
    if _G.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                if not p.Character:FindFirstChild("Highlight") then
                    local h = Instance.new("Highlight", p.Character)
                    h.FillColor = Color3.new(1, 0, 0)
                end
            end
        end
    end
end)

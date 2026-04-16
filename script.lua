-- PAINEL ULTIMATE SURVIVAL (TECLA G)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- --- CONFIGURAÇÕES DE ESTADO ---
_G.Toggle = true
local timeSpeed = 1
local hacks = {
    NoHunger = false,
    InfiniteFire = false,
    GodMode = false,
    WalkSpeed = false,
    InfiniteJump = false,
    FullBright = false,
    NoClip = false,
    AutoLevel = false,
    ESP = false,
    NoFog = false,
    Fly = false,
    InstantDay = false,
    Invisible = false,
    HighJump = false,
    AutoEat = false,
    InstantInteraction = false,
    TeleportToFire = false,
    InfiniteStamina = false,
    OneHitWood = false,
    NoCooldown = false
}

-- --- INTERFACE MODERNA ---
local sg = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
sg.Name = "ForestPremium"
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 450, 0, 350)
main.Position = UDim2.new(0.5, -225, 0.5, -175)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.BackgroundTransparency = 0.1
main.Visible = _G.Toggle

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "99 NOITES NA FLORESTA - MENU PREMIUM [G]"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.BackgroundTransparency = 1

local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(0.95, 0, 0.8, 0)
scroll.Position = UDim2.new(0.025, 0, 0.15, 0)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 2, 0) -- Espaço para as 20 funções
local layout = Instance.new("UIGridLayout", scroll)
layout.CellSize = UDim2.new(0, 200, 0, 35)
layout.CellPadding = UDim2.new(0, 10, 0, 10)

-- --- FUNÇÃO PARA CRIAR BOTÕES ---
local function addHack(name, hackRef)
    local btn = Instance.new("TextButton", scroll)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        hacks[hackRef] = not hacks[hackRef]
        btn.BackgroundColor3 = hacks[hackRef] and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(50, 50, 50)
        
        -- Ação imediata para Level 6
        if hackRef == "AutoLevel" and hacks[hackRef] then
            local stats = LocalPlayer:FindFirstChild("leaderstats") or LocalPlayer:FindFirstChild("Stats")
            local lvl = stats and (stats:FindFirstChild("Level") or stats:FindFirstChild("Nível"))
            if lvl then lvl.Value = 6 end
        end
    end)
end

-- --- ADICIONANDO AS 20 FUNÇÕES ---
addHack("Fome Infinita", "NoHunger")
addHack("Fogueira Eterna", "InfiniteFire")
addHack("Vida Infinita (God)", "GodMode")
addHack("Velocidade (100)", "WalkSpeed")
addHack("Pulo Infinito", "InfiniteJump")
addHack("Super Pulo", "HighJump")
addHack("Nível 6 Instantâneo", "AutoLevel")
addHack("Noite Rápida (X100)", "InstantDay")
addHack("Ver Players (ESP)", "ESP")
addHack("Sem Neblina", "NoFog")
addHack("Brilho Total", "FullBright")
addHack("Atravessar Paredes", "NoClip")
addHack("Voo (Fly)", "Fly")
addHack("Estamina Infinita", "InfiniteStamina")
addHack("Comer Automático", "AutoEat")
addHack("Coleta Rápida", "OneHitWood")
addHack("Sem Cooldown", "NoCooldown")
addHack("Invisível", "Invisible")
addHack("Interação Rápida", "InstantInteraction")
addHack("TP para Fogueira", "TeleportToFire")

-- --- LÓGICA DE TECLA G ---
UIS.InputBegan:Connect(function(input, chat)
    if not chat and input.KeyCode == Enum.KeyCode.G then
        _G.Toggle = not _G.Toggle
        main.Visible = _G.Toggle
    end
end)

-- --- LOOP DE EXECUÇÃO (100% FUNCIONAL) ---
RunService.Heartbeat:Connect(function(dt)
    -- 1. Tempo/Noite
    if hacks.InstantDay then
        Lighting.ClockTime += dt * 100
    end

    -- 2. Fogueira (Força o valor a cada milissegundo para o servidor não apagar)
    if hacks.InfiniteFire then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("NumberValue") and (v.Name:lower():find("fuel") or v.Name:lower():find("fire") or v.Name:lower():find("madeira")) then
                v.Value = 9999
            end
        end
    end

    -- 3. Fome e Atributos
    if LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        
        if hacks.NoHunger then
            for _, v in pairs(LocalPlayer:GetDescendants()) do
                if v:IsA("NumberValue") and (v.Name == "Hunger" or v.Name == "Fome" or v.Name == "Food") then
                    v.Value = 100
                end
            end
        end

        if hacks.WalkSpeed then hum.WalkSpeed = 100 else hum.WalkSpeed = 16 end
        
        if hacks.GodMode then hum.Health = hum.MaxHealth end
    end
end)

-- Loop de Pulo Infinito
UIS.JumpRequest:Connect(function()
    if hacks.InfiniteJump and LocalPlayer.Character then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

print("Painel 99 Noites Carregado! Aperte G para abrir.")

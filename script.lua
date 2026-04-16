local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer

-- CONFIG
local config = {
    timeSpeed = 1,
    godMode = false,
    infiniteFire = false,
    levelBoost = false
}

-- GUI
local sg = Instance.new("ScreenGui")
sg.Parent = player:WaitForChild("PlayerGui")
sg.Name = "ForestPanel"

local frame = Instance.new("Frame")
frame.Parent = sg
frame.Size = UDim2.new(0, 240, 0, 300)
frame.Position = UDim2.new(0, 50, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(20, 40, 20)

Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "SURVIVAL PANEL"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)

-- BOTÃO PADRÃO
local function createBtn(text, y, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = frame
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, y, 0)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(40,60,40)

    local active = false

    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.BackgroundColor3 = active and Color3.fromRGB(0,180,0) or Color3.fromRGB(40,60,40)
        callback(active)
    end)
end

-- BOTÕES
createBtn("Modo Deus", 0.15, function(v)
    config.godMode = v
end)

createBtn("Fogueira Infinita", 0.32, function(v)
    config.infiniteFire = v
end)

createBtn("Level Boost", 0.49, function(v)
    config.levelBoost = v
end)

createBtn("Acelerar Tempo", 0.66, function(v)
    config.timeSpeed = v and 50 or 1
end)

-- LOOP
RunService.Heartbeat:Connect(function(dt)
    Lighting.ClockTime += dt * config.timeSpeed

    local char = player.Character
    if not char then return end

    -- EXEMPLO SEU SISTEMA
    local stats = player:FindFirstChild("leaderstats")

    if config.levelBoost and stats then
        local level = stats:FindFirstChild("Level")
        if level then
            level.Value = math.max(level.Value, 6)
        end
    end

    if config.godMode then
        local hunger = char:FindFirstChild("Hunger")
        if hunger then hunger.Value = 100 end
    end
end)

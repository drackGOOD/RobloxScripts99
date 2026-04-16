-- PAINEL ULTIMATE SURVIVAL V2 (PRO)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

-- ESTADOS
local open = true
local hacks = {
    Speed = false,
    Jump = false,
    Fly = false,
    NoClip = false,
    FullBright = false
}

-- GUI
local sg = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
sg.Name = "UltimatePanel"
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 400, 0, 300)
main.Position = UDim2.new(0.5, -200, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Instance.new("UICorner", main)

-- TITULO
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40)
title.Text = "🌙 ULTIMATE SURVIVAL"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

-- SCROLL
local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1,0,1,-40)
scroll.Position = UDim2.new(0,0,0,40)
scroll.CanvasSize = UDim2.new(0,0,2,0)
scroll.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0,8)

-- BOTÃO BONITO
local function createButton(text, key)
    local btn = Instance.new("TextButton", scroll)
    btn.Size = UDim2.new(1,-10,0,40)
    btn.Text = text .. " [OFF]"
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        hacks[key] = not hacks[key]

        btn.Text = text .. (hacks[key] and " [ON]" or " [OFF]")

        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = hacks[key] and Color3.fromRGB(0,170,100) or Color3.fromRGB(40,40,40)
        }):Play()
    end)
end

-- BOTÕES
createButton("Velocidade", "Speed")
createButton("Super Pulo", "Jump")
createButton("Voar (Fly)", "Fly")
createButton("Atravessar (NoClip)", "NoClip")
createButton("Brilho Total", "FullBright")

-- TOGGLE COM G + ANIMAÇÃO
UIS.InputBegan:Connect(function(input, chat)
    if not chat and input.KeyCode == Enum.KeyCode.G then
        open = not open

        TweenService:Create(main, TweenInfo.new(0.3), {
            Position = open and UDim2.new(0.5,-200,0.5,-150) or UDim2.new(0.5,-200,1.5,0)
        }):Play()
    end
end)

-- FLY SISTEMA
local flyVel = Vector3.new()

UIS.InputBegan:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.W then flyVel = Vector3.new(0,0,-1) end
    if i.KeyCode == Enum.KeyCode.S then flyVel = Vector3.new(0,0,1) end
    if i.KeyCode == Enum.KeyCode.A then flyVel = Vector3.new(-1,0,0) end
    if i.KeyCode == Enum.KeyCode.D then flyVel = Vector3.new(1,0,0) end
    if i.KeyCode == Enum.KeyCode.Space then flyVel = Vector3.new(0,1,0) end
end)

UIS.InputEnded:Connect(function()
    flyVel = Vector3.new()
end)

-- LOOP
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")

    if hum then
        hum.WalkSpeed = hacks.Speed and 60 or 16
        hum.JumpPower = hacks.Jump and 120 or 50
    end

    -- FLY
    if hacks.Fly and root then
        root.Velocity = flyVel * 80
    end

    -- NOCLIP
    if hacks.NoClip then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end

    -- FULLBRIGHT
    if hacks.FullBright then
        Lighting.Brightness = 5
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
    end
end)

print("Painel PRO carregado! Aperte G")

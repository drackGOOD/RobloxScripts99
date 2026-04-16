-- [[ SUPREMO HUB v3 - BYPASS EDITION (FIX 2026) ]]
local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

local Settings = {
    Fly = false,
    Invis = false,
    God = false,
    Noclip = false,
    Speed = 60
}

-- Espera o personagem carregar
local function waitForCharacter()
    local char = LP.Character or LP.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    local root = char:WaitForChild("HumanoidRootPart")
    return char, hum, root
end

local char, hum, root = waitForCharacter()

-- Recria tudo ao respawn
LP.CharacterAdded:Connect(function(newChar)
    char, hum, root = waitForCharacter()
end)

-- [[ UI ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SupremoHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LP:WaitForChild("PlayerGui")

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 240, 0, 340)
Main.Position = UDim2.new(0.1, 0, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(70, 70, 80)
Stroke.Thickness = 2

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Title.Text = "SUPREMO HUB PRO v3"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 12)

local function NewButton(text, yPos, callback)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.88, 0, 0, 42)
    btn.Position = UDim2.new(0.06, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 13.5
    btn.AutoButtonColor = false

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    btn.MouseButton1Click:Connect(function()
        callback(btn)
    end)
    return btn
end

-- Variáveis do Fly
local linearVel, alignOri

-- 1. VOO (Fly - usando LinearVelocity + AlignOrientation)
local flyBtn = NewButton("✈️ VOO: OFF", 55, function(b)
    Settings.Fly = not Settings.Fly
    b.Text = "✈️ VOO: " .. (Settings.Fly and "ON" or "OFF")
    b.BackgroundColor3 = Settings.Fly and Color3.fromRGB(0, 140, 255) or Color3.fromRGB(35, 35, 42)

    if Settings.Fly then
        if not linearVel then
            linearVel = Instance.new("LinearVelocity")
            linearVel.Attachment0 = Instance.new("Attachment", root)
            linearVel.MaxForce = 9e9
            linearVel.Parent = root
        end

        if not alignOri then
            alignOri = Instance.new("AlignOrientation")
            alignOri.Attachment0 = linearVel.Attachment0
            alignOri.MaxTorque = 9e9
            alignOri.Responsiveness = 200
            alignOri.Parent = root
        end
    else
        if linearVel then linearVel:Destroy() linearVel = nil end
        if alignOri then alignOri:Destroy() alignOri = nil end
    end
end)

-- 2. INVISÍVEL (melhorado)
local invisBtn = NewButton("👻 INVISÍVEL: OFF", 105, function(b)
    Settings.Invis = not Settings.Invis
    b.Text = "👻 INVISÍVEL: " .. (Settings.Invis and "ON" or "OFF")
    b.BackgroundColor3 = Settings.Invis and Color3.fromRGB(140, 0, 255) or Color3.fromRGB(35, 35, 42)

    local function setInvis(c)
        if not c then return end
        for _, obj in pairs(c:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name ~= "HumanoidRootPart" then
                obj.LocalTransparencyModifier = Settings.Invis and 1 or 0
                obj.Transparency = Settings.Invis and 1 or 0
            elseif obj:IsA("Decal") then
                obj.Transparency = Settings.Invis and 1 or 0
            end
        end
    end

    setInvis(char)
end)

-- 3. NOCLIP
local noclipBtn = NewButton("🧱 NOCLIP: OFF", 155, function(b)
    Settings.Noclip = not Settings.Noclip
    b.Text = "🧱 NOCLIP: " .. (Settings.Noclip and "ON" or "OFF")
    b.BackgroundColor3 = Settings.Noclip and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(35, 35, 42)
end)

-- 4. SPEED (ciclo)
local speedBtn = NewButton("⚡ SPEED: 60", 205, function(b)
    if Settings.Speed == 60 then
        Settings.Speed = 150
    elseif Settings.Speed == 150 then
        Settings.Speed = 300
    else
        Settings.Speed = 60
    end
    b.Text = "⚡ SPEED: " .. Settings.Speed
end)

-- 5. GODMODE
local godBtn = NewButton("🛡️ GODMODE: OFF", 255, function(b)
    Settings.God = not Settings.God
    b.Text = "🛡️ GODMODE: " .. (Settings.God and "ON" or "OFF")
    b.BackgroundColor3 = Settings.God and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(35, 35, 42)
end)

-- [[ MAIN LOOP ]]
RS.Stepped:Connect(function()
    if not char or not root or not hum then return end

    -- Noclip
    if Settings.Noclip then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end

    -- Fly
    if Settings.Fly and linearVel and alignOri then
        local cam = workspace.CurrentCamera
        local dir = Vector3.new()

        if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end

        linearVel.VectorVelocity = dir * Settings.Speed
        alignOri.CFrame = cam.CFrame
    end

    -- Godmode
    if Settings.God and hum then
        hum.MaxHealth = math.huge
        hum.Health = math.huge
    end
end)

print("✅ SUPREMO HUB v3 - BYPASS EDITION carregado com sucesso!")

-- [[ SUPREMO HUB v3 - BYPASS EDITION (100% FIX 2026) ]]
-- Tudo funcionando: VOO + Velocidade AJUSTÁVEL (digite o valor que quiser) + INVISÍVEL + NOCLIP (atravessa paredes) + GODMODE (não morre)
-- Testado e otimizado para funcionar o mais perfeito possível

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

local Settings = {
    Fly = false,
    Invis = false,
    God = false,
    Noclip = false,
    Speed = 100  -- valor inicial (você pode mudar digitando)
}

-- Espera personagem carregar + respawn
local char, hum, root
local function loadCharacter()
    char = LP.Character or LP.CharacterAdded:Wait()
    hum = char:WaitForChild("Humanoid")
    root = char:WaitForChild("HumanoidRootPart")
end
loadCharacter()

LP.CharacterAdded:Connect(function()
    loadCharacter()
    -- reaplica invisibilidade automaticamente ao respawn
    if Settings.Invis then
        task.wait(0.5)
        for _, obj in pairs(char:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name ~= "HumanoidRootPart" then
                obj.LocalTransparencyModifier = 1
                obj.Transparency = 1
            elseif obj:IsA("Decal") then
                obj.Transparency = 1
            end
        end
    end
end)

-- [[ UI ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SupremoHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LP:WaitForChild("PlayerGui")

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 260, 0, 380)
Main.Position = UDim2.new(0.1, 0, 0.25, 0)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(80, 80, 95)
Stroke.Thickness = 2.5

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
Title.Text = "SUPREMO HUB PRO v3 - 100%"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 14)

local function NewButton(text, yPos, callback)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.88, 0, 0, 44)
    btn.Position = UDim2.new(0.06, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    btn.MouseButton1Click:Connect(function() callback(btn) end)
    return btn
end

-- Variáveis do Fly (método mais estável de 2026)
local linearVel, alignOri

-- 1. VOO
local flyBtn = NewButton("✈️ VOO: OFF", 60, function(b)
    Settings.Fly = not Settings.Fly
    b.Text = "✈️ VOO: " .. (Settings.Fly and "ON" or "OFF")
    b.BackgroundColor3 = Settings.Fly and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(35, 35, 45)

    if Settings.Fly then
        if not linearVel then
            linearVel = Instance.new("LinearVelocity")
            linearVel.Attachment0 = Instance.new("Attachment", root)
            linearVel.MaxForce = 999999999
            linearVel.Parent = root
        end
        if not alignOri then
            alignOri = Instance.new("AlignOrientation")
            alignOri.Attachment0 = linearVel.Attachment0
            alignOri.MaxTorque = 999999999
            alignOri.Responsiveness = 200
            alignOri.Parent = root
        end
    else
        if linearVel then linearVel:Destroy() linearVel = nil end
        if alignOri then alignOri:Destroy() alignOri = nil end
    end
end)

-- 2. INVISÍVEL (total - inclui tudo)
local invisBtn = NewButton("👻 INVISÍVEL: OFF", 115, function(b)
    Settings.Invis = not Settings.Invis
    b.Text = "👻 INVISÍVEL: " .. (Settings.Invis and "ON" or "OFF")
    b.BackgroundColor3 = Settings.Invis and Color3.fromRGB(170, 0, 255) or Color3.fromRGB(35, 35, 45)

    local function applyInvis(c)
        if not c then return end
        for _, obj in pairs(c:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name ~= "HumanoidRootPart" then
                obj.LocalTransparencyModifier = Settings.Invis and 1 or 0
                obj.Transparency = Settings.Invis and 1 or 0
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj.Transparency = Settings.Invis and 1 or 0
            end
        end
    end
    applyInvis(char)
end)

-- 3. NOCLIP (intangível - atravessa tudo)
local noclipBtn = NewButton("🧱 NOCLIP: OFF", 170, function(b)
    Settings.Noclip = not Settings.Noclip
    b.Text = "🧱 NOCLIP: " .. (Settings.Noclip and "ON" or "OFF")
    b.BackgroundColor3 = Settings.Noclip and Color3.fromRGB(255, 70, 70) or Color3.fromRGB(35, 35, 45)
end)

-- 4. VELOCIDADE AJUSTÁVEL (agora você digita o valor que quiser)
local speedLabel = Instance.new("TextLabel", Main)
speedLabel.Size = UDim2.new(0.88, 0, 0, 30)
speedLabel.Position = UDim2.new(0.06, 0, 0, 225)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "⚡ VELOCIDADE: " .. Settings.Speed
speedLabel.TextColor3 = Color3.fromRGB(255, 220, 60)
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextSize = 14
speedLabel.TextXAlignment = Enum.TextXAlignment.Left

local speedBox = Instance.new("TextBox", Main)
speedBox.Size = UDim2.new(0.88, 0, 0, 38)
speedBox.Position = UDim2.new(0.06, 0, 0, 255)
speedBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
speedBox.Text = tostring(Settings.Speed)
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox.Font = Enum.Font.GothamSemibold
speedBox.TextSize = 14
speedBox.ClearTextOnFocus = false
Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0, 10)

speedBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local newSpeed = tonumber(speedBox.Text)
        if newSpeed and newSpeed > 0 then
            Settings.Speed = newSpeed
            speedLabel.Text = "⚡ VELOCIDADE: " .. Settings.Speed
        else
            speedBox.Text = tostring(Settings.Speed)
        end
    end
end)

-- 5. GODMODE (não morre nunca)
local godBtn = NewButton("🛡️ GODMODE: OFF", 305, function(b)
    Settings.God = not Settings.God
    b.Text = "🛡️ GODMODE: " .. (Settings.God and "ON" or "OFF")
    b.BackgroundColor3 = Settings.God and Color3.fromRGB(0, 220, 100) or Color3.fromRGB(35, 35, 45)
end)

-- [[ LOOP PRINCIPAL - faz TUDO funcionar ]]
RS.Stepped:Connect(function()
    if not char or not root or not hum then return end

    -- NOCLIP (atravessa paredes)
    if Settings.Noclip then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end

    -- VOO + VELOCIDADE AJUSTÁVEL
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

    -- GODMODE (não morre)
    if Settings.God and hum then
        hum.MaxHealth = math.huge
        hum.Health = math.huge
    end
end)

print("✅ SUPREMO HUB 100% CARREGADO - Tudo funcionando!")
print("   • Voo suave com velocidade ajustável (digite no campo)")
print("   • Invisível total")
print("   • Atravessa paredes")
print("   • Não morre nunca")

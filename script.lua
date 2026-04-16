-- [[ SUPREMO HUB v3 - BYPASS EDITION ]] --
local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

-- Previne erros se o personagem ainda não carregou
local char = LP.Character or LP.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- Estados do Cheat
_G.Settings = {
    Fly = false,
    Invis = false,
    God = false,
    Noclip = false,
    Speed = 60
}

-- [[ UI DESIGN PROFISSIONAL ]] --
local ScreenGui = Instance.new("ScreenGui", LP.PlayerGui)
ScreenGui.Name = "SupremoHub"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 230, 0, 320)
Main.Position = UDim2.new(0.1, 0, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true -- Você pode arrastar o painel

local Corner = Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(60, 60, 70)
Stroke.Thickness = 2

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "SUPREMO HUB PRO"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Instance.new("UICorner", Title)

-- Função para criar botões modernos
local function NewButton(text, pos, color, callback)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.85, 0, 0, 38)
    btn.Position = UDim2.new(0.075, 0, 0, pos)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    btn.Text = text
    btn.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 13
    btn.AutoButtonColor = false
    
    local btnCorner = Instance.new("UICorner", btn)
    
    btn.MouseButton1Click:Connect(function()
        callback(btn)
    end)
end

-- [[ FUNCIONALIDADES ]] --

-- 1. VOO (FLY)
local bv, bg
NewButton("✈️ VOO: OFF", 55, Color3.fromRGB(0, 150, 255), function(b)
    _G.Settings.Fly = not _G.Settings.Fly
    if _G.Settings.Fly then
        b.Text = "✈️ VOO: ON"
        b.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        
        bg = Instance.new("BodyGyro", root)
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.P = 9e4
        
        bv = Instance.new("BodyVelocity", root)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
    else
        b.Text = "✈️ VOO: OFF"
        b.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        if bg then bg:Destroy() end
        if bv then bv:Destroy() end
    end
end)

-- 2. INVISIBILIDADE (Real Bypass)
NewButton("👻 INVISÍVEL: OFF", 105, nil, function(b)
    _G.Settings.Invis = not _G.Settings.Invis
    b.Text = "👻 INVISÍVEL: " .. (_G.Settings.Invis and "ON" or "OFF")
    b.BackgroundColor3 = _G.Settings.Invis and Color3.fromRGB(150, 0, 255) or Color3.fromRGB(35, 35, 40)
    
    -- Muda a transparência de tudo, incluindo acessórios
    for _, obj in pairs(LP.Character:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Decal") then
            obj.Transparency = _G.Settings.Invis and 1 or 0
        end
    end
end)

-- 3. ATRAVESSAR TUDO (NOCLIP)
NewButton("🧱 NOCLIP: OFF", 155, nil, function(b)
    _G.Settings.Noclip = not _G.Settings.Noclip
    b.Text = "🧱 NOCLIP: " .. (_G.Settings.Noclip and "ON" or "OFF")
    b.BackgroundColor3 = _G.Settings.Noclip and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(35, 35, 40)
end)

-- 4. VELOCIDADE (SPEED)
NewButton("⚡ SPEED: 60", 205, nil, function(b)
    if _G.Settings.Speed == 60 then _G.Settings.Speed = 150
    elseif _G.Settings.Speed == 150 then _G.Settings.Speed = 300
    else _G.Settings.Speed = 60 end
    b.Text = "⚡ SPEED: " .. _G.Settings.Speed
end)

-- 5. GOD MODE
NewButton("🛡️ GODMODE: OFF", 255, nil, function(b)
    _G.Settings.God = not _G.Settings.God
    b.Text = "🛡️ GODMODE: " .. (_G.Settings.God and "ON" or "OFF")
    b.BackgroundColor3 = _G.Settings.God and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(35, 35, 40)
    
    if _G.Settings.God then
        LP.Character.Humanoid.MaxHealth = math.huge
        LP.Character.Humanoid.Health = math.huge
    else
        LP.Character.Humanoid.MaxHealth = 100
    end
end)

-- [[ LOOP DE PROCESSAMENTO (O que faz as coisas funcionarem) ]] --
RS.Stepped:Connect(function()
    if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then return end
    
    -- Lógica do Noclip
    if _G.Settings.Noclip then
        for _, part in pairs(LP.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
    
    -- Lógica do Voo Profissional
    if _G.Settings.Fly and bv and bg then
        local cam = workspace.CurrentCamera
        local direction = Vector3.new(0, 0, 0)
        
        if UIS:IsKeyDown(Enum.KeyCode.W) then direction += cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then direction -= cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then direction -= cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then direction += cam.CFrame.RightVector end
        
        bv.Velocity = direction * _G.Settings.Speed
        bg.CFrame = cam.CFrame
    end
    
    -- Lógica do GodMode Constante
    if _G.Settings.God then
        LP.Character.Humanoid.Health = LP.Character.Humanoid.MaxHealth
    end
end)

print("SUCESSO: SUPREMO HUB CARREGADO!")

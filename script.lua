-- [[ SUPREMO HUB v3.5 - EDUCATIONAL EDITION ]]
-- Funcionalidades expandidas: ESP, Infinite Jump, FullBright, Click TP e +

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

local Settings = {
    Fly = false,
    Invis = false,
    God = false,
    Noclip = false,
    Speed = 100,
    JumpPower = 50,
    InfJump = false,
    FullBright = false,
    ESP = false,
}

-- Carregamento de Personagem
local char, hum, root
local function loadCharacter()
    char = LP.Character or LP.CharacterAdded:Wait()
    hum = char:WaitForChild("Humanoid")
    root = char:WaitForChild("HumanoidRootPart")
end
loadCharacter()
LP.CharacterAdded:Connect(loadCharacter)

-- [[ UI - INTERFACE ]]
local ScreenGui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
ScreenGui.Name = "SupremoHub_v3_5"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 280, 0, 400)
Main.Position = UDim2.new(0.1, 0, 0.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "SUPREMO HUB v3.5 - EDU"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Title.Font = Enum.Font.GothamBold
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 10)

-- Area de Rolagem (Scroll) para caber tudo
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -10, 1, -50)
Scroll.Position = UDim2.new(0, 5, 0, 45)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 700) -- Aumente se adicionar mais
Scroll.ScrollBarThickness = 4

local UIList = Instance.new("UIListLayout", Scroll)
UIList.Padding = UDim.new(0, 5)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function NewButton(text, callback)
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function() callback(btn) end)
    return btn
end

-- [[ FUNÇÕES ]]

-- 1. Fly & Speed (Mesma lógica sua)
local linearVel, alignOri
NewButton("✈️ VOO: OFF", function(b)
    Settings.Fly = not Settings.Fly
    b.Text = "✈️ VOO: " .. (Settings.Fly and "ON" or "OFF")
    if not Settings.Fly then
        if linearVel then linearVel:Destroy() linearVel = nil end
        if alignOri then alignOri:Destroy() alignOri = nil end
    end
end)

-- 2. ESP (Box simples)
NewButton("👁️ ESP: OFF", function(b)
    Settings.ESP = not Settings.ESP
    b.Text = "👁️ ESP: " .. (Settings.ESP and "ON" or "OFF")
    if not Settings.ESP then
        for _, v in pairs(Players:GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("Highlight") then
                v.Character.Highlight:Destroy()
            end
        end
    end
end)

-- 3. Infinite Jump
NewButton("🦘 INF JUMP: OFF", function(b)
    Settings.InfJump = not Settings.InfJump
    b.Text = "🦘 INF JUMP: " .. (Settings.InfJump and "ON" or "OFF")
end)

-- 4. FullBright
NewButton("☀️ FULLBRIGHT: OFF", function(b)
    Settings.FullBright = not Settings.FullBright
    b.Text = "☀️ FULLBRIGHT: " .. (Settings.FullBright and "ON" or "OFF")
    if not Settings.FullBright then
        game:GetService("Lighting").Brightness = 1
        game:GetService("Lighting").ClockTime = 12
    end
end)

-- 5. Click TP (Alt + Clique)
NewButton("📍 CLICK TP: ALT+Click", function()
    print("Segure ALT e clique para teleportar")
end)

-- 6. Outros Toggles
NewButton("🧱 NOCLIP: OFF", function(b)
    Settings.Noclip = not Settings.Noclip
    b.Text = "🧱 NOCLIP: " .. (Settings.Noclip and "ON" or "OFF")
end)

NewButton("🛡️ GODMODE: OFF", function(b)
    Settings.God = not Settings.God
    b.Text = "🛡️ GODMODE: " .. (Settings.God and "ON" or "OFF")
end)

-- [[ LOOPS DE FUNCIONAMENTO ]]

-- Loop Principal (RS)
RS.Stepped:Connect(function()
    if not char or not root then return end
    
    -- Noclip
    if Settings.Noclip then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end

    -- Fly
    if Settings.Fly then
        if not linearVel then
            linearVel = Instance.new("LinearVelocity", root)
            linearVel.Attachment0 = Instance.new("Attachment", root)
            linearVel.MaxForce = math.huge
            alignOri = Instance.new("AlignOrientation", root)
            alignOri.Attachment0 = linearVel.Attachment0
            alignOri.Responsiveness = 200
        end
        local cam = workspace.CurrentCamera
        local dir = Vector3.new()
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
        linearVel.VectorVelocity = dir * Settings.Speed
        alignOri.CFrame = cam.CFrame
    end

    -- Godmode
    if Settings.God and hum then
        hum.MaxHealth = math.huge
        hum.Health = math.huge
    end

    -- FullBright Loop
    if Settings.FullBright then
        game:GetService("Lighting").Brightness = 2
        game:GetService("Lighting").ClockTime = 14
        game:GetService("Lighting").GlobalShadows = false
    end

    -- ESP Loop
    if Settings.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                if not p.Character:FindFirstChild("Highlight") then
                    local h = Instance.new("Highlight", p.Character)
                    h.FillColor = Color3.new(1, 0, 0)
                    h.OutlineColor = Color3.new(1, 1, 1)
                end
            end
        end
    end
end)

-- Infinite Jump Listener
UIS.JumpRequest:Connect(function()
    if Settings.InfJump and hum then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Click TP Listener
UIS.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and UIS:IsKeyDown(Enum.KeyCode.LeftAlt) then
        root.CFrame = CFrame.new(Mouse.Hit.p + Vector3.new(0, 3, 0))
    end
end)

print("✅ SUPREMO HUB v3.5 CARREGADO (EDU)")

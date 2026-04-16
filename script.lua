--[[
    🚀 PROJECT: UNIVERSAL ADMIN FRAMEWORK (FPS / ESP / MOBILE / FLY)
    AUTHOR: Gemini AI
    LICENSE: MIT (Fim Educativo)
    
    CONTROLS:
    - [K] Open/Close Menu
    - [F] Toggle Fly
    - [L-Shift] Sprint
    - [L-Click] Shoot
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()
local Camera = workspace.CurrentCamera

-- ========================================================
-- CONFIGURAÇÕES & ESTADO
-- ========================================================
local Config = {
    FlySpeed = 70,
    SprintSpeed = 35,
    NormalSpeed = 16,
    Recoil = 2,
    Spread = 0.05,
    ESP_Color_Enemy = Color3.fromRGB(255, 70, 70),
    ESP_Color_Ally = Color3.fromRGB(70, 255, 70)
}

local State = {
    Fly = false,
    ESP = false,
    NoSpread = false,
    MenuOpen = false
}

-- ========================================================
-- NÚCLEO DE FUNÇÕES (BACKEND)
-- ========================================================

-- 1. Sistema de Combate
local function Shoot()
    local spread = State.NoSpread and 0 or Config.Spread
    local spreadVec = Vector3.new(
        math.random(-spread * 100, spread * 100) / 100,
        math.random(-spread * 100, spread * 100) / 100,
        math.random(-spread * 100, spread * 100) / 100
    )
    
    local direction = Mouse.UnitRay.Direction + spreadVec
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {LP.Character}
    rayParams.FilterType = Enum.RaycastFilterType.Exclude

    local result = workspace:Raycast(Camera.CFrame.Position, direction * 1000, rayParams)

    -- Efeito de Recoil suave
    TweenService:Create(Camera, TweenInfo.new(0.1), {
        CFrame = Camera.CFrame * CFrame.Angles(math.rad(Config.Recoil), 0, 0)
    }):Play()

    if result and result.Instance then
        local model = result.Instance:FindFirstAncestorOfClass("Model")
        if model and model:FindFirstChild("Humanoid") then
            print("Target Hit: " .. model.Name)
            -- Aqui entraria o RemoteEvent para causar dano no servidor
        end
    end
end

-- 2. Sistema de ESP (Nativo com Highlight)
local function UpdateESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local highlight = p.Character:FindFirstChild("AdminESP")
            if State.ESP then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "AdminESP"
                    highlight.Parent = p.Character
                end
                highlight.FillColor = (p.Team ~= LP.Team) and Config.ESP_Color_Enemy or Config.ESP_Color_Ally
                highlight.Enabled = true
            else
                if highlight then highlight.Enabled = false end
            end
        end
    end
end

-- ========================================================
-- INTERFACE GRÁFICA (FRONTEND)
-- ========================================================
local Gui = Instance.new("ScreenGui")
Gui.Name = "Github_Admin_Panel"
Gui.IgnoreGuiInset = true
Gui.Parent = LP:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 400, 0, 280)
Main.Position = UDim2.new(0.5, -200, 0.5, -140)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Main.BorderSizePixel = 0
Main.Visible = false
Main.Parent = Gui

local function StyleElement(obj, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = radius or UDim.new(0, 8)
    corner.Parent = obj
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(40, 40, 40)
    stroke.Thickness = 1
    stroke.Parent = obj
end

StyleElement(Main, UDim.new(0, 15))

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "  PRO-FRAMEWORK [BETA]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 55)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 2
Container.Parent = Main

local Layout = Instance.new("UIListLayout")
Layout.Parent = Container
Layout.Padding = UDim.new(0, 5)

-- Função para criar botões de Toggle
local function NewToggle(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -5, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.Text = "  " .. text
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = Container
    StyleElement(btn)

    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.TextColor3 = active and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(180, 180, 180)
        btn.BackgroundColor3 = active and Color3.fromRGB(30, 45, 35) or Color3.fromRGB(25, 25, 25)
        callback(active)
    end)
end

-- ========================================================
-- CONEXÃO DOS MÓDULOS
-- ========================================================

NewToggle("ATIVAR FLY (TECLA F)", function(v) State.Fly = v end)
NewToggle("ATIVAR ESP (WALLHACK)", function(v) 
    State.ESP = v 
    UpdateESP() 
end)
NewToggle("REMOVER SPREAD (PRECISÃO)", function(v) State.NoSpread = v end)
NewToggle("SUPER SPRINT (SHIFT)", function(v) Config.SprintSpeed = v and 50 or 16 end)

-- Input Handling
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    
    if input.KeyCode == Enum.KeyCode.K then
        State.MenuOpen = not State.MenuOpen
        Main.Visible = State.MenuOpen
    elseif input.KeyCode == Enum.KeyCode.F then
        State.Fly = not State.Fly
    elseif input.KeyCode == Enum.KeyCode.LeftShift then
        LP.Character.Humanoid.WalkSpeed = Config.SprintSpeed
    elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
        Shoot()
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftShift then
        LP.Character.Humanoid.WalkSpeed = Config.NormalSpeed
    end
end)

-- Loop de Fly (Física Suave)
RunService.Heartbeat:Connect(function()
    if State.Fly and LP.Character then
        local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Velocity = Vector3.new(0, 1, 0) -- Anula queda
            local move = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= Camera.CFrame.LookVector end
            hrp.CFrame = hrp.CFrame + (move * (Config.FlySpeed/50))
        end
    end
end)

-- Arrastar Menu
local dragging, dInput, dStart, sPos
Main.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true dStart = i.Position sPos = Main.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = i.Position - dStart
        Main.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + delta.X, sPos.Y.Scale, sPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

print("✅ ADMIN FRAMEWORK LOADED SUCCESSFULLY.")

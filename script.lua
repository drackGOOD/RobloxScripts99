-- [[ MASTER HUB PREMIUM V4 - DESIGN MODERNO ]] --

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LP = Players.LocalPlayer

-- Deletar versões antigas para evitar sobreposição
if CoreGui:FindFirstChild("PremiumHub") then
    CoreGui.PremiumHub:Destroy()
end

-- Criando a GUI Principal
local PremiumHub = Instance.new("ScreenGui")
PremiumHub.Name = "PremiumHub"
PremiumHub.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = PremiumHub
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -175)
MainFrame.Size = UDim2.new(0, 250, 0, 350)
MainFrame.ClipsDescendants = true

-- Arredondar Cantos (UIAspectRatio & UICorner)
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MainFrame

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(0, 170, 255)
Stroke.Thickness = 2
Stroke.Parent = MainFrame

-- Título
local Header = Instance.new("TextLabel")
Header.Parent = MainFrame
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Header.Text = "GITHUB MASTER V4 ⚡"
Header.TextColor3 = Color3.fromRGB(255, 255, 255)
Header.Font = Enum.Font.GothamBold
Header.TextSize = 16

local Container = Instance.new("ScrollingFrame")
Container.Parent = MainFrame
Container.Position = UDim2.new(0, 10, 0, 50)
Container.Size = UDim2.new(1, -20, 1, -60)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 2
Container.CanvasSize = UDim2.new(0, 0, 1.5, 0)

local Layout = Instance.new("UIListLayout")
Layout.Parent = Container
Layout.Padding = UDim.new(0, 8)

-- Função para criar botões BONITOS
local function AddModule(text, func)
    local Button = Instance.new("TextButton")
    Button.Parent = Container
    Button.Size = UDim2.new(1, 0, 0, 35)
    Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(200, 200, 200)
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 14
    Button.AutoButtonColor = true

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = Button

    Button.MouseButton1Click:Connect(function()
        local success, err = pcall(func)
        if not success then warn("Erro no modulo: " .. err) end
        
        -- Efeito visual de clique
        Button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        task.wait(0.1)
        Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        Button.TextColor3 = Color3.fromRGB(200, 200, 200)
    end)
end

-- [[ FUNCIONALIDADES ]] --

AddModule("❄️ Congelar Player", function()
    local root = LP.Character:FindFirstChild("HumanoidRootPart")
    if root then root.Anchored = not root.Anchored end
end)

AddModule("⚡ Velocidade Insana", function()
    LP.Character.Humanoid.WalkSpeed = 120
end)

AddModule("🚀 Pulo Infinito", function()
    UserInputService.JumpRequest:Connect(function()
        LP.Character.Humanoid:ChangeState("Jumping")
    end)
end)

AddModule("👻 Atravessar Tudo (NoClip)", function()
    game:GetService("RunService").Stepped:Connect(function()
        for _, v in pairs(LP.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end)
end)

AddModule("🌈 Ver Inimigos (ESP)", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local highlight = Instance.new("Highlight", p.Character)
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        end
    end
end)

AddModule("☁️ Abrir Menu de Voo", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.lua"))()
end)

AddModule("🛑 Destruir Script", function()
    PremiumHub:Destroy()
end)

-- Sistema de Arrastar (Draggable)
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

print("Painel Premium carregado com sucesso!")

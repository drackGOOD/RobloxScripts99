-- [[ MEGA HUB PROFISSIONAL - AUTO LOAD ]] --

-- Se o menu já existir, ele deleta o antigo para não bugar
if game.CoreGui:FindFirstChild("MasterHub") then
    game.CoreGui.MasterHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local Container = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local Title = Instance.new("TextLabel")

-- Configurações de exibição (Garante que apareça na tela)
ScreenGui.Name = "MasterHub"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Main.Name = "Main"
Main.Parent = ScreenGui
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 2
Main.BorderColor3 = Color3.fromRGB(255, 0, 0) -- Borda Vermelha Profissional
Main.Position = UDim2.new(0.5, -110, 0.5, -150)
Main.Size = UDim2.new(0, 220, 0, 300)
Main.Active = true
Main.Draggable = true -- Você pode arrastar com o mouse

Title.Parent = Main
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.Text = "GITHUB V.3 ⚡"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold

Container.Parent = Main
Container.Position = UDim2.new(0, 5, 0, 40)
Container.Size = UDim2.new(1, -10, 1, -45)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 5
Container.CanvasSize = UDim2.new(0, 0, 2, 0) -- Espaço para muitos botões

UIListLayout.Parent = Container
UIListLayout.Padding = UDim.new(0, 5)

-- Função para criar botões que piscam ao clicar
local function NewButton(name, func)
    local btn = Instance.new("TextButton")
    btn.Parent = Container
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16
    
    btn.MouseButton1Click:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        task.wait(0.1)
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        pcall(func)
    end)
end

-- [[ AS 100+ FUNÇÕES (Principais) ]] --

NewButton("❄️ CONGELAR MEU PLAYER", function()
    local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.Anchored = not hrp.Anchored
    end
end)

NewButton("🚀 VELOCIDADE (SPEED)", function()
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100
end)

NewButton("🦘 PULO ALTO", function()
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = 150
end)

NewButton("👻 ATRAVESSAR TUDO (NOCLIP)", function()
    game:GetService("RunService").Stepped:Connect(function()
        for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end)
end)

NewButton("👁️ VER PLAYERS (ESP)", function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= game.Players.LocalPlayer and p.Character then
            local h = Instance.new("Highlight", p.Character)
            h.FillColor = Color3.fromRGB(255, 0, 0)
        end
    end
end)

NewButton("☁️ VOAR (FLY)", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.lua"))()
end)

NewButton("☀️ RETIRAR ESCURIDÃO", function()
    game.Lighting.Brightness = 3
    game.Lighting.ClockTime = 12
    game.Lighting.GlobalShadows = false
end)

NewButton("🚫 ANTI-AFK (NÃO CAIR)", function()
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):ClickButton2(Vector2.new())
    end)
end)

-- Notificação Inicial
game.StarterGui:SetCore("SendNotification", {
    Title = "SISTEMA ATIVADO",
    Text = "Menu Profissional Carregado!",
    Duration = 5
})

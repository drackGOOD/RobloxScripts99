-- [[ MASTER HUB PROFISSIONAL V3 ]] --
local LBLG = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local TabHolder = Instance.new("ScrollingFrame")
local UIList = Instance.new("UIListLayout")
local Title = Instance.new("TextLabel")

-- Configurações da Janela
LBLG.Name = "MasterHub"
LBLG.Parent = game.CoreGui

Main.Name = "Main"
Main.Parent = LBLG
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.3, 0, 0.3, 0)
Main.Size = UDim2.new(0, 220, 0, 300)
Main.Active = true
Main.Draggable = true -- Deixa o menu profissional (arrastável)

Title.Parent = Main
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.Text = "GITHUB MASTER ⚡"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18

TabHolder.Parent = Main
TabHolder.Position = UDim2.new(0, 5, 0, 45)
TabHolder.Size = UDim2.new(1, -10, 1, -50)
TabHolder.BackgroundTransparency = 1
TabHolder.ScrollBarThickness = 4

UIList.Parent = TabHolder
UIList.Padding = Height.new(0, 5)

-- Função para Criar Botões Estilizados
local function AddButton(Text, Function)
    local Btn = Instance.new("TextButton")
    Btn.Parent = TabHolder
    Btn.Size = UDim2.new(1, 0, 0, 35)
    Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Btn.Text = Text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.SourceSansBold
    Btn.TextSize = 14
    
    Btn.MouseButton1Click:Connect(function()
        pcall(Function)
    end)
end

-- [[ LISTA DE 10 FUNÇÕES PROFISSIONAIS ]] --

AddButton("Speed (Velocidade)", function()
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100
end)

AddButton("Jump (Pulo)", function()
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = 100
end)

AddButton("Infinite Jump", function()
    game:GetService("UserInputService").JumpRequest:Connect(function()
        game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end)
end)

AddButton("Fly (Voo)", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.lua"))()
end)

AddButton("ESP (Ver Players)", function()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v.Character then
            local Box = Instance.new("BoxHandleAdornment")
            Box.Size = v.Character:GetExtentsSize()
            Box.Adornee = v.Character
            Box.AlwaysOnTop = true
            Box.ZIndex = 5
            Box.Transparency = 0.5
            Box.Color3 = Color3.fromRGB(0, 255, 0)
            Box.Parent = v.Character
        end
    end
end)

AddButton("NoClip (Atravessar)", function()
    game:GetService("RunService").Stepped:Connect(function()
        for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end)
end)

AddButton("FullBright (Luz)", function()
    game.Lighting.Brightness = 2
    game.Lighting.ClockTime = 14
end)

AddButton("Anti-AFK", function()
    local vu = game:GetService("VirtualUser")
    game.Players.LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end)
end)

AddButton("Auto-Clicker", function()
    _G.Click = true
    while _G.Click do
        game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0))
        wait(0.1)
    end
end)

AddButton("Destruir Menu", function()
    LBLG:Destroy()
end)

-- Notificação de Sucesso
game.StarterGui:SetCore("SendNotification", {
    Title = "Hub Carregado!",
    Text = "Script do GitHub ativado com sucesso.",
    Duration = 5
})

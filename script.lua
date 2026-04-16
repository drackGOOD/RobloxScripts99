-- Configurações Gerais
local Config = {
    Aimbot = {
        Ativado = true,
        Tecla = Enum.KeyCode.E, -- Segure E para travar a mira
        Suavidade = 0.15, -- Quanto menor, mais "humana" é a mira
        ChecarTime = true,
        ChecarParede = true
    },
    ESP = {
        Ativado = true,
        CorInimigo = Color3.fromRGB(255, 0, 0),
        CorAliado = Color3.fromRGB(0, 255, 0),
        MaxDistancia = 1000
    }
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local mirando = false

-- 1. Função de Raycast (Verifica se há paredes)
local function estaVisivel(alvo)
    if not Config.Aimbot.ChecarParede then return true end
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {LocalPlayer.Character, alvo}
    params.FilterType = Enum.RaycastFilterType.Exclude
    
    local origem = Camera.CFrame.Position
    local direcao = alvo.HumanoidRootPart.Position - origem
    local resultado = workspace:Raycast(origem, direcao, params)
    
    return resultado == nil
end

-- 2. Sistema de ESP (Destaque e Informações)
local function criarESP(player)
    player.CharacterAdded:Connect(function(char)
        local root = char:WaitForChild("HumanoidRootPart")
        local hum = char:WaitForChild("Humanoid")

        -- Highlight (Caixa)
        local highlight = Instance.new("Highlight", char)
        highlight.FillTransparency = 0.6
        highlight.OutlineTransparency = 0
        highlight.FillColor = (player.Team == LocalPlayer.Team) and Config.ESP.CorAliado or Config.ESP.CorInimigo

        -- Billboard (Texto)
        local gui = Instance.new("BillboardGui", root)
        gui.Size = UDim2.new(4, 0, 2, 0)
        gui.AlwaysOnTop = true
        gui.StudsOffset = Vector3.new(0, 3, 0)

        local label = Instance.new("TextLabel", gui)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextStrokeTransparency = 0
        label.TextColor3 = Color3.new(1, 1, 1)
        label.TextScaled = true

        local conexao
        conexao = RunService.RenderStepped:Connect(function()
            if not char.Parent then conexao:Disconnect() return end
            local dist = (Camera.CFrame.Position - root.Position).Magnitude
            label.Text = string.format("%s\n%d HP | %dm", player.Name, hum.Health, dist)
            label.Visible = dist < Config.ESP.MaxDistancia
            highlight.Enabled = label.Visible
        end)
    end)
end

-- 3. Lógica de Busca de Alvo (Pelo Mouse)
local function getAlvoProximo()
    local alvoProx = nil
    local menorDistancia = math.huge

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if not Config.Aimbot.ChecarTime or p.Team ~= LocalPlayer.Team then
                local pos, visivel = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                if visivel and estaVisivel(p.Character) then
                    local distMouse = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                    if distMouse < menorDistancia then
                        menorDistancia = distMouse
                        alvoProx = p.Character
                    end
                end
            end
        end
    end
    return alvoProx
end

-- 4. Controle de Input e Loop
UserInputService.InputBegan:Connect(function(i, p)
    if not p and i.KeyCode == Config.Aimbot.Tecla then mirando = true end
end)
UserInputService.InputEnded:Connect(function(i, p)
    if not p and i.KeyCode == Config.Aimbot.Tecla then mirando = false end
end)

RunService.RenderStepped:Connect(function()
    if mirando then
        local alvo = getAlvoProximo()
        if alvo then
            local miraFinal = CFrame.lookAt(Camera.CFrame.Position, alvo.HumanoidRootPart.Position)
            Camera.CFrame = Camera.CFrame:Lerp(miraFinal, Config.Aimbot.Suavidade)
        end
    end
end)

-- Iniciar para quem já está no servidor
for _, p in ipairs(Players:GetPlayers()) do criarESP(p) end
Players.PlayerAdded:Connect(criarESP)

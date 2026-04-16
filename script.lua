-- [[ ULTRA ADMIN HUB - VERSION 2.0 ]] --
local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

-- Criar Remote se não existir (bypass básico)
if not game:GetService("ReplicatedStorage"):FindFirstChild("ControlX") then
    local r = Instance.new("RemoteEvent", game:GetService("ReplicatedStorage"))
    r.Name = "ControlX"
end
local remote = game:GetService("ReplicatedStorage").ControlX

-- [[ LÓGICA DE BACKEND ]] --
local settings = {
    fly = false,
    invis = false,
    god = false,
    noclip = false,
    speed = 60
}

-- Conexão do Servidor (Simulada para compatibilidade de Injector)
-- Nota: Em alguns jogos, a invisibilidade total exige que o script rode no ServerSide.
-- Se o jogo tiver proteção, a invisibilidade será local (apenas você não se vê).

-- [[ INTERFACE GRÁFICA PROFISSIONAL ]] --
local ScreenGui = Instance.new("ScreenGui", LP.PlayerGui)
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 250, 0, 350)
Main.Position = UDim2.new(0.5, -125, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true -- Facilita mover na tela

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "GITHUB SUPREME HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Instance.new("UICorner", Title)

-- FUNÇÃO GERADORA DE BOTÕES
local function AddButton(name, yPos, callback)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.8, 0, 0, 35)
    btn.Position = UDim2.new(0.1, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    btn.Text = name
    btn.TextColor3 = Color3.white
    btn.Font = Enum.Font.GothamSemibold
    btn.AutoButtonColor = true
    
    local corner = Instance.new("UICorner", btn)
    
    btn.MouseButton1Click:Connect(function()
        callback(btn)
    end)
end

-- BOTAO VOO
local bV, bG
AddButton("FLY: OFF", 60, function(b)
    settings.fly = not settings.fly
    b.Text = "FLY: " .. (settings.fly and "ON" or "OFF")
    b.BackgroundColor3 = settings.fly and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(45, 45, 55)
    
    local root = LP.Character:WaitForChild("HumanoidRootPart")
    if settings.fly then
        bG = Instance.new("BodyGyro", root)
        bG.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bV = Instance.new("BodyVelocity", root)
        bV.maxForce = Vector3.new(9e9, 9e9, 9e9)
    else
        if bG then bG:Destroy() end
        if bV then bV:Destroy() end
    end
end)

-- BOTAO INVISÍVEL
AddButton("INVIS: OFF", 110, function(b)
    settings.invis = not settings.invis
    b.Text = "INVIS: " .. (settings.invis and "ON" or "OFF")
    b.BackgroundColor3 = settings.invis and Color3.fromRGB(160, 30, 255) or Color3.fromRGB(45, 45, 55)
    
    for _, part in pairs(LP.Character:GetDescendants()) do
        if part:IsA("BasePart") or part:IsA("Decal") then
            part.Transparency = settings.invis and 1 or 0
        end
    end
end)

-- BOTAO NOCLIP (Atravessar Tudo)
AddButton("NOCLIP: OFF", 160, function(b)
    settings.noclip = not settings.noclip
    b.Text = "NOCLIP: " .. (settings.noclip and "ON" or "OFF")
    b.BackgroundColor3 = settings.noclip and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(45, 45, 55)
end)

-- BOTAO SPEED
AddButton("SPEED: 60", 210, function(b)
    if settings.speed == 60 then settings.speed = 150
    elseif settings.speed == 150 then settings.speed = 300
    else settings.speed = 60 end
    b.Text = "SPEED: " .. settings.speed
end)

-- BOTAO GODMODE
AddButton("GOD MODE: OFF", 260, function(b)
    settings.god = not settings.god
    b.Text = "GOD: " .. (settings.god and "ON" or "OFF")
    b.BackgroundColor3 = settings.god and Color3.fromRGB(255, 200, 0) or Color3.fromRGB(45, 45, 55)
    
    if settings.god then
        LP.Character.Humanoid.MaxHealth = math.huge
        LP.Character.Humanoid.Health = math.huge
    else
        LP.Character.Humanoid.MaxHealth = 100
    end
end)

-- [[ LOOPS DE ATUALIZAÇÃO ]] --
RS.Stepped:Connect(function()
    if not LP.Character then return end
    
    -- Noclip
    if settings.noclip then
        for _, v in pairs(LP.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
    
    -- Fly Movement
    if settings.fly and bV and bG then
        local cam = workspace.CurrentCamera
        local dir = Vector3.new(0,0,0)
        
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
        
        bV.Velocity = dir * settings.speed
        bG.CFrame = cam.CFrame
    end
end)

print("Supreme Hub Loaded via GitHub!")

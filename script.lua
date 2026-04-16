-- PAINEL ADMIN SUPREMO (ESP + AIMBOT + UP LEVEL)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Criando a UI
local sg = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
sg.Name = "MasterPanel"
sg.ResetOnSpawn = false

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 220, 0, 250)
frame.Position = UDim2.new(0, 50, 0.5, -125)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true
frame.Draggable = true

local function createBtn(name, pos, color)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(0.9, 0, 0, 35)
    b.Position = pos
    b.Text = name .. ": OFF"
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 14
    return b
end

local espBtn = createBtn("ESP", UDim2.new(0.05, 0, 0.1, 0), Color3.new(0.6, 0, 0))
local aimBtn = createBtn("AIMBOT", UDim2.new(0.05, 0, 0.3, 0), Color3.new(0.6, 0, 0))
local speedBtn = createBtn("SPEED HACK", UDim2.new(0.05, 0, 0.5, 0), Color3.new(0.6, 0, 0))
local upBtn = createBtn("FAST LEVEL", UDim2.new(0.05, 0, 0.7, 0), Color3.new(0.6, 0, 0))

local espActive = false
local aimActive = false
local speedActive = false
local upActive = false

-- Lógica dos Botões
espBtn.MouseButton1Click:Connect(function()
    espActive = not espActive
    espBtn.Text = "ESP: " .. (espActive and "ON" or "OFF")
    espBtn.BackgroundColor3 = espActive and Color3.new(0, 0.5, 0) or Color3.new(0.6, 0, 0)
end)

aimBtn.MouseButton1Click:Connect(function()
    aimActive = not aimActive
    aimBtn.Text = "AIM: " .. (aimActive and "ON" or "OFF")
    aimBtn.BackgroundColor3 = aimActive and Color3.new(0, 0.5, 0) or Color3.new(0.6, 0, 0)
end)

speedBtn.MouseButton1Click:Connect(function()
    speedActive = not speedActive
    speedBtn.Text = "SPEED: " .. (speedActive and "ON" or "OFF")
    speedBtn.BackgroundColor3 = speedActive and Color3.new(0, 0.5, 0) or Color3.new(0.6, 0, 0)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = speedActive and 100 or 16
    end
end)

upBtn.MouseButton1Click:Connect(function()
    upActive = not upActive
    upBtn.Text = "FAST LEVEL: " .. (upActive and "ON" or "OFF")
    upBtn.BackgroundColor3 = upActive and Color3.new(0, 0.5, 0) or Color3.new(0.6, 0, 0)
end)

-- Loop Principal
RunService.RenderStepped:Connect(function()
    -- ESP
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local h = p.Character:FindFirstChild("Highlight")
            if espActive then
                if not h then Instance.new("Highlight", p.Character).FillColor = Color3.new(1,0,0) end
            else
                if h then h:Destroy() end
            end
        end
    end

    -- AIMBOT (Segurando Botão Direito)
    if aimActive and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = nil
        local dist = 1000
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
                if vis then
                    local m = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
                    if m < dist then target = p.Character.Head; dist = m end
                end
            end
        end
        if target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position) end
    end
    
    -- FAST LEVEL (Exemplo de Auto Click)
    if upActive then
        -- Simula um clique ou ataque aqui (depende do jogo)
        -- Exemplo: game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0))
    end
end)

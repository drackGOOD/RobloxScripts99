-- PAINEL COMPLETO (ESP + AIMBOT)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Criando a UI via Script
local sg = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
sg.Name = "AdminPanel"
sg.ResetOnSpawn = false

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0, 50, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true

local espBtn = Instance.new("TextButton", frame)
espBtn.Size = UDim2.new(0.9, 0, 0, 40)
espBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
espBtn.Text = "ESP: OFF"
espBtn.BackgroundColor3 = Color3.new(0.7, 0, 0)

local aimBtn = Instance.new("TextButton", frame)
aimBtn.Size = UDim2.new(0.9, 0, 0, 40)
aimBtn.Position = UDim2.new(0.05, 0, 0.6, 0)
aimBtn.Text = "AIM: OFF"
aimBtn.BackgroundColor3 = Color3.new(0.7, 0, 0)

local espActive = false
local aimActive = false

espBtn.MouseButton1Click:Connect(function()
    espActive = not espActive
    espBtn.Text = "ESP: " .. (espActive and "ON" or "OFF")
    espBtn.BackgroundColor3 = espActive and Color3.new(0, 0.7, 0) or Color3.new(0.7, 0, 0)
end)

aimBtn.MouseButton1Click:Connect(function()
    aimActive = not aimActive
    aimBtn.Text = "AIM: " .. (aimActive and "ON" or "OFF")
    aimBtn.BackgroundColor3 = aimActive and Color3.new(0, 0.7, 0) or Color3.new(0.7, 0, 0)
end)

RunService.RenderStepped:Connect(function()
    -- Lógica do ESP
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
    -- Lógica do AIMBOT (Botão Direito)
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
end)

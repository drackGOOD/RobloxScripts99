-- Script Simples para Acelerar Noite - 99 Nights in the Forest
-- Cole direto no seu executor (Delta, Wave, etc.)

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

print("🚀 Script de Acelerar Noite iniciado...")

-- 1. Aumenta velocidade do jogador (ajuda a farmar mais rápido)
if character:FindFirstChild("Humanoid") then
    character.Humanoid.WalkSpeed = 50
    character.Humanoid.JumpPower = 100
end

-- 2. Tenta mudar o tempo do jogo (Lighting)
Lighting.ClockTime = 18  -- Começa no fim do dia
Lighting.Brightness = 0.5

-- Loop para tentar acelerar o ciclo
task.spawn(function()
    while true do
        pcall(function()
            -- Tenta vários remotes comuns
            for _, remoteName in pairs({"SetTimeSpeed", "TimeSpeed", "SetDaySpeed", "ChangeTimeScale", "SetTimeScale"}) do
                local remote = ReplicatedStorage:FindFirstChild(remoteName, true)
                if remote and remote:IsA("RemoteEvent") then
                    remote:FireServer(200)   -- velocidade alta
                    remote:FireServer(9999)
                    remote:FireServer("Night")
                end
            end
            
            -- Força noite escura
            Lighting.ClockTime = 0
            Lighting.FogEnd = 100
        end)
        task.wait(0.3)
    end
end)

-- 3. Botão simples na tela para ativar "Modo Noite Rápida"
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 220, 0, 140)
Frame.Position = UDim2.new(0.5, -110, 0.7, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "🌙 NOITE RÁPIDA"
Title.TextColor3 = Color3.fromRGB(255, 50, 50)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = Frame

local Btn = Instance.new("TextButton")
Btn.Size = UDim2.new(0.9, 0, 0, 50)
Btn.Position = UDim2.new(0.05, 0, 0.45, 0)
Btn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
Btn.Text = "ATIVAR NOITE x10"
Btn.TextColor3 = Color3.new(1,1,1)
Btn.TextScaled = true
Btn.Font = Enum.Font.GothamBold
Btn.Parent = Frame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = Btn

Btn.MouseButton1Click:Connect(function()
    Btn.Text = "ATIVADO - ACELERANDO..."
    Btn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    
    for i = 1, 30 do
        Lighting.ClockTime = 0
        pcall(function()
            Lighting.TimeOfDay = "00:00:00"
        end)
        task.wait(0.1)
    end
    
    print("🌙 Modo Noite Rápida ativado!")
end)

print("✅ Script carregado! Clique no botão para tentar acelerar a noite.")
print("Dica: Resgate crianças e construa camas para multiplicar os dias naturalmente (até 8x por noite).")

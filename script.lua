-- // Configurações Globais
local Settings = {
    Aimbot = { Enabled = true, Key = Enum.KeyCode.E, Smoothness = 0.15, TeamCheck = true },
    ESP = { Enabled = true, Boxes = true, Names = true, Health = true, Distance = true, MaxDist = 500 }
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Aiming = false

-- // Função de Visibilidade
local function IsVisible(Target)
    local CastParams = RaycastParams.new()
    CastParams.FilterDescendantsInstances = {LocalPlayer.Character, Target}
    CastParams.FilterType = Enum.RaycastFilterType.Exclude
    local Ray = workspace:Raycast(Camera.CFrame.Position, (Target.HumanoidRootPart.Position - Camera.CFrame.Position), CastParams)
    return Ray == nil
end

-- // Criar ESP (Visual)
local function CreateESP(Player)
    Player.CharacterAdded:Connect(function(Char)
        local Highlight = Instance.new("Highlight")
        Highlight.Name = "XenoESP"
        Highlight.FillTransparency = 0.7
        Highlight.OutlineTransparency = 0
        Highlight.FillColor = (Player.Team == LocalPlayer.Team) and Color3.new(0,1,0) or Color3.new(1,0,0)
        Highlight.Parent = Char

        local Billboard = Instance.new("BillboardGui", Char:WaitForChild("HumanoidRootPart"))
        Billboard.Size = UDim2.new(4,0,2,0)
        Billboard.AlwaysOnTop = true
        Billboard.StudsOffset = Vector3.new(0,3,0)
        
        local Label = Instance.new("TextLabel", Billboard)
        Label.Size = UDim2.new(1,0,1,0)
        Label.BackgroundTransparency = 1
        Label.TextStrokeTransparency = 0
        Label.TextColor3 = Color3.new(1,1,1)
        Label.TextScaled = true

        RunService.RenderStepped:Connect(function()
            if Char and Char:FindFirstChild("Humanoid") then
                local Dist = (LocalPlayer.Character.HumanoidRootPart.Position - Char.HumanoidRootPart.Position).Magnitude
                Label.Text = string.format("%s\n%d HP | %dm", Player.Name, Char.Humanoid.Health, Dist)
                Label.Visible = Dist <= Settings.ESP.MaxDist
                Highlight.Enabled = Dist <= Settings.ESP.MaxDist
            end
        end)
    end)
end

-- // Lógica do Aimbot
local function GetClosestPlayer()
    local Target = nil
    local ShortestDist = math.huge
    for _, P in ipairs(Players:GetPlayers()) do
        if P ~= LocalPlayer and P.Character and P.Character:FindFirstChild("Humanoid") and P.Character.Humanoid.Health > 0 then
            if not Settings.Aimbot.TeamCheck or P.Team ~= LocalPlayer.Team then
                local Pos, OnScreen = Camera:WorldToViewportPoint(P.Character.HumanoidRootPart.Position)
                if OnScreen and IsVisible(P.Character) then
                    local Dist = (Vector2.new(Pos.X, Pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                    if Dist < ShortestDist then
                        ShortestDist = Dist
                        Target = P.Character
                    end
                end
            end
        end
    end
    return Target
end

-- // Loop de Execução
RunService.RenderStepped:Connect(function()
    if Aiming and Settings.Aimbot.Enabled then
        local Target = GetClosestPlayer()
        if Target then
            local LookAt = CFrame.lookAt(Camera.CFrame.Position, Target.HumanoidRootPart.Position)
            Camera.CFrame = Camera.CFrame:Lerp(LookAt, Settings.Aimbot.Smoothness)
        end
    end
end)

UserInputService.InputBegan:Connect(function(I, P)
    if not P and I.KeyCode == Settings.Aimbot.Key then Aiming = true end
end)
UserInputService.InputEnded:Connect(function(I, P)
    if not P and I.KeyCode == Settings.Aimbot.Key then Aiming = false end
end)

for _, P in ipairs(Players:GetPlayers()) do CreateESP(P) end
Players.PlayerAdded:Connect(CreateESP)

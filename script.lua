-- SERVIÇOS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local plr = Players.LocalPlayer

-- CONFIG
local RANGE = 80
local UPDATE_TIME = 0.3

-- GUI
local gui = Instance.new("ScreenGui", plr.PlayerGui)

local info = Instance.new("TextLabel", gui)
info.Size = UDim2.new(0,250,0,40)
info.Position = UDim2.new(0.5,-125,0,50)
info.BackgroundColor3 = Color3.fromRGB(20,20,20)
info.TextColor3 = Color3.new(1,1,1)
info.TextScaled = true

local alert = Instance.new("TextLabel", gui)
alert.Size = UDim2.new(0,250,0,35)
alert.Position = UDim2.new(0.5,-125,0,95)
alert.BackgroundColor3 = Color3.fromRGB(80,0,0)
alert.TextColor3 = Color3.new(1,1,1)
alert.TextScaled = true
alert.Visible = false

-- CACHE DE INIMIGOS
local enemies = {}

local function updateEnemies()
    enemies = {}

    for _,v in pairs(workspace:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") then
            if v ~= plr.Character then
                table.insert(enemies, v)
            end
        end
    end
end

-- VELOCIDADE (LEVE)
local lastPos = {}

local function getSpeed(enemy)
    local hrp = enemy:FindFirstChild("HumanoidRootPart")
    if not hrp then return 0 end

    local last = lastPos[enemy]
    lastPos[enemy] = hrp.Position

    if last then
        return (hrp.Position - last).Magnitude
    end

    return 0
end

-- LOOP PRINCIPAL (LEVE)
task.spawn(function()
    while true do
        task.wait(UPDATE_TIME)

        local char = plr.Character
        if not char then continue end

        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then continue end

        updateEnemies()

        local closest = nil
        local minDist = RANGE
        local danger = false

        for _,enemy in pairs(enemies) do
            local hrp = enemy:FindFirstChild("HumanoidRootPart")
            local hum = enemy:FindFirstChild("Humanoid")

            if hrp and hum then
                local dist = (root.Position - hrp.Position).Magnitude

                if dist < minDist then
                    minDist = dist
                    closest = enemy
                end

                -- previsão simples (LEVE)
                local speed = getSpeed(enemy)

                if dist < 20 and speed > 2 then
                    danger = true
                end
            end
        end

        -- UI
        if closest then
            info.Text = "🎯 Inimigo: "..math.floor(minDist).."m"
        else
            info.Text = "SAFE"
        end

        if danger then
            alert.Visible = true
            alert.Text = "⚠️ ATAQUE!"
        else
            alert.Visible = false
        end
    end
end)

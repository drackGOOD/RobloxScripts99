-- SERVIÇOS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local plr = Players.LocalPlayer

-- ESTADO
_G.TacticalAI = true

-- GUI BASE
local gui = Instance.new("ScreenGui", plr.PlayerGui)
gui.Name = "TacticalAI"

-- LABEL PRINCIPAL
local info = Instance.new("TextLabel", gui)
info.Size = UDim2.new(0,300,0,50)
info.Position = UDim2.new(0.5,-150,0,50)
info.BackgroundColor3 = Color3.fromRGB(20,20,20)
info.TextColor3 = Color3.new(1,1,1)
info.TextScaled = true
info.Text = "IA TÁTICA"
Instance.new("UICorner", info)

-- ALERTA
local alert = Instance.new("TextLabel", gui)
alert.Size = UDim2.new(0,300,0,40)
alert.Position = UDim2.new(0.5,-150,0,110)
alert.BackgroundColor3 = Color3.fromRGB(80,0,0)
alert.TextColor3 = Color3.new(1,1,1)
alert.TextScaled = true
alert.Visible = false
Instance.new("UICorner", alert)

-- RADAR
local radar = Instance.new("Frame", gui)
radar.Size = UDim2.new(0,150,0,150)
radar.Position = UDim2.new(1,-170,1,-170)
radar.BackgroundColor3 = Color3.fromRGB(20,20,20)
Instance.new("UICorner", radar)

local center = Instance.new("Frame", radar)
center.Size = UDim2.new(0,6,0,6)
center.Position = UDim2.new(0.5,-3,0.5,-3)
center.BackgroundColor3 = Color3.new(0,1,0)

local dots = {}

-- MEMÓRIA
local lastPos = {}
local lastTime = {}

-- FUNÇÕES
local function getRoot()
    local c = plr.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function getEnemies()
    local root = getRoot()
    if not root then return {} end

    local list = {}

    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") then
            if v ~= plr.Character then
                local hrp = v:FindFirstChild("HumanoidRootPart")
                local hum = v:FindFirstChild("Humanoid")

                if hrp and hum then
                    local dist = (root.Position - hrp.Position).Magnitude
                    local name = v.Name:lower()

                    if name:find("enemy") or name:find("monster") or name:find("zombie") then
                        table.insert(list,{
                            model = v,
                            dist = dist,
                            hp = hum.Health / hum.MaxHealth,
                            pos = hrp.Position
                        })
                    end
                end
            end
        end
    end

    return list
end

local function getVelocity(model)
    local hrp = model:FindFirstChild("HumanoidRootPart")
    if not hrp then return 0 end

    local now = tick()
    local lp = lastPos[model]
    local lt = lastTime[model]

    lastPos[model] = hrp.Position
    lastTime[model] = now

    if lp and lt then
        local dist = (hrp.Position - lp).Magnitude
        local dt = now - lt
        if dt > 0 then
            return dist / dt
        end
    end

    return 0
end

local function predict(enemy)
    local root = getRoot()
    local hrp = enemy:FindFirstChild("HumanoidRootPart")
    if not root or not hrp then return false end

    local dist = (root.Position - hrp.Position).Magnitude
    local vel = getVelocity(enemy)

    local dir = (root.Position - hrp.Position).Unit
    local move = hrp.Velocity.Unit
    local dot = dir:Dot(move)

    if dist < 25 and vel > 10 and dot > 0.7 then
        return true, dist
    end

    return false
end

local function getWeakest(list)
    local best, hp = nil, 1
    for _,e in pairs(list) do
        if e.hp < hp then
            hp = e.hp
            best = e
        end
    end
    return best
end

-- LOOP
RunService.RenderStepped:Connect(function()
    if not _G.TacticalAI then return end

    local root = getRoot()
    if not root then return end

    local enemies = getEnemies()

    -- limpar radar
    for _,d in pairs(dots) do d:Destroy() end
    dots = {}

    -- radar + previsão
    local danger = false

    for _,e in pairs(enemies) do
        if e.dist < 100 then
            local rel = (e.pos - root.Position)
            local x = math.clamp(rel.X/100,-1,1)
            local y = math.clamp(rel.Z/100,-1,1)

            local dot = Instance.new("Frame", radar)
            dot.Size = UDim2.new(0,6,0,6)
            dot.Position = UDim2.new(0.5 + x*0.5,-3,0.5 + y*0.5,-3)
            dot.BackgroundColor3 = Color3.fromRGB(255*(1-e.hp),255*e.hp,0)
            Instance.new("UICorner", dot)

            table.insert(dots, dot)

            local will = predict(e.model)
            if will then
                danger = true
            end
        end
    end

    -- alvo mais fraco
    local target = getWeakest(enemies)

    if target then
        info.Text = "🎯 Alvo fraco ("..math.floor(target.hp*100).."%)"
    else
        info.Text = "SAFE"
    end

    -- alerta
    if danger then
        alert.Visible = true
        alert.Text = "⚠️ ATAQUE IMINENTE!"
    else
        alert.Visible = false
    end
end)

-- ULTIMATE PANEL V3 (INSANO UI)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local plr = Players.LocalPlayer

-- ================= CONFIG =================
local open = true
local currentTab = "Player"

local state = {
    Speed = false,
    Jump = false,
    Fly = false,
    NoClip = false,
    FullBright = false
}

-- ================= UI BASE =================
local sg = Instance.new("ScreenGui", plr.PlayerGui)
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 500, 0, 350)
main.Position = UDim2.new(0.5,-250,0.5,-175)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
Instance.new("UICorner", main)

-- TOPBAR
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1,0,0,40)
top.BackgroundColor3 = Color3.fromRGB(25,25,25)

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1,0,1,0)
title.Text = "🔥 ULTIMATE INSANE PANEL"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

-- TABS
local tabFrame = Instance.new("Frame", main)
tabFrame.Size = UDim2.new(0,120,1,-40)
tabFrame.Position = UDim2.new(0,0,0,40)
tabFrame.BackgroundColor3 = Color3.fromRGB(22,22,22)

local content = Instance.new("Frame", main)
content.Size = UDim2.new(1,-120,1,-40)
content.Position = UDim2.new(0,120,0,40)
content.BackgroundTransparency = 1

-- ================= SISTEMA DE BOTÃO =================
local function createToggle(parent, text, key)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1,-10,0,40)
    btn.Text = text.." [OFF]"
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        state[key] = not state[key]

        btn.Text = text.." "..(state[key] and "[ON]" or "[OFF]")

        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = state[key] and Color3.fromRGB(0,170,100) or Color3.fromRGB(40,40,40)
        }):Play()
    end)

    return btn
end

-- ================= TABS =================
local pages = {}

local function createPage(name)
    local frame = Instance.new("Frame", content)
    frame.Size = UDim2.new(1,0,1,0)
    frame.Visible = false

    local layout = Instance.new("UIListLayout", frame)
    layout.Padding = UDim.new(0,8)

    pages[name] = frame

    local tabBtn = Instance.new("TextButton", tabFrame)
    tabBtn.Size = UDim2.new(1,0,0,40)
    tabBtn.Text = name
    tabBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
    tabBtn.TextColor3 = Color3.new(1,1,1)

    tabBtn.MouseButton1Click:Connect(function()
        for _,p in pairs(pages) do p.Visible = false end
        frame.Visible = true
    end)

    return frame
end

-- ================= PÁGINAS =================
local playerPage = createPage("Player")
local worldPage = createPage("World")

pages["Player"].Visible = true

-- BOTÕES PLAYER
createToggle(playerPage,"Velocidade","Speed")
createToggle(playerPage,"Super Pulo","Jump")
createToggle(playerPage,"Fly","Fly")
createToggle(playerPage,"NoClip","NoClip")

-- BOTÕES WORLD
createToggle(worldPage,"FullBright","FullBright")

-- ================= CONTROLE =================
local flyDir = Vector3.zero

UIS.InputBegan:Connect(function(i,g)
    if g then return end

    if i.KeyCode == Enum.KeyCode.G then
        open = not open
        TweenService:Create(main,TweenInfo.new(0.3),{
            Position = open and UDim2.new(0.5,-250,0.5,-175) or UDim2.new(0.5,-250,1.5,0)
        }):Play()
    end

    if i.KeyCode == Enum.KeyCode.W then flyDir = Vector3.new(0,0,-1) end
    if i.KeyCode == Enum.KeyCode.S then flyDir = Vector3.new(0,0,1) end
    if i.KeyCode == Enum.KeyCode.A then flyDir = Vector3.new(-1,0,0) end
    if i.KeyCode == Enum.KeyCode.D then flyDir = Vector3.new(1,0,0) end
    if i.KeyCode == Enum.KeyCode.Space then flyDir = Vector3.new(0,1,0) end
end)

UIS.InputEnded:Connect(function()
    flyDir = Vector3.zero
end)

-- ================= LOOP =================
RunService.RenderStepped:Connect(function()
    local char = plr.Character
    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")

    if hum then
        hum.WalkSpeed = state.Speed and 60 or 16
        hum.JumpPower = state.Jump and 120 or 50
    end

    if state.Fly and root then
        root.Velocity = flyDir * 90
    end

    if state.NoClip then
        for _,v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end

    if state.FullBright then
        Lighting.Brightness = 5
        Lighting.FogEnd = 100000
        Lighting.ClockTime = 14
    end
end)

print("🔥 INSANE PANEL LOADED (G)")

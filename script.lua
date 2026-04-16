-- ULTIMATE PANEL V4 (ABSURDO)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local plr = Players.LocalPlayer

-- ================= SAVE SYSTEM =================
local saveFile = "ultimate_config.json"

local state = {
    Speed = false,
    Jump = false,
    Fly = false,
    NoClip = false,
    FullBright = false,
    ESP = false
}

-- carregar config
pcall(function()
    if readfile and isfile and isfile(saveFile) then
        state = HttpService:JSONDecode(readfile(saveFile))
    end
end)

local function save()
    if writefile then
        writefile(saveFile, HttpService:JSONEncode(state))
    end
end

-- ================= UI =================
local sg = Instance.new("ScreenGui", plr.PlayerGui)
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 520, 0, 360)
main.Position = UDim2.new(0.5,-260,0.5,-180)
main.BackgroundColor3 = Color3.fromRGB(15,15,20)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

-- TOP
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1,0,0,40)
top.BackgroundColor3 = Color3.fromRGB(30,0,50)

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1,0,1,0)
title.Text = "💜 ABSURD PANEL"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold

-- TABS
local tabFrame = Instance.new("Frame", main)
tabFrame.Size = UDim2.new(0,130,1,-40)
tabFrame.Position = UDim2.new(0,0,0,40)
tabFrame.BackgroundColor3 = Color3.fromRGB(20,20,30)

local content = Instance.new("Frame", main)
content.Size = UDim2.new(1,-130,1,-40)
content.Position = UDim2.new(0,130,0,40)

local pages = {}

local function createPage(name)
    local frame = Instance.new("Frame", content)
    frame.Size = UDim2.new(1,0,1,0)
    frame.Visible = false

    local layout = Instance.new("UIListLayout", frame)
    layout.Padding = UDim.new(0,8)

    pages[name] = frame

    local btn = Instance.new("TextButton", tabFrame)
    btn.Size = UDim2.new(1,0,0,40)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(40,0,70)
    btn.TextColor3 = Color3.new(1,1,1)

    btn.MouseButton1Click:Connect(function()
        for _,p in pairs(pages) do p.Visible = false end
        frame.Visible = true
    end)

    return frame
end

local playerPage = createPage("Player")
local visualPage = createPage("Visual")

pages["Player"].Visible = true

-- ================= BOTÕES =================
local function toggle(parent,text,key)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1,-10,0,40)
    b.Text = text.." [OFF]"
    b.BackgroundColor3 = Color3.fromRGB(50,50,60)
    b.TextColor3 = Color3.new(1,1,1)

    b.MouseButton1Click:Connect(function()
        state[key] = not state[key]
        b.Text = text.." "..(state[key] and "[ON]" or "[OFF]")
        save()
    end)
end

-- PLAYER
toggle(playerPage,"Speed","Speed")
toggle(playerPage,"Jump","Jump")
toggle(playerPage,"Fly","Fly")
toggle(playerPage,"NoClip","NoClip")

-- VISUAL
toggle(visualPage,"FullBright","FullBright")
toggle(visualPage,"ESP","ESP")

-- ================= ESP =================
local espFolder = Instance.new("Folder", game.CoreGui)

RunService.RenderStepped:Connect(function()
    if state.ESP then
        for _,p in pairs(Players:GetPlayers()) do
            if p ~= plr and p.Character then
                if not espFolder:FindFirstChild(p.Name) then
                    local h = Instance.new("Highlight", espFolder)
                    h.Name = p.Name
                    h.FillColor = Color3.fromRGB(150,0,255)
                    h.OutlineColor = Color3.new(1,1,1)
                    h.Adornee = p.Character
                end
            end
        end
    else
        espFolder:ClearAllChildren()
    end
end)

-- ================= MOVIMENTO =================
local dir = Vector3.zero

UIS.InputBegan:Connect(function(i,g)
    if g then return end

    if i.KeyCode == Enum.KeyCode.W then dir = Vector3.new(0,0,-1) end
    if i.KeyCode == Enum.KeyCode.S then dir = Vector3.new(0,0,1) end
    if i.KeyCode == Enum.KeyCode.A then dir = Vector3.new(-1,0,0) end
    if i.KeyCode == Enum.KeyCode.D then dir = Vector3.new(1,0,0) end
    if i.KeyCode == Enum.KeyCode.Space then dir = Vector3.new(0,1,0) end
end)

UIS.InputEnded:Connect(function()
    dir = Vector3.zero
end)

-- ================= LOOP =================
RunService.RenderStepped:Connect(function()
    local char = plr.Character
    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")

    if hum then
        hum.WalkSpeed = state.Speed and 70 or 16
        hum.JumpPower = state.Jump and 130 or 50
    end

    if state.Fly and root then
        root.Velocity = dir * 100
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

print("💜 ABSURD PANEL LOADED")

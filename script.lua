local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- UI
local sg = Instance.new("ScreenGui")
sg.Parent = LocalPlayer:WaitForChild("PlayerGui")
sg.Name = "DevPanel"
sg.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Parent = sg
frame.Size = UDim2.new(0, 230, 0, 260)
frame.Position = UDim2.new(0, 50, 0.5, -130)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true

local function createBtn(text, pos)
	local b = Instance.new("TextButton")
	b.Parent = frame
	b.Size = UDim2.new(0.9, 0, 0, 35)
	b.Position = pos
	b.Text = text .. ": OFF"
	b.BackgroundColor3 = Color3.fromRGB(120,0,0)
	b.TextColor3 = Color3.new(1,1,1)
	b.Font = Enum.Font.SourceSansBold
	b.TextSize = 14
	return b
end

local highlightBtn = createBtn("HIGHLIGHT", UDim2.new(0.05,0,0.1,0))
local camBtn = createBtn("FOCUS PLAYER", UDim2.new(0.05,0,0.3,0))
local speedBtn = createBtn("SPEED BOOST", UDim2.new(0.05,0,0.5,0))
local infoBtn = createBtn("SHOW INFO", UDim2.new(0.05,0,0.7,0))

local highlightOn = false
local camOn = false
local speedOn = false
local infoOn = false

-- BOTÕES
highlightBtn.MouseButton1Click:Connect(function()
	highlightOn = not highlightOn
	highlightBtn.Text = "HIGHLIGHT: "..(highlightOn and "ON" or "OFF")
	highlightBtn.BackgroundColor3 = highlightOn and Color3.fromRGB(0,120,0) or Color3.fromRGB(120,0,0)
end)

camBtn.MouseButton1Click:Connect(function()
	camOn = not camOn
	camBtn.Text = "FOCUS: "..(camOn and "ON" or "OFF")
	camBtn.BackgroundColor3 = camOn and Color3.fromRGB(0,120,0) or Color3.fromRGB(120,0,0)
end)

speedBtn.MouseButton1Click:Connect(function()
	speedOn = not speedOn
	speedBtn.Text = "SPEED: "..(speedOn and "ON" or "OFF")
	speedBtn.BackgroundColor3 = speedOn and Color3.fromRGB(0,120,0) or Color3.fromRGB(120,0,0)

	local char = LocalPlayer.Character
	if char and char:FindFirstChild("Humanoid") then
		char.Humanoid.WalkSpeed = speedOn and 40 or 16
	end
end)

infoBtn.MouseButton1Click:Connect(function()
	infoOn = not infoOn
	infoBtn.Text = "INFO: "..(infoOn and "ON" or "OFF")
	infoBtn.BackgroundColor3 = infoOn and Color3.fromRGB(0,120,0) or Color3.fromRGB(120,0,0)
end)

-- LOOP
RunService.RenderStepped:Connect(function()

	-- Highlight (debug players)
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character then
			local h = p.Character:FindFirstChild("Highlight")

			if highlightOn then
				if not h then
					local hl = Instance.new("Highlight")
					hl.FillColor = Color3.fromRGB(255,0,0)
					hl.Parent = p.Character
				end
			else
				if h then h:Destroy() end
			end
		end
	end

	-- Camera focus (modo espectador simples)
	if camOn then
		local closest = nil
		local dist = math.huge

		for _, p in pairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
				local d = (p.Character.Head.Position - Camera.CFrame.Position).Magnitude
				if d < dist then
					dist = d
					closest = p.Character.Head
				end
			end
		end

		if closest then
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, closest.Position)
		end
	end

	-- Info (debug simples)
	if infoOn then
		print("FPS:", math.floor(1/RunService.RenderStepped:Wait()))
	end

end)

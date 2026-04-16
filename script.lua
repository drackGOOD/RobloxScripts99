local Players = game:GetService("Players")
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "DevPanel"
gui.Parent = player:WaitForChild("PlayerGui")

-- BOTÃO
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 180, 0, 50)
button.Position = UDim2.new(0, 20, 0, 100)
button.Text = "ESP NPC: OFF"
button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
button.TextColor3 = Color3.new(1,1,1)
button.Parent = gui

local enabled = false
local highlights = {}

local function clearESP()
	for _, h in pairs(highlights) do
		if h then h:Destroy() end
	end
	highlights = {}
end

local function createESP()
	clearESP()

	local folder = workspace:FindFirstChild("NPCs")
	if not folder then return end

	for _, npc in pairs(folder:GetChildren()) do
		if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") then

			local hl = Instance.new("Highlight")
			hl.FillColor = Color3.fromRGB(255, 0, 0)
			hl.OutlineColor = Color3.fromRGB(255, 255, 255)
			hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
			hl.Adornee = npc
			hl.Parent = npc

			table.insert(highlights, hl)
		end
	end
end

button.MouseButton1Click:Connect(function()
	enabled = not enabled

	if enabled then
		button.Text = "ESP NPC: ON"
		createESP()
	else
		button.Text = "ESP NPC: OFF"
		clearESP()
	end
end)

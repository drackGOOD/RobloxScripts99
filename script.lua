local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local frame = script.Parent
local btnESP = frame:WaitForChild("ToggleESP")
local btnRadar = frame:WaitForChild("ToggleRadar")
local btnInfo = frame:WaitForChild("ToggleInfo")
local radarFrame = frame:WaitForChild("RadarFrame")

local espAtivo = false
local radarAtivo = false
local infoAtivo = false

local highlights = {}
local billboards = {}

--------------------------------------------------
-- 👁️ ESP
--------------------------------------------------
local function criarESP(player)
	if player == LocalPlayer then return end
	
	player.CharacterAdded:Connect(function(char)
		task.wait(1)
		
		if espAtivo and char then
			local h = Instance.new("Highlight")
			h.Name = "ESP"
			h.FillColor = Color3.fromRGB(255,0,0)
			h.Parent = char
			
			highlights[player] = h
		end
	end)
end

for _, p in pairs(Players:GetPlayers()) do
	criarESP(p)
end

Players.PlayerAdded:Connect(criarESP)

local function ativarESP()
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character then
			if not p.Character:FindFirstChild("ESP") then
				local h = Instance.new("Highlight")
				h.Name = "ESP"
				h.FillColor = Color3.fromRGB(255,0,0)
				h.Parent = p.Character
				
				highlights[p] = h
			end
		end
	end
end

local function desativarESP()
	for _, h in pairs(highlights) do
		if h then h:Destroy() end
	end
	highlights = {}
end

--------------------------------------------------
-- 📛 INFO
--------------------------------------------------
local function criarInfo(player)
	if player == LocalPlayer then return end
	
	player.CharacterAdded:Connect(function(char)
		task.wait(1)
		
		if infoAtivo and char and char:FindFirstChild("Head") then
			local bill = Instance.new("BillboardGui")
			bill.Size = UDim2.new(0,100,0,40)
			bill.AlwaysOnTop = true
			bill.Parent = char.Head

			local text = Instance.new("TextLabel")
			text.Size = UDim2.new(1,0,1,0)
			text.BackgroundTransparency = 1
			text.TextColor3 = Color3.new(1,1,1)
			text.TextScaled = true
			text.Parent = bill

			RunService.RenderStepped:Connect(function()
				if char and char:FindFirstChild("Humanoid") then
					text.Text = player.Name.." | "..math.floor(char.Humanoid.Health)
				end
			end)

			billboards[player] = bill
		end
	end)
end

for _, p in pairs(Players:GetPlayers()) do
	criarInfo(p)
end

Players.PlayerAdded:Connect(criarInfo)

local function ativarInfo()
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character then
			criarInfo(p)
		end
	end
end

local function desativarInfo()
	for _, b in pairs(billboards) do
		if b then b:Destroy() end
	end
	billboards = {}
end

--------------------------------------------------
-- 🗺️ RADAR
--------------------------------------------------
radarFrame.Visible = false

RunService.RenderStepped:Connect(function()
	if not radarAtivo then return end
	
	radarFrame:ClearAllChildren()
	
	if not LocalPlayer.Character then return end
	local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not root then return end
	
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			
			local dot = Instance.new("Frame")
			dot.Size = UDim2.new(0,5,0,5)
			dot.BackgroundColor3 = Color3.fromRGB(255,0,0)
			dot.BorderSizePixel = 0
			dot.Parent = radarFrame

			local offset = (p.Character.HumanoidRootPart.Position - root.Position) / 10

			dot.Position = UDim2.new(0.5, offset.X, 0.5, offset.Z)
		end
	end
end)

--------------------------------------------------
-- 🔘 BOTÕES
--------------------------------------------------
btnESP.MouseButton1Click:Connect(function()
	espAtivo = not espAtivo
	btnESP.Text = "ESP: "..(espAtivo and "ON" or "OFF")
	
	if espAtivo then ativarESP() else desativarESP() end
end)

btnRadar.MouseButton1Click:Connect(function()
	radarAtivo = not radarAtivo
	btnRadar.Text = "RADAR: "..(radarAtivo and "ON" or "OFF")
	radarFrame.Visible = radarAtivo
end)

btnInfo.MouseButton1Click:Connect(function()
	infoAtivo = not infoAtivo
	btnInfo.Text = "INFO: "..(infoAtivo and "ON" or "OFF")
	
	if infoAtivo then ativarInfo() else desativarInfo() end
end)

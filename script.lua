local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- // CONFIGURAÇÕES
local MAX_DISTANCIA = 200 -- Distância máxima para ver o ESP
local FADE_DISTANCIA = 50 -- Começa a sumir após essa distância
local CHECAR_VISAO = true -- Só mostra se não houver paredes entre você e o alvo

local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- // FUNÇÃO DE VISIBILIDADE (Raycast)
local function estaVisivel(character)
	if not CHECAR_VISAO then return true end
	local origin = camera.CFrame.Position
	local targetPos = character.HumanoidRootPart.Position
	local direction = targetPos - origin
	
	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = {localPlayer.Character, character}
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	
	local result = workspace:Raycast(origin, direction, raycastParams)
	return result == nil -- Se for nil, não bateu em nenhuma parede
end

-- // FUNÇÃO PARA CRIAR O ESP
local function criarESP(player)
	if player == localPlayer then return end

	local function setup(char)
		local root = char:WaitForChild("HumanoidRootPart", 5)
		local hum = char:WaitForChild("Humanoid", 5)
		if not root or not hum then return end

		-- Criar Container de Texto (Nome, Vida, Distância)
		local bgui = Instance.new("BillboardGui")
		bgui.Name = "ESP_UI"
		bgui.Size = UDim2.new(4, 0, 1.5, 0)
		bgui.StudsOffset = Vector3.new(0, 3, 0)
		bgui.AlwaysOnTop = true
		bgui.Parent = root

		local infoLabel = Instance.new("TextLabel")
		infoLabel.Size = UDim2.new(1, 0, 1, 0)
		infoLabel.BackgroundTransparency = 1
		infoLabel.TextColor3 = player.TeamColor.Color -- Cor por Time
		infoLabel.TextStrokeTransparency = 0
		infoLabel.TextScaled = true
		infoLabel.Parent = bgui

		-- Criar Box (Bounding Box usando Highlight)
		local box = Instance.new("Highlight")
		box.Name = "ESP_Box"
		box.FillTransparency = 0.8
		box.OutlineTransparency = 0
		box.FillColor = player.TeamColor.Color
		box.OutlineColor = Color3.new(1, 1, 1)
		box.Parent = char

		-- Loop de Atualização
		local connection
		connection = RunService.RenderStepped:Connect(function()
			if not char.Parent or not root.Parent then 
				connection:Disconnect() 
				return 
			end

			local dist = (camera.CFrame.Position - root.Position).Magnitude
			
			-- Lógica de Distância e Visibilidade
			if dist < MAX_DISTANCIA and estaVisivel(char) then
				bgui.Enabled = true
				box.Enabled = true
				
				-- Fade (Transparência baseada na distância)
				local alpha = math.clamp((dist - FADE_DISTANCIA) / (MAX_DISTANCIA - FADE_DISTANCIA), 0, 1)
				infoLabel.TextTransparency = alpha
				box.OutlineTransparency = alpha
				box.FillTransparency = 0.8 + (alpha * 0.2)

				-- Atualizar Texto
				infoLabel.Text = string.format("%s\nHP: %d | Dist: %dm", player.Name, math.floor(hum.Health), math.floor(dist))
			else
				bgui.Enabled = false
				box.Enabled = false
			end
		end)
	end

	player.CharacterAdded:Connect(setup)
	if player.Character then setup(player.Character) end
end

-- // INICIALIZAÇÃO
Players.PlayerAdded:Connect(criarESP)
for _, p in ipairs(Players:GetPlayers()) do criarESP(p) end

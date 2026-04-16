-- // SERVIÇOS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- // CONFIGURAÇÕES (Ajuste para testar)
local CONFIG = {
	MAX_DISTANCIA = 300,
	FADE_DISTANCIA = 100,
	SUAVE_MIRA = 0.1, -- 0.1 (lento/humano) até 1 (instantâneo)
	TECLA_MIRA = Enum.KeyCode.E,
	CHECAR_VISAO = true,
	COR_INIMIGO = Color3.fromRGB(255, 0, 0),
	COR_ALIADO = Color3.fromRGB(0, 255, 0)
}

local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera
local travaAtiva = false

-- // 1. FUNÇÃO DE VISIBILIDADE (RAYCAST)
local function estaVisivel(alvo)
	if not CONFIG.CHECAR_VISAO then return true end
	local params = RaycastParams.new()
	params.FilterDescendantsInstances = {localPlayer.Character, alvo}
	params.FilterType = Enum.RaycastFilterType.Exclude
	
	local direcao = alvo.HumanoidRootPart.Position - camera.CFrame.Position
	local resultado = workspace:Raycast(camera.CFrame.Position, direcao, params)
	return resultado == nil
end

-- // 2. FUNÇÃO VISUAL (ESP + BOX)
local function criarESP(player)
	if player == localPlayer then return end

	local function setup(char)
		local root = char:WaitForChild("HumanoidRootPart", 10)
		local hum = char:WaitForChild("Humanoid", 10)
		
		-- Container de Texto
		local bgui = Instance.new("BillboardGui", root)
		bgui.Name = "EduESP"
		bgui.Size = UDim2.new(4, 0, 2, 0)
		bgui.AlwaysOnTop = true
		bgui.StudsOffset = Vector3.new(0, 3, 0)

		local info = Instance.new("TextLabel", bgui)
		info.Size = UDim2.new(1, 0, 1, 0)
		info.BackgroundTransparency = 1
		info.TextColor3 = (player.Team == localPlayer.Team) and CONFIG.COR_ALIADO or CONFIG.COR_INIMIGO
		info.TextStrokeTransparency = 0
		info.TextScaled = true

		-- Box Visual (Highlight)
		local highlight = Instance.new("Highlight", char)
		highlight.FillTransparency = 0.7
		highlight.FillColor = info.TextColor3
		highlight.OutlineColor = Color3.new(1, 1, 1)

		-- Update do ESP
		local conn
		conn = RunService.RenderStepped:Connect(function()
			if not char.Parent then conn:Disconnect() return end
			
			local dist = (camera.CFrame.Position - root.Position).Magnitude
			local visivel = estaVisivel(char)

			if dist < CONFIG.MAX_DISTANCIA and visivel then
				bgui.Enabled = true
				highlight.Enabled = true
				
				-- Fade de distância
				local alpha = math.clamp((dist - CONFIG.FADE_DISTANCIA) / (CONFIG.MAX_DISTANCIA - CONFIG.FADE_DISTANCIA), 0, 1)
				info.TextTransparency = alpha
				highlight.OutlineTransparency = alpha
				
				info.Text = string.format("%s\n%d HP | %dm", player.Name, math.floor(hum.Health), math.floor(dist))
			else
				bgui.Enabled = false
				highlight.Enabled = false
			end
		end)
	end

	player.CharacterAdded:Connect(setup)
	if player.Character then setup(player.Character) end
end

-- // 3. LÓGICA DE BUSCA DE ALVO (FOV/MOUSE)
local function obterAlvoProximo()
	local alvoFinal = nil
	local menorDistanciaMouse = math.huge

	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= localPlayer and p.Team ~= localPlayer.Team and p.Character then
			local char = p.Character
			local root = char:FindFirstChild("HumanoidRootPart")
			if root and char.Humanoid.Health > 0 and estaVisivel(char) then
				local posTela, visivelTela = camera:WorldToViewportPoint(root.Position)
				if visivelTela then
					local mouse = UserInputService:GetMouseLocation()
					local distMouse = (Vector2.new(posTela.X, posTela.Y) - mouse).Magnitude
					if distMouse < menorDistanciaMouse then
						menorDistanciaMouse = distMouse
						alvoFinal = char
					end
				end
			end
		end
	end
	return alvoFinal
end

-- // 4. LOOP PRINCIPAL E INPUT
RunService.RenderStepped:Connect(function()
	if travaAtiva then
		local alvo = obterAlvoProximo()
		if alvo then
			local novaCFrame = CFrame.lookAt(camera.CFrame.Position, alvo.HumanoidRootPart.Position)
			camera.CFrame = camera.CFrame:Lerp(novaCFrame, CONFIG.SUAVE_MIRA)
		end
	end
end)

UserInputService.InputBegan:Connect(function(i, p)
	if not p and i.KeyCode == CONFIG.TECLA_MIRA then
		travaAtiva = not travaAtiva
		print("Estado da Mira:", travaAtiva)
	end
end)

-- Iniciar para todos
Players.PlayerAdded:Connect(criarESP)
for _, p in ipairs(Players:GetPlayers()) do criarESP(p) end

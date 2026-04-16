--[[
    SISTEMA INTEGRADO DE COMBATE - SENTINELA PRO v2.0
    Otimizado PROFISSIONALMENTE para "Noite na Floresta" (99 Noites / 10.000+ pontos)
    
    ✅ AUTO-TUDO: Mira suave + Headshot opcional
    ✅ AUTO-MOVE: Personagem anda sozinho até os inimigos (com Pathfinding básico)
    ✅ AUTO-ATTACK: Equipa arma + ataca automaticamente (sem mouse1click)
    ✅ AUTO-EQUIP: Pega qualquer Tool do Backpack
    ✅ ESP Simples + Highlight nos inimigos
    ✅ GUI Moderna, arrastável e limpa
    ✅ Performance extrema (detecção a cada 0.15s, não lagga em noite 99)
    ✅ Ignora jogadores (só mata monstros/NPCs)
    ✅ Totalmente AFK: Você abre o Roblox, executa e vai dormir. A IA joga sozinha até passar a noite 99 com 10k+ fácil.
    
    Como usar:
    1. Cole tudo no executor (Synapse, Krnl, Fluxus, etc)
    2. Execute
    3. Deixe o jogo rodando (não mexa em nada)
    4. Vai dormir ou fazer outra coisa 😂
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local PathfindingService = game:GetService("PathfindingService")
local UserInputService = game:GetService("UserInputService")

local plr = Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = plr:GetMouse()

-- ==================== CONFIGURAÇÕES (AJUSTE AQUI SE QUISER) ====================
local SETTINGS = {
    RANGE = 150,              -- Distância máxima de detecção (aumentei pra floresta grande)
    ATTACK_RANGE = 20,        -- Distância pra começar a atacar
    MOVE_RANGE = 25,          -- Distância pra começar a andar (um pouco maior que attack)
    SMOOTHNESS = 0.25,        -- Suavidade da mira (0.1 = instantâneo, 0.4 = bem suave)
    AUTO_AIM = true,
    AUTO_MOVE = true,         -- IA anda sozinha
    AUTO_ATTACK = true,       -- IA ataca sozinha
    HEADSHOT = true,          -- Mira na cabeça (mais dano)
    UPDATE_RATE = 0.15,       -- Detecção a cada 0.15s (muito mais otimizado)
    ESP_ENABLED = true,
}

-- ==================== GUI PROFISSIONAL ====================
local gui = Instance.new("ScreenGui")
gui.Name = "SentinelaPro"
gui.ResetOnSpawn = false
gui.Parent = plr:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 240, 0, 140)
mainFrame.Position = UDim2.new(0.5, -120, 0, 30)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
title.Text = "🚀 SENTINELA PRO v2.0 - NOITE 99 AFK"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = title

-- Status
local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, -20, 0, 25)
info.Position = UDim2.new(0, 10, 0, 40)
info.BackgroundTransparency = 1
info.Text = "🔎 BUSCANDO ALVOS..."
info.TextColor3 = Color3.new(1,1,1)
info.Font = Enum.Font.GothamBold
info.TextSize = 14
info.TextXAlignment = Enum.TextXAlignment.Left
info.Parent = mainFrame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 25)
status.Position = UDim2.new(0, 10, 0, 70)
status.BackgroundTransparency = 1
status.Text = "✅ SISTEMA 100% ATIVO - AFK TOTAL"
status.TextColor3 = Color3.fromRGB(0, 255, 100)
status.Font = Enum.Font.Gotham
status.TextSize = 13
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = mainFrame

local killsLabel = Instance.new("TextLabel") -- Contador de kills aproximado
killsLabel.Size = UDim2.new(1, -20, 0, 25)
killsLabel.Position = UDim2.new(0, 10, 0, 100)
killsLabel.BackgroundTransparency = 1
killsLabel.Text = "Kills: 0 | Noite atual: ??"
killsLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
killsLabel.Font = Enum.Font.Gotham
killsLabel.TextSize = 13
killsLabel.TextXAlignment = Enum.TextXAlignment.Left
killsLabel.Parent = mainFrame

-- Draggable GUI
local dragging, dragInput, dragStart, startPos
title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)
title.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ==================== VARIÁVEIS GLOBAIS ====================
local currentTarget = nil
local lastUpdate = 0
local killCount = 0
local lastTargetHealth = 0
local highlights = {}

-- ==================== FUNÇÃO DE DETECÇÃO OTIMIZADA ====================
local function getClosestEnemy()
    local closest = nil
    local shortestDist = SETTINGS.RANGE
    local char = plr.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end

    for _, v in ipairs(workspace:GetChildren()) do
        if v:IsA("Model") and v ~= char then
            local hum = v:FindFirstChild("Humanoid")
            local root = v:FindFirstChild("HumanoidRootPart")
            
            -- IGNORA JOGADORES (só mata monstros da floresta)
            if hum and root and hum.Health > 0 and not Players:GetPlayerFromCharacter(v) then
                local dist = (char.HumanoidRootPart.Position - root.Position).Magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    closest = v
                end
            end
        end
    end
    return closest, shortestDist
end

-- ==================== ESP + HIGHLIGHT ====================
local function updateESP(target)
    if not SETTINGS.ESP_ENABLED then return end
    
    if target and target:FindFirstChild("HumanoidRootPart") then
        if not highlights[target] then
            local highlight = Instance.new("Highlight")
            highlight.Adornee = target
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
            highlight.FillTransparency = 0.7
            highlight.OutlineTransparency = 0
            highlight.Parent = target
            highlights[target] = highlight
        end
    end
    
    -- Limpa highlights de inimigos mortos
    for model, hl in pairs(highlights) do
        if not model or not model:FindFirstChild("Humanoid") or model.Humanoid.Health <= 0 then
            hl:Destroy()
            highlights[model] = nil
        end
    end
end

-- ==================== EQUIPAR ARMA AUTOMÁTICO ====================
local function equipBestWeapon()
    local char = plr.Character
    if not char then return end
    
    local currentTool = char:FindFirstChildOfClass("Tool")
    if currentTool then return end -- já está com arma
    
    local backpack = plr:FindFirstChild("Backpack")
    if not backpack then return end
    
    -- Pega a primeira Tool disponível (funciona na maioria dos jogos de floresta)
    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            tool.Parent = char
            break
        end
    end
end

-- ==================== AUTO ATTACK ====================
local function handleAttack(target, dist)
    if not SETTINGS.AUTO_ATTACK or not target then return end
    if dist >= SETTINGS.ATTACK_RANGE then return end
    
    equipBestWeapon()
    
    local char = plr.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    
    if tool then
        tool:Activate() -- Ativa a arma (funciona em 99% dos jogos)
    end
end

-- ==================== AUTO MOVE COM PATHFINDING ====================
local function handleMovement(target, dist)
    if not SETTINGS.AUTO_MOVE or not target then return end
    if dist <= SETTINGS.MOVE_RANGE then return end
    
    local char = plr.Character
    local humanoid = char and char:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    -- Pathfinding simples pra não ficar preso nas árvores
    local path = PathfindingService:CreatePath({
        Cost = 0,
        AgentRadius = 2,
        AgentHeight = 5,
        AgentCanJump = true,
        WaypointSpacing = 4,
    })
    
    path:ComputeAsync(char.HumanoidRootPart.Position, target.HumanoidRootPart.Position)
    
    if path.Status == Enum.PathStatus.Success then
        local waypoints = path:GetWaypoints()
        for _, waypoint in ipairs(waypoints) do
            humanoid:MoveTo(waypoint.Position)
            if (char.HumanoidRootPart.Position - waypoint.Position).Magnitude < 8 then
                break
            end
        end
    else
        -- Fallback simples se pathfinding falhar
        humanoid:MoveTo(target.HumanoidRootPart.Position)
    end
end

-- ==================== AIMBOT SUAVE ====================
local function handleAimbot(target)
    if not SETTINGS.AUTO_AIM or not target then return end
    
    local char = plr.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local targetPart = SETTINGS.HEADSHOT and target:FindFirstChild("Head") or target:FindFirstChild("HumanoidRootPart")
    if not targetPart then targetPart = target:FindFirstChild("HumanoidRootPart") end
    
    local targetPos = targetPart.Position
    
    local lookAt = CFrame.new(camera.CFrame.Position, targetPos)
    camera.CFrame = camera.CFrame:Lerp(lookAt, SETTINGS.SMOOTHNESS)
end

-- ==================== LOOP PRINCIPAL (SUPER OTIMIZADO) ====================
RunService.Heartbeat:Connect(function()
    local now = tick()
    
    -- Detecção de alvo (só a cada UPDATE_RATE pra não lagar)
    if now - lastUpdate >= SETTINGS.UPDATE_RATE then
        lastUpdate = now
        currentTarget, _ = getClosestEnemy()
    end
    
    local char = plr.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then
        info.Text = "⏳ ESPERANDO PERSONAGEM..."
        return
    end
    
    if currentTarget and currentTarget:FindFirstChild("HumanoidRootPart") then
        local root = currentTarget.HumanoidRootPart
        local dist = (char.HumanoidRootPart.Position - root.Position).Magnitude
        
        -- Atualiza GUI
        info.Text = "🎯 ALVO: " .. (currentTarget.Name:sub(1,12)) .. " (" .. math.floor(dist) .. "m)"
        status.TextColor3 = (dist < SETTINGS.ATTACK_RANGE) and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(0, 255, 100)
        status.Text = dist < SETTINGS.ATTACK_RANGE and "⚔️ ATACANDO AGORA!" or "🚶 MOVENDO PARA ALVO"
        
        -- Contador de kills (aproximado)
        if currentTarget.Humanoid.Health <= 0 and lastTargetHealth > 0 then
            killCount = killCount + 1
            killsLabel.Text = "Kills: " .. killCount .. " | Noite 99 AFK MODE"
        end
        lastTargetHealth = currentTarget.Humanoid.Health
        
        updateESP(currentTarget)
        handleAimbot(currentTarget)
        handleMovement(currentTarget, dist)
        handleAttack(currentTarget, dist)
        
    else
        info.Text = "🔄 BUSCANDO NOVOS ALVOS NA FLORESTA..."
        status.Text = "🟢 AGUARDANDO ONDA..."
        status.TextColor3 = Color3.fromRGB(0, 255, 100)
        currentTarget = nil
    end
end)

-- ==================== MENSAGEM FINAL ====================
print("✅ SENTINELA PRO v2.0 CARREGADO COM SUCESSO!")
print("   Modo AFK TOTAL ativado - Vá dormir e acorde com 10.000+ na noite 99!")
print("   Pressione F9 pra ver os logs se precisar.")

-- Anti-idle (mantém o jogo ativo)
spawn(function()
    while wait(30) do
        if plr.Character and plr.Character:FindFirstChild("Humanoid") then
            plr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

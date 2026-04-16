--[[
    EDUCATIONAL ESP LOADER (GITHUB VERSION)
    Este script busca a lógica de renderização externamente.
    Certifique-se de que "Allow HTTP Requests" esteja ATIVADO nas configurações do Game Studio.
]]

local HttpService = game:GetService("HttpService")

-- URL do script bruto (raw) no GitHub
-- Usaremos uma biblioteca famosa e segura (Exunys) como exemplo educativo
local githubUrl = "https://raw.githubusercontent.com/Exunys/ESP-Library/main/Library.lua"

local function LoadExternalScript()
    print("Conectando ao GitHub para carregar ESP...")
    
    -- Tenta baixar o código do GitHub
    local sucesso, resultado = pcall(function()
        return game:HttpGet(githubUrl)
    end)

    if sucesso then
        -- O loadstring transforma o texto do GitHub em uma função executável
        local carregarScript = loadstring(resultado)
        
        -- Executa a biblioteca e configura as opções
        local ESP = carregarScript()
        
        -- Configurações de visualização (Fins educativos)
        ESP.Config.Players = true
        ESP.Config.Boxes = true
        ESP.Config.Names = true
        ESP.Config.Tracers = true
        ESP.Config.TeamCheck = false -- Altere para true se quiser ignorar aliados
        ESP.Config.Color = Color3.fromRGB(255, 0, 0) -- Cor vermelha
        
        print("ESP Ativado com sucesso via GitHub!")
    else
        warn("Falha ao carregar o script do GitHub. Verifique sua conexão ou a URL.")
        warn("Erro: " .. tostring(resultado))
    end
end

-- Inicia o processo
LoadExternalScript()

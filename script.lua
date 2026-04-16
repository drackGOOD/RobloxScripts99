-- Carrega o Script de ESP diretamente do repositório oficial no GitHub
loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/ESP-Library/main/Library.lua"))()

-- Configurações básicas (você pode alterar os valores abaixo)
_G.Config = {
    Players = true,
    Boxes = true,
    Names = true,
    Tracers = true, -- Linhas que ligam você ao jogador
    Distance = true,
    Health = true,
    TeamCheck = true, -- Não mostra aliados (se houver times)
    Color = Color3.fromRGB(0, 255, 120)
}

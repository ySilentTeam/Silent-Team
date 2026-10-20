-- ============================================================
-- PAINEL DE TESTE – AIMBOT / CÍRCULO DE DETECÇÃO
-- LocalScript para Roblox (Luau)
-- Coloque em StarterPlayerScripts ou StarterGui
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- ============================================================
-- CONFIGURAÇÃO INICIAL
-- ============================================================
local CONFIG = {
    RaioInicial = 150,
    RaioMin = 30,
    RaioMax = 400,
    SuavizacaoCamera = 0.15,   -- 0 = instantâneo, 1 = lento
    CorPrimaria = Color3.fromRGB(80, 120, 255),
    CorSecundaria = Color3.fromRGB(150, 80, 255),
    CorFundo = Color3.fromRGB(22, 22, 30),
    CorFundoBarra = Color3.fromRGB(32, 32, 44),
    CorTexto = Color3.fromRGB(240, 240, 255),
    CorTextoFraco = Color3.fromRGB(160, 160, 180),
}

local estado = {
    AimbotAtivo = false,
    RaioAtual = CONFIG.RaioInicial,
    AlvoAtual = nil,
    CameraOriginal = nil,
    CameraSalva = false,
}

-- ============================================================
-- CRIAÇÃO DA INTERFACE (UI)
-- ============================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PainelSilentAimbot"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")

-- Janela principal
local janela = Instance.new("Frame")
janela.Name = "JanelaPrincipal"
janela.Size = UDim2.new(0, 340, 0, 280)
janela.Position = UDim2.new(0.5, -170, 0.5, -140)
janela.BackgroundColor3 = CONFIG.CorFundo
janela.BackgroundTransparency = 0.05
janela.BorderSizePixel = 0
janela.Active = true
janela.Draggable = true
janela.Parent = screenGui

local cantoJanela = Instance.new("UICorner")
cantoJanela.CornerRadius = UDim.new(0, 12)
cantoJanela.Parent = janela

local strokeJanela = Instance.new("UIStroke")
strokeJanela.Color = CONFIG.CorPrimaria
strokeJanela.Thickness = 1.5
strokeJanela.Transparency = 0.4
strokeJanela.Parent = janela

-- Barra de título
local barraTitulo = Instance.new("Frame")
barraTitulo.Name = "BarraTitulo"
barraTitulo.Size = UDim2.new(1, 0, 0, 42)
barraTitulo.BackgroundColor3 = CONFIG.CorFundoBarra
barraTitulo.BackgroundTransparency = 0.2
barraTitulo.BorderSizePixel = 0
barraTitulo.Parent = janela

local cantoBarra = Instance.new("UICorner")
cantoBarra.CornerRadius = UDim.new(0, 12)
cantoBarra.Parent = barraTitulo

-- Cobrir cantos inferiores da barra para ficar reta
local coberturaBarra = Instance.new("Frame")
coberturaBarra.Size = UDim2.new(1, 0, 0, 16)
coberturaBarra.Position = UDim2.new(0, 0, 1, -16)
coberturaBarra.BackgroundColor3 = CONFIG.CorFundoBarra
coberturaBarra.BackgroundTransparency = 0.2
coberturaBarra.BorderSizePixel = 0
coberturaBarra.Parent = barraTitulo

-- Título
local titulo = Instance.new("TextLabel")
titulo.Size = UDim2.new(1, -80, 1, 0)
titulo.Position = UDim2.new(0, 16, 0, 0)
titulo.BackgroundTransparency = 1
titulo.Text = "Silent Team"
titulo.TextColor3 = CONFIG.CorTexto
titulo.TextSize = 16
titulo.Font = Enum.Font.GothamBold
titulo.TextXAlignment = Enum.TextXAlignment.Left
titulo.Parent = barraTitulo

-- Botão minimizar
local btnMinimizar = Instance.new("TextButton")
btnMinimizar.Size = UDim2.new(0, 30, 0, 30)
btnMinimizar.Position = UDim2.new(1, -70, 0.5, -15)
btnMinimizar.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
btnMinimizar.BackgroundTransparency = 0.3
btnMinimizar.BorderSizePixel = 0
btnMinimizar.Text = "−"
btnMinimizar.TextColor3 = CONFIG.CorTexto
btnMinimizar.TextSize = 18
btnMinimizar.Font = Enum.Font.GothamBold
btnMinimizar.Parent = barraTitulo

local cantoMin = Instance.new("UICorner")
cantoMin.CornerRadius = UDim.new(0, 8)
cantoMin.Parent = btnMinimizar

-- Botão fechar
local btnFechar = Instance.new("TextButton")
btnFechar.Size = UDim2.new(0, 30, 0, 30)
btnFechar.Position = UDim2.new(1, -36, 0.5, -15)
btnFechar.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
btnFechar.BackgroundTransparency = 0.2
btnFechar.BorderSizePixel = 0
btnFechar.Text = "×"
btnFechar.TextColor3 = Color3.fromRGB(255, 220, 220)
btnFechar.TextSize = 18
btnFechar.Font = Enum.Font.GothamBold
btnFechar.Parent = barraTitulo

local cantoFechar = Instance.new("UICorner")
cantoFechar.CornerRadius = UDim.new(0, 8)
cantoFechar.Parent = btnFechar

-- Container do conteúdo (para minimizar/restaurar)
local conteudo = Instance.new("Frame")
conteudo.Name = "Conteudo"
conteudo.Size = UDim2.new(1, -24, 1, -58)
conteudo.Position = UDim2.new(0, 12, 0, 50)
conteudo.BackgroundTransparency = 1
conteudo.Parent = janela

-- ============================================================
-- BOTÃO AIMBOT
-- ============================================================
local btnAimbot = Instance.new("TextButton")
btnAimbot.Name = "BtnAimbot"
btnAimbot.Size = UDim2.new(1, 0, 0, 44)
btnAimbot.Position = UDim2.new(0, 0, 0, 0)
btnAimbot.BackgroundColor3 = CONFIG.CorPrimaria
btnAimbot.BackgroundTransparency = 0.1
btnAimbot.BorderSizePixel = 0
btnAimbot.Text = "AIMBOT: DESATIVADO"
btnAimbot.TextColor3 = CONFIG.CorTexto
btnAimbot.TextSize = 15
btnAimbot.Font = Enum.Font.GothamBold
btnAimbot.Parent = conteudo

local cantoAimbot = Instance.new("UICorner")
cantoAimbot.CornerRadius = UDim.new(0, 8)
cantoAimbot.Parent = btnAimbot

local strokeAimbot = Instance.new("UIStroke")
strokeAimbot.Color = CONFIG.CorSecundaria
strokeAimbot.Thickness = 2
strokeAimbot.Transparency = 0.3
strokeAimbot.Parent = btnAimbot

-- ============================================================
-- TEXTOBOX DE CONFIGURAÇÃO DO RAIO
-- ============================================================
local labelRaio = Instance.new("TextLabel")
labelRaio.Size = UDim2.new(1, 0, 0, 20)
labelRaio.Position = UDim2.new(0, 0, 0, 62)
labelRaio.BackgroundTransparency = 1
labelRaio.Text = "RAIO DO CÍRCULO (pixels)"
labelRaio.TextColor3 = CONFIG.CorTextoFraco
labelRaio.TextSize = 12
labelRaio.Font = Enum.Font.Gotham
labelRaio.TextXAlignment = Enum.TextXAlignment.Left
labelRaio.Parent = conteudo

local textBoxRaio = Instance.new("TextBox")
textBoxRaio.Name = "TextBoxRaio"
textBoxRaio.Size = UDim2.new(1, -70, 0, 36)
textBoxRaio.Position = UDim2.new(0, 0, 0, 84)
textBoxRaio.BackgroundColor3 = CONFIG.CorFundoBarra
textBoxRaio.BackgroundTransparency = 0.2
textBoxRaio.BorderSizePixel = 0
textBoxRaio.Text = tostring(CONFIG.RaioInicial)
textBoxRaio.TextColor3 = CONFIG.CorTexto
textBoxRaio.TextSize = 16
textBoxRaio.Font = Enum.Font.GothamMedium
textBoxRaio.PlaceholderText = "Ex: 150"
textBoxRaio.PlaceholderColor3 = CONFIG.CorTextoFraco
textBoxRaio.Parent = conteudo

local cantoTextBox = Instance.new("UICorner")
cantoTextBox.CornerRadius = UDim.new(0, 8)
cantoTextBox.Parent = textBoxRaio

local strokeTextBox = Instance.new("UIStroke")
strokeTextBox.Color = CONFIG.CorSecundaria
strokeTextBox.Thickness = 1
strokeTextBox.Transparency = 0.5
strokeTextBox.Parent = textBoxRaio

-- Botão aplicar raio
local btnAplicarRaio = Instance.new("TextButton")
btnAplicarRaio.Size = UDim2.new(0, 60, 0, 36)
btnAplicarRaio.Position = UDim2.new(1, -60, 0, 84)
btnAplicarRaio.BackgroundColor3 = CONFIG.CorSecundaria
btnAplicarRaio.BackgroundTransparency = 0.2
btnAplicarRaio.BorderSizePixel = 0
btnAplicarRaio.Text = "OK"
btnAplicarRaio.TextColor3 = CONFIG.CorTexto
btnAplicarRaio.TextSize = 14
btnAplicarRaio.Font = Enum.Font.GothamBold
btnAplicarRaio.Parent = conteudo

local cantoBtnRaio = Instance.new("UICorner")
cantoBtnRaio.CornerRadius = UDim.new(0, 8)
cantoBtnRaio.Parent = btnAplicarRaio

-- Label de status do raio
local labelStatus = Instance.new("TextLabel")
labelStatus.Size = UDim2.new(1, 0, 0, 22)
labelStatus.Position = UDim2.new(0, 0, 0, 128)
labelStatus.BackgroundTransparency = 1
labelStatus.Text = "Raio atual: " .. tostring(CONFIG.RaioInicial) .. " px"
labelStatus.TextColor3 = CONFIG.CorPrimaria
labelStatus.TextSize = 13
labelStatus.Font = Enum.Font.GothamMedium
labelStatus.TextXAlignment = Enum.TextXAlignment.Left
labelStatus.Parent = conteudo

-- Dica
local dica = Instance.new("TextLabel")
dica.Size = UDim2.new(1, 0, 0, 18)
dica.Position = UDim2.new(0, 0, 0, 156)
dica.BackgroundTransparency = 1
dica.Text = "O círculo aparece no centro da tela quando ativo."
dica.TextColor3 = CONFIG.CorTextoFraco
dica.TextSize = 11
dica.Font = Enum.Font.Gotham
dica.TextXAlignment = Enum.TextXAlignment.Left
dica.TextWrapped = true
dica.Parent = conteudo

-- ============================================================
-- CÍRCULO CENTRAL (FOV)
-- ============================================================
local circulo = Instance.new("Frame")
circulo.Name = "CirculoFOV"
circulo.AnchorPoint = Vector2.new(0.5, 0.5)
circulo.Position = UDim2.new(0.5, 0, 0.5, 0)
circulo.Size = UDim2.new(0, CONFIG.RaioInicial * 2, 0, CONFIG.RaioInicial * 2)
circulo.BackgroundTransparency = 1
circulo.BorderSizePixel = 0
circulo.Visible = false
circulo.Parent = screenGui

local cantoCirculo = Instance.new("UICorner")
cantoCirculo.CornerRadius = UDim.new(1, 0)
cantoCirculo.Parent = circulo

local strokeCirculo = Instance.new("UIStroke")
strokeCirculo.Color = CONFIG.CorPrimaria
strokeCirculo.Thickness = 2
strokeCirculo.Transparency = 0.3
strokeCirculo.Parent = circulo

-- ============================================================
-- FUNÇÕES AUXILIARES
-- ============================================================

-- Atualiza o visual do círculo conforme o raio
local function atualizarCirculo()
    circulo.Size = UDim2.new(0, estado.RaioAtual * 2, 0, estado.RaioAtual * 2)
    labelStatus.Text = "Raio atual: " .. tostring(estado.RaioAtual) .. " px"
end

-- Valida e aplica o valor digitado na TextBox
local function aplicarRaio()
    local texto = textBoxRaio.Text
    local numero = tonumber(texto)
    if not numero then
        textBoxRaio.Text = tostring(estado.RaioAtual)
        return
    end
    numero = math.clamp(math.floor(numero), CONFIG.RaioMin, CONFIG.RaioMax)
    estado.RaioAtual = numero
    textBoxRaio.Text = tostring(numero)
    atualizarCirculo()
end

-- Restringe a TextBox a apenas números (e permite apagar)
textBoxRaio:GetPropertyChangedSignal("Text"):Connect(function()
    local textoFiltrado = string.gsub(textBoxRaio.Text, "%D", "")
    if textoFiltrado ~= textBoxRaio.Text then
        textBoxRaio.Text = textoFiltrado
    end
end)

textBoxRaio.FocusLost:Connect(aplicarRaio)
btnAplicarRaio.MouseButton1Click:Connect(aplicarRaio)

-- ============================================================
-- LÓGICA DE SELEÇÃO DE ALVO (SEPARADA DA UI)
-- ============================================================

-- Retorna o centro da tela (viewport)
local function obterCentroTela()
    local vp = camera.ViewportSize
    return Vector2.new(vp.X / 2, vp.Y / 2)
end

-- Encontra o personagem mais próximo do centro dentro do raio
local function encontrarAlvo()
    local centro = obterCentroTela()
    local melhorDistancia = estado.RaioAtual
    local melhorPersonagem = nil
    local melhorCabeca = nil

    for _, jogador in ipairs(Players:GetPlayers()) do
        if jogador == localPlayer then continue end

        local personagem = jogador.Character
        if not personagem then continue end

        local humanoid = personagem:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then continue end

        local cabeca = personagem:FindFirstChild("Head")
        if not cabeca then continue end

        -- Converte posição da cabeça para tela
        local posTela, naTela = camera:WorldToViewportPoint(cabeca.Position)
        if not naTela then continue end

        local pos2D = Vector2.new(posTela.X, posTela.Y)
        local distancia = (pos2D - centro).Magnitude

        if distancia <= melhorDistancia then
            melhorDistancia = distancia
            melhorPersonagem = personagem
            melhorCabeca = cabeca
        end
    end

    return melhorPersonagem, melhorCabeca
end

-- Direciona a câmera suavemente para a cabeça do alvo
local function mirarNoAlvo(cabeca)
    if not cabeca then return end
    local posicaoCamera = camera.CFrame.Position
    local alvoPosicao = cabeca.Position
    local cfAlvo = CFrame.new(posicaoCamera, alvoPosicao)
    camera.CFrame = camera.CFrame:Lerp(cfAlvo, CONFIG.SuavizacaoCamera)
end

-- ============================================================
-- LOOP PRINCIPAL (RenderStepped)
-- ============================================================
RunService.RenderStepped:Connect(function()
    -- Atualiza posição do círculo (sempre centralizado)
    if circulo.Visible then
        circulo.Position = UDim2.new(0.5, 0, 0.5, 0)
    end

    -- Se o aimbot estiver ativo, procura e mira
    if estado.AimbotAtivo then
        local personagem, cabeca = encontrarAlvo()
        estado.AlvoAtual = personagem

        if cabeca then
            mirarNoAlvo(cabeca)
        end
    end
end)

-- ============================================================
-- TOGGLE DO AIMBOT
-- ============================================================
local function alternarAimbot()
    estado.AimbotAtivo = not estado.AimbotAtivo
    circulo.Visible = estado.AimbotAtivo

    if estado.AimbotAtivo then
        btnAimbot.Text = "AIMBOT: ATIVADO"
        btnAimbot.BackgroundColor3 = CONFIG.CorSecundaria
        strokeAimbot.Color = CONFIG.CorPrimaria
    else
        btnAimbot.Text = "AIMBOT: DESATIVADO"
        btnAimbot.BackgroundColor3 = CONFIG.CorPrimaria
        strokeAimbot.Color = CONFIG.CorSecundaria
        estado.AlvoAtual = nil
    end
end

btnAimbot.MouseButton1Click:Connect(alternarAimbot)

-- ============================================================
-- MINIMIZAR / RESTAURAR / FECHAR
-- ============================================================
local minimizado = false

btnMinimizar.MouseButton1Click:Connect(function()
    minimizado = not minimizado
    if minimizado then
        conteudo.Visible = false
        janela.Size = UDim2.new(0, 340, 0, 42)
        btnMinimizar.Text = "+"
    else
        conteudo.Visible = true
        janela.Size = UDim2.new(0, 340, 0, 280)
        btnMinimizar.Text = "−"
    end
end)

btnFechar.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- ============================================================
-- INICIALIZAÇÃO
-- ============================================================
atualizarCirculo()
circulo.Position = UDim2.new(0.5, 0, 0.5, 0)
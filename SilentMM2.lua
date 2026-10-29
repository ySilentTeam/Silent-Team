-- ============================================================
-- MM2 HUB v4 - CYBER NEON EDITION
-- UI + Loading + ESP + WalkSpeed + Fly + TP + Noclip + Aimbot
-- ============================================================

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local LocalPlayer      = Players.LocalPlayer
local Camera           = workspace.CurrentCamera

local IS_MOBILE = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- ============================================================
-- PALETA
-- ============================================================
local TC   = Color3.fromRGB(0, 210, 255)
local BG   = Color3.fromRGB(5, 9, 18)
local BG2  = Color3.fromRGB(9, 17, 30)
local BG3  = Color3.fromRGB(14, 27, 44)
local LINE = Color3.fromRGB(29, 77, 104)
local DIM  = Color3.fromRGB(145, 169, 188)
local WH   = Color3.fromRGB(235, 246, 255)
local RED  = Color3.fromRGB(255, 76, 94)
local GRN  = Color3.fromRGB(0, 220, 120)
local VIO  = Color3.fromRGB(126, 85, 255)

local RoleColors = {
    Murderer = Color3.fromRGB(255, 60, 60),
    Sheriff  = Color3.fromRGB(60, 130, 255),
    Innocent = Color3.fromRGB(60, 220, 60),
    Local    = Color3.fromRGB(255, 220, 60),
}

-- ============================================================
-- CONFIG
-- ============================================================
local Config = {
    ESP = {
        Enabled = false, ShowBox = true, ShowName = true,
        ShowDistance = true, ShowTracer = false, ShowWeapon = true,
        MaxDistance = 800,
    },
    WalkSpeed = { Default = 16, Current = 16, Enabled = false },
    Fly       = { Enabled = false, Speed = 50, DefaultSpeed = 50 },
    Aimbot    = { Enabled = false, Mode = "Legit", FOV = 120, Distance = 500,
                  Smoothness = 0.15, BodyPart = "Head" },
    Noclip    = { Enabled = false },
}

-- ============================================================
-- HELPERS
-- ============================================================
local function corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = p
    return c
end

local function stroke(p, color, thick)
    local s = Instance.new("UIStroke")
    s.Color = color or LINE
    s.Thickness = thick or 1
    s.Parent = p
    return s
end

local function tween(obj, props, time, style, dir)
    TweenService:Create(obj, TweenInfo.new(
        time or 0.2, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out
    ), props):Play()
end

-- ============================================================
-- SCREENGUI
-- ============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2_Hub_v4"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = not IS_MOBILE
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

local ok = pcall(function()
    ScreenGui.Parent = gethui and gethui() or game:GetService("CoreGui")
end)
if not ok or not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end
-- ============================================================
-- TELA DE LOADING (SPLASH)
-- ============================================================
local LoadingGui = Instance.new("ScreenGui")
LoadingGui.Name = "SilentTeam_Loading"
LoadingGui.ResetOnSpawn = false
LoadingGui.IgnoreGuiInset = true
LoadingGui.DisplayOrder = 9999
LoadingGui.Parent = ScreenGui.Parent

local LoadBg = Instance.new("Frame")
LoadBg.Size = UDim2.new(1, 0, 1, 0)
LoadBg.BackgroundColor3 = BG
LoadBg.BorderSizePixel = 0
LoadBg.ZIndex = 1
LoadBg.Parent = LoadingGui

local bgGrad = Instance.new("UIGradient")
bgGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(5, 9, 18)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(8, 15, 28)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 9, 18)),
})
bgGrad.Rotation = 90
bgGrad.Parent = LoadBg

-- Container central
local LoadCenter = Instance.new("Frame")
LoadCenter.AnchorPoint = Vector2.new(0.5, 0.5)
LoadCenter.Position = UDim2.new(0.5, 0, 0.5, 0)
LoadCenter.Size = UDim2.new(0, IS_MOBILE and 300 or 480, 0, IS_MOBILE and 300 or 400)
LoadCenter.BackgroundTransparency = 1
LoadCenter.ZIndex = 3
LoadCenter.Parent = LoadBg

-- Logo pulsante
local LogoBox = Instance.new("Frame")
LogoBox.AnchorPoint = Vector2.new(0.5, 0)
LogoBox.Position = UDim2.new(0.5, 0, 0, 0)
LogoBox.Size = UDim2.new(0, IS_MOBILE and 90 or 120, 0, IS_MOBILE and 90 or 120)
LogoBox.BackgroundColor3 = BG2
LogoBox.BorderSizePixel = 0
LogoBox.ZIndex = 4
LogoBox.Parent = LoadCenter
corner(LogoBox, 20)
stroke(LogoBox, TC, 2)

local logoInner = Instance.new("Frame")
logoInner.AnchorPoint = Vector2.new(0.5, 0.5)
logoInner.Position = UDim2.new(0.5, 0, 0.5, 0)
logoInner.Size = UDim2.new(0, IS_MOBILE and 50 or 70, 0, IS_MOBILE and 50 or 70)
logoInner.BackgroundColor3 = TC
logoInner.BorderSizePixel = 0
logoInner.ZIndex = 5
logoInner.Parent = LogoBox
corner(logoInner, 12)

local logoText = Instance.new("TextLabel")
logoText.Size = UDim2.new(1, 0, 1, 0)
logoText.BackgroundTransparency = 1
logoText.Text = "M2"
logoText.TextColor3 = BG
logoText.Font = Enum.Font.GothamBlack
logoText.TextSize = IS_MOBILE and 24 or 32
logoText.ZIndex = 6
logoText.Parent = logoInner

-- Pulso do logo
task.spawn(function()
    while LoadingGui.Parent do
        tween(LogoBox, {Size = UDim2.new(0, IS_MOBILE and 96 or 128, 0, IS_MOBILE and 96 or 128)}, 0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(0.9)
        if not LoadingGui.Parent then break end
        tween(LogoBox, {Size = UDim2.new(0, IS_MOBILE and 90 or 120, 0, IS_MOBILE and 90 or 120)}, 0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(0.9)
    end
end)

-- Título com shimmer cromado
local LoadTitle = Instance.new("TextLabel")
LoadTitle.AnchorPoint = Vector2.new(0.5, 0)
LoadTitle.Position = UDim2.new(0.5, 0, 0, IS_MOBILE and 110 or 140)
LoadTitle.Size = UDim2.new(1, 0, 0, IS_MOBILE and 32 or 42)
LoadTitle.BackgroundTransparency = 1
LoadTitle.Text = "Silent Team MM2"
LoadTitle.TextColor3 = WH
LoadTitle.Font = Enum.Font.GothamBlack
LoadTitle.TextSize = IS_MOBILE and 24 or 34
LoadTitle.TextStrokeColor3 = BG
LoadTitle.TextStrokeTransparency = 0.2
LoadTitle.ZIndex = 4
LoadTitle.Parent = LoadCenter

local titleGrad = Instance.new("UIGradient")
titleGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(125, 136, 153)),
    ColorSequenceKeypoint.new(0.32, Color3.fromRGB(225, 233, 244)),
    ColorSequenceKeypoint.new(0.48, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.62, Color3.fromRGB(183, 194, 210)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 132, 150)),
})
titleGrad.Offset = Vector2.new(-1, 0)
titleGrad.Parent = LoadTitle

task.spawn(function()
    while LoadTitle.Parent do
        tween(titleGrad, {Offset = Vector2.new(1, 0)}, 2.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(2.5)
        if not LoadTitle.Parent then break end
        titleGrad.Offset = Vector2.new(-1, 0)
        task.wait(0.25)
    end
end)

-- Subtítulo
local LoadSub = Instance.new("TextLabel")
LoadSub.AnchorPoint = Vector2.new(0.5, 0)
LoadSub.Position = UDim2.new(0.5, 0, 0, IS_MOBILE and 145 or 185)
LoadSub.Size = UDim2.new(1, 0, 0, 18)
LoadSub.BackgroundTransparency = 1
LoadSub.Text = "Script MM2 HUB "
LoadSub.TextColor3 = TC
LoadSub.Font = Enum.Font.GothamMedium
LoadSub.TextSize = IS_MOBILE and 9 or 11
LoadSub.ZIndex = 4
LoadSub.Parent = LoadCenter

-- Barra de progresso
local BarHolder = Instance.new("Frame")
BarHolder.AnchorPoint = Vector2.new(0.5, 0)
BarHolder.Position = UDim2.new(0.5, 0, 0, IS_MOBILE and 190 or 240)
BarHolder.Size = UDim2.new(1, IS_MOBILE and -40 or -80, 0, 6)
BarHolder.BackgroundColor3 = BG3
BarHolder.BorderSizePixel = 0
BarHolder.ZIndex = 4
BarHolder.Parent = LoadCenter
corner(BarHolder, 3)
stroke(BarHolder, LINE, 1)

local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = TC
BarFill.BorderSizePixel = 0
BarFill.ZIndex = 5
BarFill.Parent = BarHolder
corner(BarFill, 3)

local barGrad = Instance.new("UIGradient")
barGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, TC),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(35, 120, 255)),
    ColorSequenceKeypoint.new(1, VIO),
})
barGrad.Parent = BarFill

-- Status + Porcentagem
local StatusLbl = Instance.new("TextLabel")
StatusLbl.AnchorPoint = Vector2.new(0.5, 0)
StatusLbl.Position = UDim2.new(0.5, 0, 0, IS_MOBILE and 205 or 260)
StatusLbl.Size = UDim2.new(1, 0, 0, 20)
StatusLbl.BackgroundTransparency = 1
StatusLbl.Text = "Inicializando..."
StatusLbl.TextColor3 = DIM
StatusLbl.Font = Enum.Font.Gotham
StatusLbl.TextSize = IS_MOBILE and 11 or 12
StatusLbl.ZIndex = 4
StatusLbl.Parent = LoadCenter

local PctLbl = Instance.new("TextLabel")
PctLbl.AnchorPoint = Vector2.new(0.5, 0)
PctLbl.Position = UDim2.new(0.5, 0, 0, IS_MOBILE and 225 or 285)
PctLbl.Size = UDim2.new(1, 0, 0, 24)
PctLbl.BackgroundTransparency = 1
PctLbl.Text = "0%"
PctLbl.TextColor3 = TC
PctLbl.Font = Enum.Font.GothamBold
PctLbl.TextSize = IS_MOBILE and 16 or 20
PctLbl.ZIndex = 4
PctLbl.Parent = LoadCenter

-- Sequência de loading
local loadSteps = {
    {pct = 10,  msg = "Carregando modulos...",     delay = 0.35},
    {pct = 25,  msg = "Inicializando ESP...",      delay = 0.4},
    {pct = 40,  msg = "Configurando UI...",        delay = 0.35},
    {pct = 55,  msg = "Verificando Drawing...",    delay = 0.4},
    {pct = 70,  msg = "Preparando Aimbot...",      delay = 0.35},
    {pct = 85,  msg = "Conectando ao servidor...", delay = 0.4},
    {pct = 100, msg = "Pronto!",                   delay = 0.5},
}

task.spawn(function()
    for _, step in ipairs(loadSteps) do
        if not LoadingGui.Parent then return end
        StatusLbl.Text = step.msg
        PctLbl.Text = step.pct .. "%"
        tween(BarFill, {Size = UDim2.new(step.pct / 100, 0, 1, 0)}, step.delay, Enum.EasingStyle.Quart)
        task.wait(step.delay)
    end
    task.wait(0.4)
    tween(LoadBg, {BackgroundTransparency = 1}, 0.6, Enum.EasingStyle.Quart)
    for _, c in ipairs(LoadBg:GetDescendants()) do
        if c:IsA("GuiObject") and c.BackgroundTransparency < 1 then
            pcall(function() tween(c, {BackgroundTransparency = 1, TextTransparency = 1, ImageTransparency = 1}, 0.5) end)
        end
        if c:IsA("UIStroke") then
            pcall(function() tween(c, {Transparency = 1}, 0.5) end)
        end
    end
    task.wait(0.7)
    LoadingGui:Destroy()
end)
-- ============================================================
-- NOTIFICAÇÕES (TOAST)
-- ============================================================
local NotifyHolder = Instance.new("Frame")
NotifyHolder.Size = UDim2.new(0, 260, 0, 400)
NotifyHolder.Position = UDim2.new(1, -280, 1, -420)
NotifyHolder.BackgroundTransparency = 1
NotifyHolder.ZIndex = 200
NotifyHolder.Parent = ScreenGui

local function Notify(text, color)
    color = color or TC
    local toast = Instance.new("Frame")
    toast.Size = UDim2.new(1, 0, 0, 44)
    toast.Position = UDim2.new(1, 20, 1, -48 * (#NotifyHolder:GetChildren() + 1))
    toast.BackgroundColor3 = BG2
    toast.BackgroundTransparency = 0.05
    toast.ZIndex = 200
    toast.Parent = NotifyHolder
    corner(toast, 10)
    stroke(toast, color, 1)

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 4, 1, 0)
    bar.BackgroundColor3 = color
    bar.BorderSizePixel = 0
    bar.ZIndex = 201
    bar.Parent = toast
    corner(bar, 4)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -20, 1, 0)
    lbl.Position = UDim2.new(0, 16, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = WH
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 201
    lbl.Parent = toast

    tween(toast, {Position = UDim2.new(0, 0, 1, toast.Position.Y.Offset)}, 0.25)
    task.delay(2.5, function()
        tween(toast, {Position = UDim2.new(1, 20, 1, toast.Position.Y.Offset), BackgroundTransparency = 1}, 0.3)
        task.delay(0.35, function() toast:Destroy() end)
    end)
end

-- ============================================================
-- BOTÃO TOGGLE
-- ============================================================
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = IS_MOBILE and UDim2.new(0, 150, 0, 46) or UDim2.new(0, 140, 0, 40)
ToggleBtn.Position = UDim2.new(0.5, IS_MOBILE and -75 or -70, 0.5, IS_MOBILE and -23 or -20)
ToggleBtn.BackgroundColor3 = BG3
ToggleBtn.Text = ""
ToggleBtn.Parent = ScreenGui
ToggleBtn.Active = true
ToggleBtn.ZIndex = 100
corner(ToggleBtn, 12)
local tglStroke = stroke(ToggleBtn, TC, 2)

local StatusDot = Instance.new("Frame")
StatusDot.Size = UDim2.new(0, 10, 0, 10)
StatusDot.Position = UDim2.new(0, 14, 0.5, -5)
StatusDot.BackgroundColor3 = GRN
StatusDot.ZIndex = 101
StatusDot.Parent = ToggleBtn
corner(StatusDot, 5)

local ToggleLbl = Instance.new("TextLabel")
ToggleLbl.Size = UDim2.new(1, -36, 1, 0)
ToggleLbl.Position = UDim2.new(0, 30, 0, 0)
ToggleLbl.BackgroundTransparency = 1
ToggleLbl.Text = "MM2 HUB"
ToggleLbl.TextColor3 = WH
ToggleLbl.Font = Enum.Font.GothamBlack
ToggleLbl.TextSize = IS_MOBILE and 14 or 13
ToggleLbl.TextXAlignment = Enum.TextXAlignment.Left
ToggleLbl.ZIndex = 101
ToggleLbl.Parent = ToggleBtn

-- Pulso do stroke
task.spawn(function()
    while ToggleBtn.Parent do
        tween(tglStroke, {Color = VIO}, 1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(1.2)
        if not ToggleBtn.Parent then break end
        tween(tglStroke, {Color = TC}, 1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(1.2)
    end
end)

-- Drag do botão
local tDrag, tStart, tPos, tMoved = false, nil, nil, false
ToggleBtn.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
        tDrag, tMoved = true, false
        tStart, tPos = i.Position, ToggleBtn.Position
    end
end)
ToggleBtn.InputChanged:Connect(function(i)
    if not tDrag then return end
    if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement then
        local d = i.Position - tStart
        if d.Magnitude > 5 then tMoved = true end
        ToggleBtn.Position = UDim2.new(tPos.X.Scale, tPos.X.Offset + d.X, tPos.Y.Scale, tPos.Y.Offset + d.Y)
    end
end)
ToggleBtn.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
        tDrag = false
    end
end)

-- ============================================================
-- JANELA PRINCIPAL
-- ============================================================
local Main = Instance.new("Frame")
Main.Size = IS_MOBILE and UDim2.new(0, 360, 0, 500) or UDim2.new(0, 560, 0, 520)
Main.Position = IS_MOBILE and UDim2.new(0.5, -180, 0.5, -250) or UDim2.new(0.5, -280, 0.5, -260)
Main.BackgroundColor3 = BG
Main.BorderSizePixel = 0
Main.Visible = false
Main.Active = true
Main.ZIndex = 50
Main.ClipsDescendants = true
Main.Parent = ScreenGui
corner(Main, 14)
local mainStroke = stroke(Main, TC, 2)

-- Glow animado da borda
task.spawn(function()
    while Main.Parent do
        tween(mainStroke, {Color = VIO}, 1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(1.5)
        if not Main.Parent then break end
        tween(mainStroke, {Color = TC}, 1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(1.5)
    end
end)

-- Backdrop
local Backdrop = Instance.new("TextButton")
Backdrop.Size = UDim2.new(1, 0, 1, 0)
Backdrop.BackgroundTransparency = 1
Backdrop.Text = ""
Backdrop.Visible = false
Backdrop.ZIndex = 40
Backdrop.Parent = ScreenGui
Backdrop.MouseButton1Click:Connect(function()
    Main.Visible = false
    Backdrop.Visible = false
end)

ToggleBtn.MouseButton1Click:Connect(function()
    if tMoved then tMoved = false; return end
    Main.Visible = not Main.Visible
    Backdrop.Visible = Main.Visible
end)

-- Barra de título (silver gradient)
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, IS_MOBILE and 50 or 46)
TitleBar.BackgroundColor3 = BG3
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 52
TitleBar.Parent = Main
corner(TitleBar, 14)

local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0, 14)
TitleFix.Position = UDim2.new(0, 0, 1, -14)
TitleFix.BackgroundColor3 = BG3
TitleFix.BorderSizePixel = 0
TitleFix.ZIndex = 52
TitleFix.Parent = TitleBar

local topLine = Instance.new("Frame")
topLine.Size = UDim2.new(1, 0, 0, 2)
topLine.Position = UDim2.new(0, 0, 1, -2)
topLine.BackgroundColor3 = Color3.fromRGB(190, 198, 210)
topLine.BorderSizePixel = 0
topLine.ZIndex = 53
topLine.Parent = TitleBar

local topSilver = Instance.new("UIGradient")
topSilver.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(54, 59, 69)),
    ColorSequenceKeypoint.new(0.22, Color3.fromRGB(166, 174, 187)),
    ColorSequenceKeypoint.new(0.38, Color3.fromRGB(245, 248, 255)),
    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(112, 121, 137)),
    ColorSequenceKeypoint.new(0.68, Color3.fromRGB(226, 232, 241)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(48, 53, 63)),
})
topSilver.Offset = Vector2.new(-1, 0)
topSilver.Parent = topLine

task.spawn(function()
    while topLine.Parent do
        tween(topSilver, {Offset = Vector2.new(1, 0)}, 2.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(2.7)
        if not topLine.Parent then break end
        topSilver.Offset = Vector2.new(-1, 0)
        task.wait(0.2)
    end
end)

local TitleLbl = Instance.new("TextLabel")
TitleLbl.Size = UDim2.new(1, -100, 1, 0)
TitleLbl.Position = UDim2.new(0, 16, 0, 0)
TitleLbl.BackgroundTransparency = 1
TitleLbl.Text = "Silent MM2 HUB  •  v4"
TitleLbl.TextColor3 = WH
TitleLbl.Font = Enum.Font.GothamBlack
TitleLbl.TextSize = IS_MOBILE and 13 or 15
TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
TitleLbl.TextStrokeColor3 = BG
TitleLbl.TextStrokeTransparency = 0.4
TitleLbl.ZIndex = 53
TitleLbl.Parent = TitleBar

local titleChrome = Instance.new("UIGradient")
titleChrome.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(125, 136, 153)),
    ColorSequenceKeypoint.new(0.32, Color3.fromRGB(225, 233, 244)),
    ColorSequenceKeypoint.new(0.48, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.62, Color3.fromRGB(183, 194, 210)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 132, 150)),
})
titleChrome.Offset = Vector2.new(-1, 0)
titleChrome.Parent = TitleLbl

task.spawn(function()
    while TitleLbl.Parent do
        tween(titleChrome, {Offset = Vector2.new(1, 0)}, 2.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(2.5)
        if not TitleLbl.Parent then break end
        titleChrome.Offset = Vector2.new(-1, 0)
        task.wait(0.25)
    end
end)

-- Botão fechar
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = IS_MOBILE and UDim2.new(0, 34, 0, 34) or UDim2.new(0, 28, 0, 28)
CloseBtn.Position = IS_MOBILE and UDim2.new(1, -42, 0, 8) or UDim2.new(1, -36, 0, 9)
CloseBtn.BackgroundColor3 = RED
CloseBtn.Text = "×"
CloseBtn.TextColor3 = WH
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = IS_MOBILE and 22 or 20
CloseBtn.ZIndex = 53
CloseBtn.Parent = TitleBar
corner(CloseBtn, 6)
CloseBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    Backdrop.Visible = false
end)

-- Drag da janela
local wDrag, wStart, wPos = false, nil, nil
TitleBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
        wDrag = true
        wStart, wPos = i.Position, Main.Position
    end
end)
TitleBar.InputChanged:Connect(function(i)
    if not wDrag then return end
    if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement then
        local d = i.Position - wStart
        Main.Position = UDim2.new(wPos.X.Scale, wPos.X.Offset + d.X, wPos.Y.Scale, wPos.Y.Offset + d.Y)
    end
end)
TitleBar.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
        wDrag = false
    end
end)
-- ============================================================
-- ABAS (5)
-- ============================================================
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -24, 0, IS_MOBILE and 42 or 38)
TabBar.Position = UDim2.new(0, 12, 0, IS_MOBILE and 58 or 54)
TabBar.BackgroundColor3 = BG2
TabBar.BorderSizePixel = 0
TabBar.ZIndex = 52
TabBar.Parent = Main
corner(TabBar, 8)
stroke(TabBar, LINE, 1)

local TabIndicator = Instance.new("Frame")
TabIndicator.Size = UDim2.new(1 / 5, 0, 0, 3)
TabIndicator.Position = UDim2.new(0, 0, 1, -3)
TabIndicator.BackgroundColor3 = TC
TabIndicator.BorderSizePixel = 0
TabIndicator.ZIndex = 53
TabIndicator.Parent = TabBar
corner(TabIndicator, 2)

local function MakeTab(name, idx, total)
    local w = 1 / total
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(w, 0, 1, 0)
    btn.Position = UDim2.new(w * idx, 0, 0, 0)
    btn.BackgroundTransparency = 1
    btn.Text = name
    btn.TextColor3 = DIM
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = IS_MOBILE and 10 or 12
    btn.ZIndex = 53
    btn.Parent = TabBar
    return btn
end

local TabESP      = MakeTab("ESP",     0, 5)
local TabPlayers  = MakeTab("PLAYERS", 1, 5)
local TabMovement = MakeTab("MOV",     2, 5)
local TabTeleport = MakeTab("TP",      3, 5)
local TabNoclip   = MakeTab("NOCLIP",  4, 5)

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -24, 1, -108)
Content.Position = UDim2.new(0, 12, 0, IS_MOBILE and 108 or 100)
Content.BackgroundTransparency = 1
Content.ZIndex = 52
Content.Parent = Main

local function NewPage()
    local p = Instance.new("ScrollingFrame")
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.BorderSizePixel = 0
    p.ScrollBarThickness = 4
    p.ScrollBarImageColor3 = TC
    p.CanvasSize = UDim2.new(0, 0, 0, 0)
    p.Visible = false
    p.ZIndex = 52
    p.Parent = Content
    return p
end

local PageESP      = NewPage()
local PagePlayers  = NewPage()
local PageMovement = NewPage()
local PageTeleport = NewPage()
local PageNoclip   = NewPage()
PageESP.Visible = true

local AllTabs = { TabESP, TabPlayers, TabMovement, TabTeleport, TabNoclip }

local function SwitchTab(page, btn, idx)
    for _, p in pairs({ PageESP, PagePlayers, PageMovement, PageTeleport, PageNoclip }) do
        p.Visible = (p == page)
    end
    for _, t in pairs(AllTabs) do t.TextColor3 = DIM end
    btn.TextColor3 = WH
    tween(TabIndicator, {
        Position = UDim2.new((1 / 5) * idx, 0, 1, -3),
        Size     = UDim2.new(1 / 5, 0, 0, 3),
    }, 0.25)
end

TabESP.MouseButton1Click:Connect(function() SwitchTab(PageESP, TabESP, 0) end)
TabPlayers.MouseButton1Click:Connect(function() SwitchTab(PagePlayers, TabPlayers, 1) end)
TabMovement.MouseButton1Click:Connect(function() SwitchTab(PageMovement, TabMovement, 2) end)
TabTeleport.MouseButton1Click:Connect(function() SwitchTab(PageTeleport, TabTeleport, 3) end)
TabNoclip.MouseButton1Click:Connect(function() SwitchTab(PageNoclip, TabNoclip, 4) end)
TabESP.TextColor3 = WH

-- ============================================================
-- COMPONENTES
-- ============================================================
local function MakeCard(parent, title, height)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -8, 0, height)
    card.BackgroundColor3 = BG2
    card.BorderSizePixel = 0
    card.ZIndex = 53
    card.Parent = parent
    corner(card, 10)
    stroke(card, LINE, 1)
    if title then
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -20, 0, 20)
        lbl.Position = UDim2.new(0, 14, 0, 10)
        lbl.BackgroundTransparency = 1
        lbl.Text = title
        lbl.TextColor3 = WH
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 13
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.ZIndex = 54
        lbl.Parent = card
    end
    return card
end

local function MakeSwitch(parent, label, yPos, initial, callback)
    local rowH = IS_MOBILE and 42 or 32
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -20, 0, rowH)
    row.Position = UDim2.new(0, 14, 0, yPos)
    row.BackgroundTransparency = 1
    row.ZIndex = 54
    row.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -70, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = WH
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = IS_MOBILE and 13 or 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 54
    lbl.Parent = row

    local sw, sh = IS_MOBILE and 50 or 44, IS_MOBILE and 26 or 22
    local knob = IS_MOBILE and 22 or 18

    local switch = Instance.new("TextButton")
    switch.Size = UDim2.new(0, sw, 0, sh)
    switch.Position = UDim2.new(1, -sw, 0.5, -sh / 2)
    switch.BackgroundColor3 = initial and TC or LINE
    switch.Text = ""
    switch.ZIndex = 55
    switch.Parent = row
    corner(switch, sh / 2)

    local knobF = Instance.new("Frame")
    knobF.Size = UDim2.new(0, knob, 0, knob)
    knobF.Position = initial and UDim2.new(1, -knob - 2, 0.5, -knob / 2) or UDim2.new(0, 2, 0.5, -knob / 2)
    knobF.BackgroundColor3 = WH
    knobF.ZIndex = 56
    knobF.Parent = switch
    corner(knobF, knob / 2)

    local state = initial
    switch.MouseButton1Click:Connect(function()
        state = not state
        tween(switch, {BackgroundColor3 = state and TC or LINE}, 0.2)
        tween(knobF, {Position = state and UDim2.new(1, -knob - 2, 0.5, -knob / 2) or UDim2.new(0, 2, 0.5, -knob / 2)}, 0.2)
        callback(state)
    end)
end

local function MakeSlider(parent, label, yPos, minV, maxV, initial, callback)
    local rowH = IS_MOBILE and 62 or 50
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -20, 0, rowH)
    row.Position = UDim2.new(0, 14, 0, yPos)
    row.BackgroundTransparency = 1
    row.ZIndex = 54
    row.Parent = parent

    local top = Instance.new("Frame")
    top.Size = UDim2.new(1, 0, 0, 22)
    top.BackgroundTransparency = 1
    top.ZIndex = 54
    top.Parent = row

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -70, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = WH
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = IS_MOBILE and 13 or 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 54
    lbl.Parent = top

    local valLbl = Instance.new("TextLabel")
    valLbl.Size = UDim2.new(0, 60, 1, 0)
    valLbl.Position = UDim2.new(1, -60, 0, 0)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = tostring(initial)
    valLbl.TextColor3 = TC
    valLbl.Font = Enum.Font.GothamBold
    valLbl.TextSize = IS_MOBILE and 13 or 12
    valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.ZIndex = 54
    valLbl.Parent = top

    local trackH = IS_MOBILE and 8 or 6
    local knobS = IS_MOBILE and 20 or 14

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, 0, 0, trackH)
    track.Position = UDim2.new(0, 0, 0, IS_MOBILE and 32 or 28)
    track.BackgroundColor3 = BG3
    track.ZIndex = 54
    track.Parent = row
    corner(track, trackH / 2)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((initial - minV) / (maxV - minV), 0, 1, 0)
    fill.BackgroundColor3 = TC
    fill.BorderSizePixel = 0
    fill.ZIndex = 55
    fill.Parent = track
    corner(fill, trackH / 2)

    local knob2 = Instance.new("Frame")
    knob2.Size = UDim2.new(0, knobS, 0, knobS)
    knob2.Position = UDim2.new((initial - minV) / (maxV - minV), -knobS / 2, 0.5, -knobS / 2)
    knob2.BackgroundColor3 = WH
    knob2.ZIndex = 56
    knob2.Parent = track
    corner(knob2, knobS / 2)
    stroke(knob2, TC, 2)

    local drag = false
    local function update(i)
        local rel = math.clamp((i.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local v = math.floor(minV + rel * (maxV - minV))
        fill.Size = UDim2.new(rel, 0, 1, 0)
        knob2.Position = UDim2.new(rel, -knobS / 2, 0.5, -knobS / 2)
        valLbl.Text = tostring(v)
        callback(v)
    end
    track.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            drag = true; update(i)
        end
    end)
    track.InputChanged:Connect(function(i)
        if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            update(i)
        end
    end)
    track.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            drag = false
        end
    end)
end

local function MakeButton(parent, text, yPos, color, callback)
    local h = IS_MOBILE and 42 or 34
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, h)
    btn.Position = UDim2.new(0, 14, 0, yPos)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = WH
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = IS_MOBILE and 13 or 12
    btn.ZIndex = 55
    btn.Parent = parent
    corner(btn, 8)
    btn.MouseButton1Click:Connect(callback)
    return btn
end
-- ============================================================
-- IDENTIFICAÇÃO DE PAPÉIS
-- ============================================================
local ROLE_TOOL_NAMES = {
    Knife = "Murderer", ["Murder Knife"] = "Murderer",
    Gun = "Sheriff", Revolver = "Sheriff", ["Sheriff Gun"] = "Sheriff",
}

local function CheckContainer(c)
    if not c then return nil end
    for name, role in pairs(ROLE_TOOL_NAMES) do
        if c:FindFirstChild(name) then return role end
    end
    return nil
end

local function GetPlayerRole(p)
    if p == LocalPlayer then return "Local" end
    return CheckContainer(p.Character)
        or CheckContainer(p:FindFirstChild("Backpack"))
        or "Innocent"
end

-- ============================================================
-- ESP 2D
-- ============================================================
local hasDrawing = pcall(function() return Drawing.new("Square") end)
if not hasDrawing then warn("[MM2 Hub] Sem Drawing — ESP desativado") end

local ESPObjects = {}

local function CreateESP(p)
    if ESPObjects[p] then return end
    local box = Drawing.new("Square"); box.Thickness = 1; box.Filled = false; box.Visible = false
    local nm  = Drawing.new("Text"); nm.Size = 13; nm.Center = true; nm.Outline = true; nm.Visible = false
    local dst = Drawing.new("Text"); dst.Size = 11; dst.Center = true; dst.Outline = true; dst.Visible = false
    local trc = Drawing.new("Line"); trc.Thickness = 1; trc.Visible = false
    local wpn = Drawing.new("Text"); wpn.Size = 10; wpn.Center = true; wpn.Outline = true; wpn.Visible = false
    ESPObjects[p] = { Box = box, Name = nm, Dist = dst, Tracer = trc, Weapon = wpn }
end

local function RemoveESP(p)
    local e = ESPObjects[p]
    if not e then return end
    for _, obj in pairs(e) do pcall(function() obj:Remove() end) end
    ESPObjects[p] = nil
end

local function HideAllESP(e)
    for _, obj in pairs(e) do obj.Visible = false end
end

RunService.RenderStepped:Connect(function()
    if not Config.ESP.Enabled or not hasDrawing then
        for _, e in pairs(ESPObjects) do HideAllESP(e) end
        return
    end
    local lc = LocalPlayer.Character
    local lhrp = lc and lc:FindFirstChild("HumanoidRootPart")
    if not lhrp then return end
    local vp = Camera.ViewportSize

    for _, p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        if not ESPObjects[p] then CreateESP(p) end
        local e = ESPObjects[p]
        local ch = p.Character
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        local hum = ch and ch:FindFirstChild("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then HideAllESP(e); continue end
        local dist = (hrp.Position - lhrp.Position).Magnitude
        if dist > Config.ESP.MaxDistance then HideAllESP(e); continue end
        local sp, on = Camera:WorldToViewportPoint(hrp.Position)
        if not on then HideAllESP(e); continue end
        local head = ch:FindFirstChild("Head")
        if not head then HideAllESP(e); continue end
        local hs = Camera:WorldToViewportPoint(head.Position)
        local ls = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
        local h = math.abs(hs.Y - ls.Y)
        local w = h * 0.6
        local x = sp.X - w / 2
        local y = hs.Y
        local role = GetPlayerRole(p)
        local color = RoleColors[role] or WH

        e.Box.Size = Vector2.new(w, h)
        e.Box.Position = Vector2.new(x, y)
        e.Box.Color = color
        e.Box.Visible = Config.ESP.ShowBox

        e.Name.Text = p.Name .. " • " .. role
        e.Name.Position = Vector2.new(sp.X, y - 18)
        e.Name.Color = color
        e.Name.Visible = Config.ESP.ShowName

        e.Dist.Text = math.floor(dist) .. "m"
        e.Dist.Position = Vector2.new(sp.X, y + h + 3)
        e.Dist.Color = DIM
        e.Dist.Visible = Config.ESP.ShowDistance

        if Config.ESP.ShowTracer then
            e.Tracer.From = Vector2.new(vp.X / 2, vp.Y)
            e.Tracer.To = Vector2.new(sp.X, sp.Y)
            e.Tracer.Color = color
            e.Tracer.Visible = true
        else
            e.Tracer.Visible = false
        end

        if Config.ESP.ShowWeapon then
            local wp = "—"
            if ch:FindFirstChild("Knife") or (p:FindFirstChild("Backpack") and p.Backpack:FindFirstChild("Knife")) then
                wp = "KNIFE"
            elseif ch:FindFirstChild("Gun") or (p:FindFirstChild("Backpack") and p.Backpack:FindFirstChild("Gun")) then
                wp = "GUN"
            end
            e.Weapon.Text = wp
            e.Weapon.Position = Vector2.new(sp.X, y + h + 16)
            e.Weapon.Color = color
            e.Weapon.Visible = wp ~= "—"
        else
            e.Weapon.Visible = false
        end
    end
end)

Players.PlayerRemoving:Connect(RemoveESP)

-- ============================================================
-- WALKSPEED
-- ============================================================
local function ApplyWalkSpeed(v)
    local ch = LocalPlayer.Character
    local hum = ch and ch:FindFirstChild("Humanoid")
    if hum then
        hum.WalkSpeed = math.clamp(v, 0, 500)
        Config.WalkSpeed.Current = hum.WalkSpeed
        Config.WalkSpeed.Enabled = true
    end
end

local function ResetWalkSpeed()
    local ch = LocalPlayer.Character
    local hum = ch and ch:FindFirstChild("Humanoid")
    if hum then hum.WalkSpeed = Config.WalkSpeed.Default end
    Config.WalkSpeed.Current = Config.WalkSpeed.Default
    Config.WalkSpeed.Enabled = false
end

-- ============================================================
-- FLY
-- ============================================================
local flyConn, flyVel, flyGyro = nil, nil, nil
local flyUp = 0
local flyHUD = nil

UserInputService.InputBegan:Connect(function(i, g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.Space then flyUp = 1 end
    if i.KeyCode == Enum.KeyCode.LeftControl then flyUp = -1 end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.Space or i.KeyCode == Enum.KeyCode.LeftControl then flyUp = 0 end
end)

local function CreateFlyHUD()
    if flyHUD then return end
    flyHUD = Instance.new("Frame")
    flyHUD.Size = UDim2.new(0, 80, 0, 180)
    flyHUD.Position = UDim2.new(1, -100, 0.5, -90)
    flyHUD.BackgroundTransparency = 1
    flyHUD.ZIndex = 150
    flyHUD.Parent = ScreenGui

    local up = Instance.new("TextButton")
    up.Size = UDim2.new(1, 0, 0, 80)
    up.BackgroundColor3 = TC
    up.BackgroundTransparency = 0.3
    up.Text = "▲"
    up.TextColor3 = WH
    up.Font = Enum.Font.GothamBold
    up.TextSize = 32
    up.ZIndex = 151
    up.Parent = flyHUD
    corner(up, 40)

    local down = Instance.new("TextButton")
    down.Size = UDim2.new(1, 0, 0, 80)
    down.Position = UDim2.new(0, 0, 0, 100)
    down.BackgroundColor3 = RED
    down.BackgroundTransparency = 0.3
    down.Text = "▼"
    down.TextColor3 = WH
    down.Font = Enum.Font.GothamBold
    down.TextSize = 32
    down.ZIndex = 151
    down.Parent = flyHUD
    corner(down, 40)

    up.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then flyUp = 1 end
    end)
    up.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then flyUp = 0 end
    end)
    down.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then flyUp = -1 end
    end)
    down.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then flyUp = 0 end
    end)
end

local function StopFly()
    if flyConn then flyConn:Disconnect(); flyConn = nil end
    if flyVel then flyVel:Destroy(); flyVel = nil end
    if flyGyro then flyGyro:Destroy(); flyGyro = nil end
    Config.Fly.Enabled = false
    flyUp = 0
    if flyHUD then flyHUD:Destroy(); flyHUD = nil end
    local ch = LocalPlayer.Character
    local hum = ch and ch:FindFirstChild("Humanoid")
    if hum then hum.PlatformStand = false end
end

local function StartFly()
    if Config.Fly.Enabled then return end
    local ch = LocalPlayer.Character
    if not ch then return end
    local hrp = ch:FindFirstChild("HumanoidRootPart")
    local hum = ch:FindFirstChild("Humanoid")
    if not hrp or not hum then return end
    Config.Fly.Enabled = true
    hum.PlatformStand = true

    flyVel = Instance.new("BodyVelocity")
    flyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    flyVel.Velocity = Vector3.zero
    flyVel.Parent = hrp

    flyGyro = Instance.new("BodyGyro")
    flyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    flyGyro.P = 10000; flyGyro.D = 500
    flyGyro.CFrame = hrp.CFrame
    flyGyro.Parent = hrp

    if IS_MOBILE then CreateFlyHUD() end

    flyConn = RunService.RenderStepped:Connect(function()
        if not Config.Fly.Enabled then return end
        local cHRP = ch:FindFirstChild("HumanoidRootPart")
        local cHum = ch:FindFirstChild("Humanoid")
        if not cHRP or not cHum or cHum.Health <= 0 then StopFly(); return end
        flyGyro.CFrame = Camera.CFrame
        local move = cHum.MoveDirection
        local final = Vector3.zero
        if move.Magnitude > 0 then
            final = Camera.CFrame:VectorToWorldSpace(Vector3.new(move.X, 0, move.Z))
        end
        if flyUp ~= 0 then
            final = final + Vector3.new(0, flyUp, 0)
        end
        flyVel.Velocity = final.Magnitude > 0 and final.Unit * Config.Fly.Speed or Vector3.zero
    end)
end

-- ============================================================
-- NOCLIP
-- ============================================================
local noclipConn = nil

local function StartNoclip()
    if noclipConn then return end
    noclipConn = RunService.Stepped:Connect(function()
        local ch = LocalPlayer.Character
        if not ch then return end
        for _, part in ipairs(ch:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end)
    Config.Noclip.Enabled = true
    Notify("Noclip ativado", GRN)
end

local function StopNoclip()
    if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
    local ch = LocalPlayer.Character
    if ch then
        for _, part in ipairs(ch:GetDescendants()) do
            if part:IsA("BasePart") then
                pcall(function() part.CanCollide = true end)
            end
        end
    end
    Config.Noclip.Enabled = false
    Notify("Noclip desativado", RED)
end

-- ============================================================
-- TELEPORTE
-- ============================================================
local function TeleportToPlayer(name)
    local target = Players:FindFirstChild(name)
    if not target then Notify("Jogador não encontrado", RED); return end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local tChar = target.Character
    local tHRP = tChar and tChar:FindFirstChild("HumanoidRootPart")
    if not myHRP or not tHRP then Notify("Personagem inválido", RED); return end
    local offset = tHRP.CFrame.LookVector * -3 + Vector3.new(0, 2, 0)
    myHRP.CFrame = CFrame.new(tHRP.Position + offset)
    Notify("TP → " .. target.Name, GRN)
end

local function TeleportToMurderer()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and GetPlayerRole(p) == "Murderer" then
            TeleportToPlayer(p.Name); return
        end
    end
    Notify("Nenhum Murderer", RED)
end

local function TeleportToSheriff()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and GetPlayerRole(p) == "Sheriff" then
            TeleportToPlayer(p.Name); return
        end
    end
    Notify("Nenhum Sheriff", RED)
end

local function TeleportToInnocent()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and GetPlayerRole(p) == "Innocent" then
            TeleportToPlayer(p.Name); return
        end
    end
    Notify("Nenhum Innocent", RED)
end

-- ============================================================
-- AIMBOT
-- ============================================================
local aimbotConn = nil

local function GetAimbotTarget()
    local center = Camera.ViewportSize / 2
    local best, bestD = nil, math.huge
    local myPos = Camera.CFrame.Position
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local ch = p.Character
            local hum = ch and ch:FindFirstChild("Humanoid")
            local part = ch and ch:FindFirstChild(Config.Aimbot.BodyPart == "Head" and "Head" or "HumanoidRootPart")
            if part and hum and hum.Health > 0 then
                local dist = (part.Position - myPos).Magnitude
                if dist <= Config.Aimbot.Distance then
                    local sp, on = Camera:WorldToViewportPoint(part.Position)
                    if on and sp.Z > 0 then
                        local screenDist = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                        if screenDist <= Config.Aimbot.FOV and screenDist < bestD then
                            best, bestD = part, screenDist
                        end
                    end
                end
            end
        end
    end
    return best
end

local function StartAimbot()
    if aimbotConn then return end
    aimbotConn = RunService.RenderStepped:Connect(function()
        if not Config.Aimbot.Enabled then return end
        local ch = LocalPlayer.Character
        local hum = ch and ch:FindFirstChild("Humanoid")
        if not hum or hum.Health <= 0 then return end
        if Config.Aimbot.Mode == "Legit" then
            if not ch:FindFirstChildOfClass("Tool") then return end
        end
        local target = GetAimbotTarget()
        if not target then return end
        local myPos = Camera.CFrame.Position
        if Config.Aimbot.Mode == "Rage" then
            Camera.CFrame = CFrame.new(myPos, target.Position)
        else
            local currentLook = Camera.CFrame.LookVector
            local desiredLook = (target.Position - myPos).Unit
            local factor = math.clamp(Config.Aimbot.Smoothness * 8, 0.02, 0.35)
            if currentLook:Dot(desiredLook) > 0.998 then factor = 0.6 end
            Camera.CFrame = CFrame.new(myPos, myPos + currentLook:Lerp(desiredLook, factor))
        end
    end)
end

local function StopAimbot()
    if aimbotConn then aimbotConn:Disconnect(); aimbotConn = nil end
end
-- ============================================================
-- ABA ESP
-- ============================================================
local espCard = MakeCard(PageESP, "ESP Visual", 300)
espCard.Position = UDim2.new(0, 4, 0, 0)

MakeSwitch(espCard, "ESP Geral", 36, Config.ESP.Enabled, function(v)
    Config.ESP.Enabled = v
    Notify("ESP " .. (v and "ativado" or "desativado"), v and GRN or RED)
end)
MakeSwitch(espCard, "Caixas", 80, Config.ESP.ShowBox, function(v) Config.ESP.ShowBox = v end)
MakeSwitch(espCard, "Nomes", 124, Config.ESP.ShowName, function(v) Config.ESP.ShowName = v end)
MakeSwitch(espCard, "Distâncias", 168, Config.ESP.ShowDistance, function(v) Config.ESP.ShowDistance = v end)
MakeSwitch(espCard, "Tracer", 212, Config.ESP.ShowTracer, function(v) Config.ESP.ShowTracer = v end)
MakeSwitch(espCard, "Arma", 256, Config.ESP.ShowWeapon, function(v) Config.ESP.ShowWeapon = v end)
PageESP.CanvasSize = UDim2.new(0, 0, 0, 320)

-- ============================================================
-- ABA JOGADORES
-- ============================================================
local CounterLbl = Instance.new("TextLabel")
CounterLbl.Size = UDim2.new(1, -8, 0, 30)
CounterLbl.Position = UDim2.new(0, 4, 0, 0)
CounterLbl.BackgroundColor3 = BG2
CounterLbl.TextColor3 = WH
CounterLbl.Font = Enum.Font.GothamMedium
CounterLbl.TextSize = 12
CounterLbl.Text = "Carregando..."
CounterLbl.ZIndex = 54
CounterLbl.Parent = PagePlayers
corner(CounterLbl, 8)
stroke(CounterLbl, LINE, 1)

local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Size = UDim2.new(1, 0, 1, -40)
PlayerList.Position = UDim2.new(0, 0, 0, 40)
PlayerList.BackgroundTransparency = 1
PlayerList.BorderSizePixel = 0
PlayerList.ScrollBarThickness = 4
PlayerList.ScrollBarImageColor3 = TC
PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerList.ZIndex = 54
PlayerList.Parent = PagePlayers

local function RefreshPlayerList()
    for _, c in ipairs(PlayerList:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    local counts = { Murderer = 0, Sheriff = 0, Innocent = 0 }
    local y = 0
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        local role = GetPlayerRole(p)
        if counts[role] then counts[role] = counts[role] + 1 end
        local color = RoleColors[role] or DIM
        local row = Instance.new("TextButton")
        row.Size = UDim2.new(1, -8, 0, IS_MOBILE and 42 or 34)
        row.Position = UDim2.new(0, 4, 0, y)
        row.BackgroundColor3 = BG2
        row.BorderSizePixel = 0
        row.Text = ""
        row.AutoButtonColor = true
        row.ZIndex = 55
        row.Parent = PlayerList
        corner(row, 8)
        stroke(row, LINE, 1)

        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0, 10, 0, 10)
        dot.Position = UDim2.new(0, 12, 0.5, -5)
        dot.BackgroundColor3 = color
        dot.ZIndex = 56
        dot.Parent = row
        corner(dot, 5)

        local nl = Instance.new("TextLabel")
        nl.Size = UDim2.new(1, -110, 1, 0)
        nl.Position = UDim2.new(0, 30, 0, 0)
        nl.BackgroundTransparency = 1
        nl.Text = p.Name
        nl.TextColor3 = WH
        nl.Font = Enum.Font.GothamMedium
        nl.TextSize = 12
        nl.TextXAlignment = Enum.TextXAlignment.Left
        nl.ZIndex = 56
        nl.Parent = row

        local rl = Instance.new("TextLabel")
        rl.Size = UDim2.new(0, 90, 1, 0)
        rl.Position = UDim2.new(1, -96, 0, 0)
        rl.BackgroundTransparency = 1
        rl.Text = role
        rl.TextColor3 = color
        rl.Font = Enum.Font.GothamBold
        rl.TextSize = 10
        rl.TextXAlignment = Enum.TextXAlignment.Right
        rl.ZIndex = 56
        rl.Parent = row

        row.MouseButton1Click:Connect(function() TeleportToPlayer(p.Name) end)
        y = y + (IS_MOBILE and 48 or 40)
    end
    PlayerList.CanvasSize = UDim2.new(0, 0, 0, y + 10)
    CounterLbl.Text = string.format("Murderer: %d   Sheriff: %d   Innocent: %d",
        counts.Murderer, counts.Sheriff, counts.Innocent)
end

task.spawn(function()
    while true do
        task.wait(1)
        if PagePlayers.Visible then RefreshPlayerList() end
    end
end)

-- ============================================================
-- ABA MOVIMENTO
-- ============================================================
local wsCard = MakeCard(PageMovement, "WalkSpeed", 190)
wsCard.Position = UDim2.new(0, 4, 0, 0)

MakeSlider(wsCard, "Velocidade", 36, 8, 200, Config.WalkSpeed.Current, function(v)
    if Config.WalkSpeed.Enabled then ApplyWalkSpeed(v) else Config.WalkSpeed.Current = v end
end)

MakeSwitch(wsCard, "Aplicar WalkSpeed", 110, false, function(v)
    if v then
        ApplyWalkSpeed(Config.WalkSpeed.Current)
        Notify("WalkSpeed: " .. Config.WalkSpeed.Current, GRN)
    else
        ResetWalkSpeed()
        Notify("WalkSpeed restaurado", RED)
    end
end)

local flyCard = MakeCard(PageMovement, "Fly", 200)
flyCard.Position = UDim2.new(0, 4, 0, 200)

MakeSlider(flyCard, "Velocidade do Voo", 36, 10, 200, Config.Fly.DefaultSpeed, function(v)
    Config.Fly.Speed = v
end)

local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(1, -28, 0, IS_MOBILE and 42 or 34)
flyBtn.Position = UDim2.new(0, 14, 0, 110)
flyBtn.BackgroundColor3 = LINE
flyBtn.Text = "Ativar Fly"
flyBtn.TextColor3 = WH
flyBtn.Font = Enum.Font.GothamBold
flyBtn.TextSize = IS_MOBILE and 13 or 12
flyBtn.ZIndex = 55
flyBtn.Parent = flyCard
corner(flyBtn, 8)

flyBtn.MouseButton1Click:Connect(function()
    if Config.Fly.Enabled then
        StopFly()
        flyBtn.Text = "Ativar Fly"
        tween(flyBtn, {BackgroundColor3 = LINE}, 0.2)
        Notify("Fly desativado", RED)
    else
        StartFly()
        if Config.Fly.Enabled then
            flyBtn.Text = "Desativar Fly"
            tween(flyBtn, {BackgroundColor3 = TC}, 0.2)
            Notify("Fly ativado", GRN)
        else
            Notify("Falha ao ativar Fly", RED)
        end
    end
end)

local hint = Instance.new("TextLabel")
hint.Size = UDim2.new(1, -28, 0, 24)
hint.Position = UDim2.new(0, 14, 0, 154)
hint.BackgroundTransparency = 1
hint.Text = IS_MOBILE and "Joystick move • ▲/▼ sobe/desce" or "WASD move • Space sobe • Ctrl desce"
hint.TextColor3 = DIM
hint.Font = Enum.Font.Gotham
hint.TextSize = 10
hint.TextXAlignment = Enum.TextXAlignment.Left
hint.ZIndex = 55
hint.Parent = flyCard

local aimCard = MakeCard(PageMovement, "Aimbot", 260)
aimCard.Position = UDim2.new(0, 4, 0, 410)

MakeSwitch(aimCard, "Ativar Aimbot", 36, Config.Aimbot.Enabled, function(v)
    Config.Aimbot.Enabled = v
    if v then StartAimbot() else StopAimbot() end
    Notify("Aimbot " .. (v and "ativado" or "desativado"), v and GRN or RED)
end)

MakeSwitch(aimCard, "Modo Rage", 80, false, function(v)
    Config.Aimbot.Mode = v and "Rage" or "Legit"
end)

MakeSlider(aimCard, "FOV", 124, 20, 400, Config.Aimbot.FOV, function(v)
    Config.Aimbot.FOV = v
end)

MakeSlider(aimCard, "Alcance", 186, 50, 1000, Config.Aimbot.Distance, function(v)
    Config.Aimbot.Distance = v
end)

PageMovement.CanvasSize = UDim2.new(0, 0, 0, 700)

-- ============================================================
-- ABA TELEPORTE
-- ============================================================
local tpCard = MakeCard(PageTeleport, "Teleporte por Papel", 240)
tpCard.Position = UDim2.new(0, 4, 0, 0)

MakeButton(tpCard, "🔴 Murderer", 40, RoleColors.Murderer, TeleportToMurderer)
MakeButton(tpCard, "🔵 Sheriff", 92, RoleColors.Sheriff, TeleportToSheriff)
MakeButton(tpCard, "🟢 Innocent", 144, RoleColors.Innocent, TeleportToInnocent)

MakeButton(tpCard, "🎲 Aleatório", 196, TC, function()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(list, p) end
    end
    if #list == 0 then Notify("Sem jogadores", RED); return end
    TeleportToPlayer(list[math.random(1, #list)].Name)
end)

local tpListCard = MakeCard(PageTeleport, "Escolher Jogador", 260)
tpListCard.Position = UDim2.new(0, 4, 0, 250)

local tpList = Instance.new("ScrollingFrame")
tpList.Size = UDim2.new(1, -20, 0, 200)
tpList.Position = UDim2.new(0, 10, 0, 40)
tpList.BackgroundTransparency = 1
tpList.BorderSizePixel = 0
tpList.ScrollBarThickness = 4
tpList.ScrollBarImageColor3 = TC
tpList.CanvasSize = UDim2.new(0, 0, 0, 0)
tpList.ZIndex = 54
tpList.Parent = tpListCard

local function RefreshTPList()
    for _, c in ipairs(tpList:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    local y = 0
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        local role = GetPlayerRole(p)
        local color = RoleColors[role] or DIM
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -8, 0, IS_MOBILE and 42 or 34)
        btn.Position = UDim2.new(0, 4, 0, y)
        btn.BackgroundColor3 = BG
        btn.Text = ""
        btn.ZIndex = 55
        btn.Parent = tpList
        corner(btn, 6)
        stroke(btn, color, 1)

        local nl = Instance.new("TextLabel")
        nl.Size = UDim2.new(1, -80, 1, 0)
        nl.Position = UDim2.new(0, 12, 0, 0)
        nl.BackgroundTransparency = 1
        nl.Text = p.Name
        nl.TextColor3 = color
        nl.Font = Enum.Font.GothamMedium
        nl.TextSize = 12
        nl.TextXAlignment = Enum.TextXAlignment.Left
        nl.ZIndex = 56
        nl.Parent = btn

        local rl = Instance.new("TextLabel")
        rl.Size = UDim2.new(0, 70, 1, 0)
        rl.Position = UDim2.new(1, -76, 0, 0)
        rl.BackgroundTransparency = 1
        rl.Text = role
        rl.TextColor3 = color
        rl.Font = Enum.Font.GothamBold
        rl.TextSize = 10
        rl.TextXAlignment = Enum.TextXAlignment.Right
        rl.ZIndex = 56
        rl.Parent = btn

        btn.MouseButton1Click:Connect(function() TeleportToPlayer(p.Name) end)
        y = y + (IS_MOBILE and 48 or 40)
    end
    tpList.CanvasSize = UDim2.new(0, 0, 0, y + 10)
end

task.spawn(function()
    while true do
        task.wait(1)
        if PageTeleport.Visible then RefreshTPList() end
    end
end)

PageTeleport.CanvasSize = UDim2.new(0, 0, 0, 530)

-- ============================================================
-- ABA NOCLIP
-- ============================================================
local noclipCard = MakeCard(PageNoclip, "Noclip", 190)
noclipCard.Position = UDim2.new(0, 4, 0, 0)

MakeSwitch(noclipCard, "Ativar Noclip", 36, false, function(v)
    if v then StartNoclip() else StopNoclip() end
end)

local noclipDesc = Instance.new("TextLabel")
noclipDesc.Size = UDim2.new(1, -28, 0, 80)
noclipDesc.Position = UDim2.new(0, 14, 0, 90)
noclipDesc.BackgroundTransparency = 1
noclipDesc.Text = "Atravessa paredes, chão e objetos.\nO personagem continua caindo se não\nhouver base — use o Fly junto."
noclipDesc.TextColor3 = DIM
noclipDesc.Font = Enum.Font.Gotham
noclipDesc.TextSize = 11
noclipDesc.TextWrapped = true
noclipDesc.TextXAlignment = Enum.TextXAlignment.Left
noclipDesc.TextYAlignment = Enum.TextYAlignment.Top
noclipDesc.ZIndex = 55
noclipDesc.Parent = noclipCard

local noclipWarnCard = MakeCard(PageNoclip, "⚠️ Aviso", 100)
noclipWarnCard.Position = UDim2.new(0, 4, 0, 200)
stroke(noclipWarnCard, RED, 1)

local noclipWarn = Instance.new("TextLabel")
noclipWarn.Size = UDim2.new(1, -28, 0, 60)
noclipWarn.Position = UDim2.new(0, 14, 0, 36)
noclipWarn.BackgroundTransparency = 1
noclipWarn.Text = "Não use durante rodadas ativas do MM2.\nO servidor pode detectar e te kickar."
noclipWarn.TextColor3 = RED
noclipWarn.Font = Enum.Font.GothamMedium
noclipWarn.TextSize = 11
noclipWarn.TextWrapped = true
noclipWarn.TextXAlignment = Enum.TextXAlignment.Left
noclipWarn.TextYAlignment = Enum.TextYAlignment.Top
noclipWarn.ZIndex = 55
noclipWarn.Parent = noclipWarnCard

PageNoclip.CanvasSize = UDim2.new(0, 0, 0, 320)

-- ============================================================
-- BOTÃO DE PÂNICO
-- ============================================================
local PanicBtn = Instance.new("TextButton")
PanicBtn.Size = IS_MOBILE and UDim2.new(0, 200, 0, 42) or UDim2.new(0, 170, 0, 34)
PanicBtn.Position = IS_MOBILE and UDim2.new(1, -212, 1, -50) or UDim2.new(1, -182, 1, -44)
PanicBtn.BackgroundColor3 = RED
PanicBtn.Text = "⛔ DESATIVAR TUDO"
PanicBtn.TextColor3 = WH
PanicBtn.Font = Enum.Font.GothamBold
PanicBtn.TextSize = IS_MOBILE and 12 or 11
PanicBtn.ZIndex = 60
PanicBtn.Parent = Main
corner(PanicBtn, 8)

PanicBtn.MouseButton1Click:Connect(function()
    Config.ESP.Enabled = false
    StopFly()
    StopNoclip()
    StopAimbot()
    ResetWalkSpeed()
    for _, e in pairs(ESPObjects) do HideAllESP(e) end
    Notify("Tudo desativado", RED)
end)

-- ============================================================
-- RESPAWN
-- ============================================================
LocalPlayer.CharacterAdded:Connect(function()
    StopFly()
    StopNoclip()
    flyBtn.Text = "Ativar Fly"
    flyBtn.BackgroundColor3 = LINE
    if Config.WalkSpeed.Enabled then
        task.wait(0.5)
        ApplyWalkSpeed(Config.WalkSpeed.Current)
    end
end)

-- ============================================================
-- INICIALIZAÇÃO
-- ============================================================
SwitchTab(PageESP, TabESP, 0)
RefreshPlayerList()
RefreshTPList()
print("[MM2 Hub v4] Carregado com sucesso.")
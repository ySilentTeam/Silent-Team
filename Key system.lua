
local MENU_URL = "https://raw.githubusercontent.com/ySilentTeam/Silent-Team/refs/heads/main/menu.lua.txt"

-- 🔑 KEYS ATIVAS (revogue apagando a linha)
local KEYS_VALIDAS = {
    ["SILENT-A1B2C3D4E5F6"] = true,
    ["SILENT-G7H8I9J0K1L2"] = true,
    ["SILENT-M3N4O5P6Q7R8"] = true,
    ["SILENT-S9T0U1V2W3X4"] = true,
    ["SILENT-Y5Z6A7B8C9D0"] = true,
    ["SILENT-E1F2G3H4I5J6"] = true,
    ["SILENT-K7L8M9N0O1P2"] = true,
    ["SILENT-Q3R4S5T6U7V8"] = true,
    ["SILENT-W9X0Y1Z2A3B4"] = true,
    ["SILENT-C5D6E7F8G9H0"] = true,
}

local Players      = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS          = game:GetService("UserInputService")
local playerGui    = Players.LocalPlayer:WaitForChild("PlayerGui")

local TC  = Color3.fromRGB(255,255,255)
local BG  = Color3.fromRGB(7,7,7)
local BG3 = Color3.fromRGB(24,24,24)

local gate = Instance.new("ScreenGui")
gate.Name = "SilentTeam_KeyGate"
gate.ResetOnSpawn = false
gate.IgnoreGuiInset = true
gate.Parent = playerGui

local blur = Instance.new("BlurEffect")
blur.Size = 12
blur.Parent = workspace.CurrentCamera

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 220)
frame.Position = UDim2.new(0.5, -200, 0.5, -110)
frame.BackgroundColor3 = BG
frame.BorderSizePixel = 0
frame.Parent = gate
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)
local stroke = Instance.new("UIStroke"); stroke.Color = TC; stroke.Thickness = 1.5; stroke.Parent = frame

-- Arrastar
local dragging, dragStart, startPos
frame.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = i.Position; startPos = frame.Position
    end
end)
UIS.InputChanged:Connect(function(i)
    if not dragging then return end
    if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
        local d = i.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 34)
title.Position = UDim2.new(0, 0, 0, 18)
title.BackgroundTransparency = 1
title.Text = "SILENT TEAM | ACESSO"
title.TextColor3 = TC
title.Font = Enum.Font.GothamBlack
title.TextSize = 20
title.Parent = frame

local sub = Instance.new("TextLabel")
sub.Size = UDim2.new(1, 0, 0, 20)
sub.Position = UDim2.new(0, 0, 0, 52)
sub.BackgroundTransparency = 1
sub.Text = "Digite sua key de acesso"
sub.TextColor3 = Color3.fromRGB(160,160,160)
sub.Font = Enum.Font.Gotham
sub.TextSize = 12
sub.Parent = frame

local box = Instance.new("TextBox")
box.Size = UDim2.new(0.85, 0, 0, 42)
box.Position = UDim2.new(0.075, 0, 0, 86)
box.BackgroundColor3 = BG3
box.Text = ""
box.PlaceholderText = "SILENT-XXXXXXXXXXXX"
box.PlaceholderColor3 = Color3.fromRGB(120,120,120)
box.TextColor3 = TC
box.Font = Enum.Font.Gotham
box.TextSize = 15
box.ClearTextOnFocus = false
box.TextXAlignment = Enum.TextXAlignment.Center
box.Parent = frame
Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)
local bs = Instance.new("UIStroke"); bs.Color = Color3.fromRGB(75,75,75); bs.Parent = box

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0.85, 0, 0, 40)
btn.Position = UDim2.new(0.075, 0, 0, 138)
btn.BackgroundColor3 = TC
btn.Text = "VERIFICAR"
btn.TextColor3 = BG
btn.Font = Enum.Font.GothamBlack
btn.TextSize = 15
btn.AutoButtonColor = false
btn.Parent = frame
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 24)
status.Position = UDim2.new(0, 0, 0, 186)
status.BackgroundTransparency = 1
status.Text = ""
status.TextColor3 = Color3.fromRGB(255,90,90)
status.Font = Enum.Font.Gotham
status.TextSize = 12
status.Parent = frame

local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0, 20)
footer.Position = UDim2.new(0, 0, 1, -26)
footer.BackgroundTransparency = 1
footer.Text = "Silent Team © 2026"
footer.TextColor3 = Color3.fromRGB(120,120,120)
footer.Font = Enum.Font.Gotham
footer.TextSize = 10
footer.Parent = frame

btn.MouseButton1Click:Connect(function()
    local key = box.Text:gsub("%s+", "")
    if KEYS_VALIDAS[key] then
        status.TextColor3 = Color3.fromRGB(100,255,140)
        status.Text = "Acesso liberado! Carregando..."
        task.wait(0.6)
        gate:Destroy()
        blur:Destroy()
        local ok, src = pcall(function() return game:HttpGet(MENU_URL) end)
        if ok and src and #src > 100 then
            local fn = loadstring(src)
            if fn then pcall(fn) end
        end
    else
        status.TextColor3 = Color3.fromRGB(255,90,90)
        status.Text = "Key inválida."
        local p = frame.Position
        for _ = 1, 4 do
            frame.Position = p + UDim2.new(0, 8, 0, 0); task.wait(0.03)
            frame.Position = p - UDim2.new(0, 8, 0, 0); task.wait(0.03)
        end
        frame.Position = p
    end
end)

box.FocusLost:Connect(function(enter)
    if enter then btn:Fire("MouseButton1Click") end
end)

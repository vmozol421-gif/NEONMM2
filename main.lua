-- NEON MM2 PRO | Mobile UI
-- Purple skull theme | Draggable interface

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")

local old = pg:FindFirstChild("NeonMM2Pro")
if old then old:Destroy() end

local purple = Color3.fromRGB(155, 35, 255)
local pink = Color3.fromRGB(230, 35, 255)
local panelColor = Color3.fromRGB(15, 10, 22)
local buttonColor = Color3.fromRGB(37, 24, 52)
local white = Color3.fromRGB(245, 240, 255)

local gui = Instance.new("ScreenGui")
gui.Name = "NeonMM2Pro"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.Parent = pg

local function corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = obj
end

local function stroke(obj, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness or 1.5
    s.Parent = obj
end

local function makeDraggable(obj, handle)
    handle = handle or obj
    local dragging = false
    local startPos, startInput, originalPos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startInput = input.Position
            originalPos = obj.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            local delta = input.Position - startInput
            obj.Position = UDim2.new(
                originalPos.X.Scale,
                originalPos.X.Offset + delta.X,
                originalPos.Y.Scale,
                originalPos.Y.Offset + delta.Y
            )
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

local panel = Instance.new("Frame")
panel.Name = "MainPanel"
panel.Size = UDim2.new(0.84, 0, 0, 390)
panel.Position = UDim2.new(0.08, 0, 0.2, 0)
panel.BackgroundColor3 = panelColor
panel.BorderSizePixel = 0
panel.ClipsDescendants = true
panel.Parent = gui
corner(panel, 25)
stroke(panel, purple, 2)

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 12, 42)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(9, 8, 17))
})
gradient.Rotation = 35
gradient.Parent = panel

local header = Instance.new("TextButton")
header.Size = UDim2.new(1, -20, 0, 58)
header.Position = UDim2.new(0, 10, 0, 8)
header.BackgroundColor3 = buttonColor
header.Text = "☠  NEON MM2 PRO"
header.TextColor3 = pink
header.TextSize = 22
header.Font = Enum.Font.GothamBlack
header.Parent = panel
corner(header, 17)
makeDraggable(panel, header)

local collapse = Instance.new("TextButton")
collapse.Size = UDim2.new(0, 43, 0, 43)
collapse.Position = UDim2.new(1, -55, 0, 15)
collapse.BackgroundColor3 = purple
collapse.Text = "−"
collapse.TextColor3 = white
collapse.TextSize = 28
collapse.Font = Enum.Font.GothamBold
collapse.Parent = panel
corner(collapse, 14)

local content = Instance.new("Frame")
content.Position = UDim2.new(0, 13, 0, 77)
content.Size = UDim2.new(1, -26, 1, -90)
content.BackgroundTransparency = 1
content.Parent = panel

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0, 9)
list.SortOrder = Enum.SortOrder.LayoutOrder
list.Parent = content

local function makeButton(text, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 49)
    b.BackgroundColor3 = buttonColor
    b.Text = text
    b.TextColor3 = white
    b.TextSize = 16
    b.Font = Enum.Font.GothamSemibold
    b.AutoButtonColor = false
    b.Parent = content
    corner(b, 15)
    stroke(b, Color3.fromRGB(77, 43, 100), 1)

    b.Activated:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.12), {
            BackgroundColor3 = purple
        }):Play()
        task.delay(0.2, function()
            if b.Parent then
                b.BackgroundColor3 = buttonColor
            end
        end)
        if callback then callback() end
    end)
    return b
end

local espEnabled = false

makeButton("ESP : OFF", function()
    espEnabled = not espEnabled
    -- Visual toggle only; connect your own permitted ESP implementation.
end)

makeButton("REFRESH ESP", function()
    -- Refresh hook goes here.
end)

makeButton("EMOTES", function()
    -- Opens supported emote controls.
end)

makeButton("SIZE  +", function()
    panel.Size = UDim2.new(
        panel.Size.X.Scale,
        panel.Size.X.Offset,
        0,
        math.min(panel.Size.Y.Offset + 25, 520)
    )
end)

makeButton("SIZE  −", function()
    panel.Size = UDim2.new(
        panel.Size.X.Scale,
        panel.Size.X.Offset,
        0,
        math.max(panel.Size.Y.Offset - 25, 230)
    )
end)

local collapsed = false
collapse.Activated:Connect(function()
    collapsed = not collapsed
    content.Visible = not collapsed
    collapse.Text = collapsed and "+" or "−"
    panel.Size = collapsed
        and UDim2.new(0.84, 0, 0, 70)
        or UDim2.new(0.84, 0, 0, 390)
end)

-- Floating draggable buttons
local function floatingButton(text, x, y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 66, 0, 58)
    b.Position = UDim2.new(x, 0, y, 0)
    b.BackgroundColor3 = panelColor
    b.Text = text
    b.TextColor3 = white
    b.TextSize = 13
    b.Font = Enum.Font.GothamBold
    b.Parent = gui
    corner(b, 16)
    stroke(b, purple, 2)
    makeDraggable(b)
    return b
end

local menuIcon = floatingButton("☠", 0.03, 0.42)
menuIcon.Activated:Connect(function()
    panel.Visible = not panel.Visible
end)

floatingButton("JUMP", 0.80, 0.72).Activated:Connect(function()
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Jump = true
    end
end)

floatingButton("ACTION", 0.80, 0.61)

print("NEON MM2 PRO UI loaded")

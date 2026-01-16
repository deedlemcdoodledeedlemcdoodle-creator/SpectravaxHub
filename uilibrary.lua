-- Modern Mobile UI Library | LocalScript
-- Fully mobile-friendly, draggable, touch-optimized, theme-support
-- Default window: 360x640 px

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- UI Folder
local UIFolder = PlayerGui:FindFirstChild("ModernUI") or Instance.new("Folder")
UIFolder.Name = "ModernUI"
UIFolder.Parent = PlayerGui

-- Optional Blur
local enableBlur = true
if enableBlur then
    local Blur = Instance.new("BlurEffect")
    Blur.Size = 15
    Blur.Parent = game.Lighting
end

-- ==================== THEME ====================
local Theme = {
    Background = Color3.fromRGB(30,30,30),
    Stroke = Color3.fromRGB(60,60,60),
    Button = Color3.fromRGB(50,50,50),
    ButtonHover = Color3.fromRGB(70,70,70),
    ToggleActive = Color3.fromRGB(0,200,150),
    ToggleInactive = Color3.fromRGB(70,70,70),
    Text = Color3.fromRGB(255,255,255),
    SliderTrack = Color3.fromRGB(100,100,100),
    SliderFill = Color3.fromRGB(0,200,150),
    InputBackground = Color3.fromRGB(40,40,40)
}

-- ==================== LIBRARY TABLE ====================
local UI = {}

-- ==================== UTILITY ====================
local function CreateUICorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,radius or 10)
    c.Parent = parent
end

local function Tween(obj, props, time)
    TweenService:Create(obj, TweenInfo.new(time or 0.2), props):Play()
end

-- ==================== WINDOW ====================
function UI:CreateWindow(title, width, height)
    width = width or 360
    height = height or 640

    local Window = Instance.new("Frame")
    Window.Name = title
    Window.Size = UDim2.new(0,width,0,height)
    Window.Position = UDim2.fromScale(0.5,0.5)
    Window.AnchorPoint = Vector2.new(0.5,0.5)
    Window.BackgroundColor3 = Theme.Background
    Window.ClipsDescendants = true
    Window.Parent = UIFolder

    CreateUICorner(Window,15)

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Theme.Stroke
    Stroke.Thickness = 2
    Stroke.Parent = Window

    -- Dragging
    local dragging, dragInput, mousePos, framePos = false
    local function update(input)
        local delta = input.Position - mousePos
        Window.Position = UDim2.new(0, framePos.X + delta.X, 0, framePos.Y + delta.Y)
    end

    Window.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = Vector2.new(Window.Position.X.Offset,Window.Position.Y.Offset)
            input.Changed:Connect(function()
                if input.UserInputState==Enum.UserInputState.End then dragging=false end
            end)
        end
    end)
    Window.InputChanged:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then update(dragInput) end
    end)

    -- Title
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1,-20,0,50)
    TitleLabel.Position = UDim2.new(0,10,0,10)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Theme.Text
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 24
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Window

    -- Scrollable Content
    local Content = Instance.new("ScrollingFrame")
    Content.Size = UDim2.new(1,-20,1,-70)
    Content.Position = UDim2.new(0,10,0,60)
    Content.BackgroundTransparency = 1
    Content.ScrollBarThickness = 6
    Content.CanvasSize = UDim2.new(0,0,0,0)
    Content.Parent = Window

    local Layout = Instance.new("UIListLayout")
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0,8)
    Layout.Parent = Content
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Content.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y+10)
    end)

    -- Return window object
    return {
        Window=Window,
        Content=Content,
        Destroy=function() Window:Destroy() end
    }
end

-- ==================== BUTTON ====================
function UI:CreateButton(parent,text,callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1,0,0,40)
    Button.BackgroundColor3 = Theme.Button
    Button.TextColor3 = Theme.Text
    Button.Text = text
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 20
    Button.Parent = parent
    CreateUICorner(Button,10)

    -- Touch highlight
    Button.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
            Tween(Button,{BackgroundColor3=Theme.ButtonHover})
        end
    end)
    Button.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
            Tween(Button,{BackgroundColor3=Theme.Button})
            callback()
        end
    end)
end

-- ==================== TOGGLE ====================
function UI:CreateToggle(parent,text,default,callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1,0,0,40)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.75,0,1,0)
    Label.BackgroundTransparency = 1
    Label.Text=text
    Label.Font=Enum.Font.Gotham
    Label.TextSize=20
    Label.TextColor3=Theme.Text
    Label.Parent = Frame

    local Toggle = Instance.new("Frame")
    Toggle.Size=UDim2.new(0,50,0,25)
    Toggle.Position=UDim2.new(0.85,0,0.5,-12)
    Toggle.BackgroundColor3=default and Theme.ToggleActive or Theme.ToggleInactive
    Toggle.AnchorPoint=Vector2.new(0.5,0.5)
    Toggle.Parent=Frame
    CreateUICorner(Toggle,12)

    local Circle=Instance.new("Frame")
    Circle.Size=UDim2.new(0,20,0,20)
    Circle.Position=default and UDim2.new(0.75,0,0.5,-10) or UDim2.new(0.25,0,0.5,-10)
    Circle.BackgroundColor3=Theme.Text
    Circle.AnchorPoint=Vector2.new(0.5,0.5)
    Circle.Parent=Toggle
    CreateUICorner(Circle,12)

    local toggled = default
    Frame.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
            toggled = not toggled
            Tween(Circle,{Position = toggled and UDim2.new(0.75,0,0.5,-10) or UDim2.new(0.25,0,0.5,-10)})
            Tween(Toggle,{BackgroundColor3 = toggled and Theme.ToggleActive or Theme.ToggleInactive})
            callback(toggled)
        end
    end)
end

-- ==================== DROPDOWN ====================
function UI:CreateDropdown(parent,labelText,options,callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1,0,0,40)
    Frame.BackgroundTransparency=1
    Frame.Parent = parent

    local Label=Instance.new("TextLabel")
    Label.Size=UDim2.new(0.5,0,1,0)
    Label.BackgroundTransparency=1
    Label.Text=labelText
    Label.TextColor3=Theme.Text
    Label.Font=Enum.Font.Gotham
    Label.TextSize=20
    Label.Parent=Frame

    local Button = Instance.new("TextButton")
    Button.Size=UDim2.new(0.45,0,1,0)
    Button.Position=UDim2.new(0.55,0,0,0)
    Button.BackgroundColor3=Theme.Button
    Button.Text="Select"
    Button.TextColor3=Theme.Text
    Button.Font=Enum.Font.Gotham
    Button.TextSize=18
    Button.Parent=Frame
    CreateUICorner(Button,10)

    local OptionsFrame = Instance.new("Frame")
    OptionsFrame.Size=UDim2.new(1,0,0,#options*35)
    OptionsFrame.Position=UDim2.new(0,0,1,5)
    OptionsFrame.BackgroundColor3=Theme.Background
    OptionsFrame.Visible=false
    OptionsFrame.Parent=Frame
    CreateUICorner(OptionsFrame,10)

    local layout=Instance.new("UIListLayout")
    layout.Parent=OptionsFrame
    layout.Padding=UDim.new(0,5)

    for _,opt in ipairs(options) do
        local OptBtn=Instance.new("TextButton")
        OptBtn.Size=UDim2.new(1,0,0,30)
        OptBtn.BackgroundColor3=Theme.Button
        OptBtn.Text=opt
        OptBtn.TextColor3=Theme.Text
        OptBtn.Font=Enum.Font.Gotham
        OptBtn.TextSize=18
        OptBtn.Parent=OptionsFrame
        CreateUICorner(OptBtn,8)

        OptBtn.InputBegan:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
                Button.Text=opt
                OptionsFrame.Visible=false
                callback(opt)
            end
        end)
    end

    Button.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
            OptionsFrame.Visible=not OptionsFrame.Visible
        end
    end)
end

-- ==================== SLIDER ====================
function UI:CreateSlider(parent,labelText,min,max,default,callback)
    local Frame = Instance.new("Frame")
    Frame.Size=UDim2.new(1,0,0,40)
    Frame.BackgroundTransparency=1
    Frame.Parent=parent

    local Label=Instance.new("TextLabel")
    Label.Size=UDim2.new(0.4,0,1,0)
    Label.BackgroundTransparency=1
    Label.Text=labelText
    Label.TextColor3=Theme.Text
    Label.Font=Enum.Font.Gotham
    Label.TextSize=20
    Label.Parent=Frame

    local Slider=Instance.new("Frame")
    Slider.Size=UDim2.new(0.55,0,0,10)
    Slider.Position=UDim2.new(0.45,0,0.5,-5)
    Slider.BackgroundColor3=Theme.SliderTrack
    Slider.Parent=Frame
    CreateUICorner(Slider,5)

    local Fill=Instance.new("Frame")
    Fill.Size=UDim2.new((default-min)/(max-min),0,1,0)
    Fill.BackgroundColor3=Theme.SliderFill
    Fill.Parent=Slider
    CreateUICorner(Fill,5)

    local dragging=false
    Slider.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging=true
        end
    end)
    Slider.InputEnded:Connect(function(input)
        dragging=false
    end)
    Slider.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
            local relX=input.Position.X-Slider.AbsolutePosition.X
            relX=math.clamp(relX,0,Slider.AbsoluteSize.X)
            Fill.Size=UDim2.new(relX/Slider.AbsoluteSize.X,0,1,0)
            local value=min + (max-min)*(relX/Slider.AbsoluteSize.X)
            callback(value)
        end
    end)
end

-- ==================== INPUT BOX ====================
function UI:CreateInput(parent,labelText,placeholder,callback)
    local Frame = Instance.new("Frame")
    Frame.Size=UDim2.new(1,0,0,40)
    Frame.BackgroundTransparency=1
    Frame.Parent=parent

    local Label=Instance.new("TextLabel")
    Label.Size=UDim2.new(0.35,0,1,0)
    Label.BackgroundTransparency=1
    Label.Text=labelText
    Label.TextColor3=Theme.Text
    Label.Font=Enum.Font.Gotham
    Label.TextSize=20
    Label.Parent=Frame

    local TextBox=Instance.new("TextBox")
    TextBox.Size=UDim2.new(0.6,0,0.8,0)
    TextBox.Position=UDim2.new(0.4,0,0.1,0)
    TextBox.BackgroundColor3=Theme.InputBackground
    TextBox.PlaceholderText=placeholder
    TextBox.TextColor3=Theme.Text
    TextBox.Font=Enum.Font.Gotham
    TextBox.TextSize=18
    TextBox.Parent=Frame
    CreateUICorner(TextBox,8)

    TextBox.FocusLost:Connect(function()
        callback(TextBox.Text)
    end)
end

-- ==================== THEME SWITCH ====================
function UI:SetTheme(newTheme)
    for k,v in pairs(newTheme) do
        if Theme[k]~=nil then Theme[k]=v end
    end
end

-- ==================== RETURN LIBRARY ====================
return UI
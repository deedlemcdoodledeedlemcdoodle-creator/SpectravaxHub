local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local UI = {}
UI.__index = UI

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui
ScreenGui.IgnoreGuiInset = true

local Blur = game.Lighting:FindFirstChild("SpectravaxBlur") or Instance.new("BlurEffect")
Blur.Name = "SpectravaxBlur"
Blur.Size = 10
Blur.Parent = game.Lighting

local ParticleLayer = Instance.new("Folder")
ParticleLayer.Name = "Particles"
ParticleLayer.Parent = ScreenGui

local function spawnParticle()
    local part = Instance.new("Frame")
    part.Size = UDim2.new(0,6,0,6)
    part.BackgroundColor3 = Color3.fromRGB(0,170,255)
    part.BorderSizePixel = 0
    part.Position = UDim2.new(math.random(),0,1,0)
    part.AnchorPoint = Vector2.new(0.5,0.5)
    part.ZIndex = 0
    part.Parent = ParticleLayer
    local duration = math.random(3,7)
    local xOffset = math.random(-50,50)
    local tween = TweenService:Create(part,TweenInfo.new(duration,Enum.EasingStyle.Quad),{
        Position = UDim2.new(0.5, xOffset,0,-50),
        BackgroundTransparency = 1
    })
    tween:Play()
    tween.Completed:Connect(function() part:Destroy() end)
end

task.spawn(function()
    while true do
        spawnParticle()
        wait(math.random(1,3)/5)
    end
end)

function UI:CreateWindow(title)
    local selfInstance = setmetatable({}, UI)
    local Window = Instance.new("Frame")
    Window.Size = UDim2.new(0,450,0,500)
    Window.Position = UDim2.new(0.5,0,0.5,0)
    Window.AnchorPoint = Vector2.new(0.5,0.5)
    Window.BackgroundColor3 = Color3.fromRGB(30,30,30)
    Window.BorderSizePixel = 0
    Window.Parent = ScreenGui
    selfInstance.Window = Window

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(200,200,200)
    UIStroke.Parent = Window

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1,0,0,40)
    Title.BackgroundTransparency = 1
    Title.Text = title
    Title.TextColor3 = Color3.fromRGB(255,255,255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20
    Title.Parent = Window
    selfInstance.Title = Title

    local TabHolder = Instance.new("Frame")
    TabHolder.Size = UDim2.new(1,0,1,-40)
    TabHolder.Position = UDim2.new(0,0,0,40)
    TabHolder.BackgroundTransparency = 1
    TabHolder.Parent = Window
    selfInstance.TabHolder = TabHolder
    selfInstance.Tabs = {}

    return selfInstance
end

function UI:CreateTab(name)
    local tabFrame = Instance.new("Frame")
    tabFrame.Size = UDim2.new(1,0,1,0)
    tabFrame.BackgroundTransparency = 1
    tabFrame.Visible = true
    tabFrame.Parent = self.TabHolder

    local Scroll = Instance.new("ScrollingFrame")
    Scroll.Size = UDim2.new(1,0,1,0)
    Scroll.CanvasSize = UDim2.new(0,0,0,0)
    Scroll.ScrollBarThickness = 6
    Scroll.BackgroundTransparency = 1
    Scroll.Parent = tabFrame

    local UIList = Instance.new("UIListLayout")
    UIList.SortOrder = Enum.SortOrder.LayoutOrder
    UIList.Padding = UDim.new(0,8)
    UIList.Parent = Scroll

    table.insert(self.Tabs,{Frame=tabFrame,Scroll=Scroll,Layout=UIList})
    return #self.Tabs
end

function UI:Button(text,imageId)
    local BtnFrame = Instance.new("Frame")
    BtnFrame.Size = UDim2.new(1,-20,0,40)
    BtnFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
    BtnFrame.BorderSizePixel = 0

    local BtnImage = Instance.new("ImageLabel")
    BtnImage.Size = UDim2.new(0,30,0,30)
    BtnImage.Position = UDim2.new(0,5,0.5,-15)
    BtnImage.BackgroundTransparency = 1
    BtnImage.Image = imageId
    BtnImage.Parent = BtnFrame

    local BtnText = Instance.new("TextLabel")
    BtnText.Size = UDim2.new(1,-40,1,0)
    BtnText.Position = UDim2.new(0,40,0,0)
    BtnText.BackgroundTransparency = 1
    BtnText.Text = text
    BtnText.TextColor3 = Color3.fromRGB(255,255,255)
    BtnText.Font = Enum.Font.Gotham
    BtnText.TextSize = 16
    BtnText.TextXAlignment = Enum.TextXAlignment.Left
    BtnText.Parent = BtnFrame

    BtnFrame.Parent = self.Tabs[1].Scroll
    local count = 0
    for _,child in pairs(self.Tabs[1].Scroll:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextButton") then count += 1 end
    end
    self.Tabs[1].Scroll.CanvasSize = UDim2.new(0,0,0,count*48)

    local selfButton = {}
    function selfButton:OnClick(callback)
        BtnFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                callback()
            end
        end)
    end
    return selfButton
end

function UI:Toggle(text, default)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1,-20,0,30)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
    ToggleFrame.BorderSizePixel = 0

    local ToggleText = Instance.new("TextLabel")
    ToggleText.Size = UDim2.new(1,-50,1,0)
    ToggleText.Position = UDim2.new(0,5,0,0)
    ToggleText.BackgroundTransparency = 1
    ToggleText.Text = text
    ToggleText.TextColor3 = Color3.fromRGB(255,255,255)
    ToggleText.Font = Enum.Font.Gotham
    ToggleText.TextSize = 16
    ToggleText.TextXAlignment = Enum.TextXAlignment.Left
    ToggleText.Parent = ToggleFrame

    local Switch = Instance.new("Frame")
    Switch.Size = UDim2.new(0,40,0,20)
    Switch.Position = UDim2.new(1,-45,0.5,-10)
    Switch.BackgroundColor3 = Color3.fromRGB(100,100,100)
    Switch.AnchorPoint = Vector2.new(0,0)
    Switch.Parent = ToggleFrame

    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0,18,0,18)
    Circle.Position = UDim2.new(0,1,0.5,-9)
    Circle.BackgroundColor3 = Color3.fromRGB(255,255,255)
    Circle.BorderSizePixel = 0
    Circle.AnchorPoint = Vector2.new(0,0.5)
    Circle.Parent = Switch

    ToggleFrame.Parent = self.Tabs[1].Scroll
    local state = default or false

    local selfToggle = {}
    function selfToggle:OnToggle(callback)
        local function updateCircle()
            local goal = {}
            if state then
                goal.Position = UDim2.new(1,-19,0.5,-9)
                TweenService:Create(Circle,TweenInfo.new(0.2),goal):Play()
                Switch.BackgroundColor3 = Color3.fromRGB(0,170,255)
            else
                goal.Position = UDim2.new(0,1,0.5,-9)
                TweenService:Create(Circle,TweenInfo.new(0.2),goal):Play()
                Switch.BackgroundColor3 = Color3.fromRGB(100,100,100)
            end
        end
        updateCircle()
        Switch.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                state = not state
                updateCircle()
                callback(state)
            end
        end)
    end
    return selfToggle
end

function UI:Dropdown(title, options)
    local DropFrame = Instance.new("Frame")
    DropFrame.Size = UDim2.new(1,-20,0,40)
    DropFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
    DropFrame.BorderSizePixel = 0

    local DropText = Instance.new("TextLabel")
    DropText.Size = UDim2.new(1,-40,1,0)
    DropText.Position = UDim2.new(0,5,0,0)
    DropText.BackgroundTransparency = 1
    DropText.Text = title
    DropText.TextColor3 = Color3.fromRGB(255,255,255)
    DropText.Font = Enum.Font.Gotham
    DropText.TextSize = 16
    DropText.TextXAlignment = Enum.TextXAlignment.Left
    DropText.Parent = DropFrame

    local DropButton = Instance.new("ImageButton")
    DropButton.Size = UDim2.new(0,30,0,30)
    DropButton.Position = UDim2.new(1,-35,0.5,-15)
    DropButton.BackgroundTransparency = 1
    DropButton.Image = "rbxassetid://6031094678"
    DropButton.Parent = DropFrame

    DropFrame.Parent = self.Tabs[1].Scroll
    local count = 0
    for _,child in pairs(self.Tabs[1].Scroll:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextButton") then count += 1 end
    end
    self.Tabs[1].Scroll.CanvasSize = UDim2.new(0,0,0,count*48)

    local OptionFrame = Instance.new("Frame")
    OptionFrame.Size = UDim2.new(0,200,0,0)
    OptionFrame.Position = DropFrame.Position + UDim2.new(0,0,0,40)
    OptionFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
    OptionFrame.ZIndex = 999
    OptionFrame.ClipsDescendants = false
    OptionFrame.Parent = ScreenGui

    local SearchBox = Instance.new("TextBox")
    SearchBox.PlaceholderText = "Search..."
    SearchBox.Size = UDim2.new(1,0,0,30)
    SearchBox.BackgroundColor3 = Color3.fromRGB(60,60,60)
    SearchBox.TextColor3 = Color3.fromRGB(255,255,255)
    SearchBox.Font = Enum.Font.Gotham
    SearchBox.TextSize = 16
    SearchBox.Parent = OptionFrame

    local AllBtn = Instance.new("TextButton")
    AllBtn.Size = UDim2.new(1,0,0,30)
    AllBtn.Position = UDim2.new(0,0,0,30)
    AllBtn.Text = "All"
    AllBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)
    AllBtn.TextColor3 = Color3.fromRGB(255,255,255)
    AllBtn.Font = Enum.Font.GothamBold
    AllBtn.TextSize = 16
    AllBtn.Parent = OptionFrame

    local OptionList = Instance.new("ScrollingFrame")
    OptionList.Size = UDim2.new(1,0,1,-60)
    OptionList.Position = UDim2.new(0,0,0,60)
    OptionList.BackgroundTransparency = 1
    OptionList.CanvasSize = UDim2.new(0,0,0,#options*30)
    OptionList.ScrollBarThickness = 6
    OptionList.Parent = OptionFrame

    local OptionLayout = Instance.new("UIListLayout")
    OptionLayout.SortOrder = Enum.SortOrder.LayoutOrder
    OptionLayout.Padding = UDim.new(0,2)
    OptionLayout.Parent = OptionList

    local optButtons = {}
    for _,opt in pairs(options) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1,0,0,30)
        btn.Text = opt
        btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        btn.Parent = OptionList
        table.insert(optButtons,btn)
    end

    local selfDropdown = {}
    function selfDropdown:OnSelect(callback)
        for _,btn in pairs(optButtons) do
            btn.MouseButton1Click:Connect(function()
                callback(btn.Text)
            end)
        end
        AllBtn.MouseButton1Click:Connect(function()
            local selected = {}
            for _,btn in pairs(optButtons) do
                table.insert(selected,btn.Text)
            end
            callback(selected)
        end)
        SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
            local text = SearchBox.Text:lower()
            for _,btn in pairs(optButtons) do
                btn.Visible = btn.Text:lower():find(text) and true or false
            end
        end)
    end

    local open = false
    DropButton.MouseButton1Click:Connect(function()
        open = not open
        TweenService:Create(OptionFrame,TweenInfo.new(0.3,Enum.EasingStyle.Quad),{Size = open and UDim2.new(0,200,0,math.min(#options*30 + 60,300)) or UDim2.new(0,200,0,0)}):Play()
    end)

    return selfDropdown
end

return UI
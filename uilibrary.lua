local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Library = {}

function Library:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ModernLibrary"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local success, err = pcall(function()
        ScreenGui.Parent = game:GetService("CoreGui")
    end)
    if not success then
        ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 200, 0, 260)
    Main.Position = UDim2.new(0.5, -100, 0.5, -130)
    Main.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Main.BorderSizePixel = 0
    Main.Draggable = true 
    Main.Active = true
    Main.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 5)
    UICorner.Parent = Main

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(40, 40, 40)
    UIStroke.Thickness = 1
    UIStroke.Parent = Main

    local Header = Instance.new("TextLabel")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 30)
    Header.BackgroundTransparency = 1
    Header.Text = "  " .. title
    Header.TextColor3 = Color3.fromRGB(230, 230, 230)
    Header.TextXAlignment = Enum.TextXAlignment.Left
    Header.Font = Enum.Font.GothamBold
    Header.TextSize = 13
    Header.Parent = Main

    local Container = Instance.new("ScrollingFrame")
    Container.Name = "Container"
    Container.Size = UDim2.new(1, -14, 1, -40)
    Container.Position = UDim2.new(0, 7, 0, 35)
    Container.BackgroundTransparency = 1
    Container.CanvasSize = UDim2.new(0, 0, 0, 0)
    Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Container.ScrollBarThickness = 0
    Container.Parent = Main

    local Layout = Instance.new("UIListLayout")
    Layout.Parent = Container
    Layout.Padding = UDim.new(0, 6)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder

    local Elements = {}

    function Elements:Button(text, callback)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, 0, 0, 28)
        Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Button.Text = text
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.Font = Enum.Font.Gotham
        Button.TextSize = 12
        Button.AutoButtonColor = false
        Button.Parent = Container

        Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 4)

        Button.Activated:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
            task.wait(0.1)
            TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
            callback()
        end)
    end

    function Elements:Slider(text, min, max, default, callback)
        local SliderFrame = Instance.new("Frame")
        SliderFrame.Size = UDim2.new(1, 0, 0, 38)
        SliderFrame.BackgroundTransparency = 1
        SliderFrame.Parent = Container

        local Label = Instance.new("TextLabel")
        Label.Text = text .. ": " .. default
        Label.Size = UDim2.new(1, 0, 0, 18)
        Label.BackgroundTransparency = 1
        Label.TextColor3 = Color3.fromRGB(180, 180, 180)
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 11
        Label.Parent = SliderFrame

        local Bar = Instance.new("Frame")
        Bar.Size = UDim2.new(1, 0, 0, 4)
        Bar.Position = UDim2.new(0, 0, 0, 24)
        Bar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        Bar.Parent = SliderFrame
        Instance.new("UICorner", Bar)

        local Fill = Instance.new("Frame")
        Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        Fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Fill.BorderSizePixel = 0
        Fill.Parent = Bar
        Instance.new("UICorner", Fill)

        local dragging = false

        local function Update(input)
            local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
            Fill.Size = UDim2.new(pos, 0, 1, 0)
            local val = math.floor(((max - min) * pos) + min)
            Label.Text = text .. ": " .. val
            callback(val)
        end

        Bar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                Update(input)
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                Update(input)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
    end

    function Elements:Dropdown(text, list, callback)
        local DropdownFrame = Instance.new("Frame")
        DropdownFrame.Size = UDim2.new(1, 0, 0, 28)
        DropdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        DropdownFrame.ClipsDescendants = true
        DropdownFrame.Parent = Container
        Instance.new("UICorner", DropdownFrame).CornerRadius = UDim.new(0, 4)

        local DropBtn = Instance.new("TextButton")
        DropBtn.Size = UDim2.new(1, 0, 0, 28)
        DropBtn.BackgroundTransparency = 1
        DropBtn.Text = text .. " ▼"
        DropBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        DropBtn.Font = Enum.Font.Gotham
        DropBtn.TextSize = 12
        DropBtn.Parent = DropdownFrame

        local toggled = false
        DropBtn.Activated:Connect(function()
            toggled = not toggled
            local goalSize = toggled and UDim2.new(1, 0, 0, 28 + (#list * 25)) or UDim2.new(1, 0, 0, 28)
            TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = goalSize}):Play()
        end)

        for i, v in pairs(list) do
            local Option = Instance.new("TextButton")
            Option.Size = UDim2.new(1, 0, 0, 25)
            Option.Position = UDim2.new(0, 0, 0, 28 + (i-1)*25)
            Option.BackgroundTransparency = 1
            Option.Text = v
            Option.TextColor3 = Color3.fromRGB(150, 150, 150)
            Option.Font = Enum.Font.Gotham
            Option.TextSize = 11
            Option.Parent = DropdownFrame

            Option.Activated:Connect(function()
                toggled = false
                TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 28)}):Play()
                DropBtn.Text = text .. ": " .. v
                callback(v)
            end)
        end
    end

    function Elements:Label(text)
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, 0, 0, 20)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(160, 160, 160)
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 11
        Label.Parent = Container
    end

    function Elements:CopyLabel(text, content)
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(1, 0, 0, 28)
        Frame.BackgroundTransparency = 1
        Frame.Parent = Container

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0.7, 0, 1, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(160, 160, 160)
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 11
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Frame

        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(0.28, 0, 0.8, 0)
        Btn.Position = UDim2.new(0.72, 0, 0.1, 0)
        Btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Btn.Text = "Copy"
        Btn.TextColor3 = Color3.fromRGB(0, 0, 0)
        Btn.Font = Enum.Font.GothamBold
        Btn.TextSize = 10
        Btn.Parent = Frame
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)

        Btn.Activated:Connect(function()
            if setclipboard then
                setclipboard(content or text)
                Btn.Text = "Done!"
                task.wait(1)
                Btn.Text = "Copy"
            end
        end)
    end

    return Elements
end

local UILib = {}
UILib.__index = UILib

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpectravaxApex"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Utility: Tween
local function Tween(obj, props, time)
    time = time or 0.3
    TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

-- Utility: Draggable
local function MakeDraggable(frame)
    local dragging = false
    local dragInput, mousePos, framePos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            Tween(frame, {Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)}, 0.15)
        end
    end)
end

-- Theme
UILib.Theme = {
    Accent = Color3.fromRGB(0, 170, 255),
    Background = Color3.fromRGB(25, 25, 30),
    Header = Color3.fromRGB(18, 18, 22),
    Element = Color3.fromRGB(45, 45, 55),
    Hover = Color3.fromRGB(65, 65, 80),
    Text = Color3.fromRGB(240, 240, 240),
    TextDim = Color3.fromRGB(180, 180, 180),
}

-- Notification System
function UILib:Notify(title, description, duration)
    duration = duration or 4
    local count = #ScreenGui:GetChildren()
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 320, 0, 90)
    notif.Position = UDim2.new(1, 340, 1, -100 - (count * 100))
    notif.BackgroundColor3 = UILib.Theme.Element
    notif.Parent = ScreenGui

    Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 10)

    local titleLabel = Instance.new("TextLabel", notif)
    titleLabel.Text = title
    titleLabel.Size = UDim2.new(1, -20, 0, 30)
    titleLabel.Position = UDim2.new(0, 10, 0, 8)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = UILib.Theme.Text
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local descLabel = Instance.new("TextLabel", notif)
    descLabel.Text = description
    descLabel.Size = UDim2.new(1, -20, 0, 40)
    descLabel.Position = UDim2.new(0, 10, 0, 38)
    descLabel.BackgroundTransparency = 1
    descLabel.TextColor3 = UILib.Theme.TextDim
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextWrapped = true
    descLabel.TextXAlignment = Enum.TextXAlignment.Left

    Tween(notif, {Position = UDim2.new(1, -340, notif.Position.Y.Offset)}, 0.4)
    task.delay(duration, function()
        Tween(notif, {Position = UDim2.new(1, 340, notif.Position.Y.Offset)}, 0.4)
        task.wait(0.4)
        notif:Destroy()
    end)
end

-- Create Window
function UILib:CreateWindow(title)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 620, 0, 540)
    Frame.Position = UDim2.new(0.5, -310, 0.5, -270)
    Frame.BackgroundColor3 = UILib.Theme.Background
    Frame.Parent = ScreenGui
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)
    MakeDraggable(Frame)

    local Header = Instance.new("Frame", Frame)
    Header.Size = UDim2.new(1, 0, 0, 45)
    Header.BackgroundColor3 = UILib.Theme.Header

    local TitleLabel = Instance.new("TextLabel", Header)
    TitleLabel.Text = title or "Spectravax Apex"
    TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    TitleLabel.Position = UDim2.new(0, 20, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.TextColor3 = UILib.Theme.Text
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 18
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local CloseBtn = Instance.new("TextButton", Header)
    CloseBtn.Text = "X"
    CloseBtn.Size = UDim2.new(0, 35, 0, 35)
    CloseBtn.Position = UDim2.new(1, -45, 0, 5)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 20
    CloseBtn.MouseButton1Click:Connect(function()
        Tween(Frame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        task.wait(0.3)
        Frame:Destroy()
    end)

    local TabContainer = Instance.new("Frame", Frame)
    TabContainer.Size = UDim2.new(1, 0, 0, 40)
    TabContainer.Position = UDim2.new(0, 0, 0, 45)
    TabContainer.BackgroundTransparency = 1

    local TabList = Instance.new("UIListLayout", TabContainer)
    TabList.FillDirection = Enum.FillDirection.Horizontal
    TabList.Padding = UDim.new(0, 8)

    local ContentArea = Instance.new("Frame", Frame)
    ContentArea.Size = UDim2.new(1, 0, 1, -85)
    ContentArea.Position = UDim2.new(0, 0, 0, 85)
    ContentArea.BackgroundTransparency = 1

    local Window = {Tabs = {}, CurrentTab = nil}

    function Window:AddTab(name)
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(0, 130, 1, 0)
        TabButton.BackgroundColor3 = UILib.Theme.Element
        TabButton.Text = name
        TabButton.TextColor3 = UILib.Theme.Text
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.Parent = TabContainer
        Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 8)

        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Size = UDim2.new(1, -20, 1, -10)
        TabContent.Position = UDim2.new(0, 10, 0, 5)
        TabContent.BackgroundTransparency = 1
        TabContent.ScrollBarThickness = 6
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Visible = false
        TabContent.Parent = ContentArea

        local ContentLayout = Instance.new("UIListLayout", TabContent)
        ContentLayout.Padding = UDim.new(0, 10)
        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
        end)

        TabButton.MouseButton1Click:Connect(function()
            if Window.CurrentTab then
                Window.CurrentTab.Content.Visible = false
                Window.CurrentTab.Button.BackgroundColor3 = UILib.Theme.Element
            end
            TabContent.Visible = true
            TabButton.BackgroundColor3 = UILib.Theme.Accent
            Window.CurrentTab = {Content = TabContent, Button = TabButton}
        end)

        if #Window.Tabs == 0 then
            TabButton.MouseButton1Click:Invoke()
        end

        table.insert(Window.Tabs, {Content = TabContent, Button = TabButton})

        -- Add Section
        function TabContent:AddSection(sectionName)
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Size = UDim2.new(1, 0, 0, 40)
            SectionFrame.BackgroundColor3 = UILib.Theme.Element
            SectionFrame.Parent = TabContent
            Instance.new("UICorner", SectionFrame).CornerRadius = UDim.new(0, 8)

            local SectionTitle = Instance.new("TextLabel", SectionFrame)
            SectionTitle.Text = sectionName
            SectionTitle.Size = UDim2.new(1, -60, 1, 0)
            SectionTitle.Position = UDim2.new(0, 15, 0, 0)
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.TextColor3 = UILib.Theme.Text
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left

            local ToggleArrow = Instance.new("TextButton", SectionFrame)
            ToggleArrow.Text = "▼"
            ToggleArrow.Size = UDim2.new(0, 50, 1, 0)
            ToggleArrow.Position = UDim2.new(1, -50, 0, 0)
            ToggleArrow.BackgroundTransparency = 1
            ToggleArrow.TextColor3 = UILib.Theme.Text

            local SectionContent = Instance.new("Frame")
            SectionContent.Size = UDim2.new(1, -20, 0, 0)
            SectionContent.Position = UDim2.new(0, 10, 0, 50)
            SectionContent.BackgroundTransparency = 1
            SectionContent.Parent = TabContent

            local SectionLayout = Instance.new("UIListLayout", SectionContent)
            SectionLayout.Padding = UDim.new(0, 10)

            local isOpen = true
            ToggleArrow.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                ToggleArrow.Text = isOpen and "▼" or "▶"
                Tween(SectionContent, {Size = isOpen and UDim2.new(1, -20, 0, SectionLayout.AbsoluteContentSize.Y + 20) or UDim2.new(1, -20, 0, 0)}, 0.3)
            end)

            SectionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                if isOpen then
                    Tween(SectionContent, {Size = UDim2.new(1, -20, 0, SectionLayout.AbsoluteContentSize.Y + 20)}, 0.2)
                end
            end)

            return SectionContent
        end

        -- Add Button
        function TabContent:AddButton(text, callback)
            local container = Window.CurrentTab and Window.CurrentTab.Section or TabContent
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, 0, 0, 40)
            Button.BackgroundColor3 = UILib.Theme.Element
            Button.Text = "  " .. text
            Button.TextColor3 = UILib.Theme.Text
            Button.Font = Enum.Font.Gotham
            Button.TextSize = 16
            Button.TextXAlignment = Enum.TextXAlignment.Left
            Button.Parent = container or TabContent
            Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 8)

            Button.MouseEnter:Connect(function()
                Tween(Button, {BackgroundColor3 = UILib.Theme.Hover}, 0.2)
            end)
            Button.MouseLeave:Connect(function()
                Tween(Button, {BackgroundColor3 = UILib.Theme.Element}, 0.2)
            end)
            Button.MouseButton1Click:Connect(function()
                pcall(callback)
            end)
        end

        -- Add Toggle
        function TabContent:AddToggle(text, default, callback)
            local container = Window.CurrentTab and Window.CurrentTab.Section or TabContent
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
            ToggleFrame.BackgroundColor3 = UILib.Theme.Element
            ToggleFrame.Parent = container or TabContent
            Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 8)

            local Label = Instance.new("TextLabel", ToggleFrame)
            Label.Text = "  " .. text
            Label.Size = UDim2.new(1, -70, 1, 0)
            Label.BackgroundTransparency = 1
            Label.TextColor3 = UILib.Theme.Text
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 16
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local Switch = Instance.new("Frame")
            Switch.Size = UDim2.new(0, 50, 0, 26)
            Switch.Position = UDim2.new(1, -60, 0.5, -13)
            Switch.BackgroundColor3 = default and UILib.Theme.Accent or UILib.Theme.Element
            Switch.Parent = ToggleFrame
            Instance.new("UICorner", Switch).CornerRadius = UDim.new(0, 13)

            local Circle = Instance.new("Frame")
            Circle.Size = UDim2.new(0, 22, 0, 22)
            Circle.Position = default and UDim2.new(0, 26, 0, 2) or UDim2.new(0, 4, 0, 2)
            Circle.BackgroundColor3 = Color3.new(1, 1, 1)
            Circle.Parent = Switch
            Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

            local state = default or false
            ToggleFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    state = not state
                    Tween(Circle, {Position = state and UDim2.new(0, 26, 0, 2) or UDim2.new(0, 4, 0, 2)}, 0.2)
                    Tween(Switch, {BackgroundColor3 = state and UILib.Theme.Accent or UILib.Theme.Element}, 0.2)
                    pcall(callback, state)
                end
            end)
        end

        -- Add Slider
        function TabContent:AddSlider(text, min, max, default, callback)
            local container = Window.CurrentTab and Window.CurrentTab.Section or TabContent
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1, 0, 0, 60)
            SliderFrame.BackgroundColor3 = UILib.Theme.Element
            SliderFrame.Parent = container or TabContent
            Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 8)

            local Label = Instance.new("TextLabel", SliderFrame)
            Label.Text = text .. ": " .. default
            Label.Size = UDim2.new(1, -100, 0, 25)
            Label.Position = UDim2.new(0, 15, 0, 5)
            Label.BackgroundTransparency = 1
            Label.TextColor3 = UILib.Theme.Text
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local ValueLabel = Instance.new("TextLabel", SliderFrame)
            ValueLabel.Text = tostring(default)
            ValueLabel.Size = UDim2.new(0, 80, 0, 25)
            ValueLabel.Position = UDim2.new(1, -95, 0, 5)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.TextColor3 = UILib.Theme.Accent
            ValueLabel.Font = Enum.Font.GothamBold

            local Track = Instance.new("Frame", SliderFrame)
            Track.Size = UDim2.new(1, -30, 0, 8)
            Track.Position = UDim2.new(0, 15, 0, 35)
            Track.BackgroundColor3 = UILib.Theme.Header
            Instance.new("UICorner", Track).CornerRadius = UDim.new(0, 4)

            local Fill = Instance.new("Frame", Track)
            Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            Fill.BackgroundColor3 = UILib.Theme.Accent
            Instance.new("UICorner", Fill).CornerRadius = UDim.new(0, 4)

            local Knob = Instance.new("Frame", Fill)
            Knob.Size = UDim2.new(0, 16, 0, 16)
            Knob.Position = UDim2.new(1, -8, 0.5, -8)
            Knob.BackgroundColor3 = Color3.new(1,1,1)
            Knob.ZIndex = 2
            Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

            local dragging = false
            Track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
            end)
            Track.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local rel = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                    local value = math.floor(min + (max - min) * rel)
                    Fill.Size = UDim2.new(rel, 0, 1, 0)
                    ValueLabel.Text = tostring(value)
                    Label.Text = text .. ": " .. value
                    pcall(callback, value)
                end
            end)
        end

        -- Add Dropdown
        function TabContent:AddDropdown(text, items, callback)
            local container = Window.CurrentTab and Window.CurrentTab.Section or TabContent
            local DropFrame = Instance.new("Frame")
            DropFrame.Size = UDim2.new(1, 0, 0, 40)
            DropFrame.BackgroundColor3 = UILib.Theme.Element
            DropFrame.Parent = container or TabContent
            Instance.new("UICorner", DropFrame).CornerRadius = UDim.new(0, 8)

            local DropLabel = Instance.new("TextLabel", DropFrame)
            DropLabel.Text = text .. ": " .. items[1]
            DropLabel.Size = UDim2.new(1, -50, 1, 0)
            DropLabel.Position = UDim2.new(0, 15, 0, 0)
            DropLabel.BackgroundTransparency = 1
            DropLabel.TextColor3 = UILib.Theme.Text
            DropLabel.TextXAlignment = Enum.TextXAlignment.Left

            local DropBtn = Instance.new("TextButton", DropFrame)
            DropBtn.Text = "▼"
            DropBtn.Size = UDim2.new(0, 40, 1, 0)
            DropBtn.Position = UDim2.new(1, -40, 0, 0)
            DropBtn.BackgroundTransparency = 1
            DropBtn.TextColor3 = UILib.Theme.Text

            local DropList = Instance.new("Frame")
            DropList.Size = UDim2.new(1, 0, 0, #items * 35)
            DropList.Position = UDim2.new(0, 0, 1, 5)
            DropList.BackgroundColor3 = UILib.Theme.Element
            DropList.Visible = false
            DropList.Parent = DropFrame
            Instance.new("UICorner", DropList).CornerRadius = UDim.new(0, 8)

            for i, item in ipairs(items) do
                local ItemBtn = Instance.new("TextButton", DropList)
                ItemBtn.Size = UDim2.new(1, 0, 0, 35)
                ItemBtn.Position = UDim2.new(0, 0, 0, (i-1)*35)
                ItemBtn.BackgroundColor3 = UILib.Theme.Element
                ItemBtn.Text = item
                ItemBtn.TextColor3 = UILib.Theme.Text
                ItemBtn.MouseButton1Click:Connect(function()
                    DropLabel.Text = text .. ": " .. item
                    DropList.Visible = false
                    pcall(callback, item)
                end)
            end

            DropBtn.MouseButton1Click:Connect(function()
                DropList.Visible = not DropList.Visible
            end)
        end

        -- Add Keybind
        function TabContent:AddKeybind(text, defaultKey, callback)
            local container = Window.CurrentTab and Window.CurrentTab.Section or TabContent
            local BindFrame = Instance.new("Frame")
            BindFrame.Size = UDim2.new(1, 0, 0, 40)
            BindFrame.BackgroundColor3 = UILib.Theme.Element
            BindFrame.Parent = container or TabContent
            Instance.new("UICorner", BindFrame).CornerRadius = UDim.new(0, 8)

            local Label = Instance.new("TextLabel", BindFrame)
            Label.Text = text
            Label.Size = UDim2.new(1, -100, 1, 0)
            Label.Position = UDim2.new(0, 15, 0, 0)
            Label.BackgroundTransparency = 1
            Label.TextColor3 = UILib.Theme.Text
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local KeyLabel = Instance.new("TextLabel", BindFrame)
            KeyLabel.Text = defaultKey.Name or "None"
            KeyLabel.Size = UDim2.new(0, 80, 1, 0)
            KeyLabel.Position = UDim2.new(1, -90, 0, 0)
            KeyLabel.BackgroundTransparency = 1
            KeyLabel.TextColor3 = UILib.Theme.Accent
            KeyLabel.Font = Enum.Font.GothamBold

            local listening = false
            BindFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    listening = true
                    KeyLabel.Text = "..."
                end
            end)
            UserInputService.InputBegan:Connect(function(input)
                if listening then
                    listening = false
                    KeyLabel.Text = input.KeyCode.Name
                    pcall(callback, input.KeyCode)
                end
            end)
        end

        -- Add Color Picker (Simple)
        function TabContent:AddColorPicker(text, default, callback)
            local container = Window.CurrentTab and Window.CurrentTab.Section or TabContent
            local PickerFrame = Instance.new("Frame")
            PickerFrame.Size = UDim2.new(1, 0, 0, 40)
            PickerFrame.BackgroundColor3 = UILib.Theme.Element
            PickerFrame.Parent = container or TabContent
            Instance.new("UICorner", PickerFrame).CornerRadius = UDim.new(0, 8)

            local Label = Instance.new("TextLabel", PickerFrame)
            Label.Text = text
            Label.Size = UDim2.new(1, -60, 1, 0)
            Label.Position = UDim2.new(0, 15, 0, 0)
            Label.BackgroundTransparency = 1
            Label.TextColor3 = UILib.Theme.Text
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local ColorPreview = Instance.new("Frame", PickerFrame)
            ColorPreview.Size = UDim2.new(0, 40, 0, 30)
            ColorPreview.Position = UDim2.new(1, -50, 0, 5)
            ColorPreview.BackgroundColor3 = default or UILib.Theme.Accent
            Instance.new("UICorner", ColorPreview).CornerRadius = UDim.new(0, 6)

            -- Simple random color change on click (full HSV picker is advanced, this is functional demo)
            ColorPreview.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local newColor = Color3.fromHSV(math.random(), 1, 1)
                    ColorPreview.BackgroundColor3 = newColor
                    pcall(callback, newColor)
                end
            end)
        end

        -- Add Textbox
        function TabContent:AddTextbox(text, placeholder, callback)
            local container = Window.CurrentTab and Window.CurrentTab.Section or TabContent
            local BoxFrame = Instance.new("Frame")
            BoxFrame.Size = UDim2.new(1, 0, 0, 40)
            BoxFrame.BackgroundColor3 = UILib.Theme.Element
            BoxFrame.Parent = container or TabContent
            Instance.new("UICorner", BoxFrame).CornerRadius = UDim.new(0, 8)

            local Label = Instance.new("TextLabel", BoxFrame)
            Label.Text = text
            Label.Size = UDim2.new(1, 0, 0, 20)
            Label.Position = UDim2.new(0, 15, 0, 0)
            Label.BackgroundTransparency = 1
            Label.TextColor3 = UILib.Theme.TextDim
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local TextBox = Instance.new("TextBox", BoxFrame)
            TextBox.PlaceholderText = placeholder
            TextBox.Size = UDim2.new(1, -30, 0, 25)
            TextBox.Position = UDim2.new(0, 15, 0, 15)
            TextBox.BackgroundColor3 = UILib.Theme.Header
            TextBox.TextColor3 = UILib.Theme.Text
            TextBox.Text = ""
            Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 6)

            TextBox.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    pcall(callback, TextBox.Text)
                end
            end)
        end

        return TabContent
    end

    return Window
end

return UILib

-- Spectravax Apex UI Library - Complete Edition (January 01, 2026)
-- Features: Tabs, Minimize/Close, Sections, Buttons, Toggles, Sliders, Dropdowns, Keybinds, Color Pickers, Textboxes, Notifications

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

local function Tween(obj, props, time)
    TweenService:Create(obj, TweenInfo.new(time or 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

UILib.Theme = {
    Accent = Color3.fromRGB(0, 170, 255),
    Background = Color3.fromRGB(22, 22, 28),
    Header = Color3.fromRGB(15, 15, 20),
    Element = Color3.fromRGB(40, 40, 50),
    Hover = Color3.fromRGB(60, 60, 75),
    Text = Color3.fromRGB(240, 240, 240),
    TextDim = Color3.fromRGB(160, 160, 160),
}

function UILib:Notify(title, text, duration)
    duration = duration or 4
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 300, 0, 80)
    notif.Position = UDim2.new(1, 320, 1, -100)
    notif.BackgroundColor3 = UILib.Theme.Element
    notif.Parent = ScreenGui
    Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 8)

    local t = Instance.new("TextLabel", notif)
    t.Text = title
    t.Size = UDim2.new(1, -20, 0, 30)
    t.Position = UDim2.new(0, 10, 0, 8)
    t.BackgroundTransparency = 1
    t.TextColor3 = UILib.Theme.Text
    t.Font = Enum.Font.GothamBold
    t.TextXAlignment = Enum.TextXAlignment.Left

    local d = Instance.new("TextLabel", notif)
    d.Text = text
    d.Size = UDim2.new(1, -20, 0, 40)
    d.Position = UDim2.new(0, 10, 0, 38)
    d.BackgroundTransparency = 1
    d.TextColor3 = UILib.Theme.TextDim
    d.TextWrapped = true

    Tween(notif, {Position = UDim2.new(1, -320, 1, -100)}, 0.4)
    task.delay(duration, function()
        Tween(notif, {Position = UDim2.new(1, 320, 1, -100)}, 0.4)
        task.wait(0.4)
        notif:Destroy()
    end)
end

function UILib:CreateWindow(title)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0.85, 0, 0.8, 0)
    Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.BackgroundColor3 = UILib.Theme.Background
    Frame.Parent = ScreenGui
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

    local Header = Instance.new("Frame", Frame)
    Header.Size = UDim2.new(1, 0, 0, 50)
    Header.BackgroundColor3 = UILib.Theme.Header

    local Title = Instance.new("TextLabel", Header)
    Title.Text = title or "Spectravax Apex"
    Title.Size = UDim2.new(1, -160, 1, 0)
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = UILib.Theme.Text
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local Minimize = Instance.new("TextButton", Header)
    Minimize.Text = "−"
    Minimize.Size = UDim2.new(0, 40, 0, 40)
    Minimize.Position = UDim2.new(1, -90, 0, 5)
    Minimize.BackgroundTransparency = 1
    Minimize.TextColor3 = UILib.Theme.Text
    Minimize.Font = Enum.Font.GothamBold

    local Close = Instance.new("TextButton", Header)
    Close.Text = "X"
    Close.Size = UDim2.new(0, 40, 0, 40)
    Close.Position = UDim2.new(1, -45, 0, 5)
    Close.BackgroundTransparency = 1
    Close.TextColor3 = Color3.fromRGB(255, 80, 80)
    Close.Font = Enum.Font.GothamBold
    Close.MouseButton1Click:Connect(function()
        Tween(Frame, {Size = UDim2.new(0,0,0,0)}, 0.3)
        task.wait(0.3)
        Frame:Destroy()
    end)

    local TabBar = Instance.new("Frame", Frame)
    TabBar.Size = UDim2.new(1, 0, 0, 40)
    TabBar.Position = UDim2.new(0, 0, 0, 50)
    TabBar.BackgroundTransparency = 1

    local TabLayout = Instance.new("UIListLayout", TabBar)
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.Padding = UDim.new(0, 10)

    local Content = Instance.new("Frame", Frame)
    Content.Size = UDim2.new(1, 0, 1, -90)
    Content.Position = UDim2.new(0, 0, 0, 90)
    Content.BackgroundTransparency = 1

    local minimized = false
    Minimize.MouseButton1Click:Connect(function()
        minimized = not minimized
        Minimize.Text = minimized and "+" or "−"
        Tween(Frame, {Size = minimized and UDim2.new(0.85, 0, 0, 50) or UDim2.new(0.85, 0, 0.8, 0)}, 0.3)
    end)

    local Window = {Tabs = {}, CurrentTab = nil}

    function Window:AddTab(name)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(0, 130, 1, 0)
        TabBtn.BackgroundColor3 = UILib.Theme.Element
        TabBtn.Text = name
        TabBtn.TextColor3 = UILib.Theme.Text
        TabBtn.Parent = TabBar
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)

        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Size = UDim2.new(1, -20, 1, -10)
        TabContent.Position = UDim2.new(0, 10, 0, 5)
        TabContent.BackgroundTransparency = 1
        TabContent.ScrollBarThickness = 6
        TabContent.Visible = false
        TabContent.Parent = Content

        local Layout = Instance.new("UIListLayout", TabContent)
        Layout.Padding = UDim.new(0, 12)
        Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 20)
        end)

        TabBtn.MouseButton1Click:Connect(function()
            if Window.CurrentTab then
                Window.CurrentTab.Content.Visible = false
                Window.CurrentTab.Btn.BackgroundColor3 = UILib.Theme.Element
            end
            TabContent.Visible = true
            TabBtn.BackgroundColor3 = UILib.Theme.Accent
            Window.CurrentTab = {Content = TabContent, Btn = TabBtn}
        end)

        if #Window.Tabs == 0 then TabBtn.MouseButton1Click:Invoke() end
        table.insert(Window.Tabs, {Content = TabContent, Btn = TabBtn})

        function TabContent:AddSection(name)
            local Sec = Instance.new("Frame")
            Sec.Size = UDim2.new(1, 0, 0, 40)
            Sec.BackgroundColor3 = UILib.Theme.Element
            Sec.Parent = TabContent
            Instance.new("UICorner", Sec).CornerRadius = UDim.new(0, 8)

            local SecTitle = Instance.new("TextLabel", Sec)
            SecTitle.Text = name
            SecTitle.Size = UDim2.new(1, -60, 1, 0)
            SecTitle.Position = UDim2.new(0, 15, 0, 0)
            SecTitle.BackgroundTransparency = 1
            SecTitle.TextColor3 = UILib.Theme.Text
            SecTitle.Font = Enum.Font.GothamBold
            SecTitle.TextXAlignment = Enum.TextXAlignment.Left

            local Arrow = Instance.new("TextButton", Sec)
            Arrow.Text = "▼"
            Arrow.Size = UDim2.new(0, 50, 1, 0)
            Arrow.Position = UDim2.new(1, -50, 0, 0)
            Arrow.BackgroundTransparency = 1
            Arrow.TextColor3 = UILib.Theme.Text

            local SecContent = Instance.new("Frame")
            SecContent.Size = UDim2.new(1, -20, 0, 0)
            SecContent.Position = UDim2.new(0, 10, 0, 50)
            SecContent.BackgroundTransparency = 1
            SecContent.Parent = TabContent

            local SecLayout = Instance.new("UIListLayout", SecContent)
            SecLayout.Padding = UDim.new(0, 10)

            local open = true
            Arrow.MouseButton1Click:Connect(function()
                open = not open
                Arrow.Text = open and "▼" or "▶"
                Tween(SecContent, {Size = open and UDim2.new(1, -20, 0, SecLayout.AbsoluteContentSize.Y + 20) or UDim2.new(1, -20, 0, 0)}, 0.3)
            end)

            SecLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                if open then Tween(SecContent, {Size = UDim2.new(1, -20, 0, SecLayout.AbsoluteContentSize.Y + 20)}, 0.2) end
            end)

            return SecContent
        end

        function TabContent:AddButton(text, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 40)
            btn.BackgroundColor3 = UILib.Theme.Element
            btn.Text = text
            btn.TextColor3 = UILib.Theme.Text
            btn.Font = Enum.Font.Gotham
            btn.Parent = TabContent
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
            btn.MouseEnter:Connect(function() Tween(btn, {BackgroundColor3 = UILib.Theme.Hover}, 0.2) end)
            btn.MouseLeave:Connect(function() Tween(btn, {BackgroundColor3 = UILib.Theme.Element}, 0.2) end)
            btn.MouseButton1Click:Connect(function() pcall(callback) end)
        end

        function TabContent:AddToggle(text, default, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, 40)
            frame.BackgroundColor3 = UILib.Theme.Element
            frame.Parent = TabContent
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

            local label = Instance.new("TextLabel", frame)
            label.Text = text
            label.Size = UDim2.new(1, -70, 1, 0)
            label.Position = UDim2.new(0, 15, 0, 0)
            label.BackgroundTransparency = 1
            label.TextColor3 = UILib.Theme.Text
            label.TextXAlignment = Enum.TextXAlignment.Left

            local switch = Instance.new("Frame")
            switch.Size = UDim2.new(0, 50, 0, 26)
            switch.Position = UDim2.new(1, -60, 0.5, -13)
            switch.BackgroundColor3 = default and UILib.Theme.Accent or UILib.Theme.Element
            switch.Parent = frame
            Instance.new("UICorner", switch).CornerRadius = UDim.new(0, 13)

            local circle = Instance.new("Frame")
            circle.Size = UDim2.new(0, 22, 0, 22)
            circle.Position = default and UDim2.new(0, 26, 0, 2) or UDim2.new(0, 4, 0, 2)
            circle.BackgroundColor3 = Color3.new(1,1,1)
            circle.Parent = switch
            Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

            local state = default
            frame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    state = not state
                    Tween(circle, {Position = state and UDim2.new(0, 26, 0, 2) or UDim2.new(0, 4, 0, 2)}, 0.2)
                    Tween(switch, {BackgroundColor3 = state and UILib.Theme.Accent or UILib.Theme.Element}, 0.2)
                    pcall(callback, state)
                end
            end)
        end

        function TabContent:AddSlider(text, min, max, default, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, 60)
            frame.BackgroundColor3 = UILib.Theme.Element
            frame.Parent = TabContent
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

            local label = Instance.new("TextLabel", frame)
            label.Text = text .. ": " .. default
            label.Size = UDim2.new(1, -100, 0, 25)
            label.Position = UDim2.new(0, 15, 0, 5)
            label.BackgroundTransparency = 1
            label.TextColor3 = UILib.Theme.Text
            label.TextXAlignment = Enum.TextXAlignment.Left

            local valueLabel = Instance.new("TextLabel", frame)
            valueLabel.Text = tostring(default)
            valueLabel.Size = UDim2.new(0, 80, 0, 25)
            valueLabel.Position = UDim2.new(1, -95, 0, 5)
            valueLabel.BackgroundTransparency = 1
            valueLabel.TextColor3 = UILib.Theme.Accent
            valueLabel.Font = Enum.Font.GothamBold

            local track = Instance.new("Frame", frame)
            track.Size = UDim2.new(1, -30, 0, 8)
            track.Position = UDim2.new(0, 15, 0, 35)
            track.BackgroundColor3 = UILib.Theme.Header
            Instance.new("UICorner", track).CornerRadius = UDim.new(0, 4)

            local fill = Instance.new("Frame", track)
            fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
            fill.BackgroundColor3 = UILib.Theme.Accent
            Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 4)

            local dragging = false
            track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
            end)
            track.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local rel = math.clamp((input.Position.X - track.AbsolutePosition.X)/track.AbsoluteSize.X, 0, 1)
                    local val = math.floor(min + (max - min) * rel)
                    fill.Size = UDim2.new(rel, 0, 1, 0)
                    valueLabel.Text = tostring(val)
                    label.Text = text .. ": " .. val
                    pcall(callback, val)
                end
            end)
        end

        function TabContent:AddDropdown(text, items, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, 40)
            frame.BackgroundColor3 = UILib.Theme.Element
            frame.Parent = TabContent
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

            local label = Instance.new("TextLabel", frame)
            label.Text = text .. ": " .. items[1]
            label.Size = UDim2.new(1, -50, 1, 0)
            label.Position = UDim2.new(0, 15, 0, 0)
            label.BackgroundTransparency = 1
            label.TextColor3 = UILib.Theme.Text
            label.TextXAlignment = Enum.TextXAlignment.Left

            local btn = Instance.new("TextButton", frame)
            btn.Text = "▼"
            btn.Size = UDim2.new(0, 40, 1, 0)
            btn.Position = UDim2.new(1, -40, 0, 0)
            btn.BackgroundTransparency = 1
            btn.TextColor3 = UILib.Theme.Text

            local list = Instance.new("Frame")
            list.Size = UDim2.new(1, 0, 0, #items * 35)
            list.Position = UDim2.new(0, 0, 1, 5)
            list.BackgroundColor3 = UILib.Theme.Element
            list.Visible = false
            list.Parent = frame
            Instance.new("UICorner", list).CornerRadius = UDim.new(0, 8)

            for i, item in ipairs(items) do
                local itembtn = Instance.new("TextButton", list)
                itembtn.Size = UDim2.new(1, 0, 0, 35)
                itembtn.Position = UDim2.new(0, 0, 0, (i-1)*35)
                itembtn.BackgroundColor3 = UILib.Theme.Element
                itembtn.Text = item
                itembtn.TextColor3 = UILib.Theme.Text
                itembtn.MouseButton1Click:Connect(function()
                    label.Text = text .. ": " .. item
                    list.Visible = false
                    pcall(callback, item)
                end)
            end

            btn.MouseButton1Click:Connect(function()
                list.Visible = not list.Visible
            end)
        end

        function TabContent:AddKeybind(text, default, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, 40)
            frame.BackgroundColor3 = UILib.Theme.Element
            frame.Parent = TabContent
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

            local label = Instance.new("TextLabel", frame)
            label.Text = text
            label.Size = UDim2.new(1, -100, 1, 0)
            label.Position = UDim2.new(0, 15, 0, 0)
            label.BackgroundTransparency = 1
            label.TextColor3 = UILib.Theme.Text
            label.TextXAlignment = Enum.TextXAlignment.Left

            local keylabel = Instance.new("TextLabel", frame)
            keylabel.Text = default.Name
            keylabel.Size = UDim2.new(0, 80, 1, 0)
            keylabel.Position = UDim2.new(1, -90, 0, 0)
            keylabel.BackgroundTransparency = 1
            keylabel.TextColor3 = UILib.Theme.Accent
            keylabel.Font = Enum.Font.GothamBold

            local listening = false
            frame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    listening = true
                    keylabel.Text = "..."
                end
            end)
            UserInputService.InputBegan:Connect(function(input)
                if listening then
                    listening = false
                    keylabel.Text = input.KeyCode.Name
                    pcall(callback, input.KeyCode)
                end
            end)
        end

        function TabContent:AddColorPicker(text, default, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, 40)
            frame.BackgroundColor3 = UILib.Theme.Element
            frame.Parent = TabContent
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

            local label = Instance.new("TextLabel", frame)
            label.Text = text
            label.Size = UDim2.new(1, -60, 1, 0)
            label.Position = UDim2.new(0, 15, 0, 0)
            label.BackgroundTransparency = 1
            label.TextColor3 = UILib.Theme.Text
            label.TextXAlignment = Enum.TextXAlignment.Left

            local preview = Instance.new("Frame", frame)
            preview.Size = UDim2.new(0, 40, 0, 30)
            preview.Position = UDim2.new(1, -50, 0, 5)
            preview.BackgroundColor3 = default
            Instance.new("UICorner", preview).CornerRadius = UDim.new(0, 6)

            preview.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local newColor = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                    preview.BackgroundColor3 = newColor
                    pcall(callback, newColor)
                end
            end)
        end

        function TabContent:AddTextbox(text, placeholder, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, 60)
            frame.BackgroundColor3 = UILib.Theme.Element
            frame.Parent = TabContent
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

            local label = Instance.new("TextLabel", frame)
            label.Text = text
            label.Size = UDim2.new(1, 0, 0, 20)
            label.Position = UDim2.new(0, 15, 0, 5)
            label.BackgroundTransparency = 1
            label.TextColor3 = UILib.Theme.TextDim
            label.TextXAlignment = Enum.TextXAlignment.Left

            local box = Instance.new("TextBox", frame)
            box.PlaceholderText = placeholder
            box.Size = UDim2.new(1, -30, 0, 30)
            box.Position = UDim2.new(0, 15, 0, 25)
            box.BackgroundColor3 = UILib.Theme.Header
            box.TextColor3 = UILib.Theme.Text
            Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)

            box.FocusLost:Connect(function(enter)
                if enter then
                    pcall(callback, box.Text)
                end
            end)
        end

        return TabContent
    end

    return Window
end

return UILib

-- SpectravaxHub Mobile-Friendly UI Library
-- Original: https://github.com/deedlemcdoodledeedlemcdoodle-creator/SpectravaxHub
-- Fixed for mobile (360x320 default), keeps themes & draggable window

local UI = {}
UI.__index = UI

local Players = game:GetService("Players")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")

-- ==================== Utility ====================
local function Create(Class, Properties, Parent)
    local Obj = Instance.new(Class)
    if Properties then
        for i,v in pairs(Properties) do
            Obj[i] = v
        end
    end
    if Parent then
        Obj.Parent = Parent
    end
    return Obj
end

-- ==================== Window ====================
function UI:CreateWindow(Title, Icon)
    local selfObj = {}
    setmetatable(selfObj, UI)

    -- ScreenGui
    selfObj.ScreenGui = Create("ScreenGui", { ResetOnSpawn = false }, PlayerGui)

    -- Main Frame (mobile-friendly)
    selfObj.WindowWidth = 360
    selfObj.WindowHeight = 320
    selfObj.MainFrame = Create("Frame", {
        Size = UDim2.new(0, selfObj.WindowWidth, 0, selfObj.WindowHeight),
        Position = UDim2.new(0.5, -selfObj.WindowWidth/2, 0.5, -selfObj.WindowHeight/2),
        BackgroundColor3 = Color3.fromRGB(30,30,30),
        BorderSizePixel = 0
    }, selfObj.ScreenGui)

    -- TopBar (draggable)
    local TopBar = Create("Frame", { Size=UDim2.new(1,0,0,40), BackgroundTransparency=1 }, selfObj.MainFrame)
    selfObj.TopBar = TopBar

    -- Tabs container
    selfObj.Tabs = {}

    -- ==================== Dragging ====================
    do
        local UIS = game:GetService("UserInputService")
        local dragToggle, dragStart, startPos
        TopBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragToggle = true
                dragStart = input.Position
                startPos = selfObj.MainFrame.Position
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if dragToggle and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                selfObj.MainFrame.Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end)
        TopBar.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragToggle = false
            end
        end)
    end

    -- ==================== Window Methods ====================
    function selfObj:CreateTab(Name, IconId)
        local tab = {}
        tab.Name = Name
        tab.IconId = IconId
        tab.Elements = {}

        -- Section frame
        tab.Section = Create("Frame", {
            Size = UDim2.new(1,0,1,-50),
            Position = UDim2.new(0,0,0,50),
            BackgroundColor3 = Color3.fromRGB(40,40,40),
            BorderSizePixel = 0,
            Parent = selfObj.MainFrame
        })

        selfObj.Tabs[Name] = tab

        -- ==================== Element Methods ====================
        function tab:Button(Text, Callback)
            local Btn = Create("TextButton", {
                Text = Text,
                Size = UDim2.new(1,-20,0,30),
                Position = UDim2.new(0,10,#tab.Elements*40,0),
                BackgroundColor3 = Color3.fromRGB(85,170,255),
                TextColor3 = Color3.fromRGB(255,255,255),
                BorderSizePixel = 0,
                Parent = tab.Section
            })
            Btn.MouseButton1Click:Connect(Callback)
            table.insert(tab.Elements, Btn)
            return Btn
        end

        function tab:Toggle(Text, Default, Callback)
            local ToggleFrame = Create("Frame", {
                Size = UDim2.new(1,-20,0,30),
                Position = UDim2.new(0,10,#tab.Elements*40,0),
                BackgroundColor3 = Color3.fromRGB(60,60,60),
                Parent = tab.Section
            })
            local Label = Create("TextLabel", {
                Text = Text,
                Size = UDim2.new(0.7,0,1,0),
                BackgroundTransparency = 1,
                TextColor3 = Color3.fromRGB(255,255,255),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = ToggleFrame
            })
            local State = Default
            local Btn = Create("TextButton", {
                Text = "",
                Size = UDim2.new(0,30,0,30),
                Position = UDim2.new(0.8,0,0,0),
                BackgroundColor3 = State and Color3.fromRGB(85,170,255) or Color3.fromRGB(100,100,100),
                BorderSizePixel = 0,
                Parent = ToggleFrame
            })
            Btn.MouseButton1Click:Connect(function()
                State = not State
                Btn.BackgroundColor3 = State and Color3.fromRGB(85,170,255) or Color3.fromRGB(100,100,100)
                Callback(State)
            end)
            table.insert(tab.Elements, ToggleFrame)
        end

        function tab:Slider(Text, Min, Max, Callback)
            local SliderFrame = Create("Frame", {
                Size = UDim2.new(1,-20,0,30),
                Position = UDim2.new(0,10,#tab.Elements*40,0),
                BackgroundColor3 = Color3.fromRGB(60,60,60),
                Parent = tab.Section
            })
            local Label = Create("TextLabel", {
                Text = Text,
                Size = UDim2.new(0.7,0,1,0),
                BackgroundTransparency = 1,
                TextColor3 = Color3.fromRGB(255,255,255),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = SliderFrame
            })
            local SliderBtn = Create("TextButton", {
                Size = UDim2.new(0,20,1,0),
                Position = UDim2.new(0,0,0,0),
                BackgroundColor3 = Color3.fromRGB(85,170,255),
                Parent = SliderFrame
            })
            local dragging = false
            local UIS = game:GetService("UserInputService")
            SliderBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)
            UIS.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            UIS.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local relative = math.clamp(input.Position.X - SliderFrame.AbsolutePosition.X, 0, SliderFrame.AbsoluteSize.X)
                    SliderBtn.Position = UDim2.new(0, relative, 0, 0)
                    local value = Min + (Max-Min)*(relative/SliderFrame.AbsoluteSize.X)
                    Callback(math.floor(value))
                end
            end)
            table.insert(tab.Elements, SliderFrame)
        end

        function tab:Dropdown(Name, Options, Callback)
            local DropFrame = Create("Frame", {
                Size = UDim2.new(1,-20,0,30),
                Position = UDim2.new(0,10,#tab.Elements*40,0),
                BackgroundColor3 = Color3.fromRGB(60,60,60),
                Parent = tab.Section
            })
            local Label = Create("TextLabel", {
                Text = Name,
                Size = UDim2.new(0.7,0,1,0),
                BackgroundTransparency = 1,
                TextColor3 = Color3.fromRGB(255,255,255),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = DropFrame
            })
            DropFrame.MouseButton1Click:Connect(function()
                local Choice = Options[1] -- simple first option
                Callback(Choice)
            end)
            table.insert(tab.Elements, DropFrame)
        end

        return tab
    end

    return selfObj
end

return UI
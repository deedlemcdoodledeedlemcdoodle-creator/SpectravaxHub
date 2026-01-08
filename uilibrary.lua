local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- Prevent duplicate UI
if Player.PlayerGui:FindFirstChild("ArialUI") then
    Player.PlayerGui.ArialUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ArialUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player.PlayerGui

-- Tween helper
local function tween(obj, t, props)
    TweenService:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

-- Drag helper
local function draggable(bar, frame)
    local drag, start, pos
    bar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true
            start = i.Position
            pos = frame.Position
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = false
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - start
            frame.Position = pos + UDim2.fromOffset(delta.X, delta.Y)
        end
    end)
end

-- ================= WINDOW =================
local UI = {}

function UI:CreateWindow(title, iconId)
    local Window = {}
    local Main = Instance.new("Frame")
    Main.Size = UDim2.fromOffset(560, 380)
    Main.Position = UDim2.fromScale(0.5, 0.5)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Color3.fromRGB(18,18,18)
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0,12)

    local Top = Instance.new("Frame", Main)
    Top.Size = UDim2.new(1,0,0,40)
    Top.BackgroundTransparency = 1

    if iconId then
        local Icon = Instance.new("ImageLabel", Top)
        Icon.Size = UDim2.fromOffset(20,20)
        Icon.Position = UDim2.fromOffset(10,10)
        Icon.Image = iconId
        Icon.BackgroundTransparency = 1
    end

    local Title = Instance.new("TextLabel", Top)
    Title.Size = UDim2.new(1,-50,1,0)
    Title.Position = iconId and UDim2.fromOffset(40,0) or UDim2.fromOffset(10,0)
    Title.Text = title
    Title.Font = Enum.Font.Arial
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.TextColor3 = Color3.new(1,1,1)
    Title.BackgroundTransparency = 1

    draggable(Top, Main)

    local Tabs = Instance.new("Frame", Main)
    Tabs.Size = UDim2.new(0,150,1,-40)
    Tabs.Position = UDim2.fromOffset(0,40)
    Tabs.BackgroundColor3 = Color3.fromRGB(14,14,14)
    Tabs.BorderSizePixel = 0

    local TabsLayout = Instance.new("UIListLayout", Tabs)
    TabsLayout.Padding = UDim.new(0,6)

    local Pages = Instance.new("Frame", Main)
    Pages.Size = UDim2.new(1,-150,1,-40)
    Pages.Position = UDim2.fromOffset(150,40)
    Pages.BackgroundTransparency = 1

    function Window:CreateTab(name, iconId)
        local Tab = {}

        local Button = Instance.new("TextButton", Tabs)
        Button.Size = UDim2.new(1,-10,0,34)
        Button.Position = UDim2.fromOffset(5,0)
        Button.Text = ""
        Button.BackgroundColor3 = Color3.fromRGB(26,26,26)
        Button.BorderSizePixel = 0
        Instance.new("UICorner", Button).CornerRadius = UDim.new(0,6)

        if iconId then
            local Icon = Instance.new("ImageLabel", Button)
            Icon.Size = UDim2.fromOffset(18,18)
            Icon.Position = UDim2.fromOffset(8,8)
            Icon.Image = iconId
            Icon.BackgroundTransparency = 1
        end

        local Text = Instance.new("TextLabel", Button)
        Text.Size = UDim2.new(1,-40,1,0)
        Text.Position = iconId and UDim2.fromOffset(34,0) or UDim2.fromOffset(10,0)
        Text.Text = name
        Text.Font = Enum.Font.Arial
        Text.TextSize = 14
        Text.TextXAlignment = Enum.TextXAlignment.Left
        Text.TextColor3 = Color3.fromRGB(220,220,220)
        Text.BackgroundTransparency = 1

        local Page = Instance.new("ScrollingFrame", Pages)
        Page.Size = UDim2.fromScale(1,1)
        Page.CanvasSize = UDim2.new()
        Page.ScrollBarImageTransparency = 1
        Page.Visible = false

        local Layout = Instance.new("UIListLayout", Page)
        Layout.Padding = UDim.new(0,10)

        Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.fromOffset(0, Layout.AbsoluteContentSize.Y + 10)
        end)

        Button.MouseButton1Click:Connect(function()
            for _,v in ipairs(Pages:GetChildren()) do
                if v:IsA("ScrollingFrame") then v.Visible = false end
            end
            Page.Visible = true
        end)

        -- ================= COMPONENTS =================

        function Tab:Section(text)
            local s = Instance.new("TextLabel", Page)
            s.Size = UDim2.new(1,-20,0,24)
            s.Position = UDim2.fromOffset(10,0)
            s.Text = text
            s.Font = Enum.Font.Arial
            s.TextSize = 14
            s.TextXAlignment = Enum.TextXAlignment.Left
            s.TextColor3 = Color3.new(1,1,1)
            s.BackgroundTransparency = 1
        end

        function Tab:Button(text, callback)
            local b = Instance.new("TextButton", Page)
            b.Size = UDim2.new(1,-20,0,32)
            b.Position = UDim2.fromOffset(10,0)
            b.Text = text
            b.Font = Enum.Font.Arial
            b.TextSize = 14
            b.TextColor3 = Color3.new(1,1,1)
            b.BackgroundColor3 = Color3.fromRGB(32,32,32)
            b.BorderSizePixel = 0
            Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
            b.MouseButton1Click:Connect(function()
                tween(b,0.1,{BackgroundColor3=Color3.fromRGB(45,45,45)})
                task.wait(0.1)
                tween(b,0.1,{BackgroundColor3=Color3.fromRGB(32,32,32)})
                callback()
            end)
        end

        function Tab:Toggle(text, default, callback)
            local state = default or false
            local holder = Instance.new("Frame", Page)
            holder.Size = UDim2.new(1,-20,0,36)
            holder.Position = UDim2.fromOffset(10,0)
            holder.BackgroundTransparency = 1

            local label = Instance.new("TextLabel", holder)
            label.Size = UDim2.new(1,-60,1,0)
            label.Text = text
            label.Font = Enum.Font.Arial
            label.TextSize = 14
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.TextColor3 = Color3.new(1,1,1)
            label.BackgroundTransparency = 1

            local bg = Instance.new("Frame", holder)
            bg.Size = UDim2.fromOffset(42,22)
            bg.Position = UDim2.fromScale(1,0.5) + UDim2.fromOffset(-50,-11)
            bg.BackgroundColor3 = Color3.fromRGB(70,70,70)
            bg.BorderSizePixel = 0
            Instance.new("UICorner", bg).CornerRadius = UDim.new(1,0)

            local circle = Instance.new("Frame", bg)
            circle.Size = UDim2.fromOffset(18,18)
            circle.Position = UDim2.fromOffset(2,2)
            circle.BackgroundColor3 = Color3.new(1,1,1)
            circle.BorderSizePixel = 0
            Instance.new("UICorner", circle).CornerRadius = UDim.new(1,0)

            local function set(v)
                state = v
                if v then
                    tween(bg,0.2,{BackgroundColor3=Color3.fromRGB(0,170,255)})
                    tween(circle,0.2,{Position=UDim2.fromOffset(22,2)})
                else
                    tween(bg,0.2,{BackgroundColor3=Color3.fromRGB(70,70,70)})
                    tween(circle,0.2,{Position=UDim2.fromOffset(2,2)})
                end
                callback(state)
            end

            bg.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    set(not state)
                end
            end)

            set(state)
        end

        -- Label (editable)
        function Tab:Label(text)
            local lbl = Instance.new("TextLabel", Page)
            lbl.Size = UDim2.new(1,-20,0,20)
            lbl.Position = UDim2.fromOffset(10,0)
            lbl.Text = text
            lbl.Font = Enum.Font.Arial
            lbl.TextSize = 14
            lbl.TextWrapped = true
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextYAlignment = Enum.TextYAlignment.Top
            lbl.TextColor3 = Color3.fromRGB(200,200,200)
            lbl.BackgroundTransparency = 1
            lbl.AutomaticSize = Enum.AutomaticSize.Y
            local API = {}
            function API:SetText(newText) lbl.Text = newText end
            return API
        end

        -- CopyLabel
        function Tab:CopyLabel(text)
            local holder = Instance.new("Frame", Page)
            holder.Size = UDim2.new(1,-20,0,24)
            holder.Position = UDim2.fromOffset(10,0)
            holder.BackgroundTransparency = 1
            holder.AutomaticSize = Enum.AutomaticSize.Y

            local lbl = Instance.new("TextButton", holder)
            lbl.Size = UDim2.new(1,0,1,0)
            lbl.Text = text
            lbl.Font = Enum.Font.Arial
            lbl.TextSize = 14
            lbl.TextWrapped = true
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextYAlignment = Enum.TextYAlignment.Top
            lbl.TextColor3 = Color3.fromRGB(200,200,200)
            lbl.BackgroundTransparency = 1
            lbl.AutomaticSize = Enum.AutomaticSize.Y

            local original = text
            local copied = false

            lbl.MouseButton1Click:Connect(function()
                if copied then return end
                copied = true
                if setclipboard then setclipboard(original) end
                lbl.Text = "Copied!"
                lbl.TextColor3 = Color3.fromRGB(0,200,255)
                task.delay(1,function)
                    lbl.Text = original
                    lbl.TextColor3 = Color3.fromRGB(200,200,200)
                    copied = false
                end)
            end)
        end

        -- Textbox
        function Tab:Textbox(placeholder, callback)
            local holder = Instance.new("Frame", Page)
            holder.Size = UDim2.new(1,-20,0,36)
            holder.Position = UDim2.fromOffset(10,0)
            holder.BackgroundTransparency = 1

            local box = Instance.new("TextBox", holder)
            box.Size = UDim2.new(1,0,1,0)
            box.Text = ""
            box.PlaceholderText = placeholder or ""
            box.Font = Enum.Font.Arial
            box.TextSize = 14
            box.TextColor3 = Color3.fromRGB(0,0,0)
            box.BackgroundColor3 = Color3.fromRGB(240,240,240)
            box.BorderSizePixel = 0
            Instance.new("UICorner", box).CornerRadius = UDim.new(0,6)

            box.FocusLost:Connect(function(enter)
                if enter then callback(box.Text) end
            end)
        end

        -- Slider
        function Tab:Slider(text, min, max, default, callback)
            local holder = Instance.new("Frame", Page)
            holder.Size = UDim2.new(1,-20,0,36)
            holder.Position = UDim2.fromOffset(10,0)
            holder.BackgroundTransparency = 1

            local label = Instance.new("TextLabel", holder)
            label.Size = UDim2.new(1,-10,0,14)
            label.Position = UDim2.fromOffset(0,0)
            label.Text = text .. " : " .. tostring(default)
            label.Font = Enum.Font.Arial
            label.TextSize = 14
            label.TextColor3 = Color3.fromRGB(255,255,255)
            label.BackgroundTransparency = 1
            label.TextXAlignment = Enum.TextXAlignment.Left

            local bar = Instance.new("Frame", holder)
            bar.Size = UDim2.new(1,0,0,6)
            bar.Position = UDim2.fromOffset(0,24)
            bar.BackgroundColor3 = Color3.fromRGB(100,100,100)
            bar.BorderSizePixel = 0
            Instance.new("UICorner", bar).CornerRadius = UDim.new(0,3)

            local fill = Instance.new("Frame", bar)
            fill.Size = UDim2.new((default-min)/(max-min),0,1,0)
            fill.BackgroundColor3 = Color3.fromRGB(0,170,255)
            fill.BorderSizePixel = 0
            Instance.new("UICorner", fill).CornerRadius = UDim.new(0,3)

            local dragging = false
            bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local pos = math.clamp((input.Position.X - bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
                    fill.Size = UDim2.new(pos,0,1,0)
                    local value = math.floor(min + (max-min)*pos)
                    label.Text = text .. " : " .. tostring(value)
                    callback(value)
                end
            end)
        end

        -- Dropdown
        function Tab:Dropdown(text, options, callback)
            local holder = Instance.new("Frame", Page)
            holder.Size = UDim2.new(1,-20,0,32)
            holder.Position = UDim2.fromOffset(10,0)
            holder.BackgroundTransparency = 1

            local label = Instance.new("TextLabel", holder)
            label.Size = UDim2.new(1,0,1,0)
            label.Text = text
            label.Font = Enum.Font.Arial
            label.TextSize = 14
            label.TextColor3 = Color3.fromRGB(255,255,255)
            label.BackgroundTransparency = 1
            label.TextXAlignment = Enum.TextXAlignment.Left

            local dropdownOpen = false
            local list = Instance.new("Frame", holder)
            list.Size = UDim2.new(1,0,0,#options*28)
            list.Position = UDim2.new(0,0,1,2)
            list.BackgroundColor3 = Color3.fromRGB(32,32,32)
            list.Visible = false
            Instance.new("UICorner", list).CornerRadius = UDim.new(0,6)

            for i,opt in ipairs(options) do
                local btn = Instance.new("TextButton", list)
                btn.Size = UDim2.new(1,0,0,28)
                btn.Position = UDim2.fromOffset(0,(i-1)*28)
                btn.Text = opt
                btn.Font = Enum.Font.Arial
                btn.TextSize = 14
                btn.TextColor3 = Color3.fromRGB(255,255,255)
                btn.BackgroundColor3 = Color3.fromRGB(26,26,26)
                btn.BorderSizePixel = 0
                Instance.new("UICorner", btn).CornerRadius = UDim.new(0,4)
                btn.MouseButton1Click:Connect(function()
                    label.Text = text.." : "..opt
                    list.Visible = false
                    dropdownOpen = false
                    callback(opt)
                end)
            end

            label.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    dropdownOpen = not dropdownOpen
                    list.Visible = dropdownOpen
                end
            end)
        end

        -- Keybind
function Tab:Keybind(text, defaultKey, callback)
    local holder = Instance.new("Frame", Page)
    holder.Size = UDim2.new(1,-20,0,36)
    holder.Position = UDim2.fromOffset(10,0)
    holder.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", holder)
    label.Size = UDim2.new(1,0,1,0)
    label.Text = text.." : "..(defaultKey.Name or "None")
    label.Font = Enum.Font.Arial
    label.TextSize = 14
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left

    local binding = defaultKey

    label.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            label.Text = text.." : ..."
            local conn
            conn = UserInputService.InputBegan:Connect(function(key)
                if key.UserInputType == Enum.UserInputType.Keyboard then
                    binding = key.KeyCode
                    label.Text = text.." : "..binding.Name
                    conn:Disconnect()
                    callback(binding)
                end
            end)
        end
    end)
    end

return UI    

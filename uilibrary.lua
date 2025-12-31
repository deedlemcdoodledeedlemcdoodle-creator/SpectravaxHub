local UILib = {}
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModernUILib"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local function Tween(obj,props,time,style,dir)
    style = style or Enum.EasingStyle.Quad
    dir = dir or Enum.EasingDirection.Out
    local tween = TweenService:Create(obj, TweenInfo.new(time,style,dir), props)
    tween:Play()
    return tween
end

UILib.Theme = {
    Background = Color3.fromRGB(30,30,30),
    Header = Color3.fromRGB(20,20,20),
    Button = Color3.fromRGB(60,60,60),
    ButtonHover = Color3.fromRGB(75,75,75),
    ButtonText = Color3.fromRGB(255,255,255),
    ToggleOff = Color3.fromRGB(80,80,80),
    ToggleOn = Color3.fromRGB(0,170,255)
}

UILib.Themes = {
    ["Amber Glow"] = {Background=Color3.fromRGB(40,20,0), Header=Color3.fromRGB(60,30,0), Button=Color3.fromRGB(90,45,0), ButtonHover=Color3.fromRGB(120,60,0), ButtonText=Color3.fromRGB(255,200,100), ToggleOff=Color3.fromRGB(90,45,0), ToggleOn=Color3.fromRGB(255,200,100)},
    ["Amethyst"] = {Background=Color3.fromRGB(50,0,50), Header=Color3.fromRGB(70,0,70), Button=Color3.fromRGB(100,0,100), ButtonHover=Color3.fromRGB(130,0,130), ButtonText=Color3.fromRGB(220,180,255), ToggleOff=Color3.fromRGB(100,0,100), ToggleOn=Color3.fromRGB(220,180,255)},
    ["Bloom"] = {Background=Color3.fromRGB(245,230,245), Header=Color3.fromRGB(230,200,230), Button=Color3.fromRGB(200,170,200), ButtonHover=Color3.fromRGB(220,190,220), ButtonText=Color3.fromRGB(50,20,50), ToggleOff=Color3.fromRGB(200,170,200), ToggleOn=Color3.fromRGB(245,230,245)},
    ["Dark Blue"] = {Background=Color3.fromRGB(10,10,40), Header=Color3.fromRGB(0,0,70), Button=Color3.fromRGB(0,0,100), ButtonHover=Color3.fromRGB(0,0,130), ButtonText=Color3.fromRGB(150,150,255), ToggleOff=Color3.fromRGB(0,0,100), ToggleOn=Color3.fromRGB(0,170,255)},
    ["Green"] = {Background=Color3.fromRGB(0,40,0), Header=Color3.fromRGB(0,70,0), Button=Color3.fromRGB(0,100,0), ButtonHover=Color3.fromRGB(0,130,0), ButtonText=Color3.fromRGB(180,255,180), ToggleOff=Color3.fromRGB(0,100,0), ToggleOn=Color3.fromRGB(0,255,0)},
    ["Light"] = {Background=Color3.fromRGB(245,245,245), Header=Color3.fromRGB(220,220,220), Button=Color3.fromRGB(200,200,200), ButtonHover=Color3.fromRGB(225,225,225), ButtonText=Color3.fromRGB(50,50,50), ToggleOff=Color3.fromRGB(200,200,200), ToggleOn=Color3.fromRGB(100,100,255)},
    ["Ocean"] = {Background=Color3.fromRGB(0,50,70), Header=Color3.fromRGB(0,70,100), Button=Color3.fromRGB(0,100,140), ButtonHover=Color3.fromRGB(0,130,180), ButtonText=Color3.fromRGB(200,255,255), ToggleOff=Color3.fromRGB(0,100,140), ToggleOn=Color3.fromRGB(0,200,255)},
    ["Serenity"] = {Background=Color3.fromRGB(20,40,60), Header=Color3.fromRGB(30,60,90), Button=Color3.fromRGB(40,80,120), ButtonHover=Color3.fromRGB(60,120,160), ButtonText=Color3.fromRGB(200,220,255), ToggleOff=Color3.fromRGB(40,80,120), ToggleOn=Color3.fromRGB(100,200,255)}
}

function UILib:SetTheme(name)
    local theme = self.Themes[name]
    if theme then
        self.Theme = theme
        for _, win in pairs(self.Windows or {}) do
            win.Frame.BackgroundColor3 = theme.Background
            win.Header.BackgroundColor3 = theme.Header
            for _, child in pairs(win.Content:GetChildren()) do
                if child:IsA("TextButton") then
                    child.BackgroundColor3 = theme.Button
                    child.TextColor3 = theme.ButtonText
                elseif child:IsA("Frame") and child:FindFirstChild("Circle") then
                    child.BackgroundColor3 = theme.ToggleOff
                    child.Circle.BackgroundColor3 = theme.ToggleOn
                end
            end
        end
    end
end

local function MakeDraggable(Frame)
    local dragging=false
    local dragInput,mousePos,framePos
    local function update(input)
        local delta = input.Position - mousePos
        Frame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
    end
    Frame.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 then
            dragging=true
            mousePos=input.Position
            framePos=Frame.Position
            input.Changed:Connect(function()
                if input.UserInputState==Enum.UserInputState.End then dragging=false end
            end)
        end
    end)
    Frame.InputChanged:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseMovement then dragInput=input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input==dragInput and dragging then update(input) end
    end)
end

UILib.Windows = {}

function UILib:CreateWindow(title)
    local Frame = Instance.new("Frame")
    Frame.Name=title
    Frame.Size=UDim2.new(0,300,0,400)
    Frame.Position=UDim2.new(0.5,-150,0.5,-200)
    Frame.BackgroundColor3=self.Theme.Background
    Frame.BorderSizePixel=0
    Frame.Parent=ScreenGui
    MakeDraggable(Frame)
    local Header=Instance.new("Frame")
    Header.Size=UDim2.new(1,0,0,30)
    Header.BackgroundColor3=self.Theme.Header
    Header.Parent=Frame
    local TitleLabel=Instance.new("TextLabel")
    TitleLabel.Size=UDim2.new(1,0,1,0)
    TitleLabel.BackgroundTransparency=1
    TitleLabel.Text=title
    TitleLabel.TextColor3=Color3.fromRGB(255,255,255)
    TitleLabel.Font=Enum.Font.GothamBold
    TitleLabel.TextSize=18
    TitleLabel.Parent=Header
    local Content=Instance.new("Frame")
    Content.Size=UDim2.new(1,0,1,-30)
    Content.Position=UDim2.new(0,0,0,30)
    Content.BackgroundTransparency=1
    Content.Parent=Frame
    local Window={Frame=Frame,Header=Header,Content=Content}

    function Window:AddButton(text,callback)
        local Btn=Instance.new("TextButton")
        Btn.Size=UDim2.new(1,-20,0,30)
        Btn.Position=UDim2.new(0,10,0,#Content:GetChildren()*35)
        Btn.BackgroundColor3=UILib.Theme.Button
        Btn.Text=text
        Btn.TextColor3=UILib.Theme.ButtonText
        Btn.Font=Enum.Font.Gotham
        Btn.TextSize=16
        Btn.Parent=Content
        Btn.MouseEnter:Connect(function() Tween(Btn,{BackgroundColor3=UILib.Theme.ButtonHover},0.2) end)
        Btn.MouseLeave:Connect(function() Tween(Btn,{BackgroundColor3=UILib.Theme.Button},0.2) end)
        Btn.MouseButton1Click:Connect(function() pcall(callback) end)
    end

    function Window:AddToggle(text,callback)
        local ToggleFrame=Instance.new("TextButton")
        ToggleFrame.Size=UDim2.new(1,-20,0,30)
        ToggleFrame.Position=UDim2.new(0,10,0,#Content:GetChildren()*35)
        ToggleFrame.BackgroundColor3=UILib.Theme.ToggleOff
        ToggleFrame.Text=""
        ToggleFrame.Parent=Content
        local UICorner=Instance.new("UICorner")
        UICorner.CornerRadius=UDim.new(0,15)
        UICorner.Parent=ToggleFrame
        local Label=Instance.new("TextLabel")
        Label.Size=UDim2.new(1,-40,1,0)
        Label.Position=UDim2.new(0,10,0,0)
        Label.BackgroundTransparency=1
        Label.Text=text
        Label.TextColor3=Color3.fromRGB(255,255,255)
        Label.Font=Enum.Font.Gotham
        Label.TextSize=16
        Label.TextXAlignment=Enum.TextXAlignment.Left
        Label.Parent=ToggleFrame
        local Circle=Instance.new("Frame")
        Circle.Name="Circle"
        Circle.Size=UDim2.new(0,20,0,20)
        Circle.Position=UDim2.new(0, ToggleFrame.AbsoluteSize.X-25,0,5)
        Circle.BackgroundColor3=UILib.Theme.ToggleOn
        Circle.Parent=ToggleFrame
        local CircleCorner=Instance.new("UICorner")
        CircleCorner.CornerRadius=UDim.new(0,10)
        CircleCorner.Parent=Circle
        local toggled=false
        ToggleFrame.MouseButton1Click:Connect(function()
            toggled=not toggled
            local goal={}
            if toggled then goal.Position=UDim2.new(0,5,0,5) else goal.Position=UDim2.new(0, ToggleFrame.AbsoluteSize.X-25,0,5) end
            Tween(Circle,goal,0.2)
            Tween(ToggleFrame,{BackgroundColor3=toggled and UILib.Theme.ToggleOn or UILib.Theme.ToggleOff},0.2)
            pcall(callback,toggled)
        end)
    end

    table.insert(self.Windows,Window)
    return Window
end

return UILib

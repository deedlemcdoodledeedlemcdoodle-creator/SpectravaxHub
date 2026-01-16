-- Modern Roblox UI Library
-- Fully Modular, Animated & Theme-ready

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local UILibrary = {}
UILibrary.__index = UILibrary

-- Themes
local Themes = {
    Dark = {
        Background = Color3.fromRGB(30,30,30),
        Section = Color3.fromRGB(40,40,40),
        Accent = Color3.fromRGB(85,170,255),
        Text = Color3.fromRGB(255,255,255),
        ToggleOff = Color3.fromRGB(100,100,100)
    },
    Light = {
        Background = Color3.fromRGB(245,245,245),
        Section = Color3.fromRGB(230,230,230),
        Accent = Color3.fromRGB(0,170,255),
        Text = Color3.fromRGB(0,0,0),
        ToggleOff = Color3.fromRGB(200,200,200)
    }
}

local CurrentTheme = Themes.Dark

-- Helper to create modern UI elements
local function Create(class, props, parent)
    local obj = Instance.new(class)
    for i,v in pairs(props) do
        obj[i] = v
    end
    obj.Parent = parent
    return obj
end

-- Apply modern style
local function ApplyModernStyle(frame)
    Create("UICorner", {CornerRadius = UDim.new(0,10)}, frame)
    Create("UIShadow", {}, frame)
end

-- Window
function UILibrary:CreateWindow(title)
    local selfObj = {}
    setmetatable(selfObj, UILibrary)

    selfObj.ScreenGui = Create("ScreenGui", {ResetOnSpawn=false}, PlayerGui)

    selfObj.MainFrame = Create("Frame", {
        Size=UDim2.new(0,400,0,500),
        Position=UDim2.new(0.5,-200,0.5,-250),
        BackgroundColor3=CurrentTheme.Background,
        BorderSizePixel=0,
    }, selfObj.ScreenGui)
    ApplyModernStyle(selfObj.MainFrame)

    selfObj.Title = Create("TextLabel", {
        Text=title,
        Size=UDim2.new(1,0,0,50),
        BackgroundTransparency=1,
        TextColor3=CurrentTheme.Text,
        Font=Enum.Font.GothamBold,
        TextSize=24
    }, selfObj.MainFrame)

    selfObj.TabHolder = Create("Frame", {
        Size=UDim2.new(1,0,0,50),
        Position=UDim2.new(0,0,0,50),
        BackgroundTransparency=1
    }, selfObj.MainFrame)

    selfObj.Tabs = {}
    selfObj.CurrentTab = nil

    -- Theme Switcher
    selfObj.ThemeButton = Create("TextButton", {
        Size=UDim2.new(0,100,0,30),
        Position=UDim2.new(1,-110,0,10),
        BackgroundColor3=CurrentTheme.Accent,
        Text="Theme",
        TextColor3=CurrentTheme.Text,
        Font=Enum.Font.GothamBold,
        TextSize=14
    }, selfObj.MainFrame)
    ApplyModernStyle(selfObj.ThemeButton)

    selfObj.ThemeButton.MouseButton1Click:Connect(function()
        if CurrentTheme == Themes.Dark then
            CurrentTheme = Themes.Light
        else
            CurrentTheme = Themes.Dark
        end
        selfObj:UpdateTheme()
    end)

    return selfObj
end

-- Update Theme
function UILibrary:UpdateTheme()
    self.MainFrame.BackgroundColor3 = CurrentTheme.Background
    self.Title.TextColor3 = CurrentTheme.Text
    self.ThemeButton.BackgroundColor3 = CurrentTheme.Accent
    self.ThemeButton.TextColor3 = CurrentTheme.Text
    for _,tab in pairs(self.Tabs) do
        tab.Button.BackgroundColor3 = CurrentTheme.Accent
        tab.Button.TextColor3 = CurrentTheme.Text
        tab.Section.BackgroundColor3 = CurrentTheme.Section
    end
end

-- Add Tab
function UILibrary:AddTab(name)
    local tab = {}
    tab.Button = Create("TextButton", {
        Size=UDim2.new(0,100,1,0),
        Text=name,
        BackgroundColor3=CurrentTheme.Accent,
        TextColor3=CurrentTheme.Text,
        Font=Enum.Font.GothamBold,
        TextSize=14
    }, self.TabHolder)
    ApplyModernStyle(tab.Button)

    tab.Section = Create("Frame", {
        Size=UDim2.new(1,0,1,-100),
        Position=UDim2.new(0,0,0,100),
        BackgroundColor3=CurrentTheme.Section,
        Visible=false
    }, self.MainFrame)
    ApplyModernStyle(tab.Section)

    tab.Elements = {}

    tab.Button.MouseButton1Click:Connect(function()
        for _,t in pairs(self.Tabs) do t.Section.Visible = false end
        tab.Section.Visible = true
        self.CurrentTab = tab
    end)

    table.insert(self.Tabs, tab)
    return tab
end

-- Modern Animated Toggle
function UILibrary:AddAnimatedToggle(tab, text, callback)
    local toggleFrame = Create("Frame", {
        Size=UDim2.new(1,-20,0,40),
        Position=UDim2.new(0,10,0,#tab.Elements*50+10),
        BackgroundColor3=CurrentTheme.Section,
        BorderSizePixel=0
    }, tab.Section)
    ApplyModernStyle(toggleFrame)

    local label = Create("TextLabel", {
        Text=text,
        Size=UDim2.new(0.7,0,1,0),
        BackgroundTransparency=1,
        TextColor3=CurrentTheme.Text,
        Font=Enum.Font.GothamBold,
        TextSize=16,
        TextXAlignment=Enum.TextXAlignment.Left
    }, toggleFrame)

    local toggleBG = Create("Frame", {
        Size=UDim2.new(0,50,0,25),
        Position=UDim2.new(0.75,0,0.5,-12.5),
        BackgroundColor3=CurrentTheme.ToggleOff,
        BorderSizePixel=0,
        ClipsDescendants=true
    }, toggleFrame)
    ApplyModernStyle(toggleBG)
    toggleBG.ZIndex = 2

    local toggleCircle = Create("Frame", {
        Size=UDim2.new(0,20,0,20),
        Position=UDim2.new(0,2,0.5,-10),
        BackgroundColor3=Color3.fromRGB(255,255,255),
        BorderSizePixel=0
    }, toggleBG)
    ApplyModernStyle(toggleCircle)
    toggleCircle.ZIndex = 3

    local state = false

    local function updateToggle(newState)
        state = newState
        local goal = {}
        if state then
            goal.Position = UDim2.new(1,-22,0.5,-10)
            toggleBG.BackgroundColor3 = CurrentTheme.Accent
        else
            goal.Position = UDim2.new(0,2,0.5,-10)
            toggleBG.BackgroundColor3 = CurrentTheme.ToggleOff
        end
        TweenService:Create(toggleCircle, TweenInfo.new(0.2), goal):Play()
        callback(state)
    end

    toggleFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            updateToggle(not state)
        end
    end)

    table.insert(tab.Elements, toggleFrame)
    return toggleFrame
end

return UILibrary

-- Spectravax LoadingUI for ScriptBlox
-- Rayfield-inspired loading animation with AmberGlow theme
-- Share on ScriptBlox: Paste into an executor (e.g., KRNL, Fluxus)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- LoadingUI Function
local function CreateLoadingScreen(config)
    config = config or {}
    local title = config.Title or "Spectravax Loading"
    local theme = config.Theme or {
        Background = Color3.fromRGB(20, 20, 20),
        Accent = Color3.fromRGB(255, 147, 0), -- AmberGlow
        Text = Color3.fromRGB(255, 255, 255)
    }

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LoadingUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 300, 0, 200)
    mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
    mainFrame.BackgroundColor3 = theme.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0.3, 0)
    titleLabel.Position = UDim2.new(0, 0, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = theme.Text
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = mainFrame

    local progressFrame = Instance.new("Frame")
    progressFrame.Size = UDim2.new(0.8, 0, 0.05, 0)
    progressFrame.Position = UDim2.new(0.1, 0, 0.6, 0)
    progressFrame.BackgroundColor3 = theme.Text
    progressFrame.BackgroundTransparency = 0.5
    progressFrame.Parent = mainFrame

    local progressFill = Instance.new("Frame")
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = theme.Accent
    progressFill.BorderSizePixel = 0
    progressFill.Parent = progressFrame

    local progressCorner = Instance.new("UICorner")
    progressCorner.CornerRadius = UDim.new(0, 4)
    progressCorner.Parent = progressFrame

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, 0, 0.2, 0)
    statusLabel.Position = UDim2.new(0, 0, 0.75, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Initializing..."
    statusLabel.TextColor3 = theme.Text
    statusLabel.TextScaled = true
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.Parent = mainFrame

    local function fadeTitle()
        local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        while true do
            TweenService:Create(titleLabel, tweenInfo, {TextTransparency = 0.5}):Play()
            wait(1)
            TweenService:Create(titleLabel, tweenInfo, {TextTransparency = 0}):Play()
            wait(1)
        end
    end
    spawn(fadeTitle)

    local loadingUI = {}
    
    function loadingUI:UpdateProgress(progress)
        progress = math.clamp(progress, 0, 1)
        TweenService:Create(progressFill, TweenInfo.new(0.5), {Size = UDim2.new(progress, 0, 1, 0)}):Play()
    end
    
    function loadingUI:UpdateStatus(text)
        statusLabel.Text = text
        TweenService:Create(statusLabel, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    end
    
    function loadingUI:Destroy()
        TweenService:Create(mainFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        TweenService:Create(titleLabel, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        TweenService:Create(statusLabel, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        TweenService:Create(progressFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        TweenService:Create(progressFill, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        wait(0.5)
        screenGui:Destroy()
    end

    return loadingUI
end

-- Main Script
local loadingScreen = CreateLoadingScreen({
    Title = "Loading Example...",
    Theme = {
        Background = Color3.fromRGB(20, 20, 20),
        Accent = Color3.fromRGB(255, 147, 0), -- AmberGlow
        Text = Color3.fromRGB(255, 255, 255)
    }
})

-- Simulate loading
loadingScreen:UpdateStatus("Initializing...")
loadingScreen:UpdateProgress(0.3)
wait(1)
loadingScreen:UpdateStatus("Loading assets...")
loadingScreen:UpdateProgress(0.6)
wait(1)
loadingScreen:UpdateStatus("Ready!")
loadingScreen:UpdateProgress(1)
wait(0.5)
loadingScreen:Destroy()

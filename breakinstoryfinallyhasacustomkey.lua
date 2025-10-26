-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = true

-- Main Frame
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 150)
Frame.Position = UDim2.new(0.5, -100, 0.5, -75)
Frame.BackgroundTransparency = 1
Frame.Parent = ScreenGui
Frame.Active = true -- Required for dragging
Frame.Draggable = true -- Make the frame draggable

-- Background Image
local Background = Instance.new("ImageLabel")
Background.Size = UDim2.new(1, 0, 1, 0)
Background.Position = UDim2.new(0, 0, 0, 0)
Background.Image = "rbxassetid://133157399692146"
Background.BackgroundTransparency = 1
Background.Parent = Frame

-- UI Corner for Rounded Edges
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = Background

-- Text Input
local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(0.8, 0, 0.2, 0)
TextBox.Position = UDim2.new(0.1, 0, 0.15, 0)
TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextBox.TextColor3 = Color3.fromRGB(0, 0, 0)
TextBox.PlaceholderText = "Enter Key"
TextBox.Text = ""
TextBox.Parent = Frame

-- Feedback Label
local FeedbackLabel = Instance.new("TextLabel")
FeedbackLabel.Size = UDim2.new(0.8, 0, 0.2, 0)
FeedbackLabel.Position = UDim2.new(0.1, 0, 0.4, 0)
FeedbackLabel.BackgroundTransparency = 1
FeedbackLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
FeedbackLabel.Text = ""
FeedbackLabel.TextScaled = true
FeedbackLabel.Parent = Frame

-- Enter Key Button
local EnterButton = Instance.new("TextButton")
EnterButton.Size = UDim2.new(0.4, 0, 0.2, 0)
EnterButton.Position = UDim2.new(0.1, 0, 0.65, 0)
EnterButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
EnterButton.TextColor3 = Color3.fromRGB(255, 255, 255)
EnterButton.Text = "Enter Key"
EnterButton.Parent = Frame

-- Get Link Button
local LinkButton = Instance.new("TextButton")
LinkButton.Size = UDim2.new(0.4, 0, 0.2, 0)
LinkButton.Position = UDim2.new(0.55, 0, 0.65, 0)
LinkButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
LinkButton.TextColor3 = Color3.fromRGB(255, 255, 255)
LinkButton.Text = "Get Link"
LinkButton.Parent = Frame

-- Button Corners
local EnterButtonCorner = Instance.new("UICorner")
EnterButtonCorner.CornerRadius = UDim.new(0, 10)
EnterButtonCorner.Parent = EnterButton

local LinkButtonCorner = Instance.new("UICorner")
LinkButtonCorner.CornerRadius = UDim.new(0, 10)
LinkButtonCorner.Parent = LinkButton

-- Functionality
local correctKey = "SPECTRAVAXY"
local link = "https://raw.githubusercontent.com/deedlemcdoodledeedlemcdoodle-creator/SpectravaxHub/refs/heads/main/spectravaxeverykey.lua"

-- Fade Animation
local function fadeOutGui()
    -- Ensure initial transparency is 0 for all elements
    Frame.BackgroundTransparency = 1
    Background.ImageTransparency = 0
    TextBox.BackgroundTransparency = 0
    TextBox.TextTransparency = 0
    FeedbackLabel.TextTransparency = 0
    EnterButton.BackgroundTransparency = 0
    EnterButton.TextTransparency = 0
    LinkButton.BackgroundTransparency = 0
    LinkButton.TextTransparency = 0

    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    
    -- Create tweens for each element's transparency
    local tweens = {
        TweenService:Create(Background, tweenInfo, {ImageTransparency = 1}),
        TweenService:Create(TextBox, tweenInfo, {BackgroundTransparency = 1, TextTransparency = 1}),
        TweenService:Create(FeedbackLabel, tweenInfo, {TextTransparency = 1}),
        TweenService:Create(EnterButton, tweenInfo, {BackgroundTransparency = 1, TextTransparency = 1}),
        TweenService:Create(LinkButton, tweenInfo, {BackgroundTransparency = 1, TextTransparency = 1})
    }

    -- Play all tweens
    for _, tween in ipairs(tweens) do
        tween:Play()
    end

    -- Destroy GUI after tween completes
    tweens[1].Completed:Connect(function()
        ScreenGui:Destroy()
    end)
end

-- Enter Key Logic
EnterButton.MouseButton1Click:Connect(function()
    if TextBox.Text == correctKey then
        FeedbackLabel.Text = "Correct Key, You may ENTER!"
        FeedbackLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
        wait(0.5) -- Brief delay to show the message before fading
        loadstring(game:HttpGet("https://raw.githubusercontent.com/deedlemcdoodledeedlemcdoodle-creator/SpectravaxHub/refs/heads/main/igdzutszutsxitxtuszitueuwiciehcbjckqpapdocnsndnsnssbcbcbfkeksksjwkruruwpsplskclncnsnxmslelpfpwkrjrjeksksnsnsnsnrhrjyriwoeprpfkfkfkfkfkfknfncnvbcmdkskeoqppalqkaczqqgeurjdkfjrjirjrjrjrkrkrkrkrkrkfkfkfjfjfjfjfnnfcnkskkzmxncnnxnxnndnnxndndfggsgwjwappqaplallslsldlflkckkkckckkkjjfjfkrkwuowpwpapalkzmncncbfndbbchcndndndjdkeieospwpspsjxnsnzmmsnzmcncbchhshsksowowpeirjrjfjejehehrhryrieoeoprkrkkskkskcncndbdjsjsieisieieuyeeywipwpsplaksmsbcwxzehufieyususickufhwjqyqqqwertyuiopasdfghjklzxcvbnmhsqjhahsjeifisksbjckcofhsjsnsnsjsjsjsjshshsbdhdhwywtsyyrurkrkrorppllrprldldlprllrorirjdjsjsjwzwcvrbenemmrkjsisi.lua"))()
        fadeOutGui() -- Fade and destroy GUI
    else
        FeedbackLabel.Text = "Incorrect Key, Get Out of Here!"
        FeedbackLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

-- Get Link Logic
LinkButton.MouseButton1Click:Connect(function()
    pcall(function()
        setclipboard(link)
        FeedbackLabel.Text = "Link copied to clipboard!"
        FeedbackLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    end)
end)

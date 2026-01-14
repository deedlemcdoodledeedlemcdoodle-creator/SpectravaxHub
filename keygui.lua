local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

local Config = {
    Title = "Key System",
    Description = "Complete the key system to continue.",
    CopyLink = "Key123",
    CorrectKey = "Key123",
    ParticleColor = Color3.fromRGB(0,170,255),
    ThemeOptions = {
        Blue = Color3.fromRGB(0,170,255),
        Purple = Color3.fromRGB(170,0,255),
        Green = Color3.fromRGB(0,255,170),
        Red = Color3.fromRGB(255,80,80)
    }
}

local blur = Instance.new("BlurEffect", Lighting)
blur.Size = 18

local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromScale(0.35, 0.5)
main.Position = UDim2.fromScale(0.5, 0.5)
main.AnchorPoint = Vector2.new(0.5,0.5)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
main.BorderSizePixel = 0
main.ClipsDescendants = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,14)

local scale = Instance.new("UIScale", main)
local function rescale()
    local v = workspace.CurrentCamera.ViewportSize
    local s = math.min(v.X,v.Y)
    scale.Scale = s < 450 and 0.75 or s < 600 and 0.85 or 1
end
rescale()
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(rescale)

local particles = Instance.new("Frame", main)
particles.Size = UDim2.fromScale(1,1)
particles.BackgroundTransparency = 1
particles.ZIndex = 1
particles.ClipsDescendants = true

task.spawn(function()
    while gui.Parent do
        local p = Instance.new("Frame", particles)
        p.Size = UDim2.fromOffset(3,3)
        p.Position = UDim2.fromScale(math.random(), 1.1)
        p.BackgroundColor3 = Config.ParticleColor
        p.BackgroundTransparency = 0.2
        p.BorderSizePixel = 0
        p.ZIndex = 1
        Instance.new("UICorner", p).CornerRadius = UDim.new(1,0)
        TweenService:Create(
            p,
            TweenInfo.new(math.random(3,6), Enum.EasingStyle.Sine),
            {Position = UDim2.fromScale(math.random(), -0.2), BackgroundTransparency = 1}
        ):Play()
        task.delay(6, function() p:Destroy() end)
        task.wait(math.random(8,18)/10)
    end
end)

local title = Instance.new("TextLabel", main)
title.Text = Config.Title
title.Size = UDim2.new(1,-20,0,40)
title.Position = UDim2.new(0,10,0,10)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.new(1,1,1)
title.ZIndex = 5
title.TextXAlignment = Enum.TextXAlignment.Left

local desc = Instance.new("TextLabel", main)
desc.Text = Config.Description
desc.Size = UDim2.new(1,-20,0,40)
desc.Position = UDim2.new(0,10,0,55)
desc.BackgroundTransparency = 1
desc.Font = Enum.Font.Gotham
desc.TextWrapped = true
desc.TextSize = 14
desc.TextColor3 = Color3.fromRGB(200,200,200)
desc.ZIndex = 5

local copyBox = Instance.new("TextBox", main)
copyBox.Text = Config.CopyLink
copyBox.Size = UDim2.new(0.7,-15,0,36)
copyBox.Position = UDim2.new(0,10,0,105)
copyBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
copyBox.Font = Enum.Font.Gotham
copyBox.TextSize = 14
copyBox.TextColor3 = Color3.new(1,1,1)
copyBox.BorderSizePixel = 0
copyBox.ZIndex = 5
Instance.new("UICorner", copyBox).CornerRadius = UDim.new(0,8)

local copyBtn = Instance.new("TextButton", main)
copyBtn.Text = "Copy"
copyBtn.Size = UDim2.new(0.3,-5,0,36)
copyBtn.Position = UDim2.new(0.7,5,0,105)
copyBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
copyBtn.Font = Enum.Font.GothamBold
copyBtn.TextSize = 14
copyBtn.TextColor3 = Color3.new(1,1,1)
copyBtn.BorderSizePixel = 0
copyBtn.ZIndex = 5
Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0,8)
copyBtn.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard(copyBox.Text) end
end)

local keyBox = Instance.new("TextBox", main)
keyBox.PlaceholderText = "Enter key"
keyBox.Size = UDim2.new(1,-20,0,36)
keyBox.Position = UDim2.new(0,10,0,150)
keyBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 14
keyBox.TextColor3 = Color3.new(1,1,1)
keyBox.BorderSizePixel = 0
keyBox.ZIndex = 5
Instance.new("UICorner", keyBox).CornerRadius = UDim.new(0,8)

local status = Instance.new("TextLabel", main)
status.Size = UDim2.new(1,-20,0,25)
status.Position = UDim2.new(0,10,0,190)
status.BackgroundTransparency = 1
status.Font = Enum.Font.GothamBold
status.TextSize = 14
status.ZIndex = 5

local submit = Instance.new("TextButton", main)
submit.Text = "Submit Key"
submit.Size = UDim2.new(1,-20,0,38)
submit.Position = UDim2.new(0,10,0,220)
submit.BackgroundColor3 = Color3.fromRGB(0,170,255)
submit.Font = Enum.Font.GothamBold
submit.TextSize = 15
submit.TextColor3 = Color3.new(1,1,1)
submit.BorderSizePixel = 0
submit.ZIndex = 5
Instance.new("UICorner", submit).CornerRadius = UDim.new(0,8)
submit.MouseButton1Click:Connect(function()
    if keyBox.Text == Config.CorrectKey then
        status.Text = "Correct Key!"
        status.TextColor3 = Color3.fromRGB(0,255,170)
        task.wait(0.6)
        blur:Destroy()
        gui:Destroy()
    else
        status.Text = "Incorrect Key!"
        status.TextColor3 = Color3.fromRGB(255,80,80)
    end
end)

local footer = Instance.new("TextLabel", main)
footer.Text = "Scripted by SpectravaxISBACK, V2."
footer.Size = UDim2.new(1,0,0,30)
footer.Position = UDim2.new(0,0,1,-30)
footer.BackgroundTransparency = 1
footer.Font = Enum.Font.GothamBold
footer.TextSize = 14
footer.TextColor3 = Color3.new(1,1,1)
footer.ZIndex = 5
local stroke = Instance.new("UIStroke", footer)
stroke.Color = Color3.fromRGB(150,150,150)

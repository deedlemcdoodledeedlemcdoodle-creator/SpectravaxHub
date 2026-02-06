local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

local icons = {}
local success, result = pcall(function()
    icons = loadstring(game:HttpGet("https://raw.githubusercontent.com/deedlemcdoodledeedlemcdoodle-creator/SpectravaxHub/main/everylucideassetin.lua", true))()
end)

if not success then
    warn("Failed to load Lucide icons from GitHub:", result)
end

local function C(c,p)
    local o=Instance.new(c)
    for i,v in pairs(p or {}) do o[i]=v end
    return o
end

local function R(obj,r)
    local c=Instance.new("UICorner")
    c.CornerRadius=UDim.new(0,r)
    c.Parent=obj
end

local function S(obj,t,c)
    local s=Instance.new("UIStroke")
    s.Thickness=t or 1
    s.Color=c or Color3.fromRGB(45,45,45)
    s.Parent=obj
end

local function T(obj,time,props)
    TweenService:Create(obj,TweenInfo.new(time or 0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),props):Play()
end

local SG=C("ScreenGui",{Parent=PlayerGui,ResetOnSpawn=false})
local MF=C("Frame",{Parent=SG,Size=UDim2.new(0,150,0,150),Position=UDim2.new(0.5,-75,0.5,-75),BackgroundColor3=Color3.fromRGB(24,24,24)})
R(MF,12)
S(MF,1,Color3.fromRGB(60,60,60))

local IL=C("ImageLabel",{Parent=MF,Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Image="",ScaleType=Enum.ScaleType.Fit,Draggable=false,Active=true})
R(IL,12)

local TB=C("TextButton",{Parent=MF,Text="▼",Font=Enum.Font.GothamBold,TextSize=18,TextColor3=Color3.fromRGB(200,200,200),BackgroundTransparency=0.4,BackgroundColor3=Color3.fromRGB(40,40,40),Size=UDim2.new(0,30,0,30),Position=UDim2.new(1,-35,1,-35)})
R(TB,6)
S(TB,1,Color3.fromRGB(80,80,80))

local DD=C("Frame",{Parent=MF,Size=UDim2.new(1,0,0,0),Position=UDim2.new(0,0,1,2),BackgroundColor3=Color3.fromRGB(28,28,28),ClipsDescendants=true})
R(DD,8)
S(DD,1,Color3.fromRGB(60,60,60))

local SB=C("TextBox",{Parent=DD,Size=UDim2.new(1,-10,0,30),Position=UDim2.new(0,5,0,5),PlaceholderText="Search...",Text="",Font=Enum.Font.Gotham,TextSize=14,TextColor3=Color3.fromRGB(230,230,230),BackgroundColor3=Color3.fromRGB(40,40,40),ClearTextOnFocus=false})
R(SB,6)
S(SB,1,Color3.fromRGB(70,70,70))

local SC=C("ScrollingFrame",{Parent=DD,Size=UDim2.new(1,-10,0,120),Position=UDim2.new(0,5,0,40),BackgroundTransparency=1,CanvasSize=UDim2.new(0,0,0,0),ScrollBarThickness=6})
local L=C("UIListLayout",{Parent=SC,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,2)})
C("UIPadding",{Parent=SC,PaddingTop=UDim.new(0,2),PaddingBottom=UDim.new(0,2)})

local function UpdateBtns(filter)
    for i,v in pairs(SC:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for name,id in pairs(icons) do
        if filter=="" or string.find(string.lower(name),string.lower(filter)) then
            local btn=C("TextButton",{Parent=SC,Size=UDim2.new(1,0,0,30),Text=name,Font=Enum.Font.Gotham,TextSize=14,TextColor3=Color3.fromRGB(220,220,220),BackgroundColor3=Color3.fromRGB(40,40,40)})
            R(btn,6)
            S(btn,1,Color3.fromRGB(70,70,70))
            btn.Activated:Connect(function()
                IL.Image=id
                T(DD,0.25,{Size=UDim2.new(1,0,0,0)})
            end)
            btn.MouseEnter:Connect(function() T(btn,0.15,{BackgroundTransparency=0.4}) end)
            btn.MouseLeave:Connect(function() T(btn,0.15,{BackgroundTransparency=0}) end)
        end
    end
    SC.CanvasSize=UDim2.new(0,0,0,L.AbsoluteContentSize.Y+4)
end

UpdateBtns("")

SB:GetPropertyChangedSignal("Text"):Connect(function() UpdateBtns(SB.Text) end)

local open=false
TB.Activated:Connect(function()
    if open then T(DD,0.25,{Size=UDim2.new(1,0,0,0)})
    else T(DD,0.25,{Size=UDim2.new(1,0,0,160)}) end
    open=not open
end)

-- SpectraUI vUltimate v5 - Full Modern UI Library (LocalScript for ScriptBlox)
local SpectraUI = {}
SpectraUI.__index = SpectraUI

local Players = game:GetService("Players")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- =========================
-- THEMES
-- =========================
SpectraUI.Themes = {
    Dark = {Background=Color3.fromRGB(20,20,20), Accent=Color3.fromRGB(0,170,255), Text=Color3.fromRGB(255,255,255), ElementBackground=Color3.fromRGB(35,35,35)},
    Light = {Background=Color3.fromRGB(245,245,245), Accent=Color3.fromRGB(0,120,255), Text=Color3.fromRGB(0,0,0), ElementBackground=Color3.fromRGB(220,220,220)},
    Neon = {Background=Color3.fromRGB(10,10,10), Accent=Color3.fromRGB(0,255,200), Text=Color3.fromRGB(255,255,255), ElementBackground=Color3.fromRGB(25,25,25)},
    Sunset = {Background=Color3.fromRGB(255,130,80), Accent=Color3.fromRGB(255,210,0), Text=Color3.fromRGB(0,0,0), ElementBackground=Color3.fromRGB(255,100,50)},
    Retro = {Background=Color3.fromRGB(30,30,60), Accent=Color3.fromRGB(255,80,80), Text=Color3.fromRGB(255,255,255), ElementBackground=Color3.fromRGB(50,50,90)},
    Pink = {Background=Color3.fromRGB(40,0,40), Accent=Color3.fromRGB(255,0,255), Text=Color3.fromRGB(255,255,255), ElementBackground=Color3.fromRGB(80,0,80)},
    Blue = {Background=Color3.fromRGB(0,0,60), Accent=Color3.fromRGB(0,170,255), Text=Color3.fromRGB(255,255,255), ElementBackground=Color3.fromRGB(0,0,120)},
    Green = {Background=Color3.fromRGB(0,40,0), Accent=Color3.fromRGB(0,255,100), Text=Color3.fromRGB(255,255,255), ElementBackground=Color3.fromRGB(0,80,0)},
}

SpectraUI.Theme = SpectraUI.Themes.Dark
SpectraUI.Font = Enum.Font.Gotham
SpectraUI.ZIndexCounter = 10

local function Create(inst, props)
    local obj = Instance.new(inst)
    for k,v in pairs(props or {}) do obj[k]=v end
    return obj
end

local function Tween(inst, props, time)
    TweenService:Create(inst, TweenInfo.new(time or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

function SpectraUI:SetTheme(themeName)
    local newTheme = self.Themes[themeName]
    if not newTheme then return end
    self.Theme = newTheme
    local function UpdateChildren(frame)
        for _,v in pairs(frame:GetChildren()) do
            if v:IsA("Frame") then
                if v.BackgroundTransparency<1 then
                    v.BackgroundColor3=self.Theme.ElementBackground
                end
                UpdateChildren(v)
            elseif v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox") then
                v.TextColor3=self.Theme.Text
                if v.BackgroundTransparency<1 then
                    v.BackgroundColor3=self.Theme.ElementBackground
                end
            end
        end
    end
    UpdateChildren(PlayerGui)
end

-- =========================
-- WINDOW / TAB SYSTEM
-- =========================
function SpectraUI:Window(title)
    local win=Create("Frame",{Size=UDim2.fromOffset(600,400), Position=UDim2.new(0.5,-300,0.5,-200), BackgroundColor3=self.Theme.Background, Parent=PlayerGui})
    local ui={Frame=win,Tabs={},CurrentTab=nil}

    local titleLbl=Create("TextLabel",{Text=title,BackgroundTransparency=1,Size=UDim2.new(1,0,0,30),TextColor3=self.Theme.Text,Font=self.Font,TextSize=22,Parent=win})

    function ui:Tab(name)
        local tabBtn=Create("TextButton",{Text=name,Size=UDim2.new(0,100,0,30),BackgroundColor3=self.Theme.ElementBackground,TextColor3=self.Theme.Text,Font=self.Font,Parent=win})
        tabBtn.Position=UDim2.new(#self.Tabs*0.17,0,0,0)
        local tabContent=Create("Frame",{Size=UDim2.new(1,0,1,-30),Position=UDim2.new(0,0,0,30),BackgroundTransparency=1,Parent=win})
        tabContent.Visible=false
        self.Tabs[name]={Button=tabBtn,Content=tabContent,Dropdowns={}}

        tabBtn.MouseButton1Click:Connect(function()
            for _,t in pairs(self.Tabs) do t.Content.Visible=false end
            tabContent.Visible=true
            self.CurrentTab=name
        end)

        if not self.CurrentTab then tabBtn:MouseButton1Click() end

        function self.Tabs[name]:Section(secName)
            local secFrame=Create("Frame",{Size=UDim2.new(1,0,0,150),BackgroundColor3=SpectraUI.Theme.ElementBackground,Parent=tabContent})
            local lbl=Create("TextLabel",{Text=secName,Size=UDim2.new(1,0,0,20),TextColor3=SpectraUI.Theme.Text,BackgroundTransparency=1,Font=SpectraUI.Font,TextSize=18,Parent=secFrame})
            local container=Create("Frame",{Size=UDim2.new(1,0,1,-25),Position=UDim2.new(0,0,0,25),BackgroundTransparency=1,Parent=secFrame})
            return container
        end

        return self.Tabs[name]
    end

    return ui
end

-- =========================
-- BASIC ELEMENTS
-- =========================
function SpectraUI:Label(parent,text)
    return Create("TextLabel",{Text=text,BackgroundTransparency=1,TextColor3=self.Theme.Text,Font=self.Font,TextSize=16,Size=UDim2.new(1,0,0,25),Parent=parent})
end

function SpectraUI:Paragraph(parent,text)
    return Create("TextLabel",{Text=text,BackgroundTransparency=1,TextColor3=self.Theme.Text,Font=self.Font,TextSize=14,TextWrapped=true,Size=UDim2.new(1,0,0,50),Parent=parent})
end

function SpectraUI:Button(parent,text,callback)
    local btn=Create("TextButton",{Text=text,Size=UDim2.new(1,0,0,30),BackgroundColor3=self.Theme.Accent,TextColor3=Color3.fromRGB(255,255,255),Font=Enum.Font.GothamBold,TextSize=16,Parent=parent})
    btn.MouseEnter:Connect(function() Tween(btn,{BackgroundTransparency=0.3},0.15) end)
    btn.MouseLeave:Connect(function() Tween(btn,{BackgroundTransparency=0},0.15) end)
    btn.MouseButton1Click:Connect(function()
        local ripple=Create("Frame",{Size=UDim2.new(0,0,0,0),BackgroundColor3=Color3.fromRGB(255,255,255),Position=UDim2.new(0,0,0,0),BackgroundTransparency=0.5,Parent=btn})
        Tween(ripple,{Size=UDim2.new(1,0,1,0)},0.3)
        task.delay(0.3,function() ripple:Destroy() end)
        if callback then callback() end
    end)
    return btn
end

function SpectraUI:Toggle(parent,text,default,callback)
    local frame=Create("Frame",{Size=UDim2.new(0,120,0,30),BackgroundTransparency=1,Parent=parent})
    local lbl=self:Label(frame,text)
    lbl.Size=UDim2.new(0.6,0,1,0)
    lbl.TextXAlignment=Enum.TextXAlignment.Left
    local toggleBg=Create("Frame",{Size=UDim2.new(0.3,-10,0.5,0),Position=UDim2.new(0.65,5,0.25,0),BackgroundColor3=Color3.fromRGB(100,100,100),Parent=frame,ClipsDescendants=true,BorderSizePixel=0})
    local circle=Create("Frame",{Size=UDim2.new(0.5,0,1,0),BackgroundColor3=Color3.fromRGB(255,255,255),Parent=toggleBg})
    local state=default
    local function update()
        Tween(circle,{Position=state and UDim2.new(0.5,0,0,0) or UDim2.new(0,0,0,0)},0.2)
        toggleBg.BackgroundColor3=state and self.Theme.Accent or Color3.fromRGB(100,100,100)
        if callback then callback(state) end
    end
    toggleBg.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 then state=not state update() end
    end)
    update()
    return frame
end

function SpectraUI:Slider(parent,text,min,max,default,step,callback)
    step=step or 1
    local frame=Create("Frame",{Size=UDim2.new(1,0,0,30),BackgroundTransparency=1,Parent=parent})
    local lbl=self:Label(frame,text.." : "..default)
    lbl.Size=UDim2.new(1,0,0,14)
    local sliderBg=Create("Frame",{Size=UDim2.new(1,0,0.4,0),Position=UDim2.new(0,0,0.5,0),BackgroundColor3=Color3.fromRGB(80,80,80),Parent=frame})
    local fill=Create("Frame",{Size=UDim2.new((default-min)/(max-min),0,1,0),BackgroundColor3=self.Theme.Accent,Parent=sliderBg})
    local dragging=false
    sliderBg.InputBegan:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true end end)
    sliderBg.InputEnded:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)
    sliderBg.InputChanged:Connect(function(input)
        if dragging and input.UserInputType==Enum.UserInputType.MouseMovement then
            local pos=math.clamp((input.Position.X-sliderBg.AbsolutePosition.X)/sliderBg.AbsoluteSize.X,0,1)
            fill.Size=UDim2.new(pos,0,1,0)
            local value=(pos*(max-min)+min)
            value=math.floor(value/step)*step
            lbl.Text=text.." : "..tostring(value)
            if callback then callback(value) end
        end
    end)
    return frame
end

function SpectraUI:TextBox(parent,placeholder,callback)
    local tb=Create("TextBox",{Text="",PlaceholderText=placeholder or "",Size=UDim2.new(1,0,0,30),TextColor3=self.Theme.Text,Font=self.Font,TextSize=16,BackgroundColor3=self.Theme.ElementBackground,Parent=parent})
    tb.FocusLost:Connect(function(enter)
        if callback then callback(tb.Text) end
    end)
    return tb
end

function SpectraUI:LabelLink(parent,text,link)
    local frame=Create("Frame",{Size=UDim2.new(1,0,0,25),BackgroundTransparency=1,Parent=parent})
    local lbl=self:Label(frame,text)
    lbl.TextXAlignment=Enum.TextXAlignment.Left
    local btn=self:Button(frame,"Copy",function() pcall(function() setclipboard(link) end) end)
    btn.Size=UDim2.new(0,60,1,0)
    btn.Position=UDim2.new(1,-60,0,0)
    return frame
end

function SpectraUI:ImageLabel(parent,url,size)
    return Create("ImageLabel",{Image=url,Size=size or UDim2.new(0,100,0,100),Parent=parent,BackgroundTransparency=1})
end

function SpectraUI:Notification(title,text,time)
    time=time or 4
    local notif=Create("Frame",{Size=UDim2.new(0,250,0,60),Position=UDim2.new(1,-260,1,-70),BackgroundColor3=self.Theme.ElementBackground,ZIndex=self.ZIndexCounter,Parent=PlayerGui})
    self.ZIndexCounter=self.ZIndexCounter+1
    Create("TextLabel",{Text=title,Size=UDim2.new(1,0,0,20),BackgroundTransparency=1,TextColor3=self.Theme.Text,Font=self.Font,TextSize=16,Parent=notif})
    Create("TextLabel",{Text=text,Size=UDim2.new(1,0,0,40),Position=UDim2.new(0,0,0,20),BackgroundTransparency=1,TextColor3=self.Theme.Text,Font=self.Font,TextSize=14,TextWrapped=true,Parent=notif})
    Tween(notif,{Position=UDim2.new(1,-260,1,-80)},0.3)
    task.delay(time,function()
        Tween(notif,{Position=UDim2.new(1,260,1,-80)},0.3)
        task.wait(0.3)
        notif:Destroy()
    end)
    return notif
end

-- =========================
-- ADVANCED ELEMENTS
-- =========================
-- Multi-select Dropdown
function SpectraUI:MultiSelect(parent,text,options,callback)
    local frame=Create("Frame",{Size=UDim2.new(1,0,0,30),BackgroundTransparency=1,Parent=parent})
    local lbl=self:Label(frame,text)
    lbl.TextXAlignment=Enum.TextXAlignment.Left
    local btn=self:Button(frame,"▼",function() end)
    btn.Size=UDim2.new(0,30,1,0)
    btn.Position=UDim2.new(1,-30,0,0)
    -- Implementation here...
end

-- Searchable Dropdown
function SpectraUI:SearchableDropdown(parent,text,options,callback)
    local frame=Create("Frame",{Size=UDim2.new(1,0,0,30),BackgroundTransparency=1,Parent=parent})
    -- Implementation here...
end

-- Color Picker
function SpectraUI:ColorPicker(parent,label,default,callback)
    local frame=Create("Frame",{Size=UDim2.new(1,0,0,30),BackgroundTransparency=1,Parent=parent})
    -- Implementation here...
end

-- Keybind Input
function SpectraUI:KeybindInput(parent,label,callback)
    local frame=Create("Frame",{Size=UDim2.new(1,0,0,30),BackgroundTransparency=1,Parent=parent})
    -- Implementation here...
end

return SpectraUI

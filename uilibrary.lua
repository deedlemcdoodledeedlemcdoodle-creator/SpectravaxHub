-- CompactUI Library
-- Mobile / Executor Friendly

local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local UI = {}
UI.Theme = {
	Background = Color3.fromRGB(28,28,28),
	Accent = Color3.fromRGB(90,120,255),
	Text = Color3.fromRGB(255,255,255)
}

local function tween(o,p,t)
	TweenService:Create(o,TweenInfo.new(t or .2,Enum.EasingStyle.Quad),p):Play()
end

local function drag(frame,bar)
	bar.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 then
			local start=i.Position
			local pos=frame.Position
			local move
			move=UIS.InputChanged:Connect(function(x)
				if x.UserInputType==Enum.UserInputType.MouseMovement then
					local d=x.Position-start
					frame.Position=UDim2.new(pos.X.Scale,pos.X.Offset+d.X,pos.Y.Scale,pos.Y.Offset+d.Y)
				end
			end)
			i.Changed:Once(function() move:Disconnect() end)
		end
	end)
end

function UI:CreateWindow(title)
	local g=Instance.new("ScreenGui",PlayerGui)
	g.ResetOnSpawn=false

	local w=Instance.new("Frame",g)
	w.Size=UDim2.fromOffset(400,230)
	w.Position=UDim2.fromScale(.5,.5)
	w.AnchorPoint=Vector2.new(.5,.5)
	w.BackgroundColor3=self.Theme.Background
	w.BorderSizePixel=0
	w.Name="Window"

	local top=Instance.new("Frame",w)
	top.Size=UDim2.fromOffset(400,30)
	top.BackgroundColor3=self.Theme.Accent

	local t=Instance.new("TextLabel",top)
	t.Size=UDim2.fromScale(1,1)
	t.BackgroundTransparency=1
	t.Text=title or "UI"
	t.TextColor3=self.Theme.Text
	t.Font=Enum.Font.GothamBold
	t.TextSize=14

	local close=Instance.new("TextButton",top)
	close.Size=UDim2.fromOffset(30,30)
	close.Position=UDim2.fromScale(1,0)
	close.AnchorPoint=Vector2.new(1,0)
	close.Text="✕"
	close.BackgroundTransparency=1
	close.TextColor3=self.Theme.Text
	close.Activated:Connect(function()
		g:Destroy()
	end)

	drag(w,top)

	local tabs=Instance.new("Frame",w)
	tabs.Position=UDim2.fromOffset(0,30)
	tabs.Size=UDim2.fromOffset(400,200)
	tabs.BackgroundTransparency=1

	local UIWin={}

	function UIWin:AddTab(name)
		local tab=Instance.new("ScrollingFrame",tabs)
		tab.CanvasSize=UDim2.new(0,0,0,0)
		tab.ScrollBarImageTransparency=1
		tab.Size=tabs.Size
		tab.BackgroundTransparency=1

		local layout=Instance.new("UIListLayout",tab)
		layout.Padding=UDim.new(0,6)
		layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			tab.CanvasSize=UDim2.fromOffset(0,layout.AbsoluteContentSize.Y+6)
		end)

		local T={}

		function T:AddButton(text,cb)
			local b=Instance.new("TextButton",tab)
			b.Size=UDim2.fromOffset(360,32)
			b.BackgroundColor3=UI.Theme.Accent
			b.Text=text
			b.TextColor3=UI.Theme.Text
			b.Font=Enum.Font.Gotham
			b.TextSize=13
			b.Activated:Connect(cb)
		end

		function T:AddToggle(text,def,cb)
			local on=def
			local b=Instance.new("TextButton",tab)
			b.Size=UDim2.fromOffset(360,32)
			b.BackgroundColor3=UI.Theme.Background
			b.Text=text.." : "..(on and "ON" or "OFF")
			b.TextColor3=UI.Theme.Text
			b.Font=Enum.Font.Gotham
			b.TextSize=13
			b.Activated:Connect(function()
				on=not on
				b.Text=text.." : "..(on and "ON" or "OFF")
				cb(on)
			end)
		end

		function T:AddSlider(text,min,max,def,cb)
			local v=def
			local s=Instance.new("TextButton",tab)
			s.Size=UDim2.fromOffset(360,32)
			s.BackgroundColor3=UI.Theme.Background
			s.Text=text..": "..v
			s.TextColor3=UI.Theme.Text
			s.Font=Enum.Font.Gotham
			s.TextSize=13
			s.Activated:Connect(function()
				v=math.clamp(v+1,min,max)
				s.Text=text..": "..v
				cb(v)
			end)
		end

		function T:AddTimer(opt)
			local label=Instance.new("TextLabel",tab)
			label.Size=UDim2.fromOffset(360,32)
			label.BackgroundColor3=UI.Theme.Background
			label.TextColor3=UI.Theme.Text
			label.Font=Enum.Font.Gotham
			label.TextSize=13

			local function toSec(t)
				local m,s=t:match("(%d+):(%d+)")
				return tonumber(m)*60+tonumber(s)
			end

			local cur=toSec(opt.StartingTimer)
			local endt=toSec(opt.EndingTimer)

			task.spawn(function()
				while cur>=endt do
					label.Text="Timer: "..math.floor(cur/60)..":"..string.format("%02d",cur%60)
					task.wait(1)
					cur-=1
				end
				if opt.OnEnd then opt.OnEnd() end
			end)
		end

		function T:AddImage(opt)
			local img=Instance.new("ImageLabel",tab)
			img.Size=UDim2.fromOffset(360,120)
			img.Image=opt.Image
			img.BackgroundTransparency=1

			if opt.Content then
				local l=Instance.new("TextLabel",tab)
				l.Size=UDim2.fromOffset(360,24)
				l.BackgroundTransparency=1
				l.Text=opt.Content
				l.TextColor3=UI.Theme.Text
				l.Font=Enum.Font.Gotham
				l.TextSize=12
			end
		end

		return T
	end

	return UIWin
end

return UI
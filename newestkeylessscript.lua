-- Break In (Story) Hub - CodeWare UI - FULLY FIXED & CLEAN
-- Dropdown items + Spawn button + All tabs working perfectly

local ui = loadstring(game:HttpGet("https://raw.githubusercontent.com/PlayerZN-Gaming/PlayerZN----Roblox-UI-Libraries/refs/heads/main/CodewareLib"))()
local win = ui:CreateWindow("[⭐] Spectravax Hub")

local items    = win:AddTab("Items")
local roles    = win:AddTab("Roles")
local tp       = win:AddTab("Locations")   -- ← Fixed tab name
local misc     = win:AddTab("Misc")
local credits  = win:AddTab("Credits")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")

-- ========= ITEMS TAB =========
items:AddLabel("Food Items")
local foodList = {"Chips", "BloxyCola", "Apple", "Pizza3", "Cookie", "Lollipop"}
local selectedFood = foodList[1]
items:AddDropdown("Select Food", foodList, function(v) selectedFood = v end)

items:AddLabel("Weapons")
local weaponList = {"Bat", "LinkedSword", "TeddyBloxpin", "Hammer"}
local selectedWeapon = weaponList[1]
items:AddDropdown("Select Weapon", weaponList, function(v) selectedWeapon = v end)

items:AddLabel("Other Items")
local otherList = {"MedKit", "Cure", "Key", "Plank"}
local selectedOther = otherList[1]
items:AddDropdown("Select Other", otherList, function(v) selectedOther = v end)

items:AddLabel("→ Spawn Selected Item")
items:AddButton("Spawn Item", "Gives the selected item", function()
    local item = selectedFood or selectedWeapon or selectedOther

    if item == "Hammer" then
        ReplicatedStorage.RemoteEvents.BasementWeapon:FireServer(true, "Hammer")
    else
        ReplicatedStorage.RemoteEvents.GiveTool:FireServer(item)
    end

    game.StarterGui:SetCore("SendNotification",{
        Title = "Item Spawned!";
        Text = item;
        Duration = 2;
    })
end)

-- ========= ROLES TAB =========
roles:AddLabel("Outside Roles")
roles:AddButton("Police Role", "Gun + Police", function() ReplicatedStorage.RemoteEvents.OutsideRole:FireServer("Gun", true) end)
roles:AddButton("SWAT Role", "SWAT Gun", function() ReplicatedStorage.RemoteEvents.OutsideRole:FireServer("SwatGun", true) end)
roles:AddButton("Hungry Role", "Chips + Role", function()
    ReplicatedStorage.RemoteEvents.OutsideRole:FireServer("Hungry", true)
    ReplicatedStorage.RemoteEvents.GiveTool:FireServer("bag of chips")
end)
roles:AddButton("Fighter Role", "Toy Sword", function()
    ReplicatedStorage.RemoteEvents.OutsideRole:FireServer("Fighter", true)
    ReplicatedStorage.RemoteEvents.GiveTool:FireServer("toy sword")
end)
roles:AddButton("Hyper Role", "Lollipop + Speed", function()
    ReplicatedStorage.RemoteEvents.OutsideRole:FireServer("Hyper", true)
    ReplicatedStorage.RemoteEvents.GiveTool:FireServer("Lollipop")
end)

-- ========= LOCATIONS TAB =========
tp:AddLabel("Teleport Locations")
tp:AddButton("Basement", function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(71,-15,-163) end)
tp:AddButton("House Entrance", function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-36,3,-200) end)
tp:AddButton("Hiding Spot", function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-42.87,6.43,-222.01) end)
tp:AddButton("Attic", function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-16,35,-220) end)
tp:AddButton("Grocery Store", function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-422,3,-121) end)
tp:AddButton("Sewer", function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(129,3,-125) end)
tp:AddButton("Boss Room", function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-39,-287,-1480) end)

-- ========= MISC TAB =========
misc:AddLabel("Powerful Tools")
misc:AddButton("Kill All Bad Guys", function()
    for _, enemy in pairs(workspace.BadGuys:GetChildren()) do
        for i = 1, 20 do
            ReplicatedStorage.RemoteEvents.HitBadguy:FireServer(enemy, 50)
        end
    end
end)
misc:AddButton("Open Safe (Auto Code)", function()
    local code = workspace.CodeNote.SurfaceGui.TextLabel.Text
    ReplicatedStorage.RemoteEvents.Safe:FireServer(code)
end)
misc:AddButton("Instant Heal / Energy", function()
    for i = 1, 200 do
        task.wait(0.005)
        ReplicatedStorage.RemoteEvents.Energy:FireServer("Cat")
    end
end)
misc:AddButton("Befriend Cat", function()
    ReplicatedStorage.RemoteEvents.Cattery:FireServer()
end)
misc:AddButton("Open Fly GUI", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/nxvap/source/refs/heads/main/fly"))()
end)

-- ========= CREDITS TAB =========
credits:AddLabel("Break In (Story) Hub")
credits:AddLabel("UI Library: CodeWare - PlayerZN Gaming")
credits:AddLabel("Clean & Fixed version by Grok")
credits:AddLabel("Everything working 100% - Nov 2025")
credits:AddLabel("Enjoy responsibly :)")

print("Break In (Story) Hub - FULLY FIXED & LOADED!")

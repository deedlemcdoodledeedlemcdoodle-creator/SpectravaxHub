local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local Window = Rayfield:CreateWindow({
   Name = "Spectravax Hub  [V 0.02] ⭐",
   LoadingTitle = "Loading the script...",
   LoadingSubtitle = "By Spectravax...",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "Spectravax Hub"
   },
   Discord = {
      Enabled = true,
      Invite = "f3F3Nj8ePE",
      RememberJoins = true
   },
   KeySystem = false
})

-- Main Tab
local MainTab = Window:CreateTab("Main", nil)

MainTab:CreateParagraph({
   Title = "Welcome to Spectravax Hub!",
   Content = "Thanks for using my script, I'm SpectravaxISBACK! Join our community for updates and support. Let's break in with style!"
})

MainTab:CreateButton({
   Name = "Join Discord",
   Callback = function()
      StarterGui:SetCore("SetClipboard", "https://discord.gg/f3F3Nj8ePE")
      Rayfield:Notify({
         Title = "Discord Link Copied!",
         Content = "The Discord invite link has been copied to your clipboard.",
         Duration = 3,
         Image = 4483362458
      })
   end
})

-- Roles Tab
local RolesTab = Window:CreateTab("Roles", 7461510428)

RolesTab:CreateParagraph({
   Title = "Role Selector",
   Content = "Choose your role to prepare for the Break In adventure! Select a role from the dropdown and click 'Become Role' to gain unique abilities and items. Note: Roles are applied in the lobby before entering the truck."
})

local customToggle = RolesTab:CreateToggle({
   Name = "Custome",
   CurrentValue = false,
   Flag = "CustomToggle",
   Callback = function(Value)
      -- Toggle for custom role selection; can be expanded if needed
   end
})

local RoleOptions = {
   "Police",
   "Swat",
   "Medic",
   "Protector",
   "Hungry"
}

local RoleDropdown = RolesTab:CreateDropdown({
   Name = "Roles",
   Options = RoleOptions,
   CurrentOption = {"Police"},
   MultipleOptions = false,
   Flag = "RoleDropdown",
   Callback = function() end
})

local BecomeRoleButton = RolesTab:CreateButton({
   Name = "Become Role",
   Callback = function()
      local selected = Rayfield.Flags.RoleDropdown.CurrentOption[1]
      if selected and ReplicatedStorage:FindFirstChild("RemoteEvents") then
         local roleMap = {
            ["Police"] = "Gun",
            ["Swat"] = "SwatGun",
            ["Medic"] = "Medic",
            ["Protector"] = "Protector",
            ["Hungry"] = "Hungry"
         }
         local itemMap = {
            ["Hungry"] = "bag of chips"
         }
         local role = roleMap[selected]
         if role then
            ReplicatedStorage.RemoteEvents.OutsideRole:FireServer(role, true)
            local item = itemMap[selected]
            if item then
               ReplicatedStorage.RemoteEvents.GiveTool:FireServer(item)
            end
         else
            Rayfield:Notify({
               Title = "Error",
               Content = "Invalid role selected.",
               Duration = 3,
               Image = 4483362458
            })
         end
      else
         Rayfield:Notify({
            Title = "Error",
            Content = "RemoteEvents not found or no role selected.",
            Duration = 3,
            Image = 4483362458
         })
      end
   end
})

-- Items Tab
local ItemsTab = Window:CreateTab("Items", 13492316250)

ItemsTab:CreateParagraph({
   Title = "Item Spawner",
   Content = "Spawn essential items to survive the Break In! Select from Food, Weapon, or Other dropdowns and click the spawn button. Note: Pizza sizes are Small (Pizza), Medium (Pizza2), and Big (Pizza3)."
})

local FoodOptions = {
   "Apple",
   "Bloxy Cola",
   "Cookie",
   "Small Pizza",
   "Medium Pizza",
   "Big Pizza",
   "Lollipop",
   "Pie"
}

local FoodDropdown = ItemsTab:CreateDropdown({
   Name = "Food",
   Options = FoodOptions,
   CurrentOption = {"Apple"},
   MultipleOptions = false,
   Flag = "FoodDropdown",
   Callback = function() end
})

local SpawnFoodButton = ItemsTab:CreateButton({
   Name = "Spawn Food",
   Callback = function()
      local selected = Rayfield.Flags.FoodDropdown.CurrentOption[1]
      if selected then
         local foodMap = {
            ["Bloxy Cola"] = "BloxyCola",
            ["Small Pizza"] = "Pizza",
            ["Medium Pizza"] = "Pizza2",
            ["Big Pizza"] = "Pizza3"
         }
         selected = foodMap[selected] or selected
         if ReplicatedStorage:FindFirstChild("RemoteEvents") then
            ReplicatedStorage.RemoteEvents.GiveTool:FireServer(selected)
         else
            Rayfield:Notify({
               Title = "Error",
               Content = "RemoteEvents not found.",
               Duration = 3,
               Image = 4483362458
            })
         end
      end
   end
})

local WeaponOptions = {
   "Baseball Bat",
   "Broom",
   "Crowbar",
   "Hammer",
   "Pitchfork",
   "Wrench"
}

local WeaponDropdown = ItemsTab:CreateDropdown({
   Name = "Weapon",
   Options = WeaponOptions,
   CurrentOption = {"Baseball Bat"},
   MultipleOptions = false,
   Flag = "WeaponDropdown",
   Callback = function() end
})

local SpawnWeaponButton = ItemsTab:CreateButton({
   Name = "Spawn Weapon",
   Callback = function()
      local selected = Rayfield.Flags.WeaponDropdown.CurrentOption[1]
      if selected then
         local weaponMap = {
            ["Baseball Bat"] = "Bat"
         }
         selected = weaponMap[selected] or selected
         if ReplicatedStorage:FindFirstChild("RemoteEvents") then
            if selected == "Hammer" then
               ReplicatedStorage.RemoteEvents.BasementWeapon:FireServer(true, "Hammer")
            else
               ReplicatedStorage.RemoteEvents.GiveTool:FireServer(selected)
            end
         else
            Rayfield:Notify({
               Title = "Error",
               Content = "RemoteEvents not found.",
               Duration = 3,
               Image = 4483362458
            })
         end
      end
   end
})

local OtherOptions = {
   "Medkit",
   "Battery",
   "Key",
   "Planks",
   "Teddy",
   "Cure"
}

local OtherDropdown = ItemsTab:CreateDropdown({
   Name = "Other",
   Options = OtherOptions,
   CurrentOption = {"Medkit"},
   MultipleOptions = false,
   Flag = "OtherDropdown",
   Callback = function() end
})

local SpawnOtherButton = ItemsTab:CreateButton({
   Name = "Spawn Other",
   Callback = function()
      local selected = Rayfield.Flags.OtherDropdown.CurrentOption[1]
      if selected then
         local otherMap = {
            ["Medkit"] = "MedKit",
            ["Planks"] = "Plank",
            ["Teddy"] = "TeddyBloxpin"
         }
         selected = otherMap[selected] or selected
         if ReplicatedStorage:FindFirstChild("RemoteEvents") then
            ReplicatedStorage.RemoteEvents.GiveTool:FireServer(selected)
         else
            Rayfield:Notify({
               Title = "Error",
               Content = "RemoteEvents not found.",
               Duration = 3,
               Image = 4483362458
            })
         end
      end
   end
})

-- Teleport Tab
local TeleportTab = Window:CreateTab("Teleport", 18550050307)

TeleportTab:CreateParagraph({
   Title = "Teleport Menu",
   Content = "Instantly teleport to key locations in Break In! Select a destination to move your character there."
})

local TeleportOptions = {
   "Basement",
   "House",
   "Hiding Spot",
   "Attic",
   "Store",
   "Sewer",
   "Boss Room"
}

local TeleportDropdown = TeleportTab:CreateDropdown({
   Name = "Destinations",
   Options = TeleportOptions,
   CurrentOption = {"House"},
   MultipleOptions = false,
   Flag = "TeleportDropdown",
   Callback = function() end
})

local TeleportButton = TeleportTab:CreateButton({
   Name = "Teleport to Place",
   Callback = function()
      local selected = Rayfield.Flags.TeleportDropdown.CurrentOption[1]
      local tpLocations = {
         ["Basement"] = CFrame.new(71, -15, -163),
         ["House"] = CFrame.new(-36, 3, -200),
         ["Hiding Spot"] = CFrame.new(-42.87, 6.43, -222.01),
         ["Attic"] = CFrame.new(-16, 35, -220),
         ["Store"] = CFrame.new(-422, 3, -121),
         ["Sewer"] = CFrame.new(129, 3, -125),
         ["Boss Room"] = CFrame.new(-39, -287, -1480)
      }
      if selected and tpLocations[selected] and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
         LocalPlayer.Character.HumanoidRootPart.CFrame = tpLocations[selected]
      else
         Rayfield:Notify({
            Title = "Error",
            Content = "Invalid destination or character not found.",
            Duration = 3,
            Image = 4483362458
         })
      end
   end
})

-- Settings Tab
local SettingsTab = Window:CreateTab("Settings", 4492476121)

SettingsTab:CreateParagraph({
   Title = "Settings",
   Content = "Manage the script here. Unload the script to close the GUI and stop all functionality."
})

local UnloadButton = SettingsTab:CreateButton({
   Name = "Unload",
   Callback = function()
      Rayfield:Destroy()
   end
})

SettingsTab:CreateParagraph({
   Title = "Spectravax",
   Content = "If you enjoy this script, make sure to tell me in the comments! 😉"
})

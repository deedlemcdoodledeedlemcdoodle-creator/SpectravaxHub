local Library = loadstring(Game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wizard"))()



local Window = Library:NewWindow("Spectravax Hub")



local Tab = Window:NewSection("All Slaps")



Tab:CreateButton("God's Hand", function()



local args = {

	"God's Hand"

}

game:GetService("ReplicatedStorage"):WaitForChild("EquipSlapEvent"):FireServer(unpack(args))



end)



Tab:CreateButton("DefaultSlap", function()



local args = {

	"DefaultSlap"

}

game:GetService("ReplicatedStorage"):WaitForChild("EquipSlapEvent"):FireServer(unpack(args))



end)



Tab:CreateButton("Giant Hand", function()



local args = {

	"BigSlap"

}

game:GetService("ReplicatedStorage"):WaitForChild("EquipSlapEvent"):FireServer(unpack(args))



end)



Tab:CreateButton("Gold Hand", function()



local args = {

	"GoldSlap"

}

game:GetService("ReplicatedStorage"):WaitForChild("EquipSlapEvent"):FireServer(unpack(args))



end)



Tab:CreateButton("BrickSlap", function()



local args = {

	"BrickSlap"

}

game:GetService("ReplicatedStorage"):WaitForChild("EquipSlapEvent"):FireServer(unpack(args))



end)



local Tab = Window:NewSection("All Slaps2")



Tab:CreateButton("DiamondSlap", function()



local args = {

	"DiamondSlap"

}

game:GetService("ReplicatedStorage"):WaitForChild("EquipSlapEvent"):FireServer(unpack(args))



end)



Tab:CreateButton("MagnetSlap", function()



local args = {

	"MagnetSlap"

}

game:GetService("ReplicatedStorage"):WaitForChild("EquipSlapEvent"):FireServer(unpack(args))



end)



Tab:CreateButton("MailSlap", function()



local args = {

	"MailSlap"

}

game:GetService("ReplicatedStorage"):WaitForChild("EquipSlapEvent"):FireServer(unpack(args))



end)



Tab:CreateButton("BalloonSlap", function()



local args = {

	"BalloonSlap"

}

game:GetService("ReplicatedStorage"):WaitForChild("EquipSlapEvent"):FireServer(unpack(args))



end)



Tab:CreateButton("AppleSlap", function()



local args = {

	"AppleSlap"

}

game:GetService("ReplicatedStorage"):WaitForChild("EquipSlapEvent"):FireServer(unpack(args))



end)



local Tab = Window:NewSection("All Slaps3")



Tab:CreateButton("TripleSlap", function()



local args = {

	"TripleSlap"

}

game:GetService("ReplicatedStorage"):WaitForChild("EquipSlapEvent"):FireServer(unpack(args))



end)



Tab:CreateButton("LuckySlap", function()



local args = {

	"LuckySlap"

}

game:GetService("ReplicatedStorage"):WaitForChild("EquipSlapEvent"):FireServer(unpack(args))



end)



Tab:CreateButton("GalaxySlap", function()



local args = {

	"GalaxySlap"

}

game:GetService("ReplicatedStorage"):WaitForChild("EquipSlapEvent"):FireServer(unpack(args))



end)



Tab:CreateButton("FruitSlap", function()



local args = {

	"FruitSlap"

}

game:GetService("ReplicatedStorage"):WaitForChild("EquipSlapEvent"):FireServer(unpack(args))



end)



Tab:CreateButton("SwapperSlap", function()



local args = {

	"SwapperSlap"

}

game:GetService("ReplicatedStorage"):WaitForChild("EquipSlapEvent"):FireServer(unpack(args))



end)



local Tab = Window:NewSection("All Slaps4")



Tab:CreateButton("StunSlap", function()



local args = {

	"StunSlap"

}

game:GetService("ReplicatedStorage"):WaitForChild("EquipSlapEvent"):FireServer(unpack(args))



end)



Tab:CreateButton("PoisonSlap", function()



local args = {

	"PoisonSlap"

}

game:GetService("ReplicatedStorage"):WaitForChild("EquipSlapEvent"):FireServer(unpack(args))



end)



Tab:CreateButton("RainbowLuckySlap", function()



local args = {

	"RainbowLuckySlap"

}

game:GetService("ReplicatedStorage"):WaitForChild("EquipSlapEvent"):FireServer(unpack(args))



end)



Tab:CreateButton("StreakSlap", function()



local args = {

	"StreakSlap"

}

game:GetService("ReplicatedStorage"):WaitForChild("EquipSlapEvent"):FireServer(unpack(args))



end)



Tab:CreateButton("ErrorSlap", function()



local args = {

	"Error"

}

game:GetService("ReplicatedStorage"):WaitForChild("EquipSlapEvent"):FireServer(unpack(args))



end)



local Tab = Window:NewSection("All Slaps5")



Tab:CreateButton("BloxySlap", function()



local args = {

	"BloxySlap"

}

game:GetService("ReplicatedStorage"):WaitForChild("EquipSlapEvent"):FireServer(unpack(args))



end)



Tab:CreateButton("TixSlap", function()



local args = {

	"TixSlap"

}

game:GetService("ReplicatedStorage"):WaitForChild("EquipSlapEvent"):FireServer(unpack(args))



end)



Tab:CreateButton("BlockSlap", function()



local args = {

	"BlockSlap"

}

game:GetService("ReplicatedStorage"):WaitForChild("EquipSlapEvent"):FireServer(unpack(args))



end)



Tab:CreateButton("SpinSlap", function()



local args = {

	"SpinSlap"

}

game:GetService("ReplicatedStorage"):WaitForChild("EquipSlapEvent"):FireServer(unpack(args))



end)



Tab:CreateButton("DiceSlap", function()



local args = {

	"DiceSlap"

}

game:GetService("ReplicatedStorage"):WaitForChild("EquipSlapEvent"):FireServer(unpack(args))



end)



local Tab = Window:NewSection("Movements")



Tab:CreateButton("Fast", function()



local player = game.Players.LocalPlayer

local character = player.Character or player.CharacterAdded:Wait()

local humanoid = character:WaitForChild("Humanoid")



humanoid.WalkSpeed = 32



end)



Tab:CreateButton("Normal", function()



local player = game.Players.LocalPlayer

local character = player.Character or player.CharacterAdded:Wait()

local humanoid = character:WaitForChild("Humanoid")



humanoid.WalkSpeed = 16



end)



Tab:CreateButton("Fly", function()



loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()



end)

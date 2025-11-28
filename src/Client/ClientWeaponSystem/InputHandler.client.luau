local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SharedWeaponSystem = ReplicatedStorage.SharedWeaponSystem
local Remotes = SharedWeaponSystem.Remotes

local Base = script.Parent
local InputContext = Base.Controls

InputContext.Shoot.Pressed:Connect(function()
	Remotes.Shoot:FireServer(true)
end)

InputContext.Shoot.Released:Connect(function()
	Remotes.Shoot:FireServer(false)
end)

InputContext.Reload.Pressed:Connect(function()
	Remotes.Reload:FireServer()
end)
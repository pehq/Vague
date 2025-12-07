local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui

local function CharAdded(char)
	local ChildAdded = char.ChildAdded:Connect(function(child)
		if child:IsA("Tool") and child:HasTag("PekuGun") and child:HasTag("Configured") then
			print("Equipped!! 🥳🥳") --This won't run if the tool doesn't have the configured tag.
		end
	end)
end

--Apply function if there already is character
if LocalPlayer.Character ~= nil then
	CharAdded(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(CharAdded)
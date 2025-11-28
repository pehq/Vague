--Stores and updates all of the player's aim location from this module.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Utils = ReplicatedStorage.SharedWeaponSystem.Utils

local Vector3Validate = require(Utils.TypeValidation.validateVector3)

local PlayerMouseList = {}

Players.PlayerAdded:Connect(function(plr)
	PlayerMouseList[plr] = Vector3.zero
end)

Players.PlayerRemoving:Connect(function(plr)
	PlayerMouseList[plr] = nil
end)

ReplicatedStorage.SharedWeaponSystem.Remotes.Mouse.OnServerEvent:Connect(function(plr, pos)
	if not Vector3Validate(pos) then
		return
	end
	--print(pos)
	PlayerMouseList[plr] = pos
end)

return PlayerMouseList
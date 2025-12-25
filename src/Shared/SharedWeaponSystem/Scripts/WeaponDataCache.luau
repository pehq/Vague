local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SharedWeaponSystem = ReplicatedStorage.SharedWeaponSystem
local WeaponData = SharedWeaponSystem.WeaponData

--TODO: This could probably be redone with metatables.
local Cache = {}
Cache.WeaponCache = {}

function Cache.Get(weaponDataName:string)
	local data = nil
	
	if Cache.WeaponCache[weaponDataName] == nil then
		local mod = WeaponData:FindFirstChild(weaponDataName)
		if mod then
			Cache.WeaponCache[weaponDataName] = require(mod)
		else
			error("Could not find weapon data for " .. weaponDataName)
		end
	end
	
	data = Cache.WeaponCache[weaponDataName]
	return data
end

return Cache
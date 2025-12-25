local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local ServerGunSys = ServerScriptService.ServerWeaponSystem
local SharedGunSys = ReplicatedStorage.SharedWeaponSystem

local DataCache = require(SharedGunSys.Scripts.WeaponDataCache)
local SpreadDirUtil = require(SharedGunSys.Utils.SpreadDir)
local ProjectilePlus = require(SharedGunSys.LocalDependencies.ProjectilePlus)

local function Process(shots, tool, private, weaponData)
	local Base = DataCache.Get(weaponData)
	
	for i = 1 , shots do
		
		local alpha = i / shots
		local tar = private.LastMousePos:Lerp(private.MousePos, alpha)
		private.RayFilter.FilterDescendantsInstances = {tool.Parent} --filter owner's character
		local start = tool.Handle:FindFirstChildOfClass("Attachment").WorldPosition
		local dir = SpreadDirUtil((tar - start).Unit, Base.SPREAD)
		
		local proj = ProjectilePlus.CreateProjectile(
			tool.Parent, 
			"Laser",
			Base.PROJECTILE_RADIUS,
			dir * Base.PROJECTILE_LAUNCH_POWER,
			start,
			Base.LIFE_TIME,
			Base.PROJECTILE_SPEED,
			private.RayFilter
		)
		proj.GravityEnabled = true
		
		--This module doesn't return a limb hit, do base dmg instead
		proj.HitSomeone:Once(function(hit)
			if not hit:FindFirstChild("Humanoid") then
				return
			end
			
			ServerGunSys.Bindables.Damage:Fire(hit.Humanoid, Base.BODY_DAMAGE[Enum.Limb.Unknown], private.Owner, hit)

		end)
	end
end

return Process
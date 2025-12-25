local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ServerGunSys = ServerScriptService.ServerWeaponSystem
local SharedGunSys = ReplicatedStorage.SharedWeaponSystem

local DataCache = require(SharedGunSys.Scripts.WeaponDataCache)
local SpreadDirUtil = require(SharedGunSys.Utils.SpreadDir)

local RayFunc = require(ServerGunSys.Rays.Ray)
local SphereFunc = require(ServerGunSys.Rays.Sphere)

local function x(shots, tool, private, weaponData)
	local Base = DataCache.Get(weaponData)
	
	for i = 1, shots do
		local alpha = i / shots
		local tar = private.LastMousePos:Lerp(private.MousePos, alpha)
		private.RayFilter.FilterDescendantsInstances = {tool.Parent} --filter owner's character
		local start = tool.Handle:FindFirstChildOfClass("Attachment").WorldPosition

		local rayres, hitpos = {}, {}
		if Base.RAYCAST_TYPE == "Ray" then
			--The primary shot
			rayres[1], hitpos[1] = RayFunc(start, SpreadDirUtil((tar - start).Unit, Base.PRIMARY_RANGE), Base.RANGE, private.RayFilter)
			
			for i = 1, Base.BULLETS_PER_SHOT - 1 do
				local dir = SpreadDirUtil((tar - start).Unit, Base.SHOTGUN_SPREAD)
				local newrayres, newhitpos = RayFunc(start, dir, Base.SECONDARY_RANGE, private.RayFilter)
				table.insert(rayres, newrayres)
				table.insert(hitpos, newhitpos)
			end
		elseif Base.RAYCAST_TYPE == "Sphere" then
			--The primary shot
			rayres[1], hitpos[1] = SphereFunc(start, SpreadDirUtil((tar - start).Unit, Base.PRIMARY_RANGE), Base.RANGE, private.RayFilter)
			
			for i = 1, Base.BULLETS_PER_SHOT - 1 do --Other shots
				local dir = SpreadDirUtil((tar - start).Unit, Base.SHOTGUN_SPREAD)
				local newrayres, newhitpos = SphereFunc(start, dir, Base.SECONDARY_RANGE, private.RayFilter, Base.SPHERE_RAY_RADIUS)
				table.insert(rayres, newrayres)
				table.insert(hitpos, newhitpos)
			end
		end
		
		--print(rayres)
		
		for i, v in ipairs(rayres) do
			if v == nil then
				continue
			end
			
			--Something was shot
			local hit = v.Instance
			local Humanoid = hit.Parent:FindFirstChildOfClass("Humanoid")
			if hit:IsA("BasePart") and Humanoid then
				local bodypart = Humanoid:GetLimb(hit)
				ServerGunSys.Bindables.Damage:Fire(Humanoid, Base.BODY_DAMAGE[bodypart], private.Owner, hit)
			end
		end

		SharedGunSys.Remotes.UnreliableVFX:FireAllClients("ShotgunFire", tool.Handle:FindFirstChildOfClass("Attachment"), hitpos, 1/10)
	end
end

return x
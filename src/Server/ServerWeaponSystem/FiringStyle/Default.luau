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
	
	local places_shot = {}
	for i = 1, shots do
		--	----

		local alpha = i / shots
		local tar = private.LastMousePos:Lerp(private.MousePos, alpha)
		private.RayFilter.FilterDescendantsInstances = {tool.Parent} --filter owner's character
		local start = tool.Handle:FindFirstChildOfClass("Attachment").WorldPosition
		local dir = SpreadDirUtil((tar - start).Unit, Base.SPREAD)

		local rayres, hitpos = nil, nil
		if Base.RAYCAST_TYPE == "Ray" then
			rayres, hitpos = RayFunc(start, dir, Base.RANGE, private.RayFilter)
		elseif Base.RAYCAST_TYPE == "Sphere" then
			rayres, hitpos = SphereFunc(start, dir, Base.RANGE, private.RayFilter)
		end

		if rayres ~= nil then --Something was shot
			local hit = rayres.Instance
			local Humanoid = hit.Parent:FindFirstChildOfClass("Humanoid")
			if hit:IsA("BasePart") and Humanoid then
				local bodypart = Humanoid:GetLimb(hit)
				ServerGunSys.Bindables.Damage:Fire(Humanoid, Base.BODY_DAMAGE[bodypart], private.Owner, hit)
			end
		end
		
		table.insert(places_shot, hitpos)
		--SharedGunSys.Remotes.UnreliableVFX:FireAllClients("Beam", tool.Handle:FindFirstChildOfClass("Attachment"), hitpos, 1/30)
	end
	
	SharedGunSys.Remotes.UnreliableVFX:FireAllClients("Pewpews", tool.Handle:FindFirstChildOfClass("Attachment"), places_shot, 10)
end

return x
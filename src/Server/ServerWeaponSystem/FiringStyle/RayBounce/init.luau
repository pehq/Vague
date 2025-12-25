--Omg this is just like the sharpshooter revolver from ULTRAKILL! 

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ServerGunSys = ServerScriptService.ServerWeaponSystem
local SharedGunSys = ReplicatedStorage.SharedWeaponSystem

local DataCache = require(SharedGunSys.Scripts.WeaponDataCache)
local SpreadDirUtil = require(SharedGunSys.Utils.SpreadDir)

local RayFunc = require(ServerGunSys.Rays.Ray)
local SphereFunc = require(ServerGunSys.Rays.Sphere)

local StyleVFXHandler = require(script.RayBounceVFXHandler) --Shots are timed, requiring its own handler.

return function(shots, tool, private, weaponData)
	local Base = DataCache.Get(weaponData)
	
	local ShotHandler = {}
	
	for i = 1, shots do
		local VFXHandlerObj = StyleVFXHandler.new()
		table.insert(ShotHandler,VFXHandlerObj)
		
		local nextStart = nil
		local nextDir = nil
		for j = 1, Base.MAX_BOUNCES do
			
			local curstart = nil
			local curdir = nil
			if j == 1 then --From the start
				curstart = tool.Handle:FindFirstChildOfClass("Attachment").WorldPosition
				VFXHandlerObj:AppendShot(curstart)
				
				local alpha = i / shots
				curdir = private.LastMousePos:Lerp(private.MousePos, alpha) - curstart
			else 
				--Bounced
				curstart = nextStart
				curdir = nextDir
			end
			
			local spreadDir = SpreadDirUtil(curdir.Unit, Base.SPREAD)
			
			private.RayFilter.FilterDescendantsInstances = {tool.Parent} --filter owner's character

			local rayres, hitpos = nil, nil
			if Base.RAYCAST_TYPE == "Ray" then
				rayres, hitpos = RayFunc(curstart, spreadDir, Base.RANGE, private.RayFilter)
			elseif Base.RAYCAST_TYPE == "Sphere" then
				rayres, hitpos = SphereFunc(curstart, spreadDir, Base.RANGE, private.RayFilter, Base.SPHERE_RAY_RADIUS)
			end
			
			VFXHandlerObj:AppendShot(hitpos)
			
			if rayres ~= nil then --Something was shot
				local hit = rayres.Instance
				
				local Humanoid = hit.Parent:FindFirstChildOfClass("Humanoid")
				if hit:IsA("BasePart") and Humanoid then
					local bodypart = Humanoid:GetLimb(hit)
					ServerGunSys.Bindables.Damage:Fire(Humanoid, Base.BODY_DAMAGE[bodypart], private.Owner, hit)
				end
				
				--BOUNCE!!
				--v = incoming vector
				--n = normals
				--r=v−2(v⋅n)n
				
				--If you forgot about Dot, then uhmm https://www.mathsisfun.com/algebra/vectors-dot-product.html
				
				local bouncedDir = spreadDir - 2 * (spreadDir:Dot(rayres.Normal) * rayres.Normal)
				nextStart = rayres.Position
				nextDir = bouncedDir
			else
				break --Hit nothing, don't bounce.
			end
		end
	end
	
	for i, v in ipairs(ShotHandler) do
		v:Play()
	end
	
	
	
end
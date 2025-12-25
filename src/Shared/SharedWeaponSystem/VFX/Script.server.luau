local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

local SharedGunSys = ReplicatedStorage.SharedWeaponSystem

local PPAssets = SharedGunSys.Models.VFX.ProjectilePlus
local ProjectilePlus = require(SharedGunSys.LocalDependencies.ProjectilePlus.Client)

local function ExplosionEffect(Position)
	local ExplosionPart = PPAssets.Explosion:Clone()
	ExplosionPart.Parent = workspace
	for i,v in ExplosionPart.Attachment:GetChildren() do
		if v:IsA("ParticleEmitter") then
			v:Emit(v:GetAttribute("EmitCount"))
		end
	end
	
	ExplosionPart.Position = Position
	Debris:AddItem(ExplosionPart, 1)
end

ProjectilePlus.ProjectileAdded:Connect(function(proj)
	
	local p = PPAssets.Laser:Clone()
	p.Transparency = 0
	p.Position = proj.Position
	p.Parent = workspace
	proj:WeldPart(p, CFrame.Angles(0,math.rad(90),0))
	
	proj.OnHitSomeone:Once(function(hit, pos)
		ExplosionEffect(pos)
	end)
	
	proj.OnHitMap:Once(function(hit, pos)
		ExplosionEffect(pos)
	end)
	
	proj.Destroying:Once(function()
		proj:ClearWelds()
		p.Transparency = 1
		Debris:AddItem(p, 1)
	end)
end)
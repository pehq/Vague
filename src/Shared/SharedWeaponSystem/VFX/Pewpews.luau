local TweenService = game:GetService("TweenService") --too reliable
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

local SharedGunSys = ReplicatedStorage.SharedWeaponSystem
local ModelsVfx = SharedGunSys.Models.VFX



return function(att:Attachment, Tars, lifetime)
	--local instances = {}
	
	for i, v in ipairs(Tars) do
		local Beam = ModelsVfx.PewpewBeam:Clone()
		Beam.CFrame = CFrame.lookAt(att.WorldPosition, v)
		
		Beam.Parent = workspace.Terrain
		--table.insert(instances, Beam)
		
		local tt = (v - att.WorldPosition).Magnitude / 500 --total time, t = d / s
		local info = TweenInfo.new(tt,Enum.EasingStyle.Sine,Enum.EasingDirection.Out) 
		
		local t:Tween = TweenService:Create(Beam, info, {Position = v}) --tween
		t:Play()
		t.Completed:Once(function()
			if Beam ~= nil then
				Beam:Destroy()
			end
		end)
		
		Debris:AddItem(Beam, lifetime)
	end
end
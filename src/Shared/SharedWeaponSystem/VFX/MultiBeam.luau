local TweenService = game:GetService("TweenService") --too reliable
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

local SharedGunSys = ReplicatedStorage.SharedWeaponSystem
local ModelsVfx = SharedGunSys.Models.VFX

--This VFX visualized:
-- *: attachment
-- =: beam
-- start -->  *========*====*======*=========*=*======* <-- end
-- Hence "Multi"-Beam

return function(positions:Vector3, lifetime)
	local atts = {}
	local beams = {}
	for i, v:Vector3 in ipairs(positions) do
		local att = Instance.new("Attachment")
		att.Name = "MultiBeam_Attachment#"..i
		att.Position = v
		att.Parent = workspace.Terrain
		table.insert(atts, att)
	end
	
	
	for i = 1, #atts - 1 do
		local beam = Instance.new("Beam")
		beam.Attachment0 = atts[i]
		beam.Attachment1 = atts[i + 1]
		beam.Name = "MultiBeam_Beam#"..i
		beam.Parent = workspace.Terrain
		table.insert(beams, beam)
	end
	
	task.wait(lifetime)
	
	for i, v in ipairs(atts) do
		v:Destroy()
	end
	for i, v in ipairs(beams) do
		v:Destroy()
	end
end
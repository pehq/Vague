--local Debris = game:GetService("Debris")

return function(att:Attachment, tars:{Vector3}, dur:number)
	local instances = {}
	
	for i, v in ipairs(tars) do	
		local taratt = Instance.new("Attachment")
		taratt.Parent = workspace.Terrain
		taratt.WorldPosition = v
		table.insert(instances, taratt)
		
		local Beam = Instance.new("Beam")
		Beam.Color = ColorSequence.new(Color3.new(0.9, 0.3, 0.1))
		Beam.Attachment0 = att
		Beam.Attachment1 = taratt
		Beam.Width0 = 0.4
		Beam.Width1 = 0.4
		Beam.LightEmission = 1
		Beam.LightInfluence = 0
		Beam.Transparency = NumberSequence.new(0)
		Beam.FaceCamera = true
		Beam.Parent = att
		
		table.insert(instances, Beam)
	end
	
	task.wait(dur)
	
	for i, v in ipairs(instances) do
		v:Destroy()
	end

	--Debris:AddItem(Beam, dur)
	--Debris:AddItem(taratt, dur)
end
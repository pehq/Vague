local Debris = game:GetService("Debris")

return function(att:Attachment, tar:Vector3, dur:number)
	local taratt = Instance.new("Attachment")
	taratt.Parent = workspace.Terrain
	taratt.WorldPosition = tar
	
	local Beam = Instance.new("Beam")
	Beam.Attachment0 = att
	Beam.Attachment1 = taratt
	Beam.Width0 = 0.1
	Beam.Width1 = 0.1
	Beam.LightEmission = 1
	Beam.LightInfluence = 0
	Beam.Transparency = NumberSequence.new(0)
	Beam.FaceCamera = true
	Beam.Parent = att
	task.wait(dur)
	Beam:Destroy()
	taratt:Destroy()

	--Debris:AddItem(Beam, dur)
	--Debris:AddItem(taratt, dur)
end
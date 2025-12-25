local function SphereCast(start, dir, range, filter, radius)
	if range == nil then range = 1000 end
	if filter == nil then filter = RaycastParams.new() end
	if radius == nil then radius = 1/2 end
	
	local SphereRes = workspace:Spherecast(start, radius, dir * range, filter)
	local HitPos = SphereRes and SphereRes.Position or start + dir * range
	
	return SphereRes, HitPos
end

return SphereCast
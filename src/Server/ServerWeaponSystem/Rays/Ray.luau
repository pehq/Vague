--Pehq
local function RaycastFunc(start, dir, range, filter): (RaycastResult?, Vector3)
	if range == nil then range = 1000 end
	if filter == nil then filter = RaycastParams.new() end
	
	local RayRes = workspace:Raycast(start, dir * range, filter)
	local HitPos = RayRes and RayRes.Position or start + dir * range
	
	return RayRes, HitPos
end

return RaycastFunc
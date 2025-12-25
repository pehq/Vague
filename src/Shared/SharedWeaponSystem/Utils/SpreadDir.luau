local function getSpreadDirection(direction, spreadDegrees)
	direction = direction.Unit
	local spreadRadians = math.rad(spreadDegrees)

	local randomX = (math.random() - 0.5) * 2
	local randomY = (math.random() - 0.5) * 2

	local r = math.sqrt(math.random())
	local theta = math.random() * math.pi * 2

	local spread = Vector3.new(
		math.cos(theta) * r,
		math.sin(theta) * r,
		0
	)

	local cf = CFrame.lookAt(Vector3.zero, direction)
	local newDir = (cf:VectorToWorldSpace(spread + Vector3.new(0, 0, -1))).Unit

	return newDir
end

return getSpreadDirection
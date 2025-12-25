local function getSpreadDirection(direction, spreadDegrees)
	local spreadRadians = math.rad(spreadDegrees)

	local randomX = (math.random() - 0.5) * 2
	local randomY = (math.random() - 0.5) * 2

	local spread = Vector3.new(randomX, randomY, 0) * math.tan(spreadRadians)

	local cf = CFrame.lookAt(Vector3.zero, direction)
	local newDir = (cf:VectorToWorldSpace(spread + Vector3.new(0, 0, -1))).Unit

	return newDir
end

return getSpreadDirection
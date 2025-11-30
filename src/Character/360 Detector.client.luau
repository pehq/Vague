local RunService = game:GetService("RunService")
local Character = script.Parent
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local lastYaw = 0
local accumulatedRotation = 0
local rotationDirection = 0 -- 1 = clockwise, -1 = counterclockwise
local is360 = false

local function getYaw(cf)
	local _, y, _ = cf:ToOrientation()
	return y
end

RunService.Heartbeat:Connect(function()
	if is360 then return end

	local currentYaw = getYaw(HumanoidRootPart.CFrame)
	local deltaYaw = currentYaw - lastYaw

	-- Fix wrap-around between -π and π
	if deltaYaw > math.pi then
		deltaYaw -= math.pi * 2
	elseif deltaYaw < -math.pi then
		deltaYaw += math.pi * 2
	end

	-- Ignore micro jitter
	if math.abs(deltaYaw) < 0.002 then
		return
	end

	-- Determine current direction
	local dir = deltaYaw > 0 and 1 or -1

	-- If direction changes, reset
	if rotationDirection ~= 0 and dir ~= rotationDirection then
		accumulatedRotation = 0
		rotationDirection = dir
	else
		rotationDirection = rotationDirection ~= 0 and rotationDirection or dir
	end

	accumulatedRotation += math.abs(deltaYaw)
	lastYaw = currentYaw

	-- Debug: show progress in degrees
	-- print(math.deg(accumulatedRotation))

	if accumulatedRotation >= math.pi * 2 then
		is360 = true
		print("🎯 360 detected (" .. (rotationDirection == 1 and "Clockwise" or "Counterclockwise") .. ")")

		task.delay(0.2, function()
			is360 = false
			accumulatedRotation = 0
			rotationDirection = 0
		end)
	end
end)

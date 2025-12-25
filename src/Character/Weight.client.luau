--Weight = mass * gravity
--Force = mass * gravity


local RunService = game:GetService("RunService")
local Char = script.Parent
local HumanoidRootPart:BasePart = Char:WaitForChild("HumanoidRootPart", 60)
local Humanoid:Humanoid = Char:WaitForChild("Humanoid")

local BaseWalkSpeed = Humanoid.WalkSpeed

local CharacterMass = HumanoidRootPart.AssemblyMass
local basemass = CharacterMass

local lv = Instance.new("VectorForce")
lv.Attachment0 = HumanoidRootPart:FindFirstChildOfClass("Attachment")
lv.Force = -Vector3.yAxis * basemass * workspace.Gravity
lv.ApplyAtCenterOfMass = true
lv.RelativeTo = Enum.ActuatorRelativeTo.World
lv.Parent = HumanoidRootPart

local function SetSpeedFromMass(currentMass)
	-- ratio relative to original mass
	local ratio = basemass / currentMass

	-- tune these
	local MIN_MULT = 0.35
	local MAX_MULT = 1

	ratio = math.clamp(ratio, MIN_MULT, MAX_MULT)

	return BaseWalkSpeed * ratio
end

local LastMass = math.floor(HumanoidRootPart.AssemblyMass)
RunService:BindToRenderStep(
	"CharacterWeightSpeed",
	Enum.RenderPriority.Character.Value + 1,
	function()
		local currentMass = math.floor(HumanoidRootPart.AssemblyMass)

		if currentMass == LastMass then
			return
		end

		LastMass = currentMass

		Humanoid.WalkSpeed = SetSpeedFromMass(currentMass)
		
		lv.Force = -Vector3.yAxis * currentMass * workspace.Gravity
	end
)
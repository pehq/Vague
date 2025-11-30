local RunService = game:GetService("RunService")

local ShownParts = {
	[Enum.Limb.Head] = false,
	[Enum.Limb.Torso] = false,
	[Enum.Limb.RightArm] = true,
	[Enum.Limb.LeftArm] = true,
	[Enum.Limb.RightLeg] = true,
	[Enum.Limb.LeftLeg] = true,
	[Enum.Limb.Unknown] = false,
}

local Char = script.Parent
local Humanoid = Char:FindFirstChildOfClass("Humanoid")
local CharParts = {}
for i, v in ipairs(Char:GetChildren()) do
	if v:IsA("BasePart") == false then
		continue
	end
	
	if not ShownParts[Humanoid:GetLimb(v)] then
		continue
	end
	
	table.insert(CharParts, v)
end

RunService:BindToRenderStep("ShowBody", Enum.RenderPriority.Character.Value - 1, function()
	for i, v in ipairs(CharParts) do
		v.LocalTransparencyModifier = 0
	end
end)
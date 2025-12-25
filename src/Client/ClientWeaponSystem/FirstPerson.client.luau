--Uses localTransparency Based on the head.

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local ClientGunSys = LocalPlayer.PlayerScripts.ClientWeaponSystem

local BoolVal = ClientGunSys.GuiValues.FirstPerson

local function Update()
	if LocalPlayer.Character == nil then
		BoolVal.Value = false
		return
	end
	
	local Head:BasePart = LocalPlayer.Character:FindFirstChild("Head")
	
	if not Head then
		BoolVal.Value = false
		return
	end
	
	if Head.LocalTransparencyModifier == 1 then
		BoolVal.Value = true
		return
	end
	
	BoolVal.Value = false
	return
end

--Its 298 to account for the LocalTransparency Setter that runs at 299
RunService:BindToRenderStep("CheckFirstPerson", Enum.RenderPriority.Character.Value - 2, Update)
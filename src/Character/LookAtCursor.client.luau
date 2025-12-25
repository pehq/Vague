local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local PlrScripts = LocalPlayer.PlayerScripts
local LocalGunSys= PlrScripts.ClientWeaponSystem

local Character = script.Parent
local HumanoidRootPart:BasePart = Character:WaitForChild("HumanoidRootPart")

local Cam = workspace.CurrentCamera

local Params = RaycastParams.new()
Params.FilterDescendantsInstances = {Character}

local val = LocalGunSys.GuiValues.Equipped
RunService:BindToRenderStep("LookAtMouse", Enum.RenderPriority.Character.Value - 5, function()
	if not val.Value or not UserInputService.MouseEnabled then
		return
	end

	local mousePos = UserInputService:GetMouseLocation()
	local ray = Cam:ViewportPointToRay(mousePos.X, mousePos.Y)

	local result:RaycastResult = workspace:Raycast(ray.Origin, ray.Direction * 1000, Params)
	local hitPos = result ~= nil and result.Position or ray.Origin + ray.Direction * 1000

	local rootPos = HumanoidRootPart.Position

	-- Y-only rotation (prevents tilting)
	local lookAt = Vector3.new(hitPos.X, rootPos.Y, hitPos.Z)
	HumanoidRootPart.CFrame = CFrame.new(rootPos, lookAt)
end)
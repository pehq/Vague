local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")

local Filters = require(ReplicatedStorage.SharedWeaponSystem.RayFilter)
local Camera = workspace.CurrentCamera
local Player = Players.LocalPlayer

local MouseRemote = ReplicatedStorage.SharedWeaponSystem.Remotes:WaitForChild("Mouse")

-- Prebuild RaycastParams
local Params = RaycastParams.new()
Params.FilterType = Enum.RaycastFilterType.Exclude

-- State
local LastSentPos = Vector3.zero
local MoveThreshold = 0.01 -- only update if mouse moves this far in studs

-- Updates the raycast filter whenever the character changes
local function UpdateRaycastFilter()
	local filterList = {}
	for _, v in Filters do
		table.insert(filterList, v)
	end
	if Player.Character then
		table.insert(filterList, Player.Character)
	end
	Params.FilterDescendantsInstances = filterList
end

Player.CharacterAdded:Connect(UpdateRaycastFilter)
UpdateRaycastFilter() -- run once at start

-- Main mouse tracker
RunService.RenderStepped:Connect(function()
	if not Player.Character or not Player.Character.Parent then
		return
	end
	if Player.Character:FindFirstChildOfClass("Tool") == nil then --Player must be holding a tool to send their mouse location.
		return
	end

	-- Convert screen mouse pos to world ray
	-- If there is no mouse then the Mouse Position will be from Vector2.new(.5, .3)
	local mousePos2D, unitRay = nil, nil
	
	if UserInputService.MouseEnabled and not UserInputService.GamepadEnabled then
		mousePos2D = UserInputService:GetMouseLocation()
		unitRay = Camera:ViewportPointToRay(mousePos2D.X, mousePos2D.Y)
	else
		local offset = nil
		--Check if first person. Very messy code here
		--
		if Player.PlayerScripts.ClientWeaponSystem.GuiValues.FirstPerson.Value == true then
			offset = Vector2.new(.5, .5)
		else
			offset = Vector2.new(.5, .3)
		end
		--
		mousePos2D = Camera.ViewportSize * offset
		unitRay = Camera:ViewportPointToRay(mousePos2D.X, mousePos2D.Y)
	end

	-- Raycast into world
	local result = workspace:Raycast(unitRay.Origin, unitRay.Direction * 1000, Params)
	local hitPos = result and result.Position or (unitRay.Origin + unitRay.Direction * 1000)

	-- Send only if changed significantly
	if (hitPos - LastSentPos).Magnitude > MoveThreshold then
		LastSentPos = hitPos
		MouseRemote:FireServer(hitPos)
	end
end)

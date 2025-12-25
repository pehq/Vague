local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui

local SharedWeaponSystem = ReplicatedStorage.SharedWeaponSystem
local ClientWeaponSystem = LocalPlayer.PlayerScripts.ClientWeaponSystem

local GuiVals = ClientWeaponSystem.GuiValues

local currentEquippedGun:Tool = nil

--A gun's attribute may not be loaded on the client yet.
local function SafeSet(inst, attr, valobj)
	
	local v = inst:GetAttribute(attr)
	if v == nil then
		return false
	end
	
	valobj.Value = v
	
	return true
end

local CharConnections = {}
local function CharAdded(char:Model)
	local ChildAdded = char.ChildAdded:Connect(function(child)
		if not child:IsA("Tool") or not child:HasTag("PekuGun") then
			return
		end
		
		if not child:HasTag("Configured") then
			repeat task.wait() until child:HasTag("Configured")
		end
		
		currentEquippedGun = child
		print("Equipped!! 🥳🥳")
	end)
	
	local ChildRemoved = char.ChildRemoved:Connect(function(child)
		if child ~= currentEquippedGun then
			return
		end
		
		currentEquippedGun = nil
		print("Removed...")
	end)
	
	--Memory management
	table.insert(CharConnections, ChildAdded)
	table.insert(CharConnections, ChildRemoved)
end

local function CharRemoved(char)
	for i, v in ipairs(CharConnections) do
		v:Disconnect()
	end
	CharConnections = {}
	currentEquippedGun = nil
end


--Apply function if there already is character
if LocalPlayer.Character ~= nil then
	CharAdded(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(CharAdded)
LocalPlayer.CharacterRemoving:Connect(CharRemoved)

--Foward Values to the Gui
RunService.Heartbeat:Connect(function()
	if not currentEquippedGun then
		GuiVals.Equipped.Value = false
		return
	end
	GuiVals.Equipped.Value = true
	
	SafeSet(currentEquippedGun, "Ammo", GuiVals.Ammo)
	SafeSet(currentEquippedGun, "MaxAmmo", GuiVals.MaxAmmo)
	SafeSet(currentEquippedGun, "WeaponData", GuiVals.WeaponData)
	SafeSet(currentEquippedGun, "Name", GuiVals.WeaponName)
	SafeSet(currentEquippedGun, "Description", GuiVals.Description)
	SafeSet(currentEquippedGun, "Shooting", GuiVals.Activated)
end)

SharedWeaponSystem.Remotes.DamageIndicator.OnClientEvent:Connect(function(...)
	ClientWeaponSystem.GuiValues.Hit:Fire(...)
end)
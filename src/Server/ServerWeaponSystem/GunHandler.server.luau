local ServerScriptService =game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")

local SystemFolder = ServerScriptService.ServerWeaponSystem
local SharedFolder = ReplicatedStorage.SharedWeaponSystem

local Bindables = SystemFolder.Bindables
--local GunConfigs = SystemFolder.WeaponData
local RayConfigs = SystemFolder.Rays
local PlayerMouseTargets = require(SystemFolder.PlayerMouseTargets) --The 3d mouse positions of every player.

local Utils = SharedFolder.Utils
local NewValue = require(Utils.ValueTypeMaker)
local BoolValidation = require(Utils.TypeValidation.validateNumber)
local RayFunc = require(RayConfigs.Ray)
local SphereFunc = require(RayConfigs.Sphere)

local DefaultFiring = require(SystemFolder.FiringStyle.Default)
local ShotgunFiring = require(SystemFolder.FiringStyle.Shotgun)

local WeaponCache = require(SharedFolder.Scripts.WeaponDataCache)

local FiringStyles = {}
for i, v in pairs(SystemFolder.FiringStyle:GetChildren()) do
	FiringStyles[v.Name] = require(v)
end

local function debounce(isreloading)
	if isreloading then
		return false
	end
	
	return true
end

local function LoadAnimation(Humanoid, assetId:string)
	local Animator = Humanoid:FindFirstChildOfClass("Animator")
	if not Animator then
		Animator = Instance.new("Animator")
		Animator.Parent = Humanoid
	end

	local Animation = Instance.new("Animation")
	Animation.AnimationId = assetId
	local Track = Animator:LoadAnimation(Animation)
	return Track
end

--Each Character can only have one gun equipped. Once equipped they can shoot it and reload it.
--The reason its an array of characters and not players is to allow npcs to use guns.
local CharEquippedGun = {}
local ActiveGuns = {}
local PrivateGunsData = {} --Any data here is not shared to clients.

local function SetupTool(tool:Tool)
	if not tool:IsA("Tool") or not tool:HasTag("PekuGun") or tool:HasTag("Configured") then
		return
	end
	
	local DataName = tool:GetAttribute("WeaponData")
	local Data = WeaponCache.Get(DataName)
	
	--Private
	PrivateGunsData[tool] = {}
	local private = PrivateGunsData[tool]
	private.DataName = DataName
	private.Shooting = false
	private.LastFired = tick()
	private.LastTriggered = tick()
	private.MousePos = Vector3.zero
	private.LastMousePos = Vector3.zero
	private.Owner = tool.Parent
	
	private.Reloading = false
	private.Ammo = Data.BULLETS
	private.MaxAmmo = Data.MAX_BULLETS
	private.BurstAmmo = Data.FIRETYPE == "Burst" and Data.BURST_SHOTS or nil
	private.RayFilter = RaycastParams.new()
	private.RayFilter.FilterType = Enum.RaycastFilterType.Exclude
	private.Spread = 0
	
	private.AnimationTracks = {}
	private.AudioTracks = {}
	
	--For now this does nothing.
	private.Keys = {
		["Shoot"] = {
			isPressed = false,
			lastPressed = nil,
		},
		["Reload"] = {
			isPressed = false,
			lastPressed = nil,
		}
	}

	--Public
	local Config = tool:FindFirstChildOfClass("Configuration")
	if not Config then
		Config = Instance.new("Configuration")
		
		NewValue(tool.Parent, "Owner").Parent = Config
		
		Config.Parent = tool
	end
	
	tool:SetAttribute("Name", Data.NAME or "Unnamed Gun")
	tool:SetAttribute("Description", Data.DESCRIPTION or "")
	tool:SetAttribute("Equipped", false)
	tool:SetAttribute("Shooting", false)
	tool:SetAttribute("Reloading", false)
	tool:SetAttribute("sad", "asd")
	tool:SetAttribute("Ammo", Data.BULLETS)
	tool:SetAttribute("MaxAmmo", Data.MAX_BULLETS)
	tool:SetAttribute("Spread" , private.Spread)
	--Events
	local Connections = {}
	Connections[1] = tool.Equipped:Connect(function()
		CharEquippedGun[tool.Parent] = tool
		Config.Owner.Value = tool.Parent
		
		tool:SetAttribute("Equipped", true)
		
		local Humanoid = tool.Parent:FindFirstChildOfClass("Humanoid")
		if not Humanoid then
			return
		end
		
		--Play equip animation
		local Track = LoadAnimation(Humanoid, Data.ANIMATIONS.Idle)
		Track.Looped = true
		private.AnimationTracks["Idle"] = Track
		Track:Play()
		
		local Sound = tool.Handle:FindFirstChildOfClass("Sound")
		if Sound then
			private.AudioTracks.Shoot = Sound
		end
	end)
	Connections[2] = tool.Unequipped:Connect(function()
		CharEquippedGun[Config.Owner.Value] = false
		
		tool:SetAttribute("Equipped", false)
		
		--Stop shooting
		private.Shooting = false
		
		--Stop all anims
		for i,track in pairs(private.AnimationTracks) do
			track:Stop()
			track:Destroy()
		end
	end)
	Connections[3] = tool.AncestryChanged:Connect(function(child, parent)
		local newowner = parent
		if not parent or not parent:FindFirstChildOfClass("Humanoid") then
			return
		end
		
		PrivateGunsData[tool].Owner = newowner
		Config.Owner.Value = newowner
	end)
	--Clean up once the tool gets destroyed.
	tool.Destroying:Once(function()
		PrivateGunsData[tool] = nil
		table.remove(ActiveGuns, table.find(ActiveGuns, tool))
		for i, v in ipairs(Connections) do
			v:Disconnect()
		end
	end)
	
	table.insert(ActiveGuns, tool)
	
	tool:AddTag("Configured")
end

-- Connect guns inside players
local function SetupPlayer(plr)
	local function checkTools(container)
		for _, tool in ipairs(container:GetChildren()) do
			SetupTool(tool)
		end
		container.ChildAdded:Connect(SetupTool)
	end

	checkTools(plr.Backpack)
	checkTools(plr.StarterGear)
end

Players.PlayerAdded:Connect(function(plr)
	local charAdded = nil
	charAdded = plr.CharacterAdded:Connect(function(char)
		CharEquippedGun[char] = false
		
		--If character spawned with a gun equipped.
		--There can only be one tool!
		local SpawnedTool = char:FindFirstChildOfClass("Tool")
		if SpawnedTool and SpawnedTool:HasTag("PekuGun") and not SpawnedTool:HasTag("Configured") then
			SetupTool(SpawnedTool)
			CharEquippedGun[char] = SpawnedTool
		end
		
		--Look for a tool that gets added to the character.
		local ChildAdd = char.ChildAdded:Connect(function(childadded)
			if childadded:IsA("Tool") and childadded:HasTag("PekuGun") and not childadded:HasTag("Configured") then
				SetupTool(childadded)
				CharEquippedGun[char] = childadded
			end
		end)
		
		--Memory management stuff.
		local plrRemove = nil
		local CharRemove = plr.CharacterRemoving:Once(function()
			CharEquippedGun[char] = nil
			ChildAdd:Disconnect()
			plrRemove:Disconnect()
		end)

		--Disconnect when player leaves.
		plrRemove = Players.PlayerRemoving:Connect(function(plrleaving)
			if plrleaving ~= plr then
				return
			end
			CharEquippedGun[char] = nil
			
			charAdded:Disconnect()
			CharRemove:Disconnect()
			ChildAdd:Disconnect()
			plrRemove:Disconnect()
		end)
	end)

	SetupPlayer(plr)
end)

--Input handler
--Mouse Target
RunService.PostSimulation:Connect(function() --The aiming runs before the shooting.
	for plr, pos in pairs(PlayerMouseTargets) do
		if plr.Character == nil or plr.Character.Parent == nil then
			continue
		end
		local char = plr.Character
		local Tool = CharEquippedGun[char]
		
		if not Tool then
			continue
		end
		
		PrivateGunsData[Tool].MousePos = pos
	end
end)

SharedFolder.Remotes.Shoot.OnServerEvent:Connect(function(plr, keydown:boolean)
	local Char = plr.Character
	if not Char or not Char.Parent then
		return
	end
	
	local Tool = CharEquippedGun[Char]
	if not Tool then
		return
	end
	
	local private = PrivateGunsData[Tool]
	local Base = WeaponCache.Get(private.DataName)
	
	if private.Reloading then
		return
	end
	
	if keydown then
		local base = WeaponCache.Get(private.DataName)
		if tick() - private.LastTriggered < base.FIRE_COOLDOWN then
			return
		end
		private.LastTriggered = tick()
		private.LastFired = tick() - 1 / (base.FIRERATE / 60)  
	end
	
	private.Shooting = keydown
	Tool:SetAttribute("Shooting", keydown)
	
	--Load Shoot Animation
	if keydown then
		
		local track = LoadAnimation(Char.Humanoid, Base.ANIMATIONS.Shoot)
		track.Looped = false
		private.AnimationTracks["Shoot"] = track
		
		if private.AudioTracks.Shoot.Looped then
			private.AudioTracks.Shoot:Play()
		end
	elseif private.AnimationTracks["Shoot"] ~= nil then --The shoot track exists.
		
		local track:AnimationTrack = private.AnimationTracks["Shoot"]
		track.Looped = false
		track.Ended:Once(function()
			track:Stop()
		end)
		
		if private.AudioTracks.Shoot.Looped then
			private.AudioTracks.Shoot:Stop()
		end
	end
end)

SharedFolder.Remotes.Reload.OnServerEvent:Connect(function(plr, keydown:boolean)
	local char = plr.Character
	
	if not char or not char.Parent then
		return
	end

	local Tool = CharEquippedGun[char]
	if not Tool then
		return
	end
	
	local private = PrivateGunsData[Tool]
	local Base = WeaponCache.Get(private.DataName)

	if not Base.RELOAD or private.Reloading then
		return
	end
	
	if private.Ammo == Base.MAX_BULLETS then
		return
	end
	
	print("Reload ", keydown)

	--Start reloading.
	private.Reloading = true
	Tool:SetAttribute("Reloading", true)
	
	--Play reload animation
	local track = LoadAnimation(char.Humanoid, Base.ANIMATIONS.Reload)
	track.Looped = false
	private.AnimationTracks["Reload"] = track
	track:Play(0, 1,  track.Length / Base.RELOAD_TIME)
	
	--Stop shooting
	private.Shooting = false
	local ReloadSuccess = true

	local UnequipCheck:RBXScriptConnection = Tool.Unequipped:Once(function()
		ReloadSuccess = false
		private.Reloading = false
	end)

	task.delay(Base.RELOAD_TIME, function()
		private.Reloading = false
		Tool:SetAttribute("Reloading", false)
		if ReloadSuccess then
			private.Ammo = private.MaxAmmo
			Tool:SetAttribute("Ammo", private.Ammo)
		end
		
		if UnequipCheck.Connected then
			UnequipCheck:Disconnect()
		end
	end)
end)

local fpscounter = 0 --Debug variable

--Everything gets handled through a loop.
RunService.Heartbeat:Connect(function(dt)
	for i, tool in ipairs(ActiveGuns) do
		local Humanoid = tool.Parent:FindFirstChildOfClass("Humanoid")
		if not tool:HasTag("PekuGun") or not tool:HasTag("Configured") or not Humanoid
		then
			continue
		end
		
		local private = PrivateGunsData[tool]
		local Base = WeaponCache.Get(private.DataName)

		--Check if the gun is in the state of being reloaded.
		if private.Reloading then
			continue
		end

		--Check if the player is shooting the gun.
		if not private.Shooting then
			continue --Not being shot.
		end
		
		--Check if there are bullets in the gun
		if private.Ammo <= 0 then
			--Reload
			continue
		end	
		
		--Shoot gun!
		local TimeSinceShot = tick() - private.LastFired
		local ShotsToFire = math.floor(TimeSinceShot / (1 / (Base.FIRERATE / 60))) --1
		
		--print(ShotsToFire, private.BurstAmmo)
		
		if Base.FIRETYPE == "Semi" then
			ShotsToFire = 1
		elseif Base.FIRETYPE == "Burst" then --Idk how this works, I asked an ai to help me with this.
			if private.BurstAmmo <= 0 then
				private.BurstAmmo = Base.BURST_SHOTS
				private.Shooting = false
				continue
			end

			-- Clamp shots to available burst ammo
			ShotsToFire = math.min(ShotsToFire, private.BurstAmmo)

			-- Consume burst ammo
			private.BurstAmmo -= ShotsToFire

			-- End burst if depleted
			if private.BurstAmmo <= 0 then
				private.Shooting = false
				continue
			end
		end
		
		if ShotsToFire <= 0 then continue end --No shots, skip frame.
		
		if private.Ammo < ShotsToFire then
			ShotsToFire = private.Ammo
			private.Ammo = 0
			tool:SetAttribute("Ammo", 0)
		else
			--Count ammo
			private.Ammo = private.Ammo - ShotsToFire
			tool:SetAttribute("Ammo", private.Ammo)
		end
		
		--print("Shooting ".. ShotsToFire)
		
		private.AnimationTracks.Shoot:Play()
		
		local s:Sound = private.AudioTracks.Shoot
		if not s.Looped then
			--Sound is already playing but isn't looped.
			local c = s:Clone()
			c.PlayOnRemove = true
			c.Parent = s.Parent
			c:Destroy()
		elseif not (s.Looped and s.Playing) then 
			--play sound if isn't playing, won't play if sound is looped and is playing.
			s:Play()
		end
		
		--print(private, Base)
		
		--In-frame processing
		if not Base.GUNTYPE or FiringStyles[Base.GUNTYPE] == nil then
			FiringStyles["Default"](ShotsToFire, tool, private, private.DataName)
		else
			FiringStyles[Base.GUNTYPE](ShotsToFire, tool, private, private.DataName)
		end
		
		for i = 1, ShotsToFire do
			fpscounter += 1 --Debug variable		
		end
		
		private.LastFired += ShotsToFire / (Base.FIRERATE / 60) 
		private.LastMousePos = private.MousePos
		
		if Base.FIRETYPE == "Semi" then
			private.Shooting = false
		end
		if Base.FIRETYPE == "Burst" and private.BurstAmmo == 0 then
			private.Shooting = false
		end
		
		if private.Ammo <= 0 then
			private.Shooting = false
		end
	end
end)

---- FPS counter (debug only) 

local t = tick()
RunService.Heartbeat:Connect(function()
	if tick() - t < 1 then return end
	warn(fpscounter)
	fpscounter = 0
	t = tick()
end)

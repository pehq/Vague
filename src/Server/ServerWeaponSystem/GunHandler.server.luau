local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")

local SystemFolder = script.Parent
local SharedFolder = ReplicatedStorage.SharedWeaponSystem

local Bindables = SystemFolder.Bindables
local GunConfigs = SystemFolder.WeaponData
local RayConfigs = SystemFolder.Rays
local PlayerMouseTargets = require(SystemFolder.PlayerMouseTargets) --The 3d mouse positions of every player.

local Utils = SharedFolder.Utils
local NewValue = require(Utils.ValueTypeMaker)
local BoolValidation = require(Utils.TypeValidation.validateNumber)
local RayFunc = require(RayConfigs.Ray)
local SphereFunc = require(RayConfigs.Sphere)

-- Cache configs for quick access
local ConfigCache = {}
for _, module in ipairs(GunConfigs:GetChildren()) do
	if module:IsA("ModuleScript") then
		ConfigCache[module.Name] = require(module)
	end
end

local RayCache = {}
for _, module in ipairs(RayConfigs:GetChildren()) do
	if module:IsA("ModuleScript") then
		ConfigCache[module.Name] = require(module)
	end
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
	local Data = ConfigCache[DataName]
	
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
	private.RayFilter = RaycastParams.new()
	private.RayFilter.FilterType = Enum.RaycastFilterType.Exclude
	
	private.AnimationTracks = {}
	
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
	
	tool:SetAttribute("Equipped", false)
	tool:SetAttribute("Shooting", false)
	tool:SetAttribute("Reloading", false)
	tool:SetAttribute("sad", "asd")
	
	--Events
	local Connections = {}
	Connections[1] = tool.Equipped:Connect(function()
		CharEquippedGun[tool.Parent] = tool
		Config.Owner.Value = tool.Parent
		
		tool:SetAttribute("Equipped", true)
		
		--Play equip animation
		local Track = LoadAnimation(tool.Parent:FindFirstChildOfClass("Humanoid"), Data.ANIMATIONS.Idle)
		Track.Looped = true
		table.insert(private.AnimationTracks, Track)
		Track:Play()
	end)
	Connections[2] = tool.Unequipped:Connect(function()
		CharEquippedGun[Config.Owner.Value] = false
		
		tool:SetAttribute("Equipped", false)
		
		--Stop all anims
		for i,track in ipairs(private.AnimationTracks) do
			track:Stop()
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
	local Base = ConfigCache[private.DataName]
	
	if keydown then
		local base = ConfigCache[private.DataName]
		if tick() - private.LastTriggered < base.FIRE_COOLDOWN then
			return
		end
		private.LastTriggered = tick()
		private.LastFired = tick() - (1 / base.FIRERATE)
	end
	
	
	private.Shooting = keydown
	Tool:SetAttribute("Shooting", keydown)
	if keydown then
		local track = LoadAnimation(Char.Humanoid, Base.ANIMATIONS.Shoot)
		track.Looped = false
		private.AnimationTracks["Shoot"] = track
	elseif private.AnimationTracks["Shoot"] ~= nil then
		local track:AnimationTrack = private.AnimationTracks["Shoot"]
		track.Looped = false
		track.Ended:Once(function()
			track:Stop()
		end)
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
	local Base = ConfigCache[private.DataName]

	if not Base.RELOAD or private.Reloading then
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
	track:Play(0, 3,  track.Length / Base.RELOAD_TIME)
	
	--Stop shooting
	private.Shooting= false
	local ReloadSuccess = true

	local UnequipCheck = Tool.Unequipped:Once(function()
		ReloadSuccess = false
	end)

	task.delay(Base.RELOAD_TIME, function()
		private.Reloading = false
		Tool:SetAttribute("Reloading", false)

		if ReloadSuccess then
			private.Ammo = private.MaxAmmo
		end
	end)
end)

local fpscounter = 0
local t = tick()

--Everything gets handled through a loop.
RunService.Heartbeat:Connect(function(dt)
	for i, tool in ipairs(ActiveGuns) do
		if not tool:HasTag("PekuGun") 
			or not tool:HasTag("Configured")
			or not tool.Parent:FindFirstChildOfClass("Humanoid")
		then
			continue
		end
		
		local private = PrivateGunsData[tool]
		local Base = ConfigCache[private.DataName]

		--Check if the gun is in the state of being reloaded.
		if private.Reloading then
			continue
		end

		--Check if the player is shooting the gun.
		if not private.Shooting then
			continue --Not being shot.
		end
		
		--Shoot gun!
		local TimeSinceShot = tick() - private.LastFired
		local ShotsToFire = math.floor(TimeSinceShot / (1 / Base.FIRERATE))
		
		if ShotsToFire <= 0 then continue end --No shots, skip frame.
		--print("Shooting ".. ShotsToFire)
		
		if Base.FIRETYPE == "Semi" then
			ShotsToFire = 1
		end
		
		private.AnimationTracks.Shoot:Play()
		
		local s:Sound = tool.Handle:FindFirstChildOfClass("Sound"):Clone()
		s.Parent = tool.Handle
		s.PlayOnRemove = true
		s:Play()
		
		--In frame processing
		for i = 1, ShotsToFire do
			fpscounter += 1 --Debug variable
			
		--	----
			
			local alpha = i / ShotsToFire
			local tar = private.LastMousePos:Lerp(private.MousePos, alpha)
			private.RayFilter.FilterDescendantsInstances = {tool.Parent} --filter owner's character
			local start = tool.Handle:FindFirstChildOfClass("Attachment").WorldPosition
			
			local rayres, hitpos = nil, nil
			if Base.RAYCAST_TYPE == "Ray" then
				rayres, hitpos = RayFunc(start, tar, Base.RANGE, private.RayFilter)
			elseif Base.RAYCAST_TYPE == "Sphere" then
				rayres, hitpos = SphereFunc(start, tar, Base.RANGE, private.RayFilter)
			end
			
			if rayres ~= nil then --Something was shot
				local hit = rayres.Instance
				local Humanoid = hit.Parent:FindFirstChildOfClass("Humanoid")
				if hit:IsA("BasePart") and Humanoid then
					local bodypart = Humanoid:GetLimb(hit)
					Bindables.Damage:Fire(Humanoid, Base.BODY_DAMAGE[bodypart], private.Owner, hit)
				end
			end
			
			SharedFolder.Remotes.UnreliableVFX:FireAllClients("Beam", tool.Handle:FindFirstChildOfClass("Attachment"), hitpos, 1/30)
			
		--	----

		--	--Debug Part (causes lag if on)
		--	local Part = Instance.new("Part")
		--	Part.Anchored = true
		--	Part.CanCollide = false
		--	Part.CanQuery = false
		--	Part.CanTouch = false
		--	Part.Transparency = (i == ShotsToFire) and 0 or 0.7
		--	Part.Size = (i == ShotsToFire) and Vector3.one *1.1 or Vector3.one
		--	Part.Material = (i == ShotsToFire) and Enum.Material.Neon or Enum.Material.SmoothPlastic
		--	Part.Color = (i == ShotsToFire) and Color3.new(1,0,0) or Color3.new(0,1,0)
		--	Part.Position = HitPos
		--	Part.Parent = workspace
		--	Debris:AddItem(Part, 10)

		--	--Play sound (reuse instead of clone) (TOO LOUD)
		--	local sound = Tool.Handle["Rubber band sling shot.wav"]:Clone()
		--	sound.PlayOnRemove = true
		--	sound.Parent = Tool.Handle
		--	sound:Play()
		end
		
		private.LastFired += ShotsToFire * (1 / Base.FIRERATE)
		private.LastMousePos = private.MousePos
		
		if Base.FIRETYPE == "Semi" then
			private.Shooting = false
		end
	end
end)

---- FPS counter (debug only) 
RunService.Heartbeat:Connect(function()
	if tick() - t < 1 then return end
	warn(fpscounter)
	fpscounter = 0
	t = tick()
end)

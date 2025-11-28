local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local SharedFolder = ReplicatedStorage.SharedWeaponSystem
local SystemFolder = script.Parent
local Bindables = SystemFolder.Bindables
local Remotes = SharedFolder.Remotes
local Utils = SharedFolder.Utils
local TypeMaker = require(Utils.ValueTypeMaker)

local DamageReceived = {}

Bindables.Damage.Event:Connect(function(victim:Humanoid, dmg:number, creator:Model, part:BasePart)
	if victim.Health <= 0 then
		return
	end
	
	local Died = false
	local DiedConnection = victim.Died:Once(function()
		Died = true
	end)
	victim:TakeDamage(dmg)
	DiedConnection:Disconnect()
	
	if Died then
		print(creator, " has killed ", victim.Parent)
	end
	
	--Check if player
	local plr = Players:GetPlayerFromCharacter(creator)
	if plr == nil then
		return
	end
	
	Remotes.DamageIndicator:FireClient(plr, dmg, victim.Health / victim.MaxHealth, part)
end)

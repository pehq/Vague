local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local SharedFolder = ReplicatedStorage.SharedWeaponSystem
local SystemFolder = script.Parent
local Bindables = SystemFolder.Bindables
local Remotes = SharedFolder.Remotes
local Utils = SharedFolder.Utils
local TypeMaker = require(Utils.ValueTypeMaker)

local function CheckTeammates(plr1:Player, plr2:Player)
	if plr1.Neutral == true or plr2.Neutral == true then
		return false
	end
	
	if plr1.Team == plr2.Team then
		return true
	end
	
	return false
end


local DamageReceived = {}

Bindables.Damage.Event:Connect(function(victim:Humanoid, dmg:number, creator:Model, part:BasePart)
	if victim.Health <= 0 then
		return --already dead
	end
	
	local PlrVictim = Players:GetPlayerFromCharacter(victim.Parent)
	local PlrOwner = Players:GetPlayerFromCharacter(creator)
	
	if PlrVictim and PlrOwner then --Both are players
		if CheckTeammates(PlrOwner, PlrVictim) then --they're teammates
			return
		end
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
	if PlrOwner == nil then
		return
	end
	
	Remotes.DamageIndicator:FireClient(PlrOwner, dmg, victim.Health, victim.MaxHealth, part)
end)
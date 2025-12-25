local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shots = {}
Shots.__index = Shots

function Shots.new(amount:number?, speed:number?)
	local self = setmetatable({}, Shots)
	
	self.ShotsRemaining = amount or 1
	self.Speed = speed or 300
	self.ShotsToShoot = {}
	
	return self
end

function Shots:AppendShot(Pos)
	table.insert(self.ShotsToShoot, Pos)
end

function Shots:Play()
	ReplicatedStorage.SharedWeaponSystem.Remotes.UnreliableVFX:FireAllClients("MultiBeam", self.ShotsToShoot, 1)
end

return Shots
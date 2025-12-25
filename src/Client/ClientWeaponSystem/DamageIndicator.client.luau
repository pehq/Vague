local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SharedFolder = ReplicatedStorage.SharedWeaponSystem
local Remotes = SharedFolder.Remotes

Remotes.DamageIndicator.OnClientEvent:Connect(function(dmg:number, hp:number, mhp, hit:BasePart)
	--print(`You have hit {hit.Name} for {dmg} damage!`)
	
	--Play sound at a higher pitch
	SoundService["bass.wav"].PitchShiftSoundEffect.Octave = 1 + ((1 - hp / mhp) / 2)
	SoundService["bass.wav"]:Play()
end)
local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SharedFolder = ReplicatedStorage.SharedWeaponSystem
local Remotes = SharedFolder.Remotes

Remotes.DamageIndicator.OnClientEvent:Connect(function(dmg:number, percent:number, hit:BasePart)
	--print(`You have hit {hit.Name} for {dmg} damage!`)
	
	--Play sound at a higher pitch
	SoundService["bass.wav"].PitchShiftSoundEffect.Octave = 1 + ((1 - percent) / 2)
	SoundService["bass.wav"]:Play()
end)
local SharedFolder = script.Parent
local Remotes = SharedFolder.Remotes
local VFX = SharedFolder.VFX

local VFXUtils = {}
for i, v in pairs(VFX:GetChildren()) do
	VFXUtils[v.Name] = require(v)
end

Remotes.UnreliableVFX.OnClientEvent:Connect(function(vfxname, ...)
	VFXUtils[vfxname](...)
end)
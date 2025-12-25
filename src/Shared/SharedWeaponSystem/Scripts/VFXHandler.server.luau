local SharedFolder = script.Parent.Parent
local Remotes = SharedFolder.Remotes
local VFX = SharedFolder.VFX

local VFXUtils = {}
for i, v in pairs(VFX:GetChildren()) do
	if v:IsA("ModuleScript") == false then
		continue
	end
	VFXUtils[v.Name] = require(v)
end

Remotes.UnreliableVFX.OnClientEvent:Connect(function(vfxname, ...)
	VFXUtils[vfxname](...)
end)
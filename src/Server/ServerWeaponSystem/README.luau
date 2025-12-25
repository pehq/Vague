--[[
MIT License

Copyright (c) 2025 PehqDev

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

--[[
--First time set up
If you wish to set up the source on your own then run the command in the command bar:
Modify then Copy Paste
]]
--[[the command
local x = PATH.TO.MODEL;
for _, v in pairs(x.Services:GetChildren()) do 
	local Service = (v.Name == "StarterPlayerScripts" or v.Name == "StarterCharacterScripts") and game:GetService("StarterPlayer")[v.Name] or game:GetService(v.Name)  
	for _, vi in ipairs(v:GetChildren()) do 
		vi.Parent = Service 
	end
end
for i, v in ipairs(x.Scripts:GetChildren()) do 
	v.Value.Enabled = true 
end
for i, v in ipairs(x.Data.Tools:GetChildren()) do
	v.Parent = game:GetService("ReplicatedStorage").SharedWeaponSystem.ToolStorage
end
for i, v in ipairs(x.Data.WeaponData:GetChildren()) do
	v.Parent = game:GetService("ReplicatedStorage").SharedWeaponSystem.WeaponData
end

x:Destroy()
]]

--[[ Credits:

@Bartokens for "Projectile+"
	https://devforum.roblox.com/t/projectile-an-all-in-one-projectile-system-10/3932599
	https://archive.is/HAN3b

@azavier123 for the "Zone" module
	https://create.roblox.com/store/asset/72172213626884/Zones
	https://devforum.roblox.com/t/reliable-zones-using-pure-math-boolean-logic/3763523

Rubie's Weapon Collection by @xXautoboybruhlolXx
	https://create.roblox.com/store/asset/16856138471/Rubies-Weapon-Collection-Melees
	https://create.roblox.com/store/asset/16855904941/Rubies-Weapon-Collection-Pistols
	https://create.roblox.com/store/asset/13280336214/Rubies-Weapon-Collection-Revolvers
	https://create.roblox.com/store/asset/16856033355/Rubies-Weapon-Collection-Shotguns
	https://create.roblox.com/store/asset/16856009381/Rubies-Weapon-Collection-Assault-Rifles
	https://create.roblox.com/store/asset/18175217249/Rubies-Weapon-Collection-Carbines
	https://create.roblox.com/store/asset/16856056454/Rubies-Weapon-Collection-Light-Machine-Guns
	https://create.roblox.com/store/asset/16856091776/Rubies-Weapon-Collection-Snipers-Rifles
	https://create.roblox.com/store/asset/18175229242/Rubies-Weapon-Collection-Machine-Guns
	https://create.roblox.com/store/asset/16855985616/Rubies-Weapon-Collection-Submachine-Guns
	https://create.roblox.com/store/asset/16856107796/Rubies-Weapon-Collection-Launchers
	https://create.roblox.com/store/asset/18175244182/Rubies-Weapon-Collection-DMRs
	https://create.roblox.com/store/asset/18175221626/Rubies-Weapon-Collection-Battle-Rifles
	https://create.roblox.com/store/asset/18175203047/Rubies-Weapon-Collection-Machine-Pistols
	https://create.roblox.com/store/asset/18175233431/Rubies-Weapon-Collection-Heavy-Machine-Guns
	https://create.roblox.com/store/asset/18175210690/Rubies-Weapon-Collection-PDWs
	https://create.roblox.com/store/asset/18175262567/Rubies-Weapon-Collection-AntiMateriel-Rifles
]]
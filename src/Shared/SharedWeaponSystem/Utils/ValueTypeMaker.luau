--PehqDev
--Simply creates an object value based on the initial value's type
local Switch = {
	["boolean"] = "BoolValue",
	["BrickColor"] = "BrickColorValue",
	["CFrame"] = "CFrameValue",
	["Color3"] = "Color3Value",
	["string"] = "StringValue",
	--["number"] = "NumberValue", --special case
	["Instance"] = "ObjectValue",
	["Vector3"] = "Vector3Value",
	["Ray"] = "RayValue",
}

local function Create(val:any, name:string, isInt:boolean):ValueBase
	if typeof(val) == "table" then
		return warn("This util doesn't accepts tables.")
	end
	
	local ValBase = nil
	if typeof(val) == "number" then
		if isInt == nil then
			--If number is a decimal then it'll be an int
			ValBase = val == math.floor(val) and Instance.new("IntValue") or Instance.new("NumberValue") 
		elseif isInt == true then
			ValBase = Instance.new("IntValue")
		elseif isInt == false then
			ValBase = Instance.new("NumberValue")
		end
	else
		ValBase = Instance.new(Switch[typeof(val)])
	end
	
	if name ~= nil then
		ValBase.Name = name
	end
	
	return ValBase
end

return Create
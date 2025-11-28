--camalCasedMaName
--Instead of creating 1000 instances, already have 1000 instances created and reuse them.
--from this video: https://www.youtube.com/watch?v=QBnUHXwMk50

local ObjectPool = {}
ObjectPool.__index = ObjectPool

type ObjectPoolCallback = (object: Instance) -> ()

local function empty() end

function ObjectPool.new(object: Instance, size: number, onCreate: ObjectPoolCallback, onGet: ObjectPoolCallback, onFree: ObjectPoolCallback)
	local self = setmetatable({}, ObjectPool)
	
	self._objects = {}
	self._object = object
	self._onGet = onGet or empty
	self._onFree = onFree or empty
	onCreate = onCreate or empty
	
	for i = 1, size do
		local o = object:Clone()
		table.insert(self._objects, o)
		onCreate(o)
	end
	
	return self
end

function ObjectPool:get()
	if #self._objects == 0 then
		return self._object:Clone()
	end
	
	local object = table.remove(self._objects, 1)
	self._onGet(object)
	return object
end

function ObjectPool:free(object: Instance)
	self._onFree(object)
	table.insert(self._objects, object)
end

function ObjectPool:clear()
	for _, object in ipairs(self._objects) do
		object:Destroy()
	end
	self._objects = {}
end

return ObjectPool
local BoundedStack = {}
BoundedStack.__index = BoundedStack

function BoundedStack.new(Capacity)
	local self = setmetatable({}, BoundedStack)
	
	self.Stack = {}
	self.Capacity = Capacity >= 0 and Capacity
	
	return self
end

function BoundedStack:Push(Value)
	if self.Capacity then
		if #self.Stack + 1 > self.Capacity then
			table.remove(self.Stack, 1)
		end
	end
	table.insert(self.Stack, Value)
end

function BoundedStack:Pop()
	return table.remove(self.Stack, #self.Stack)
end

function BoundedStack:Get(index)
	return self.Stack[index]
end

function BoundedStack:Size()
	return #self.Stack
end

return BoundedStack
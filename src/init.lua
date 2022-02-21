local Produce = require(script.Parent.Draft).Produce
local Signal = require(script.Parent.GoodSignal)
local BoundedStack = require(script.BoundedStack)

local State = {}
State.__index = State

function State.new(Options)
	local self = setmetatable({}, State)
	
	self.State = Options.State or {}
	self.Changed = Signal.new()
	
	if Options.History then
		self.History = BoundedStack.new(Options.History)
	end
	
	return self
end

function State:Produce(callback)
	local newState = Produce(self.State, callback)
	
	if newState ~= self.State then
		if self.History then
			self.History:Push(self.State)
		end
		
		self.Changed:Fire(newState, self.State)
		self.State = newState
	end
	
	return newState
end

function State:Overwrite(data)
	return self:Produce(function(Draft)
		table.clear(Draft)
		for key, value in pairs(data) do
			Draft[key] = value
		end
	end)
end

function State:Get()
	return self.State
end

function State:Set(key, value)
	return self:Produce(function(Draft)
		Draft[key] = value
	end)
end

function State:Revert(n)
	n = n or 0
	
	local lastPosition = self.History:Size() - n
	if lastPosition <= 0 then
		lastPosition = 1
	end
	
	local lastState = self.History:Get(lastPosition)
	return self:Overwrite(lastState)
end

return State
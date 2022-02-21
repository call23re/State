Very basic immutable state module built on top of [Draft](https://github.com/call23re/Draft). This module assumes that it shares a parent with Draft and GoodSignal.

Example:
```lua
local State = require(...State)

local CurrentState = State.new({
	State = {
		foo = 1,
		bar = {
			baz = {
				a = 2
			},
			b = 3
		}
	},
	History = 10
})

CurrentState.Changed:Connect(function(newState, oldState)
	print("old", oldState)
	print("new", newState)
end)

-- Under normal circumstances your loop should be inside of your producer.
for i = 1, 20 do
	CurrentState:Produce(function(Draft)
		Draft.bar.b = 4
		Draft.foo = i
	end)
end

CurrentState:Revert(10)

CurrentState:Set("foo", 100)

print(CurrentState:Get())
print(CurrentState.History.Stack)
```
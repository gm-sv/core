local select = select
local timer_Simple = timer.Simple
local unpack = unpack

function timer.SimpleWithArguments(Delay, Callback, ...)
	local ArgumentCount = select("#", ...) -- In case of a nil
	local Arguments = { ... } -- Cannot use '...' outside a vararg function

	timer_Simple(Delay, function()
		Callback(unpack(Arguments, 1, ArgumentCount))
	end)
end

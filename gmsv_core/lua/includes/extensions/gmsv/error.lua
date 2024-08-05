local debug_getinfo = debug.getinfo
local error = error
local ErrorNoHaltWithStack = ErrorNoHaltWithStack
local Format = Format

function FormatError(Message, ...)
	error(Format(Message, ...), 2)
end

function FormatErrorNoHalt(Message, ...)
	local CallerInfo = debug_getinfo(2, "S")

	if not CallerInfo then
		ErrorNoHaltWithStack(Format(Message, ...))
		return
	end

	-- Add location information to make it look like a normal error
	-- Who knows why this function doesn't have it automatically :P
	CallerInfo.short_src = CallerInfo.short_src or "[C]"

	CallerInfo.linedefined = CallerInfo.linedefined or -1
	if CallerInfo.linedefined == 0 then CallerInfo.linedefined = 1 end -- Fix lua_cmd

	local Leader = Format("%s:%s: ", CallerInfo.short_src, CallerInfo.linedefined)

	if ... then
		ErrorNoHaltWithStack(Format("%s%s", Leader, Format(Message, ...)))
	else
		ErrorNoHaltWithStack(Format("%s%s", Leader, "FormatErrorNoHalt was passed a nil as the error message!"))
	end
end

function FormatAssert(Condition, Message, ...)
	if not Condition then
		error(Format(Message, ...), 2)
	end
end

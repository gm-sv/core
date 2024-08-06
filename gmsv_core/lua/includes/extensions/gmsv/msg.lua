local MsgN = MsgN

local gmsv_debug = CreateConVar("gmsv_debug", 0, FCVAR_ARCHIVE, "Shows debug messages", 0, 1)

function MsgDev(...)
	if gmsv_debug:GetBool() then
		MsgN(...)
	end
end

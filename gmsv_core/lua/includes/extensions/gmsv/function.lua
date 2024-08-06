local debug_getinfo = debug.getinfo
local debug_getlocal = debug.getlocal
local Format = Format
local table_concat = table.concat

local FUNCTION = debug.getmetatable(print) or {}
FUNCTION.__index = FUNCTION.__index or FUNCTION

function FUNCTION:__tostring()
	local Info = debug_getinfo(self, "lSu")
	if not Info then return Format("function: %p", self) end

	local Params = {}

	if Info.what ~= "C" then
		if Info.nparams > 0 then
			for Param = 1, Info.nparams do
				local ParamInfo = debug_getlocal(self, Param)
				if not ParamInfo then break end

				Params[#Params + 1] = ParamInfo
			end
		end

		if Info.isvararg then
			Params[#Params + 1] = "..."
		end
	else
		Params[#Params + 1] = "???"
	end

	return Format("function: %p\n{\n\targs:\t%s\n\tsource:\t%s\n\tline:\t%s\n\tnups:\t%i\n}", self, table_concat(Params, ", "), Info.source, Info.linedefined, Info.nups)
end

debug.setmetatable(print, FUNCTION)

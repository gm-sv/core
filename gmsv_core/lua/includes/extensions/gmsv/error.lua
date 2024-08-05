local Format = Format
local error = error

function FormatError(Message, ...)
	error(Format(Message, ...), 2)
end

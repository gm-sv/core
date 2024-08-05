local include = include
local AddCSLuaFile = AddCSLuaFile

function IncludeShared(Path)
	AddCSLuaFile(Path)

	include(Path)
end

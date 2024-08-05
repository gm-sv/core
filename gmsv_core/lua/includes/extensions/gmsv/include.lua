-- Don't localize because of loadtrack, not that it would help much anyways

function IncludeShared(Path)
	AddCSLuaFile(Path)

	include(Path)
end

-- Don't localize because of loadtrack, not that it would help much anyways

function IncludeShared(Path)
	AddCSLuaFile(Path)

	include(Path)
end

function IncludeClient(Path)
	if SERVER then
		AddCSLuaFile(Path)
	elseif CLIENT then
		include(Path)
	end
end

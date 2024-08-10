-- Don't localize because of loadtrack, not that it would help much anyways

function IncludeClient(Path)
	if SERVER then
		AddCSLuaFile(Path)
	elseif CLIENT then
		include(Path)
	end
end

function IncludeServer(Path)
	if SERVER then
		include(Path)
	end
end

function IncludeShared(Path)
	AddCSLuaFile(Path)

	include(Path)
end

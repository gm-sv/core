local string_find = string.find

-- Where's that detour module when you need it
-- A little overboard just for a message almost nobody will see, eh?
TheRealAddCSLuaFile = TheRealAddCSLuaFile or AddCSLuaFile

function AddCSLuaFile(Path)
	if string_find(Path, "includes/extensions") then
		gm_sv_ExtensionCount = gm_sv_ExtensionCount + 1
	elseif string_find(Path, "includes/modules") then
		gm_sv_ModuleCount = gm_sv_ModuleCount + 1
	end

	TheRealAddCSLuaFile(Path) -- Fuck your relative paths
end

IncludeShared("includes/extensions/gmsv/error.lua")
IncludeShared("includes/extensions/gmsv/function.lua")
IncludeShared("includes/extensions/gmsv/math.lua")
IncludeShared("includes/extensions/gmsv/msg.lua")
IncludeShared("includes/extensions/gmsv/net.lua")
IncludeShared("includes/extensions/gmsv/package.lua")
IncludeShared("includes/extensions/gmsv/player.lua")
IncludeShared("includes/extensions/gmsv/sql.lua")
IncludeShared("includes/extensions/gmsv/string.lua")
IncludeShared("includes/extensions/gmsv/timer.lua")
IncludeShared("includes/extensions/gmsv/util.lua")

if SERVER then
	AddCSLuaFile("gmsv_core/sync/cl_module.lua")

	include("gmsv_core/sync/sv_module.lua")
elseif CLIENT then
	include("gmsv_core/sync/cl_module.lua")
end

IncludeShared("gmsv_core/metatables/config.lua")
IncludeShared("gmsv_core/metatables/module.lua")

AddCSLuaFile("includes/modules/gmsv.lua")

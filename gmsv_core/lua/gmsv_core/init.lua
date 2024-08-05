gm_sv_ModuleCount = 0
gm_sv_ExtensionCount = 0

-- Keep my sanity
AddCSLuaFile("includes/extensions/gmsv/include.lua")
include("includes/extensions/gmsv/include.lua")
gm_sv_ExtensionCount = 1 -- Shh

IncludeShared("loadtrack.lua")

-- Need this first
AddCSLuaFile("includes/modules/boxdraw.lua")
require("boxdraw")

local BoxName = "gm_sv Core Initialization"

boxdraw.Create(BoxName)
boxdraw.AddRow(BoxName, BoxName)
boxdraw.AddRow(BoxName)

-- The rest
IncludeShared("gmsv_core/load.lua")

boxdraw.AddRow(BoxName, "%u %s", gm_sv_ModuleCount, string.Plural("Module", gm_sv_ModuleCount))
boxdraw.AddRow(BoxName, "%u %s", gm_sv_ExtensionCount, string.Plural("Extension", gm_sv_ExtensionCount))
boxdraw.Draw("gm_sv Core Initialization")

-- Get rid of the fancy stuff
gm_sv_ModuleCount = nil
gm_sv_ExtensionCount = nil

AddCSLuaFile = TheRealAddCSLuaFile

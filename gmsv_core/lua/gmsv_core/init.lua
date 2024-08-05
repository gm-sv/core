MsgN("gm_sv Core Initialization")

-- Keep my sanity
AddCSLuaFile("includes/extensions/gmsv/include.lua")

include("includes/extensions/gmsv/include.lua")

-- Normal stuff
AddCSLuaFile("includes/modules/boxdraw.lua")

IncludeShared("includes/extensions/gmsv/error.lua")

require("boxdraw")

boxdraw.Create("test")
	boxdraw.AddRow("test", "hello world")
	boxdraw.AddRow("test", "i am a very cool box drawing thing")
	boxdraw.AddRow("test")
	boxdraw.AddRow("test", "woah! that was a section break!")
boxdraw.Draw("test")

MsgN("gm_sv Core Initialization")

AddCSLuaFile("includes/modules/boxdraw.lua")

include("includes/modules/boxdraw.lua")

boxdraw.Create("test")
	boxdraw.AddRow("test", "hello world")
	boxdraw.AddRow("test", "i am a very cool box drawing thing")
	boxdraw.AddRow("test")
	boxdraw.AddRow("test", "woah! that was a section break!")
boxdraw.Draw("test")

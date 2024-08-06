local error = error
local FindMetaTable = FindMetaTable
local getfenv = getfenv
local istable = istable
local IsValid = IsValid
local setfenv = setfenv
local setmetatable = setmetatable

module("gmsv", package.seeall)

ModuleList = {}

function CreateConfigObject()
	local CONFIG = FindMetaTable("gm_sv_Config")

	local NewConfig = setmetatable({}, CONFIG)
	NewConfig:Initialize()

	return NewConfig
end

function StartModule(Name)
	local MODULE = FindMetaTable("gm_sv_Module")

	local NewModule = setmetatable({}, MODULE)
	NewModule:SetName(string.ToPascalCase(Name))
	NewModule:Initialize()

	ModuleList[Module:GetName()] = NewModule

	local Fenv = package.gmsv({ _M = NewModule })
	setfenv(2, Fenv)

	return NewModule
end

function EndModule()
	local Fenv = getfenv(2)
	local Module = Fenv._M

	if not istable(Module) or not IsValid(Module) then
		return error("Tried to call EndModule outside of module context!")
	end

	Module:Ready()

	setfenv(2, _G)
end

function FindModule(Name)
	return ModuleList[string.ToPascalCase(Name)]
end

if not g_bGMSVLoaded then
	-- Make sure to load it if we are required early (in autorun)
	AddCSLuaFile("gmsv_core/init.lua")
	include("gmsv_core/init.lua")
end

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
	Name = string.ToPascalCase(Name)

	local MODULE = FindMetaTable("gm_sv_Module")

	local NewModule = setmetatable({}, MODULE)
	NewModule:SetName(Name)
	NewModule:Initialize()

	ModuleList[Name] = NewModule

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

-- Config sync stuff
if SERVER then
	local function EnsureSQL()
		if not sql.TableExists("gmsv_module_configs") then
			sql.Query("CREATE TABLE `gmsv_module_configs` ( `ModuleName` TEXT NOT NULL, `Key` TEXT NOT NULL, `Value` BLOB NOT NULL, `Type` TEXT NOT NULL );")
		end
	end

	function BroadcastModuleConfig(Module)
		local Config = Module:GetConfig()
		local ConfigData = Config:GetData()

		local JSON = util.TableToJSON(ConfigData)

		net.Start("gmsv_module_config_sync")
			net.WriteString(Module:GetName())
			net.WriteBlob(JSON)
		net.Broadcast()
	end

	function FetchModuleConfig(Module)
		EnsureSQL()

		local Entries = sql.FormatQuery("SELECT * FROM `gmsv_module_configs` WHERE `ModuleName` = %s;", SQLStr(Module:GetName()))

		if not Entries or #Entries < 1 then
			return MsgDev("No config data to fetch for '", Module:GetName(), "'")
		end

		MsgDev("Applying database config on '", Module:GetName(), "'")

		local Config = Module:GetConfig()

		for i = 1, #Entries do
			local Data = Entries[i]
			local Value = util.StringToType(Data.Value, Data.Type) or tostring(Data.Value)

			Config:SetValue(Data.Key, Value)
		end
	end

	function SaveModuleConfigValue(Module, Key, Value)
		EnsureSQL()

		local SafeName = SQLStr(Module:GetName())
		local SafeKey = SQLStr(Key)
		local SafeValue = SQLStr(Value)
		local SafeType = SQLStr(type(Value))

		local Existing = sql.FormatQuery("SELECT `Value` FROM `gmsv_module_configs` WHERE `ModuleName` = %s AND `Key` = %s;", SafeName, SafeKey)

		if Existing and #Existing > 0 then
			sql.FormatQuery("UPDATE `gmsv_module_configs` SET `Value` = %s, `Type` = %s WHERE `ModuleName` = %s AND `Key` = %s;", SafeValue, SafeType, SafeName, SafeKey)
		else
			sql.FormatQuery("INSERT INTO `gmsv_module_configs` VALUES ( %s, %s, %s, %s );", SafeName, SafeKey, SafeValue, SafeType)
		end

		Existing = sql.FormatQuery("SELECT `Value` FROM `gmsv_module_configs` WHERE `ModuleName` = %s AND `Key` = %s;", SafeName, SafeKey)

		if not Existing or #Existing < 1 then
			MsgDev("Failed to write config value '", Key, "' = '", tostring(Value), "' on '", Module:Getname(), "'")
		end

		BroadcastModuleConfig(Module)
	end
elseif CLIENT then
	local function RequestModuleConfig(Module)
		net.Start("gmsv_module_config_sync")
			net.WriteBool(false)
			net.WriteString(Module:GetName())
		net.SendToServer()
	end

	function FetchModuleConfig(Module)
		if IsValid(LocalPlayer()) and LocalPlayer():CanReliablyNetwork() then -- IsValid because InitPostEntity sucks
			RequestModuleConfig(Module)
		else
			hook.Add("OnPlayerReliableStream", Module:GetName() .. "_ConfigDownload", function()
				RequestModuleConfig(Module)
			end)
		end
	end
end

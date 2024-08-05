local MODULE = {}
MODULE.__index = MODULE

AccessorFunc(MODULE, "m_strName", "Name", FORCE_STRING)

function MODULE:IsValid()
	return istable(self.m_Config)
end

function MODULE:Initialize()
	self.m_Config = gmsv.CreateConfigObject()
	self:HookConfig()
end

function MODULE:AddConfigHook(Key, Callback)
	local Module = self

	hook.Add("gmsv_ModuleConfigUpdate", Module:GetName() .. "_" .. Key, function(self, ChangedKey, OldValue, NewValue)
		if self ~= Module then return end
		if ChangedKey ~= Key then return end

		Callback(self, ChangedKey, OldValue, NewValue)
	end)
end

function MODULE:HookConfig()
	-- Global config hooking system
	local Module = self
	local Config = self:GetConfig()

	function Config:OnValueChanged(Key, OldValue, NewValue)
		hook.Run("gmsv_ModuleConfigUpdate", Module, Key, OldValue, NewValue)
	end

	-- Default hooks
	self:AddConfigHook("Enabled", self.Hook_Enabled)
end

function MODULE:Ready()
	if SERVER then
		self:OnReady()
	else
		MsgN("Waiting for config")
	end
end

-- Getters
function MODULE:GetConfig()
	return self.m_Config
end

function MODULE:GetEnabled()
	return self:GetConfig():GetValue("Enabled")
end

-- Setters
function MODULE:SetEnabled(Status)
	Status = tobool(Status)
	if self:GetEnabled() == Status then return end

	self:GetConfig():SetValue("Enabled", Status)
end

-- Hooks
function MODULE:Hook_Enabled(Key, OldValue, NewValue)
	if NewValue then
		self:OnEnabled()
	else
		self:OnDisabled()
	end
end

function MODULE:OnEnabled()
	-- For override
end

function MODULE:OnDisabled()
	-- For override
end

function MODULE:OnReady()
	-- For override
end

RegisterMetaTable("gm_sv_Module", MODULE)

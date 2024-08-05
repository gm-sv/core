local CONFIG = {}
CONFIG.__index = CONFIG

function CONFIG:IsValid()
	return istable(self.m_Data)
end

function CONFIG:Initialize()
	self.m_Data = {}
end

function CONFIG:GetData()
	return self.m_Data
end

function CONFIG:GetValue(Key)
	return self:GetData()[Key]
end

function CONFIG:SetValue(Key, Value)
	local CurrentValue = self:GetValue(Key)
	if CurrentValue == Value then return end

	self:GetData()[Key] = Value

	self:OnValueChanged(Key, CurrentValue, Value)
end

function CONFIG:OnValueChanged(Key, OldValue, NewValue)
	-- For override
end

RegisterMetaTable("gm_sv_Config", CONFIG)

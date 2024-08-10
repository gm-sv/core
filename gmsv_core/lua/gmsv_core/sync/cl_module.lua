net.Receive("gmsv_module_config_sync", function()
	local ModuleName = net.ReadString()

	if string.len(ModuleName) < 1 then
		return MsgDev("Received config with no module name")
	end

	local Module = gmsv.FindModule(ModuleName)

	if not IsValid(Module) then
		return MsgDev("Received config for unknown module '", ModuleName, "'")
	end

	MsgDev("Received config update for '", Module:GetName(), "'")

	-- Assume it wasn't hooked already
	if not Module:GetReady() then
		Module:HookConfig()
	end

	local Config = Module:GetConfig()

	local NewConfigData = net.ReadBlob()
	NewConfigData = util.JSONToTable(NewConfigData, false, true)

	if not NewConfigData then
		return MsgDev("Failed to parse received config!")
	end

	-- Out with the ugly
	table.Empty(Config:GetData())

	for Key, Value in next, NewConfigData do
		Config:SetValue(Key, Value)
	end

	-- Make sure it's ready
	if not Module:GetReady() then
		Module:Ready()
	end
end)

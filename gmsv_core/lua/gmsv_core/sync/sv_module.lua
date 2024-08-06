util.AddNetworkString("gmsv_module_config_sync")

local function HandleRead(Requester)
	local ModuleName = net.ReadString()
	if string.len(ModuleName) < 1 then return end

	local Module = gmsv.FindModule(ModuleName)
	if not IsValid(Module) then return end

	MsgDev("Replicating config of '", Module:GetName(), "' to '", Requester:GetName(), "'")

	local Config = Module:GetConfig()
	local ConfigData = Config:GetData()

	local JSON = util.TableToJSON(ConfigData)

	net.Start("gmsv_module_config_sync")
		net.WriteString(ModuleName)
		net.WriteBlob(JSON)
	net.Send(Requester)
end

local function HandleWrite(Requester)
	if not Requester:IsSuperAdmin() then return end

	MsgDev("Updating config of '", Module:GetName(), "' received from '", Requester:GetName(), "'")

	print(Requester:GetName(), "wrote something")
end

net.Receive("gmsv_module_config_sync", function(_, Requester)
	local IsWrite = net.ReadBool()

	if IsWrite then
		HandleWrite(Requester)
	else
		HandleRead(Requester)
	end
end)

local CurTime = CurTime
local SysTime = SysTime

local PLAYER = FindMetaTable("Player")

function PLAYER:CanReliablyNetwork()
	if SERVER and self:IsTimingOut() then return false end

	return self.m_bHasReliableConnection
end

if SERVER then
	local ReliableUIDs = {}

	gameevent.Listen("player_activate")
	hook.Add("player_activate", "PlayerRNQ", function(Data)
		if ReliableUIDs[Data.userid] then return end

		local NewPlayer = Player(Data.userid)

		if not IsValid(NewPlayer) then
			FormatError("Invalid Player %u in PlayerRNQ", Data.userid)
			return
		end

		ReliableUIDs[Data.userid] = true

		NewPlayer:SetConnectionTime(SysTime())
		NewPlayer:SetSessionTime(0)
		NewPlayer.m_bHasReliableConnection = true

		hook.Run("OnPlayerReliableStream", Player, CurTime())
	end)

	hook.Add("EntityRemoved", "PlayerRNQ", function(Entity)
		if Entity:IsPlayer() then
			ReliableUIDs[Entity:UserID()] = nil
		end
	end)
elseif CLIENT then
	-- LocalPlayer isn't valid in player_activate, sadly
	hook.Add("InitPostEntity", "PlayerRNQ", function()
		LocalPlayer().m_bHasReliableConnection = true
		hook.Run("OnPlayerReliableStream", LocalPlayer(), CurTime())
	end)
end

-- Connection and Session times
if SERVER then
	AccessorFunc(PLAYER, "m_flConnectionTime", "ConnectionTime", FORCE_NUMBER)
	AccessorFunc(PLAYER, "m_flSessionTime", "SessionTime", FORCE_NUMBER)

	local function UpdatePlayerSessionTime(Player)
		-- CurTime and UnPredictedCurTime are inaccurate in this hook until InitPostEntity is called on client
		Player:SetSessionTime(SysTime() - (Player:GetConnectionTime() or 0))
	end

	hook.Add("PlayerTick", "Player_SessionTime", UpdatePlayerSessionTime)
	hook.Add("VehicleMove", "Player_SessionTime", UpdatePlayerSessionTime)
end

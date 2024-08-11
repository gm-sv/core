local CurTime = CurTime
local SysTime = SysTime

local PLAYER = FindMetaTable("Player")

-- Connection and Session times
if SERVER then
	AccessorFunc(PLAYER, "m_flConnectionTime", "ConnectionTime", FORCE_NUMBER)

	function PLAYER:GetSessionTime()
		return SysTime() - (self:GetConnectionTime() or 0)
	end
end

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

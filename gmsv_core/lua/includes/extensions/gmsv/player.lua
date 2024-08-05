local PLAYER = FindMetaTable("Player")

function PLAYER:CanReliablyNetwork()
	if not self:IsValid() then return false end
	if self:IsTimingOut() then return false end

	return self.m_bEstablishedReliable
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
		NewPlayer.m_bEstablishedReliable = true

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
		g_bLocalPlayerReliableStream = true

		LocalPlayer().m_bEstablishedReliable = true
		hook.Run("OnPlayerReliableStream", LocalPlayer(), CurTime())
	end)
end

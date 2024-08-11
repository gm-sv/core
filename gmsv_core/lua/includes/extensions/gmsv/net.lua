function net.WriteBlob(Blob)
	local Compressed = util.Compress(Blob)
	local Length = string.len(Compressed)

	local BitCount = math.GetBitCount(Length)

	net.WriteUInt(BitCount - 1, 5) -- Make it 0-32 instead of 1-31
	net.WriteUInt(Length, BitCount)
	net.WriteData(Compressed, Length)
end

function net.ReadBlob()
	local LengthBitCount = net.ReadUInt(5) + 1 -- Make it 1-31 instead of 0-32
	local Length = net.ReadUInt(LengthBitCount)
	local Compressed = net.ReadData(Length)

	return util.Decompress(Compressed) or ""
end

if SERVER then
	local RateLimits = {}

	function net.TestRateLimit(Player, Message, Tolerance)
		if not RateLimits[Message] then
			RateLimits[Message] = {}
		end

		local CurrentTime = CurTime()
		local LastCalledTime = RateLimits[Message][Player] or 0

		RateLimits[Message][Player] = CurrentTime

		if CurrentTime - LastCalledTime < Tolerance then
			MsgDev("Rate limiting '", Player:GetName(), "' on '", Message, "'")

			return false
		else
			return true
		end
	end

	function net.RemoveRateLimit(Player, Message)
		if not RateLimits[Message] then return end

		RateLimits[Message][Player] = nil
	end
end

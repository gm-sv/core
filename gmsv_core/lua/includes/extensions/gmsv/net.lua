function net.WriteBlob(Blob)
	local Compressed = util.Compress(Blob)
	local Length = string.len(Compressed)

	local BitCount = math.GetBitCount(Length)

	net.WriteUInt(BitCount - 1, 5) -- Make it 0-32 instead of 1-31
	net.WriteUInt(Length, BitCount)
	net.WriteData(Compressed, Length)
end

function net.ReadBlob()
	local LengthBitCount = net.ReadUInt(5) + 1
	local Length = net.ReadUInt(LengthBitCount)
	local Compressed = net.ReadData(Length)

	return util.Decompress(Compressed) or ""
end

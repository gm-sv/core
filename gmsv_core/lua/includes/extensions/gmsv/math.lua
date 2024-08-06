local math_floor = math.floor

function math.GetBitCount(Number)
	if Number == 0 then return 1 end

	local Bits = 0

	while Number > 0 do
		Number = math_floor(Number / 2)
		Bits = Bits + 1
	end

	return Bits
end

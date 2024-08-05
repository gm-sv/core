local MsgN = MsgN
local Msg = Msg
local string_len = string.len
local string_Trim = string.Trim
local isstring = isstring
local table_insert = table.insert
local math_max = math.max
local Format = Format
local string_rep = string.rep

module("boxdraw")

local BoxList = {}

function Create(Identifier)
	BoxList[Identifier] = {}
end

function AddRow(Identifier, Text, ...)
	local Data = Text

	if isstring(Text) then
		Data = string_Trim(Format(Text, ...))
	else
		Data = false
	end

	table_insert(BoxList[Identifier], Data)
end

function Draw(Identifier, Keep)
	local BoxData = BoxList[Identifier]

	local BoxWidth = 8

	for i = 1, #BoxData do
		local Block = BoxData[i]
		if not Block then continue end

		local BlockLength = string_len(BoxData[i])

		BoxWidth = math_max(BoxWidth, BlockLength + 2)
	end

	local Line = string_rep("-", BoxWidth)

	MsgN("X", Line, "X")

	for i = 1, #BoxData do
		local Block = BoxData[i]

		if not Block then
			MsgN("X", Line, "X")
		else
			local BlockLength = string_len(BoxData[i])
			local Remaining = (BoxWidth - 1) - BlockLength

			MsgN("| ", Block, string_rep(" ", Remaining), "|")
		end
	end

	MsgN("X", Line, "X")

	if not Keep then
		BoxList[Identifier] = nil
	end
end

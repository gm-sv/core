local debug_getinfo = debug.getinfo
local getfenv = getfenv
local rawget = rawget
local setfenv = setfenv
local string_gmatch = string.gmatch
local string_gsub = string.gsub
local string_len = string.len
local string_match = string.match
local string_StartsWith = string.StartsWith
local string_sub = string.sub
local string_Trim = string.Trim
local string_upper = string.upper
local tobool = tobool
local tonumber = tonumber

local function DoTitleCase(FirstCharacter, TheRest)
	return string_upper(FirstCharacter) .. TheRest
end

function string.ToTitleCase(self)
	self = string_Trim(self)
	self = string_gsub(self, "(%a)([%w_']*)", DoTitleCase)

	-- Done like this to ignore gsub's 2nd return
	return self
end

function string.ToPascalCase(self)
	self = string.ToTitleCase(self)
	self = string_gsub(self, "[^%a]", "")

	return self
end

local function TryConvert(Table, Key, Converter, UseRawGet)
	Key = Converter(Key)
	return Key ~= nil and (UseRawGet and rawget(Table, Key) or Table[Key]) or nil
end

function string.ToIndex(self, UseRawGet)
	setfenv(1, getfenv(2))

	local Source = string_sub(string_match(self, "^.-%[") or "", 1, -2)
	if string_len(Source) < 1 then return nil, nil, nil end

	local Index
	local Previous, Key

	if Source ~= "_G" then
		local IndexName, IndexValue = util.FindLocalByName(4, Source)
		if not IndexValue then return nil, nil, nil end

		Index = IndexValue
	else
		Index = _G
	end

	for Match in string_gmatch(self, "%b[]") do
		Match = string_sub(Match, 2, -2) -- Remove leading [ and trailing ]

		if string_match(Match, "%b\"\"") or string_match(Match, "%b''") then -- Remove leading "/' and trailing "/'
			Match = string_sub(Match, 2, -2)
		end

		Key = Match
		Previous = Index
		Index = (UseRawGet and rawget(Previous, Key) or Previous[Key]) or TryConvert(Previous, Key, tonumber, UseRawGet) or TryConvert(Previous, Key, tobool, UseRawGet)

		if Index == nil then break end
	end

	if Index == nil or Previous == nil then
		return nil, nil, nil
	else
		return Index, Previous, Key
	end
end

function string.Plural(self, Amount, Suffix)
	if Amount == 1 then
		return self
	else
		return self .. (Suffix or "s")
	end
end

local debug_getinfo = debug.getinfo
local debug_getlocal = debug.getlocal
local debug_getupvalue = debug.getupvalue

function util.FindDebugLocalByName(Level, Name)
	local Index = 1
	local LocalName, LocalValue = true

	repeat
		LocalName, LocalValue = debug_getlocal(Level, Index)

		Index = Index + 1
	until not LocalName or LocalName == Name

	return LocalName, LocalValue
end

function util.FindDebugUpValueByName(Func, Name)
	local FuncInfo = debug_getinfo(Func, "u")
	local UpValueCount = FuncInfo.nups
	if not UpValueCount or UpValueCount < 1 then return nil, nil end

	local UpValueName, UpValueValue

	for UpValue = 1, UpValueCount do
		UpValueName, UpValueValue = debug_getupvalue(Func, UpValue)

		if UpValueName == Name then
			break
		end
	end

	return UpValueName, UpValueValue
end

function util.FindLocalByName(Level, Name)
	local Name, Value = util.FindDebugLocalByName(Level, Name)
	if Name then return Name, Value end

	local Info = debug_getinfo(Level, "f")
	if not Info or not Info.func then return nil, nil end

	return util.FindDebugUpValueByName(Info.func, Name)
end

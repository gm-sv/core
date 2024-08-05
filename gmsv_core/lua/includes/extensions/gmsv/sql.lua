local Format = Format
local print = print
local sql_Query = sql.Query

function sql.FormatQuery(Query, ...)
	return sql_Query(Format(Query, ...))
end

-- Error printing
do
	local sql_showerrors = CreateConVar("sql_showerrors", 0, FCVAR_ARCHIVE, "Whether or not to dump SQL errors to console", 0, 1)

	local SQL = {}

	function SQL:__newindex(Key, Value)
		if sql_showerrors:GetBool() then
			if Key == "m_strError" and Value ~= nil then
				MsgN(Format("[SQL ERROR]: %s", Value))
			end
		else
			rawset(self, Key, Value)
		end
	end

	setmetatable(sql, SQL)
end

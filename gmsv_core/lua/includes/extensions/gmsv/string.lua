function string.Plural(Text, Amount, Suffix)
	if Amount == 1 then
		return Text
	else
		return Text .. (Suffix or "s")
	end
end

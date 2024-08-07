local getmetatable = getmetatable

function package.gmsv(Fenv)
	package.seeall(Fenv)

	getmetatable(Fenv).__newindex = Fenv.self

	return Fenv
end

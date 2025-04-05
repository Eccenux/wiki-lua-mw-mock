--[[
	This impl doesn't really support unicode.
]]

local p = setmetatable({}, {
	__index = function(_, key)
		return string[key]
	end
})

return p
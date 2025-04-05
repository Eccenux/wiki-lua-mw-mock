--[[
	This impl doesn't really support unicode.
]]

local p = setmetatable({}, {
	__index = function(_, key)
		return string[key]
	end
})

-- Very minimal Unicode Normalization
local decompositionMap = {
	[0x00C1] = {0x0041, 0x0301}, -- Á => A + ◌́
	[0x00E9] = {0x0065, 0x0301}, -- é => e + ◌́
}
local function unicodeDecompose(cp)
	return decompositionMap[cp]
end
function p.toNFD(s)
	if type(s) ~= "string" then return nil end

	local ok, u = pcall(utf8.codes, s)
	if not ok then return nil end

	local nfd = {}

	for codepoint in utf8.codes(s) do
		local decomposed = unicodeDecompose(codepoint)
		if decomposed then
			for _, cp in ipairs(decomposed) do
				table.insert(nfd, utf8.char(cp))
			end
		else
			table.insert(nfd, utf8.char(codepoint))
		end
	end

	return table.concat(nfd)
end

return p
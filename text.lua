local JSON = require("mw/external/JSON")

local p = {}
local priv = {}

function p.jsonDecode(raw_json_text)
	local lua_value = JSON:decode(raw_json_text)
	return lua_value
end
function p.jsonEncode(lua_value)
	local raw_json_text = JSON:encode(lua_value)
	return raw_json_text
end
function p.jsonPrettyEncode(lua_value)
	local raw_json_text = JSON:encode_pretty(lua_value)
	return raw_json_text
end

-- Note! This is not aware of unicode
-- https://www.mediawiki.org/wiki/Extension:Scribunto/Lua_reference_manual#mw.text.split
function p.split(text, pattern, plain)
    local ret = {}
    local s, l = 1, string.len( text )
    while s do
    	local e, n = string.find( text, pattern, s, plain )
    	if not e then
    		ret[#ret+1] = string.sub ( text, s )
    		s = nil
    	elseif n < e then
    		-- Empty separator!
    		ret[#ret+1] = string.sub ( text, s, e )
    		if e < l then
    			s = e + 1
    		else
    			s = nil
    		end
    	else
    		ret[#ret+1] = e > s and string.sub( text, s, e - 1 ) or ''
    		s = n + 1
    	end
    end
    return ret
end

--
-- .nowiki
-- https://www.mediawiki.org/wiki/Extension:Scribunto/Lua_reference_manual#mw.text.nowiki
--
-- Wiki characters to escape
priv.entities = {
	['"'] = "&quot;",
	["&"] = "&amp;",
	["'"] = "&#39;",
	["<"] = "&lt;",
	["="] = "&#61;",
	[">"] = "&gt;",
	["["] = "&#91;",
	["]"] = "&#93;",
	["{"] = "&#123;",
	["|"] = "&#124;",
	["}"] = "&#125;",
}
local function escapeChar(c)
	return priv.entities[c] or c
end

function p.nowiki(str)
	if type(str) ~= "string" then return "" end

	-- Main wiki characters
	str = str:gsub('[\"&\'<=>%[%]{|}]', escapeChar)

	-- `://` will have the colon escaped
	str = str:gsub(":(//)", "&#58;%1")

	-- `__` will have one underscore escaped
	str = str:gsub("(__)", "_&#95;")

	-- Escape first ---- at start of string or after newline
	str = str:gsub("(^%-%-%-%-)", "&#45;%-%-%-")
	str = str:gsub("(\n)(%-%-%-%-)", function(nl, dashes)
		return nl .. "&#45;" .. dashes:sub(2)
	end)

	-- Blank lines will have one of the associated newline or carriage return characters escaped
	str = str:gsub("(\r?\n)(\r?\n)", function(a, b)
		return a .. (b == "\r\n" and "&#13;&#10;" or (b == "\n" and "&#10;" or "&#13;"))
	end)

	-- Lists: The following characters at the start of the string or immediately after a newline: `#`, `*`, `:`, `;`, space, tab (`\t`)
	str = ("\n"..str):gsub("(\n)([ \t#%*;:])", function(nl, c)
		return nl .. "&#" .. string.byte(c) .. ";"
	end)
	str = str:gsub("^\n", "") -- remove extra \n added above

	return str
end


return p
local JSON = require("mw/external/JSON")

local p = {}

function p.jsonDecode(raw_json_text)
	local lua_value = JSON:decode(raw_json_text)
	return lua_value
end
function p.jsonEncode(lua_value)
	local raw_json_text = JSON:encode(lua_value)
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

return p
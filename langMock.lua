-- Usage:
--[[
local langMock = require("mw.langMock")
function mw.getContentLanguage()
	return langMock.createLanguageMock("pl")
end
]]

--[[
	Creates a simplified version of the language object/class.

	Not feasible and probably not needed to have a full impl as specified on Mediawiki:
	https://www.mediawiki.org/wiki/Extension:Scribunto/Lua_reference_manual#Language_library
	AFAIK MW can share impl with PHP functions that already exists. 
]]
local function createLanguageMock(langCode)
	local lang = {}

	lang.code = langCode or "en"

	function lang:getCode()
		return self.code
	end

	function lang:lc(str)
		return mw.ustring.lower(str)
	end

	function lang:lcfirst(str)
		str = tostring(str or "")
		return str:sub(1, 1):lower() .. str:sub(2)
	end

	function lang:uc(str)
		return mw.ustring.upper(str)
	end

	function lang:ucfirst(str)
		str = tostring(str or "")
		return str:sub(1, 1):upper() .. str:sub(2)
	end

	-- Formats number using only English-style grouping and decimal
	function lang:formatNum(n, options)
		local str = tostring(n)
		local noCommafy = options and options.noCommafy
		if noCommafy then
			return str
		end

		local fracPos = string.find(str, ".", 1, true)
		local intPart = str
		local fracPart = ""
		if fracPos then
			intPart = string.sub(str, 1, fracPos - 1)
			fracPart = string.sub(str, fracPos + 1)
		end
		
		local formatted = intPart
		local numReplacements = 1
		while numReplacements > 0 do	
			formatted, numReplacements = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		end
		if fracPos then
			formatted = formatted .. '.' .. fracPart
		end
		return formatted
	end

	-- Formats date using os.date. Supports basic format string
	function lang:formatDate(formatStr, timestamp, localTime)
		local time = timestamp and tonumber(timestamp) or os.time()
		local useUTC = not localTime

		if useUTC then
			return os.date("!" .. formatStr, time)
		else
			return os.date(formatStr, time)
		end
	end

	-- Formats duration into human-readable string (English only)
	function lang:formatDuration(seconds, chosenIntervals)
		local intervals = {
			millennia = 60 * 60 * 24 * 365.25 * 1000,
			centuries = 60 * 60 * 24 * 365.25 * 100,
			decades = 60 * 60 * 24 * 365.25 * 10,
			years = 60 * 60 * 24 * 365.25,
			weeks = 60 * 60 * 24 * 7,
			days = 60 * 60 * 24,
			hours = 60 * 60,
			minutes = 60,
			seconds = 1
		}

		local units = chosenIntervals or { "hours", "minutes", "seconds" }
		local result = {}

		for _, unit in ipairs(units) do
			local value = math.floor(seconds / intervals[unit])
			if value > 0 then
				table.insert(result, value .. " " .. unit)
				seconds = seconds - value * intervals[unit]
			end
		end

		if #result == 0 then
			return "0 seconds"
		elseif #result == 1 then
			return result[1]
		else
			local last = table.remove(result)
			return table.concat(result, ", ") .. " and " .. last
		end
	end

	-- ["caseFold"] = function#1,
	-- ["convertGrammar"] = function#2,
	-- ["convertPlural"] = function#3,
	-- ["gender"] = function#7,
	-- ["getArrow"] = function#8,
	-- ["getCode"] = function#9,
	-- ["getDir"] = function#10,
	-- ["getDirMark"] = function#11,
	-- ["getDirMarkEntity"] = function#12,
	-- ["getDurationIntervals"] = function#13,
	-- ["getFallbackLanguages"] = function#14,
	-- ["grammar"] = function#15,
	-- ["isRTL"] = function#16,
	-- ["parseFormattedNumber"] = function#19,
	-- ["plural"] = function#3,
	-- ["toBcp47Code"] = function#20,


	lang._mock_ = true
	return lang
end

return {
	createLanguageMock = createLanguageMock
}

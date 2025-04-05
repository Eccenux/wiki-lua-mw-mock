-- Usage:
--[[
local langMock = require("mw.langMock")
function mw.getContentLanguage()
	return langMock.createLanguageMock("pl")
end
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

	-- ["caseFold"] = function#1,
	-- ["convertGrammar"] = function#2,
	-- ["convertPlural"] = function#3,
	-- ["formatDate"] = function#4,
	-- ["formatDuration"] = function#5,
	-- ["formatNum"] = function#6,
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

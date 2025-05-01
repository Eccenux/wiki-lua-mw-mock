local originalRequire = require
function require(moduleName)
	moduleName = moduleName:gsub("Modu[^:]+:", "")
	moduleName = moduleName:gsub("mw/", "")
	return originalRequire(moduleName)
end

local mw = require("mw/mw")
local expected = ''

--
-- mw.logObject
local titleObject = nil
titleObject = mw.title.new("Some title", "Template")
mw.logObject(titleObject)
mw.logObject(titleObject:fullUrl("action=edit"))

titleObject = mw.title.new("Some title", "Template talk")
mw.logObject(titleObject)
mw.logObject(titleObject:fullUrl("action=edit"))

titleObject = mw.title.new("Zażółć/gęślą/jaźń", "Module")
mw.logObject(titleObject)

--
-- mw.html
local builder = mw.html.create()
builder
	:wikitext("[[", 'Special:test/', '1234', "|", 'Test: ')
	:tag("span")
		:addClass('abc')
		:addClass(nil)
		:addClass('def')
		:addClass(nil)
		:addClass(nil)
		:addClass('uvw-xyz')
		:attr("title", 'tip')
		:attr("data-null", nil)
		:attr("data-val", 'value')
		:wikitext('Content')
		:done()
	:wikitext("]]")

local result = tostring(builder)
expected = '[[Special:test/1234|Test: <span class="abc def uvw-xyz" title="tip" data-val="value">Content</span>]]'
mw.log(expected)
mw.log(result)
assert(result == expected, "Must render HTML properly.")

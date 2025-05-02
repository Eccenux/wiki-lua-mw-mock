local originalRequire = require
function require(moduleName)
	moduleName = moduleName:gsub("Modu[^:]+:", "")
	moduleName = moduleName:gsub("mw/", "")
	return originalRequire(moduleName)
end

local mw = require("mw/mw")
local expected
local result

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

print ('mw.logObject:END\n')

--
-- mw.html
local builder = mw.html.create()
builder
	:wikitext("[[", 'Special:test/', '1234', "|", 'Test: ')
	:tag("span")
		:addClass('abc')
		:addClass(nil)
		:addClass('uvw-xyz')
		:addClass(nil)
		:addClass(nil)
		:addClass('def')
		:attr("title", 'tip')
		:attr("data-null", nil)
		:attr("data-str", 'not used')
		:attr("data-int", 42)
		:attr("data-str", 'value')
		:wikitext('Content')
		:done()
	:wikitext("]]")

result = tostring(builder)
expected = '[[Special:test/1234|Test: <span class="abc uvw-xyz def" title="tip" data-str="value" data-int="42">Content</span>]]'
mw.log(expected)
mw.log(result)
assert(result == expected, "Must render HTML properly.")

builder = mw.html.create()
builder
	:tag("span")
		:addClass('css-props')
		:css("width", 123)
		:css("display", 'none')
		:css("opacity", 0.5)
		:css("display", 'block')
		:wikitext('Content')

result = tostring(builder)
expected = '<span class="css-props" style="width:123;display:block;opacity:0.5">Content</span>'
mw.log(expected)
mw.log(result)
assert(result == expected, "Must render style props correctly.")

print ('mw.html:END\n')

--
-- mw.text.nowiki
expected = "&#91;&#91;123&#93;&#93;"
result = mw.text.nowiki('[[123]]')
mw.log(expected)
mw.log(result)
assert(result == expected, "Must escape links.")

expected = "&#42; 123\n&#35; abc"
result = mw.text.nowiki('* 123\n# abc')
mw.log(expected)
mw.log(result)
assert(result == expected, "Must escape lists.")

print ('mw.text.nowiki:END\n')

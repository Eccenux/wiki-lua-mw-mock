local originalRequire = require
function require(moduleName)
	moduleName = moduleName:gsub("Modu[^:]+:", "")
	moduleName = moduleName:gsub("mw/", "")
	return originalRequire(moduleName)
end

local mw = require("mw/mw")

local titleObject = nil
titleObject = mw.title.new("Some title", "Template")
mw.logObject(titleObject)

titleObject = mw.title.new("Some title", "Template talk")
mw.logObject(titleObject)

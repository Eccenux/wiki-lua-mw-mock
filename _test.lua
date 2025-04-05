local originalRequire = require
function require(moduleName)
	moduleName = moduleName:gsub("Modu[^:]+:", "")
	moduleName = moduleName:gsub("mw/", "")
	return originalRequire(moduleName)
end

local mw = require("mw/mw")

local fullTemplateTitle = mw.title.new("Some title", "Template")
mw.logObject(fullTemplateTitle)

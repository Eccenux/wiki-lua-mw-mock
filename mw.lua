-- Minimal impl of 'mw' object
mw = {}

mw.site = require('mw/site') 
mw.title = require('mw/title')
mw.text = require('mw/text')
mw.ustring = require('mw/ustring')
mw.html = require('mw/html')

local langMock = require("mw.langMock")
function mw.getContentLanguage()
	return langMock.createLanguageMock("en")
end

--
-- Logging
--
function mw.log(value)
	if type(value) == "table" then
		print(mw.text.jsonPrettyEncode(value))
	else
		print(tostring(value))
	end
end
function mw.logObject(value)
	print(mw.text.jsonPrettyEncode(value))
end

--
-- Load data
--
local loadedDataModules = {}

function mw.loadData(moduleName)
	if loadedDataModules[moduleName] then
		return loadedDataModules[moduleName]
	end

	local path = moduleName:gsub("Modu[^:]+:", "") .. ".lua"
	local chunk, err = loadfile(path)
	if not chunk then
		error("mw.loadData: cannot load module '" .. moduleName .. "': " .. err)
	end

	local ok, result = pcall(chunk)
	if not ok then
		error("mw.loadData: error running module '" .. moduleName .. "': " .. result)
	end

	-- Validate: must return table only
	if type(result) ~= "table" then
		error("mw.loadData: module must return a table")
	end

	-- Cache result
	loadedDataModules[moduleName] = result
	return result
end

--
--
return mw

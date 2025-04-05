-- === mw.title ===
local p = {}

local currentTitle = {
	text = "Test",
	namespace = "Template"
}
function p.setCurrentTitleMock(text, namespace)
	currentTitle.text = text
	currentTitle.namespace = namespace
end
-- mock
function p.getCurrentTitle()
	return p.new(currentTitle.text, currentTitle.namespace)
end

-- partially based on:
-- https://github.com/wikimedia/mediawiki-extensions-Scribunto/blob/246dc44a26eaf6ce30a1219b690611a70969f35d/includes/Engines/LuaCommon/TitleLibrary.php#L83
function p.new(text, namespace)
	if type(text) ~= "string" or text == "" then
		return nil
	end

	local nsId = nil
	local titleText = nil

	local prefix, rest = text:match("^([^:]+):(.+)$")
	if rest then
		-- z prefiksem, sprawdzamy czy to namespace
		for id, ns in pairs(mw.site.namespaces) do
			if ns.name:lower() == prefix:lower() then
				nsId = id
				titleText = rest
				break
			end
		end
		if not nsId then
			-- nieznany namespace
			return nil
		end
	else
		-- brak prefiksu: użyj namespace z argumentu lub domyślnie 0
		nsId = (type(namespace) == "number") and namespace or 0
		titleText = text
	end

	if not titleText:match("[%w%d]") then
		return nil
	end

	local title = {
		namespace = nsId,
		nsText = mw.site.namespaces[nsId].name,
		text = titleText,
		isTalkPage = false,
	}

	return title
end

return p
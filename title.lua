local mw_text = require("mw/text")

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

--- Compares two title objects for equality.
function p.equals(a, b)
	if type(a) ~= "table" or type(b) ~= "table" then
		return false
	end
	if a.namespace ~= b.namespace then
		return false
	end
	if a.text ~= b.text then
		return false
	end

	return true
end

local function findNamespaceByName(nsText)
	if nsText == nil then
		return nil
	end

	local nsId = nil
	local nsToFind = nsText:lower()
	for id, ns in pairs(mw.site.namespaces) do
		if ns.name:lower() == nsToFind or ns.canonicalName:lower() == nsToFind then
			nsId = id
			break
		end
	end
	return nsId
end

-- partially based on:
-- https://github.com/wikimedia/mediawiki-extensions-Scribunto/blob/246dc44a26eaf6ce30a1219b690611a70969f35d/includes/Engines/LuaCommon/TitleLibrary.php#L83
function p.new(text, nsUser)
	if type(text) ~= "string" or text == "" then
		return nil
	end

	local nsId = nil
	local wgTitle = nil -- name without ns prefix

	local prefix, rest = text:match("^([^:]+):(.+)$")
	-- find namespace id by prefix
	if rest then
		nsId = findNamespaceByName(prefix)
		if nsId then
			wgTitle = rest
		end
	end
	-- no namespace in prefix so check parameter
	if not nsId then
		wgTitle = text
		if type(nsUser) == "number" then
			nsId = nsUser
		else
			if nsUser then
				nsId = findNamespaceByName(nsUser)
			end
		end
	end

	if not mw.site.namespaces[nsId] then
		print(string.format("[WARNING][mw.title] Unknown namespace! id:%s, t:%s, ns:%s", nsid, text, nsUser))
		nsId = 0
	end
	local ns = mw.site.namespaces[nsId]

	-- full and parts of title
	local fullText = wgTitle
	if ns.id ~= 0 then
		fullText = ns.name .. ":" .. wgTitle
	end
	local isSubpage = string.find(wgTitle, '/') ~= nil
	local subpageText = nil
	local baseText = wgTitle
	local rootText = wgTitle
	if isSubpage then
		local parts = mw_text.split(wgTitle, '/')
		rootText = parts[1]
		subpageText = parts[#parts]
		-- cut out subpageText (last part)
		baseText = wgTitle:match('^(.-)/[^/]*$')
	end

	local isTalkPage = ns.id % 2 == 1
	local talkNsId = isTalkPage and ns.id or (ns.id + 1)
	local talkNs = nil
	if ns.id < 0 then
		talkNsId = -1
		talkNs = mw.site.namespaces[talkNsId]
	end
	local talkPageTitle = nil
	if not isTalkPage and talkNsId > 0 then
		talkPageTitle = p.new(wgTitle, talkNsId)
	end
	-- title object
	local title = {
		namespace = ns.id,
		nsText = ns.name,
		text = wgTitle,

		fullText = fullText,
		isSubpage = isSubpage,
		subpageText = subpageText,
		baseText = baseText,
		rootText = rootText,
	
		isTalkPage = isTalkPage,
		talkPageTitle = talkPageTitle,
		getContent = function(self)
			return ""
		end
	}
	function title:fullUrl(query)
		local base = "https://example.org/wiki/"
		local encodedTitle = self.fullText
		encodedTitle = encodedTitle:gsub(" ", "_")
		url = base .. encodedTitle
		if not query or query == "" then
			return url
		end
		return url .. "?" .. query
	end		

	return title
end

return p
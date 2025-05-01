local p = {}

--- Escapes a string for use in HTML attributes/text.
local function escapeHtml(str)
	str = tostring(str or "")
	return str
		:gsub("&", "&amp;")
		:gsub("<", "&lt;")
		:gsub(">", "&gt;")
		:gsub('"', "&quot;")
end

--- Converts a style table to a CSS string.
local function cssToString(css)
	local parts = {}
	for k, v in pairs(css) do
		table.insert(parts, k .. ":" .. v .. ";")
	end
	return table.concat(parts)
end

--- For .attrs etc
local function orderedTableInit(t)
	t._keys = {}
	return t
end
local function orderedTableAdd(t, key, value)
	assert(type(key) == "string" and key ~= "", "Key must be a non-empty string.")
	assert(key ~= "_keys", "Key must not be named: _keys.")
	if t[key] == nil then
		table.insert(t._keys, key)
	end
	t[key] = value
end

--- HTML element builder object.
local HtmlElement = {}
HtmlElement.__index = HtmlElement

--- Adds an attribute to the element.
function HtmlElement:attr(name, value)
	-- nil = NOP
	if value == nil then
		return self
	end
	-- self.attrs[name] = tostring(value)
	orderedTableAdd(self.attrs, name, tostring(value))
	return self
end

--- Adds a CSS property.
function HtmlElement:css(name, value)
	-- nil = NOP
	if value == nil then
		return self
	end
	self.styles[name] = tostring(value)
	return self
end

--- Appends raw wikitext content (i.e., innerHTML).
function HtmlElement:wikitext(...)
	for i = 1, select("#", ...) do
		local content = select(i, ...)
		if content ~= nil then
			table.insert(self.children, { type = "wikitext", value = tostring(content) })
		end
	end
	return self
end

--- Appends a new HTML tag as a child.
function HtmlElement:tag(name)
	local child = p.create(name)
	child._parent = self
	table.insert(self.children, child)
	return child
end

--- Adds a CSS class (appends to the "class" attribute).
function HtmlElement:addClass(className)
	-- nil etc = NOP
	if type(className) ~= "string" then
		return self
	end

	local existing = self.attrs["class"] or ""
	local value
	if existing ~= "" then
		value = existing .. " " .. className
	else
		value = className
	end
	orderedTableAdd(self.attrs, "class", value)
	return self
end

--- Appends a newline (for better readability in output).
function HtmlElement:newline()
	table.insert(self.children, { type = "wikitext", value = "\n" })
	return self
end

--- Returns the parent element (useful for chaining after :tag()).
function HtmlElement:done()
	local res = self._parent or self
	return res
end


--- Converts the element and its children to HTML.
function HtmlElement:__tostring()
	local buf = {}

	if self.nodeName ~= "-" then
		table.insert(buf, "<" .. self.nodeName)

		for _, k in ipairs(self.attrs._keys) do
			local v = self.attrs[k]
			table.insert(buf, " " .. k .. '="' .. escapeHtml(v) .. '"')
		end

		if next(self.styles) then
			table.insert(buf, ' style="' .. escapeHtml(cssToString(self.styles)) .. '"')
		end
	end

	if #self.children == 0 then
		if self.nodeName ~= "-" then
			table.insert(buf, " />")
		end
	else
		if self.nodeName ~= "-" then
			table.insert(buf, ">")
		end
		for _, child in ipairs(self.children) do
			if type(child) == "table" and getmetatable(child) == HtmlElement then
				table.insert(buf, tostring(child))
			elseif child.type == "wikitext" then
				table.insert(buf, child.value)
			end
		end
		if self.nodeName ~= "-" then
			table.insert(buf, "</" .. self.nodeName .. ">")
		end
	end

	return table.concat(buf)
end

--- Creates a new HTML element object.
-- @param tag Tag name (e.g. "div", "span", etc.)
-- @return A fluent HTML builder object.
function p.create(tag)
	-- assert(type(tag) == "string" and tag ~= "", "Tag must be a non-empty string.")
	if type(tag) ~= "string" or tag == "" then
		tag = "-"
	end
	return setmetatable({
		nodeName = tag,
		attrs = orderedTableInit({}),
		styles = {},
		children = {}
	}, HtmlElement)
end

return p

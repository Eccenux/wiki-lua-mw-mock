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

--- HTML element builder object.
local HtmlElement = {}
HtmlElement.__index = HtmlElement

--- Adds an attribute to the element.
function HtmlElement:attr(name, value)
	self.attrs[name] = tostring(value)
	return self
end

--- Adds a CSS property.
function HtmlElement:css(name, value)
	self.styles[name] = tostring(value)
	return self
end

--- Appends raw wikitext content (i.e., innerHTML).
function HtmlElement:wikitext(content)
	table.insert(self.children, { type = "wikitext", value = tostring(content) })
	return self
end

--- Appends a new HTML tag as a child.
function HtmlElement:tag(name)
	local child = p.create(name)
	table.insert(self.children, child)
	return child
end

--- Adds a CSS class (appends to the "class" attribute).
function HtmlElement:addClass(className)
	local existing = self.attrs["class"] or ""
	if existing ~= "" then
		self.attrs["class"] = existing .. " " .. className
	else
		self.attrs["class"] = className
	end
	return self
end

--- Appends a newline (for better readability in output).
function HtmlElement:newline()
	table.insert(self.children, { type = "wikitext", value = "\n" })
	return self
end

--- Returns the parent element (useful for chaining after :tag()).
function HtmlElement:done()
	return self._parent or self
end


--- Converts the element and its children to HTML.
function HtmlElement:__tostring()
	local buf = {}

	table.insert(buf, "<" .. self.tag)

	for k, v in pairs(self.attrs) do
		table.insert(buf, " " .. k .. '="' .. escapeHtml(v) .. '"')
	end

	if next(self.styles) then
		table.insert(buf, ' style="' .. escapeHtml(cssToString(self.styles)) .. '"')
	end

	if #self.children == 0 then
		table.insert(buf, " />")
	else
		table.insert(buf, ">")
		for _, child in ipairs(self.children) do
			if type(child) == "table" and getmetatable(child) == HtmlElement then
				table.insert(buf, tostring(child))
			elseif child.type == "wikitext" then
				table.insert(buf, child.value)
			end
		end
		table.insert(buf, "</" .. self.tag .. ">")
	end

	return table.concat(buf)
end

--- Creates a new HTML element object.
-- @param tag Tag name (e.g. "div", "span", etc.)
-- @return A fluent HTML builder object.
function p.create(tag)
	assert(type(tag) == "string" and tag ~= "", "Tag must be a non-empty string.")
	return setmetatable({
		tag = tag,
		attrs = {},
		styles = {},
		children = {}
	}, HtmlElement)
end

return p

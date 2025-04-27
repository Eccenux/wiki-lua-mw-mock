-- You can use this generate namespaces for a specific wiki.
-- Just paste below in MW Lua console.
local function dumpNamespacesSorted()
	local namespaces = mw.site.namespaces
	local output = {}
	local ids = {}

	-- Collect all IDs
	for id in pairs(namespaces) do
		table.insert(ids, id)
	end

	-- Sort IDs
	table.sort(ids)

	-- Build formatted output
	for _, id in ipairs(ids) do
		local ns = namespaces[id]
		table.insert(output, string.format(
			"\t[%d] = { id=%d, name=%q, canonicalName=%q, displayName=%q, hasSubpages=%s },",
			id,
			ns.id,
			ns.name or "",
			ns.canonicalName or "",
			ns.displayName or "",
			tostring(ns.hasSubpages)
		))
	end

	mw.log(table.concat(output, "\n"))
end

dumpNamespacesSorted()

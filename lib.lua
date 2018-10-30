lib = {}

function lib:split(str)
	local n = {}

	while (#str > 0) do
		local off = utf8.offset(str, -1)
		if (off) then
			ch = string.sub(str, off, #str)
			str = string.sub(str, 1, off-1)
			table.insert(n, ch)
		end
	end

	local r = {}

	for i, v in pairs(n) do
		r[1+#n-i] = v
	end

	return r
end

function lib:join(tbl)
	local r = ""
	for i, v in pairs(tbl) do
		r = r..v
	end
	return r
end

function lib:slice(str, s, e)
	local r = lib:split(str)

	b = s or 0
	e = e or #r

	local s = ""
	for i = b, e do
		local c = r[i]
		if (not c) then break end
		s = s..c
	end
	return s
end

function lib:strip_cols(str)
	local r = ""
	local ls = lib:split(str)
	for i, ch in pairs(ls) do
		if (ch == "¬" and terminal.codes[ls[i+1]]) then
			ls[i] = nil
			ls[i+1] = nil
		else
			r = r..ch
		end
	end
	return r
end

function lib:round(i, n)
	if (n == nil) then
		n = 1
	end
	return i+n/2 - (i+n/2) % n
end

function lib:startsWith(s, w)
	return s:sub(1, #w) == w
end

function lib:escape(s)
	return s:gsub("\\", "\\\\"):gsub("\"", "\\\"")
end

return lib
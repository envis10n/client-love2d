lib = {}

function lib:split(str)
	local r = {}

	for i = 1, #str do
		table.insert(r, utf8.offset(str, i))
	end

	for i = 1, #r do
		local t = r[i+1]
		if (t) then
			t = t-1
		else
			t = r[i]+1
		end
		
		local v = string.sub(str, r[i], t)
		if (#v > 0) then
			r[i] = v
		else
			r[i] = nil
		end
	end

	return r
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

return lib
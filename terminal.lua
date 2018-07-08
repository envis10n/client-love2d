utf8 = require("utf8")

local terminal = {}

function split(str)
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

terminal.codes = {
	["w"] = {1, 1, 1},
	["W"] = {0.8, 0.8, 0.8},
	["R"] = {1, 0, 0},
	["r"] = {1, 0.53, 0.53},
	["G"] = {0, 1, 0},
	["g"] = {0.53, 1, 0.53},
	["B"] = {0, 0, 1},
	["b"] = {0, 1, 1},
	["y"] = {1, 1, 0},
	["o"] = {1, 0.53, 0},
	["P"] = {1, 0, 1},
	["p"] = {1, 0.53, 1},
	["V"] = {0.54, 0.16, 0.88},
	["v"] = {0.39, 0.32, 0.58},
	["*"] = {0, 1, 0}
}

function terminal:init()
	terminal.lines = {}

	terminal.input = ""
	terminal.input_active = true

	terminal:add("¬rt¬*e¬gs¬*t¬ri¬*n¬bg¬*")
	terminal:add("¬rline¬* ¬g#¬*¬b2¬*")
end

function terminal:prompt()
end

function terminal:update()
end

function terminal:draw()
	local v = #terminal.lines
	if (v > h/fonth) then
		v = h/fonth
	end

	for i = 1, v do
		local x = 10
		local y = h-(i+2)*fonth

		local l = terminal.lines[#terminal.lines-i+1]
		local ls = split(l)
		for i, ch in pairs(ls) do
			if (ch == "¬" and terminal.codes[ls[i+1]]) then
				local col = terminal.codes[ls[i+1]]
				print(col[1], col[2], col[3])
				love.graphics.setColor(col[1], col[2], col[3])

				ls[i] = nil
				ls[i+1] = nil
			else
				love.graphics.print(ch, x, y)
				x = x + fontw
			end
		end
	end

	love.graphics.setColor(0, 255, 0)

	if (terminal.input_active) then
		love.graphics.print(">>", 10, h-fonth*1.75)
	end
end

function terminal:add(text)
	local s = ""
	for ch in text:gmatch(".") do
		if (#s+1 >= w/fontw) then
			terminal.lines[#terminal.lines+1] = s
			s = ""
		end
		s = s..ch
	end
	if (#s > 0) then
		terminal.lines[#terminal.lines+1] = s
	end
end

return terminal
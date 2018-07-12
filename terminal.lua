utf8 = require("utf8")

local terminal = {}

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
	["*"] = {0, 1, 0},
	["?"] = {0.91, 0.24, 0.47, 0.9}
}

function terminal:init()
	terminal.lines = {}

	terminal.input = ""
	terminal.input_active = true

	terminal:add("¬g[¬*SUCCESS¬g]¬* System initialised. Terminal interface online.")
	terminal:add("¬?test line #2 yes yes¬*")
	terminal:add("lets add another line")
	terminal:add("this is actually hell")
end

function terminal:prompt()
end

function terminal:update()
	mx, my = love.mouse.getPosition()
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
		local ls = lib:split(l)
		for i, ch in pairs(ls) do
			if (ch == "¬" and terminal.codes[ls[i+1]]) then
				local col = terminal.codes[ls[i+1]]
				local alp = 1
				if (col[4]) then
					alp = col[4]
				end
				love.graphics.setColor(col[1], col[2], col[3], alp)

				ls[i] = nil
				ls[i+1] = nil
			else
				love.graphics.print(ch, x, y)
				x = x + fontw
			end
		end
	end

	love.graphics.setColor(0.25, 1, 0.25, 0.25)

	local sp = terminal.selp
	if (sp) then
		local rmx = lib:round(mx, fontw)
		local rmy = lib:round(my, fonth)

		if (sp.x <= rmx and sp.y <= rmy) then
			love.graphics.rectangle("fill", sp.x, sp.y, rmx-sp.x, rmy-sp.y)
		end
	end

	love.graphics.setColor(0, 1, 0)

	if (terminal.input_active) then
		love.graphics.print(">>"..terminal.input, 10, h-fonth*1.75)
	end
end

function terminal:add(text)
	local s = ""
	for ch in text:gmatch(".") do
		if (#s+1 >= w/fontw-1 or ch == "\n") then
			terminal.lines[#terminal.lines+1] = s
			s = ""
		end
		if not (ch == "\n") then
			s = s..ch
		end
	end
	if (#s > 0) then
		terminal.lines[#terminal.lines+1] = s
	end
end

function terminal:textinput(key)
	if (terminal.input_active) then
		terminal.input = terminal.input..key
	end
end

function terminal:keypress(key, scancode, isrepeat)
	if (terminal.input_active) then
		if (key == "return") then
			if (#terminal.input > 0) then
				terminal:add(">>"..terminal.input)
				send('{"request":"command", "cmd":"'..terminal.input..'"}')
				terminal.input = ""
			end
		end
		if (key == "backspace") then
			terminal.input = string.sub(terminal.input, 0, string.len(terminal.input)-1)
		end
	end
end

return terminal
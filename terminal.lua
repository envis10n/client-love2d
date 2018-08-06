utf8 = require("utf8")

local terminal = {}

terminal.codes = {
	["w"] = {1, 1, 1},
	["W"] = {0.8, 0.8, 0.8},
	["R"] = {1, 0, 0},
	["r"] = {1, 0.53, 0.53},
	["G"] = {0, 1, 0},
	["g"] = {0.53, 1, 0.53},
	["B"] = {0.15, 0.4, 1},
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
	terminal.active = true

	terminal.lines = {}

	terminal.input = ""
	terminal.input_active = true

	terminal.scrolln = 0

	terminal.history = {}
	terminal.hix = -1

	terminal.bufferln = 1
	terminal.bufferix = 1

	terminal:add("¬g[¬*SUCCESS¬g]¬* Conenction to the net established.")
end

function terminal:prompt()
end

function terminal:update()
	mx, my = love.mouse.getPosition()

	local ln = terminal.lines[terminal.bufferln]
	if (ln) then
		ln = lib:split(ln)
		if (#ln > terminal.bufferix) then
			local inc = 2
			if (ln[terminal.bufferix] == "¬") then
				inc = 3
			end
			terminal.bufferix = terminal.bufferix+inc
		else
			terminal.bufferln = terminal.bufferln+2
			terminal.bufferix = 1
		end
	end
end

function terminal:draw()
	local buffer = {}
	for i, v in pairs(terminal.lines) do
		buffer[i] = v
	end
	
	for i, v in pairs(buffer) do
		if (i == terminal.bufferln) then
			local split = lib:split(buffer[i])
			buffer[i] = ""
			for c = 1, terminal.bufferix do
				if (split[c]) then
					buffer[i] = buffer[i]..split[c]
				end
			end
		elseif (i > terminal.bufferln) then
			buffer[i] = ""
		end
	end

	local v = #buffer
	if (v > h/fonth) then
		v = h/fonth
	end
	v = v+terminal.scrolln

	for i = terminal.scrolln+1, v do
		local x = 10
		local y = (h-(i+2)*fonth)+(terminal.scrolln*fonth)

		local l = buffer[#buffer-i+1]
		if (l) then
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

		love.graphics.setColor(0, 1, 0)
	end

	local sp = terminal.selp
	if (sp) then
		love.graphics.setColor(0.25, 1, 0.25, 0.25)

		local rmx = lib:round(mx, fontw)
		local rmy = lib:round(my, fonth)

		if (sp.x <= rmx and sp.y <= rmy) then
			love.graphics.rectangle("fill", sp.x, sp.y, rmx-sp.x, rmy-sp.y)
		end

		love.graphics.setColor(0, 1, 0)
	end

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

function terminal:getselected()
	local sp = terminal.selp

	if not (sp) then
		return ""
	end

	local rmx = lib:round(mx, fontw)+1
	local rmy = lib:round(my, fonth)+1
	
	if (sp.x > rmx) then
		terminal.selp = nil
		return
	end
	if (sp.y > rmy) then
		terminal.selp = nil
		return
	end

	local dx = math.floor(sp.x/fontw)
	local dy = math.floor(sp.y/fonth)

	local rh = math.floor((h-fonth*2)/fonth)

	local rl = math.floor((rmy-sp.y)/fonth)-1
	local rt = math.floor((rmx-sp.x)/fontw)-1
	
	local s = ""
	local y = #terminal.lines-(rh-dy)
	for y = y, y+rl do
		if (#s > 0) then
			s = s.."\n"
		end

		local ln = terminal.lines[y+1-terminal.scrolln]
		if (ln) then
			ln = lib:split(lib:strip_cols(ln))

			for x = dx, dx+rt do
				if (x > 0 and ln[x]) then
					s = s..ln[x]
				end
			end
		else
			s = s.."\n"
		end
	end
	
	return s
end

function terminal:textinput(key)
	if (terminal.input_active) then
		terminal.input = terminal.input..key
	end
end

function terminal:keypress(key, scancode, isrepeat)
	if (love.keyboard.isDown("lctrl")) then
		if (key == "c") then
			local sel = terminal:getselected()
			if (sel and #sel > 0) then
				love.system.setClipboardText(sel)
			end
		elseif (key == "v" and terminal.input_active) then
			local clip = love.system.getClipboardText()
			if (clip) then
				terminal.input = terminal.input..clip
			end
		end
	else	
		if (terminal.input_active) then
			if (key == "up" or key == "down") then
				local fs = 1
				if (key == "down") then
					fs = -1
				end

				local ix = terminal.hix+fs
				local hv = terminal.history[#terminal.history-ix]
				if (hv) then
					terminal.input = hv
					terminal.hix = ix
				elseif (key == "down") then
					terminal.input = ""
					terminal.hix = -1
				end
			elseif (key == "return") then
				if (#terminal.input > 0) then
					terminal:add(">>"..terminal.input)

					if (terminal.input == "clear") then
						terminal.bufferln = 1
						terminal.bufferix = 1
						terminal.lines = {}
					elseif (terminal.input == ".ost_breach") then
						soundtrack:play("breach", 0.8)
					else
						send('{"request":"command", "cmd":"'..terminal.input..'"}')
					end

					table.insert(terminal.history, terminal.input)

					terminal.input = ""

					terminal.hix = -1
				elseif (terminal.input == "") then
					terminal.bufferln = #terminal.lines+1
				end
			elseif (key == "backspace") then
				terminal.input = string.sub(terminal.input, 0, string.len(terminal.input)-1)
			end
		end
	end
end

function terminal:scroll(amn)
	if (terminal.scrolln+amn >= 0 and terminal.scrolln+amn <= #terminal.lines) then
		terminal.scrolln = terminal.scrolln+amn
	end
end

return terminal
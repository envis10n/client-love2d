state_game = {}

function state_game:enter()
	terminal = require("terminal")
	terminal:init()

	send('{"request":"connect", "token":"'..state_game.token..'"}')
end

function state_game:update()
	terminal:update()
end

function state_game:draw()
	terminal:draw()
end

function state_game:textinput(key)
    terminal:textinput(key)
end
function state_game:keypressed(key, scancode, isrepeat)
    terminal:keypress(key, scancode, isrepeat)
end

function state_game:mousepressed(x, y, button)
	terminal.selp = {
		x = lib:round(x-fontw/2, fontw),
		y = lib:round(y-fonth/2, fonth)
	}
end
function state_game:mousereleased(x, y, button)
	local sp = terminal.selp

	local rmx = lib:round(x, fontw)+1
	local rmy = lib:round(y, fonth)+1
	
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

		local ln = terminal.lines[y+1]
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
	print(s)

	terminal.selp = nil
end

return state_game
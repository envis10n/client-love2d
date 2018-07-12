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
		x = lib:round(x, fontw),
		y = lib:round(y, fonth)
	}
end
function state_game:mousereleased(x, y, button)
	local sp = terminal.selp

	local rmx = lib:round(mx, fontw)
	local rmy = lib:round(my, fonth)

	local dx = math.floor(sp.x/fontw)
	local dw = math.floor((rmx-sp.x)/fontw)
	print("dx", dx, "dw", dw)

	--h-(i+2)*fonth
	local dy = (#terminal.lines+1)-math.floor((h-rmy-fonth)/fonth)
	local dh = math.ceil((rmy-sp.y)/fonth)-1
	print("dy", dy, "dh", dh)

	local r = ""
	local y = dy
	--for y = dy, dy+dh do
	while (y <= dy+dh) do
		print("hmmm", y)

		if not (r == "") then
			r = r.."\n"
		end

		local ln = terminal.lines[y]
		if (ln) then
			ln = lib:split(lib:strip_cols(ln))
			for x = dx, dx+dw do
				if (ln[x]) then
					r = r..ln[x]
				end
			end
		end

		y = y+1
	end
	if not (r == "") then
		print(r)
	end

	terminal.selp = nil
end

return state_game
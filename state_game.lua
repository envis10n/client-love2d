state_game = {}
terminal = require("terminal")

function state_game:enter()
	if (not terminal.active) then
		terminal:init()
	end

	soundtrack:init()

	send('{"request":"connect", "token":"'..state_game.token..'"}')
end

function state_game:leave()
	soundtrack:stop()
end

function state_game:update()
	terminal:update()
	soundtrack:update()
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
		x = x,
		y = y
	}
end
function state_game:mousereleased(x, y, button)
	print(terminal:getselected(x, y))

	terminal.selp = nil
end

function state_game:wheelmoved(x, y)
	terminal:scroll(y)
end

return state_game
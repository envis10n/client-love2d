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

return state_game
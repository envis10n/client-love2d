state_game = {}

function state_game:enter()
	terminal = require("terminal")
	terminal:init()
end

function state_game:update()
	terminal:update()
end

function state_game:draw()
	terminal:draw()
end

return state_game
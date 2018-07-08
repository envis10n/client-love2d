state_game = {}

function state_game:enter()
	terminal = require("terminal")
	terminal:init()
end

local i = 0
function state_game:update()
	i = i+0.1
	if (i > 1) then
		i = 0
		terminal:add("hello")
	end

	terminal:update()
end

function state_game:draw()
	terminal:draw()
end

return state_game
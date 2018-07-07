state_game = {}

function state_game:enter()
end

function state_game:draw()
	
	--[[for y = 0, h/fonth-3 do
		local str = ""
		for x = 1, w/fontw do
			str = str.."a"
		end

		love.graphics.print(str, 2, y*fonth)
	end]]

	love.graphics.print(">>", 5, h-fonth*1.75)
end

return state_game
local terminal = {}

function terminal:init()
	terminal.lines = {
	}

	terminal.input = ""
	terminal.input_active = true
end

function terminal:prompt()
end

function terminal:update()
end

function terminal:draw()
	local iv = #terminal.lines-2
	if (iv > h/fonth-3) then
		iv = h/fonth-3
	end

	for i = 0, iv do
		local y = h-i*fonth-fonth*3
		love.graphics.print(terminal.lines[#terminal.lines-i], 2, y)
	end

	if (terminal.input_active) then
		love.graphics.print(">>", 5, h-fonth*1.75)
	end
end

return terminal
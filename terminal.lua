local terminal = {}

terminal.codes = {
	"r":[255,136,136]
}

function terminal:init()
	terminal.lines = {}

	terminal.input = ""
	terminal.input_active = true

	local s = ""
	for i = 0, 1000 do
		s=s.."a"
	end
	terminal:add(s)

	terminal:add("¬rTesting¬*")
end

function terminal:prompt()
end

function terminal:update()
end

function terminal:draw()
	local iv = #terminal.lines-1
	if (iv > h/fonth-1) then
		iv = h/fonth-1
	end

	for i = 0, iv do
		local y = h-i*fonth-fonth*3
		love.graphics.print(terminal.lines[#terminal.lines-i], 2, y)
	end

	if (terminal.input_active) then
		love.graphics.print(">>", 5, h-fonth*1.75)
	end
end

function terminal:add(text)
	local s = ""
	for i = 1, #text-1 do
		local ch = string.sub(text, i, i)
		print(i, ch)
		if (#s+1 >= w/fontw) then
			table.insert(terminal.lines, s)
			s = ""
		end
		s = s..ch
	end
	if (s) then
		table.insert(terminal.lines, s)
	end
end

return terminal
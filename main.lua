socket = require("socket").tcp()

font = love.graphics.newFont("OCR-A.ttf", 20)
fontw = font:getWidth("_")
fonth = font:getHeight("_")

state = require("hump/gamestate")

terminal = require("terminal")

state_menu = require("state_menu")
state_auth = require("state_auth")
state_game = require("state_game")

local socket = require("socket").tcp()

function send(data)
	print("Sending data")
	socket:send(data)
end

function love.load()
	w, h = love.graphics.getDimensions()

    love.graphics.setBackgroundColor(0.02, 0.03, 0.03)

    love.graphics.setFont(font)
	love.graphics.setColor(0, 255, 0)
	
	socket:connect("::", 13373)
	socket:settimeout(0)

    state.registerEvents()
    state.switch(state_game)
end

function love.update()
	local receiving = true
	local data = ""
	while (receiving) do
		local chunk = socket:receive("*l")
		if (chunk) then
			data = data..chunk
		else
			receiving = false
		end
	end
	if (#data > 0) then
		print(data)
	end
end
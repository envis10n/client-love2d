socket = require("socket").tcp()
json = require("json/json")

font = love.graphics.newFont("OCR-A.ttf", 20)
fontw = font:getWidth("_")
fonth = font:getHeight("_")
fallback = love.graphics.newFont("Noto.ttf", 20)
font:setFallbacks(fallback)

lib = require("lib")

state = require("hump/gamestate")

soundtrack = require("soundtrack")

terminal = require("terminal")

state_menu = require("state_menu")
state_auth = require("state_auth")
state_cfg = require("state_cfg")
state_game = require("state_game")

local socket = require("socket").tcp()

function send(data)
	print("Sending data")
	socket:send(data)
end

function icfg()
	local flags = {
		fullscreen = cfg.fullscreen
	}

	love.window.setMode(cfg.width, cfg.height, flags)

	w, h = love.graphics.getDimensions()
end

function love.load()
	local exists = love.filesystem.getInfo("config.txt")
	local file = love.filesystem.newFile("config.txt")
	if (exists) then
		file:open("r")
		local r = file:read()
		cfg = json.decode(r)

		icfg()
	else
		print("creating file")
		file:open("w")
		cfg = {
			width = 1152,
			height = 768,
			borderless = false,
			fullscreen = false
		}
		file:write(json.encode(cfg))
	end
	file:close()

	w, h = love.graphics.getDimensions()

    love.graphics.setBackgroundColor(0.02, 0.03, 0.03)

    love.graphics.setFont(font)
	love.graphics.setColor(0, 255, 0)
	
	socket:connect("209.97.136.54", 13373)
	socket:settimeout(0)

    state.registerEvents()
	state.switch(state_menu)

	love.keyboard.setKeyRepeat(true)
end

function love.update()
	local receiving = true
	local data = ""
	
	local data = socket:receive("*l")
	if not (data == nil) and (#data > 0) then
		print(data)
		data = json.decode(data)

		local gs = state:current()

		if (data.cfg) then
			if not (data.cfg.vol == nil) then
				print("vol: "..tostring(data.cfg.vol/10))
				soundtrack:setVol(data.cfg.vol/10);
			end
		end

		if (gs == state_auth) then
			if (data.token) then
				state_game.token = data.token
				--state_game.token = "alonelygirl"
				state.switch(state_game)
			end
			if (data.error) then
				msg = data.error
			end
		elseif (gs == state_game) then
			if (data.panic) then
				soundtrack:stop()
				soundtrack:play("breach")
			elseif (data.panicEnd) then
				soundtrack:stop()
				soundtrack:play("peace2")
			end

			if (data.msg) then
				terminal:add(data.msg)
			end
			if (data.error) then
				terminal:add("¬r[¬*¬RERROR¬*¬r]¬* ¬r"..data.error.."¬*")
			end
		end
	end
end

function love.resize(nw, nh)
	print("window has been resized")
	w = nw
	h = nh
 end
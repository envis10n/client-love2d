json = require("dkjson/dkjson")

local postprocess = require("post")

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

local networkThread

function send(data)
	print("Sending data")
	love.thread.getChannel('send'):push(data)
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
			fullscreen = false,
			effects = {
				glow = false,
				scanlines = false,
				filmgrain = false,
				crt = false
			}
		}
		file:write(json.encode(cfg))
	end
	file:close()

	effect = postprocess()

	effect(function()
		w, h = love.graphics.getDimensions()

		love.graphics.setBackgroundColor(0.02, 0.03, 0.03)

		love.graphics.setFont(font)

		love.graphics.setColor(0, 255, 0)
	end)
	networkThread = love.thread.newThread("network.lua")

	networkThread:start()

    state.registerEvents()
	state.switch(state_menu)

	love.keyboard.setKeyRepeat(true)
end

function love.update()
	local receiving = true
	
	local dstr = love.thread.getChannel('data'):pop()
	if not (dstr == nil) and (#dstr > 0) then
		print(dstr)

		data = json.decode(dstr)
		if not (data == nil) then

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
end

function love.resize(nw, nh)
	print("window has been resized")
	w = nw
	h = nh
 end
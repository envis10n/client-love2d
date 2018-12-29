state_cfg = {}

local postprocess = require("post")

local sel = 1
local options = {
	"Toggle Fullscreen",
	"Dimensions",
	"Effects",
	"Back"
}
local ds = false
local ef = false
local last = love.timer.getTime()

local effects = {}

local resolutions = {
	{900, 700},
	{1152, 768},
	{1152, 864},
	{1280,720},
	{1280,760},
	{1280,800},
	{1280,854},
	{1280,960},
	{1280,1024},
	{1365,760},
	{1366,768},
	{1400,1050},
	{1408,792},
	{1440,900},
	{1440,960},
	{1600,900},
	{1600,1200},
	{1680,1959},
	{1792,1008},
	{1920,1080},
	{1920,1200},
	{2560,1080},
	{2560,1440},
	{2560,1600},
	{2880,1920},
	{3440,1440},
	{3840,2160},
	{4096,2160}
}

function save()
	local file = love.filesystem.newFile("config.txt")
	file:open("w")
	file:write(json.encode(cfg))
	file:close()

	love.keyboard.setKeyRepeat(true, 0)
end

function state_cfg:enter()
	effect = postprocess()
	effects = {
		{'Glow', cfg.effects.glow},
		{'Scanlines', cfg.effects.scanlines},
		{'CRT', cfg.effects.crt},
		{'Filmgrain', cfg.effects.filmgrain}
	}
	print("Entering config screen")
end

function state_cfg:draw()
	effect(function()

		love.graphics.setColor(0, 255, 0);

		love.graphics.print("Settings", 20, 20)
		
		local ix = 60

		if (ds) then
			love.graphics.print("Current: "..tostring(cfg.width).."x"..tostring(cfg.height), 20, ix)

			ix = ix+fonth

			for i, res in pairs(resolutions) do
				if (i == ds) then
					love.graphics.setColor(0.25, 1, 0.25, 0.25)
					love.graphics.rectangle("fill", 20, ix, 200, fonth)
					love.graphics.setColor(0, 1, 0)
				end

				love.graphics.print(tostring(res[1]).."x"..tostring(res[2]), 20, ix)

				ix = ix+fonth
			end

			love.graphics.print("Back", 20, ix)
			if (ds == #resolutions+1) then
				love.graphics.setColor(0.25, 1, 0.25, 0.25)
				love.graphics.rectangle("fill", 20, ix, 200, fonth)
				love.graphics.setColor(0, 1, 0)
			end

			if (cfg.fullscreen) then
				love.graphics.setColor(1, 0, 0)
				love.graphics.print("This setting is redundant in fullscreen mode.", 20, ix+fonth*2)
				love.graphics.setColor(0, 1, 0)
			end
		elseif (ef) then

			love.graphics.setColor(0, 255, 0);

			ix = ix+fonth

			for i, eff in pairs(effects) do
				if(i == ef) then
					love.graphics.setColor(0.25, 1, 0.25, 0.25)
					love.graphics.rectangle("fill", 20, ix, 200, fonth)
					love.graphics.setColor(0, 1, 0)
				end
				local enabled = ' Off'
				if eff[2] then
					enabled = ' On'
				end
				love.graphics.print(eff[1]..enabled, 20, ix)
				ix = ix+fonth
			end

			love.graphics.print("Back", 20, ix)
			if (ef == #effects+1) then
				love.graphics.setColor(0.25, 1, 0.25, 0.25)
				love.graphics.rectangle("fill", 20, ix, 200, fonth)
				love.graphics.setColor(0, 1, 0)
			end
		else
			for i, option in pairs(options) do
				local str = option
				if (sel == i) then
					str = ">"..str
				else
					str = " "..str
				end

				love.graphics.print(str, 20, ix)

				ix = ix+fonth
			end
		end
	end)
end

function state_cfg:keypressed(key, scancode, isrepeat)
	if (love.timer.getTime()-last < 0.5) then
		return
	end

	if (ds) then
		if (key == "return") then
			if (ds == #resolutions+1) then
				ds = false
			else
				local res = resolutions[ds]
				cfg.width = res[1]
				cfg.height = res[2]
				icfg()
				save()
			end
		end

		if (key == "up" and ds>1) then
			ds = ds-1
		end
		if (key == "down" and ds<#resolutions+1) then
			ds = ds+1
		end
	elseif (ef) then
		if (key == "return") then
			if (ef == #effects+1) then
				ef = false
			else
				local eff = effects[ef]
				if (eff[1] == 'Glow') then
					cfg.effects.glow = not cfg.effects.glow
				elseif (eff[1] == 'Scanlines') then
					cfg.effects.scanlines = not cfg.effects.scanlines
				elseif (eff[1] == 'CRT') then
					cfg.effects.crt = not cfg.effects.crt
				elseif (eff[1] == 'Filmgrain') then
					cfg.effects.filmgrain = not cfg.effects.filmgrain
				else

				end
				effects = {
					{'Glow', cfg.effects.glow},
					{'Scanlines', cfg.effects.scanlines},
					{'CRT', cfg.effects.crt},
					{'Filmgrain', cfg.effects.filmgrain}
				}
				icfg()
				save()
				effect = postprocess()
			end
		end

		if (key == "up" and ef>1) then
			ef = ef-1
		end
		if (key == "down" and ef<#effects+1) then
			ef = ef+1
		end
	else
		if (key == "return") then
			local option = options[sel]

			if (option == "Toggle Fullscreen") then
				cfg.fullscreen = not cfg.fullscreen
				icfg()
				save()
				last = love.timer.getTime()
			elseif (option == "Dimensions") then
				ds = 1
			elseif (option == 'Effects') then
				ef = 1
			elseif (option == "Back") then
				state.switch(state_menu)
			end
		end

		if (key == "up" and sel>1) then
			sel = sel-1
		end
		if (key == "down" and sel<#options) then
			sel = sel+1
		end
end
end

return state_cfg
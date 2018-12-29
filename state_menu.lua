state_menu = {}

local postprocess = require("post")

local sel = 1
local options = {
	"Log in",
	"Register",
	"Settings",
	"Exit"
}

function state_menu:enter()
	effect = postprocess()
	print("Entering menu screen")
end

function state_menu:draw()
	effect(function()
		love.graphics.setColor(0, 255, 0);

		love.graphics.print("Displaying index", 20, 20)

		local ix = 60
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
	end)
end

function state_menu:keypressed(key, scancode, isrepeat)
	if (key == "return") then
		local option = options[sel]

		if (option == "Log in") then
			state_auth.ctx = "login"
			state.switch(state_auth)
		elseif (option == "Register") then
			state_auth.ctx = "register"
			state.switch(state_auth)
		elseif (option == "Settings") then
			state.switch(state_cfg)
		elseif (option == "Exit") then
			love.event.quit()
		end
    end

    if (key == "up" and sel>1) then
        sel = sel-1
    end
    if (key == "down" and sel<#options) then
        sel = sel+1
    end
end

return state_menu
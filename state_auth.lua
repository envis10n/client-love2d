state_auth = {}

function state_auth:enter()
	print("Entering authentication screen")
	print("ctx:"..state_auth.ctx)

	inputting_to = "username"
	username = ""
	password = ""

	msg = ""
	if (state_auth.ctx == "login") then
		msg = "Authentication required to proceed"
	elseif (state_auth.ctx == "register") then
		msg = "Processing user registration"
	else
		msg = "Error -- why am I here?"
	end
end

function state_auth:draw()
	love.graphics.print(msg, 20, 20)

    local u = "Username: "..username
    if (inputting_to == "username") then
        u = u.."_"
    end
    love.graphics.print(u, 20, 60);

    local p = "Password: "
    for i=1, string.len(password) do
        p = p.."*"
    end
    if (inputting_to == "password") then
        p = p.."_"
    end
	love.graphics.print(p, 20, 80)
	
	local rs = "Return to menu"
	if (inputting_to == "return") then
		rs = ">"..rs
	else
		rs = " "..rs
	end
	love.graphics.print(rs, 20, 120)
end

function state_auth:textinput(key)
    if (inputting_to == "username") then
		username = username..key
	elseif (inputting_to == "password") then
		password = password..key
    end
end

function state_auth:keypressed(key, scancode, isrepeat)
    if (key == "backspace") then
        if (inputting_to == "username") then
			username = string.sub(username, 0, string.len(username)-1)
		elseif (inputting_to == "password") then
			password = string.sub(password, 0, string.len(password)-1)
        end
    end

    if (key == "return") then
        if (inputting_to == "username") then
			inputting_to = "password"
		elseif (inputting_to == "password") then
            send('{"request":"auth", "'..state_auth.ctx..'":{"username":"'..lib:escape(username)..'", "password":"'..lib:escape(password)..'"}}')
		elseif (inputting_to == "return") then
			state_auth.ctx = nil
			state.switch(state_menu)
		end
    end

	if (key == "up") then
		if (inputting_to == "password") then
			inputting_to = "username"
		elseif (inputting_to == "return") then
			inputting_to = "password"
		end
	end
	if (key == "down") then
		if (inputting_to == "username") then
			inputting_to = "password"
		elseif (inputting_to == "password") then
			inputting_to = "return"
		end
    end
end

return state_auth
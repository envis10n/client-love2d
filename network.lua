local socket = require("socket").tcp()
local buffer = ""
socket:connect("::", 13373) -- 209.97.136.54
socket:settimeout(0)
while true do
    local data = ""
    data = socket:receive(1)
    if not (data == nil) and (#data > 0) then
        buffer = buffer .. data
    else
        if (string.sub(buffer, #buffer-1, #buffer) == "}\n") then
            love.thread.getChannel('data'):push(buffer)
            buffer = ""
        end
    end
    local v = love.thread.getChannel('send'):pop()
    if v then
        socket:send(v)
    end
end
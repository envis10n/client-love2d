local soundtrack = {}

function soundtrack:init()
	soundtrack.tracks = {}

	soundtrack.tracks.peace = love.audio.newSource("sound/disturbance_of_data_security.ogg", "stream")
	soundtrack.tracks.peace:setLooping(true)

	soundtrack.tracks.breach = love.audio.newSource("sound/misuse_of_information_technology.wav", "stream")
	soundtrack.tracks.breach_loop = love.audio.newSource("sound/misuse_of_information_technology_loop.wav", "stream")
	soundtrack.tracks.breach_loop:setLooping(true)

	if (soundtrack.vol == nil) then
		soundtrack.vol = 3
	end

	soundtrack:play("peace")
end

function soundtrack:stop()
	if (soundtrack.track) then
		soundtrack.tracks[soundtrack.track]:stop()
	end
end

function soundtrack:play(track)
	soundtrack:stop()
	soundtrack.tracks[track]:setVolume(soundtrack.vol)
	soundtrack.tracks[track]:play()
	soundtrack.track = track
end

function soundtrack:setVol(vol)
	soundtrack.vol = vol
	if (soundtrack.track) then
		soundtrack.tracks[soundtrack.track]:setVolume(soundtrack.vol)
	end
end

function soundtrack:update()
	local track = soundtrack.track
	if (track == "breach") then
		if not (soundtrack.tracks[track]:isPlaying()) then
			soundtrack:stop()
			soundtrack:play("breach_loop")
		end
	end
end

return soundtrack
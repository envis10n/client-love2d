local soundtrack = {}

function soundtrack:init()
	soundtrack.tracks = {}

	soundtrack.tracks.peace = love.audio.newSource("sound/disturbance_of_data_security.ogg", "stream")
	soundtrack.tracks.peace:setLooping(true)

	soundtrack.tracks.breach = love.audio.newSource("sound/misuse_of_information_technology.wav", "stream")
	soundtrack.tracks.breach_loop = love.audio.newSource("sound/misuse_of_information_technology_loop.wav", "stream")
	soundtrack.tracks.breach_loop:setLooping(true)

	soundtrack:play("peace")
end

function soundtrack:stop()
	if (soundtrack.track) then
		soundtrack.tracks[soundtrack.track]:stop()
	end
end

function soundtrack:play(track, vol)
	soundtrack:stop()
	soundtrack.tracks[track]:setVolume(soundtrack.vol or vol or 0.4)
	soundtrack.tracks[track]:play()
	soundtrack.track = track
end

function soundtrack:setVol(vol)
	if (soundtrack.track) then
		soundtrack.vol = vol
		soundtrack.tracks[soundtrack.track]:setVolume(soundtrack.vol)
	end
end

function soundtrack:update()
	local track = soundtrack.track
	if (track == "breach") then
		if not (soundtrack.tracks[track]:isPlaying()) then
			soundtrack:stop()
			soundtrack:play("breach_loop", soundtrack.tracks[track]:getVolume())
		end
	end
end

return soundtrack
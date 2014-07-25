w=Color.new(255,255,255)
mode=0
s=0

function flip()
	screen.waitVblankStart()
	screen.flip()
	screen:clear()
end

while (1) do
	--Select mode
	while mode == 0 do
		screen:print(0,0,"Select a mode:",w)
		screen:print(8,8,"Single Player!",w)
		screen:print(8,16,"Local Multiplayer!",w)
		screen:print(0,8+s*8,">",w)
		pad=Controls.read()
		if (pad:up() or pad:down()) and not (oldpad:up() or oldpad:down()) then
			if s == 0 then
				s=1
			else
				s=0
			end
		end
		if pad:cross() do
			if s == 0 then
				mode=1
				break
			else
				mode=2
				break
			end
		end
		oldpad=pad
		flip()
	end
	while mode == 1 do
	
	end
	while mode == 2 do
	
	end
end
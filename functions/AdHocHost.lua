screen:clear()
screen:print(0,0,"Turning on Ad-Hoc",w)
screen.flip()
Adhoc.init()
Adhoc.connect()

function startHost()
	d=0
	initLocalGame()
	while d == 0 do
		Adhoc.send("0|Start")
		rm=Adhoc.recv()
		if rm ~= "" then
			decode()
			if tokens[2] == "SendBoard" then
				d=1
				mode=2
				mp=2
			end
		end
	screen:print(0,0,"Searching for client!",w)
	flip()
	end
end

function sendBoard()
	d=0
	str=1
	for i=0,3,1 do
		str=str .. "|" .. gc[i]
	end
	while d == 0 do
		Adhoc.send(str)
		rm=Adhoc.recv()
		if rm ~= "" then
			decode()
			if tokens[1] == "2" then
				d=1
				mode=1
				t="Host"
				break
			end
		end
		screen:print(0,0,"Sending Board!",w)
		flip()
	end
end

function recvBoard()
	rm=Adhoc.recv()
	if rm ~= "" then
		decode()
		if tokens[2] == "SendBoard" then
			mode=2
			mp=2
		end
	end
end
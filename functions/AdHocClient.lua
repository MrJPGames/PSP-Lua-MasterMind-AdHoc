screen:clear()
screen:print(0,0,"Turning on Ad-Hoc",w)
screen.flip()
Adhoc.init()
Adhoc.connect()

function startClient()
	d=0
	while d == 0 do
		rm=Adhoc.recv()
		if rm ~= nil then
			decode()
			if hmsg == "Start" then
				d=1
				br=0
			end
		end
		screen:print(0,0,"Waiting for host!",w)
		flip()
	end

	while d == 1 do
		Adhoc.send("0|SendBoard")
		screen:print(0,0,"Waiting for host to set board!",w)
		rm=Adhoc.recv()
		if rm ~= nil then decode() end
		if br == 1 then
			t="Client"
			mode=1
			d=2
			break
		end
		flip()
	end
end

function sendBoard()
	str="2|" .. currow
	for i=0,3,1 do
		str=str .. "|" .. c[currow][i]
	end
	Adhoc.send(str)
end

function sendGameOver()

end

function sendWin()

end
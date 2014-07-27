screen:clear()
screen:print(0,0,"Turning on Ad-Hoc",w)
screen.flip()
Adhoc.init()
Adhoc.connect()

function startClient()
	d=0
	while d == 0 do
		rm=Adhoc.recv()
		if rm ~= "" then
			decode()
			if tokens[2] == "Start" then
				br=0
				getBoard()
			end
		end
		screen:print(0,0,"Waiting for host!",w)
		flip()
	end
end
function getBoard()
	d=1
	while d == 1 do
		Adhoc.send("0|SendBoard")
		screen:print(0,0,"Waiting for host to set board!",w)
		rm=Adhoc.recv()
		if rm ~= "" then
			br=0
			decode()
			if tokens[1] == "1" then
				initLocalGame()
				t="Client"
				mode=1
				d=2
				break
			end
		end
		flip()
		oldpad=Controls.read()
	end
end


function sendBoard()
	str=nil
	str="2|" .. currow
	for i = 0,3,1 do
		str=str.."|"..c[currow][i]
	end
	Adhoc.send(str)
	rm=Adhoc.recv()
	if rm == "0|Please come back!" then
		getBoard()
	end
end
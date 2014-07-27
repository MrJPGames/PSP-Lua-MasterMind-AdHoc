w=Color.new(255,255,255)

mode=0
s=0
st=0
currow=0
mp=0
c={}
tokens={}
gc={}
tgc={}
tc={}
bpin={}
wpin={}
math.randomseed(os.time())

--init render functions and loads images
dofile("./functions/render.lua")

function decode()
	--This decodes the messages send between PSP
	--This will work on LuaPlayer but multiplayer won't so it will crash!
	num=0
	for w in string.gmatch( rm, "([^|]*)|?" ) do
		num=num+1
		tokens[num] = w
	end
	table.remove(tokens)
	-- m = message type
	-- 0 = handshake
	-- 1 = board
	-- 2 = board sync
	if tokens[1] == "0" then
		hmsg=tokens[2]
	else
		hmsh="O Hell NO"
	end
	if tokens[1] == "1" then
		for i=0,3,1  do
			gc[i]=tonumber(tokens[2+i])
		end
		br=1
	end
	if tokens[1] == "2" then
		row=tonumber(tokens[2])
		currow=row
		for i=0,3,1 do
			ti=3+i
			if tokens[ti] ~= nil then
				cnum=tonumber(tokens[ti])
				c[row][i]=cnum
			end
		end
	else
		row="NONE"
	end
end

function initLocalGame()
	--gets rand color for pins
	if mp == 0 then
		for i=0,3,1 do
			gc[i]=math.random(0,5)
		end
	end
	--clears user input
	for j=0,7,1 do
		c[j]={}
		for i=0,3,1 do
			c[j][i]=-1
		end
	end
	--clears pins
	for i=0,7,1 do
		bpin[i]=0
		wpin[i]=0
	end
	st=0
	currow=0
	if mp == 2 and t == "Client" then currow=0 end
	pad=Controls.read()
	oldpad=pad
end

function clearGC()
	for i=0,3,1 do
		gc[i]=-1
	end
end

while (1) do
	--Select mode
	while mode == 0 do
		screen:print(0,0,"Select a mode:",w)
		screen:print(8,8,"Single Player!",w)
		screen:print(8,16,"1 PSP multiplayer!",w)
		screen:print(8,24,"Ad-Hoc multiplayer!",w)
		screen:print(0,8+s*8,">",w)
		pad=Controls.read()
		
		if pad:up() and not oldpad:up() then
			s=s-1
			if s < 0 then s=2 end
		end
		if pad:down() and not oldpad:down() then
			s=s+1
			if s > 2 then s=0 end
		end
		if pad:cross() then
			if s == 0 then
				initLocalGame()
				mode=1
				oldpad=pad
				break
			end
			if s == 1 then
				clearGC()
				mode=2
				mp=1
				oldpad=pad
				break
			end
			if s == 2 then
				clearGC()
				s=0
				mp=2
				oldpad=pad
				mode=3
			end
		end
		oldpad=pad
		flip()
	end
	
	--Single Player (Board for 1 PSP MP and AdHoc MP)
	while mode == 1 do
		if not (mp == 2 and t == "Host") then
			pad=Controls.read()
		end
		--change color of selected tile!
		if pad:up() and not oldpad:up() then
			c[currow][st]=c[currow][st]-1
			if c[currow][st] < 0 then
				c[currow][st]=5
			end
		end
		if pad:down() and not oldpad:down() then
			c[currow][st]=c[currow][st]+1
			if c[currow][st] > 5 then
				c[currow][st]=0
			end
		end
		
		--change slected tile
		if pad:left() and not oldpad:left() then
			st=st-1
			if st < 0 then
				st=3
			end
		end
		if pad:right() and not oldpad:right() then
			st=st+1
			if st > 3 then
				st=0
			end
		end
		
		if pad:cross() and not oldpad:cross() then
			wi=0
			for i = 0,3,1 do
				if c[currow][i] > -1 then
					filled=1
				else
					filled=0
					break
				end
			end
			if filled == 1 then
				st=0
				for i=0,3,1 do
					var1=c[currow][i]
					var2=gc[i]
					if var1 == var2 then
						win=1
					else
						win=0
						break
					end
				end
				
				if win == 1 then
					wi=1
					done=0
					currow=0
					initLocalGame()
					oldpad=pad
					while done==0 do
						renderWin()
						pad=Controls.read()
						if pad:cross() and not oldpad:cross() then
							oldpad=pad
							if mp == 1 then
								mode=2
								clearGC()
							end
							if mp == 2 then
								clearGC()
								getBoard()
								break
							end
							done=1
							break
						end
						oldpad=pad
						flip()
					end
				else
					for i=0,3,1 do
						tgc[i]=gc[i]
					end
					for i=0,3,1 do
						tc[i]=c[currow][i]
					end
					--check correct
					for i=0,3,1 do
						if tc[i] == tgc[i] then
							bpin[currow]=bpin[currow]+1
							tgc[i]=-1
							tc[i]=-2
						end
					end
					--check possible
					for i=0,3,1 do
						for j=0,3,1 do
							if tc[i] == tgc[j] then
								wpin[currow]=wpin[currow]+1
								tgc[j]=-1
								tc[i]=-2
							end
						end
					end
				end
				if wi == 0 then currow=currow+1 end
				if currow == 8 then
					done=0
					currow=0
					initLocalGame()
					oldpad=pad
					while done==0 do
						renderGameOver()
						pad=Controls.read()
						if pad:cross() and not oldpad:cross() then
							oldpad=pad
							if mp == 1 then
								mode=2
								clearGC()
							end
							if mp == 2 then
								clearGC()
								getBoard()
								break
							end
							done=1
							break
						end
						oldpad=pad
						flip()
					end
				end
			end
		end
		oldpad=pad
		
		--If Ad-Hoc send/recv board
		if mp == 2 and t == "Client" then sendBoard() end
		if mp == 2 and t == "Host" then recvBoard() end
		
		--Render
		renderGame()
		flip()
	end
	
	--Multi-Player (On 1 PSP) (or Ad-HOC)
	while mode == 2 do
		--HOST sends please do getBoard()
		if mp == 2 then Adhoc.send("0|Please come back!") end
		
		pad=Controls.read()
		--change color of selected tile!
		if pad:up() and not oldpad:up() then
			gc[st]=gc[st]-1
			if gc[st] < 0 then
				gc[st]=5
			end
		end
		if pad:down() and not oldpad:down() then
			gc[st]=gc[st]+1
			if gc[st] > 5 then
				gc[st]=0
			end
		end
		
		--change slected tile
		if pad:left() and not oldpad:left() then
			st=st-1
			if st < 0 then
				st=3
			end
		end
		if pad:right() and not oldpad:right() then
			st=st+1
			if st > 3 then
				st=0
			end
		end
		if pad:cross() and not oldpad:cross() then
			for i = 0,3,1 do
				if gc[i] > -1 then
					filled=1
				else
					filled=0
					break
				end
			end
			if filled == 1 then
				if mp == 1 then
					initLocalGame()
					mode=1
					st=0
					break
				end
				if mp == 2 then
					sendBoard()
					break
				end
			end
		end
		oldpad=pad
		
		--render
		renderCodeSelect()
		flip()
	end
		
	--Host/Client Select screen
	while mode == 3 do
		screen:print(0,0,"Select:",w)
		screen:print(8,8,"Host!",w)
		screen:print(8,16,"Client!",w)
		screen:print(0,8+s*8,">",w)
		pad=Controls.read()
		if (pad:up() or pad:down()) and not (oldpad:up() or oldpad:down()) then
			if s == 0 then
				s=1
			else
				s=0
			end
		end
		if pad:cross() and not oldpad:cross() then
		oldpad=pad
			if s == 0 then
				dofile("./functions/AdHocHost.lua")
				startHost()
				break
			else
				dofile("./functions/AdHocClient.lua")
				startClient()
				break
			end
		end
		oldpad=pad
		flip()
	end
	
	
end
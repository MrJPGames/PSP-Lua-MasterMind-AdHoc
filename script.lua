w=Color.new(255,255,255)
mode=0
s=0
c={}
st=0
currow=0
tokens={}
gc={}
tgc={}
tc={}
bpin={}
wpin={}
math.randomseed(os.time())

px={}
py={}
px[0]=0
px[1]=13
px[2]=0
px[3]=13
py[0]=0
py[1]=0
py[2]=13
py[3]=13

--Load sprites and background
sp=Image.load("sprites.png")
bg=Image.load("bg.png")

--init render functions
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
	-- 2 = curscreen sync
	m=tokens[1]
end

function initLocalGame()
	--gets rand color for pins
	for i=0,3,1 do
		gc[i]=math.random(0,5)
	end
	--clears user input
	for j=0,7,1 do
		c[j]={}
		for i=0,3,1 do
			c[j][i]=0
		end
	end
	--clears pins
	for i=0,7,1 do
		bpin[i]=0
		wpin[i]=0
	end
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
		if pad:cross() then
			if s == 0 then
				initLocalGame()
				mode=1
				oldpad=pad
				break
			else
				mode=2
				break
			end
		end
		oldpad=pad
		flip()
	end
	--Single Player
	while mode == 1 do
		pad=Controls.read()
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
				done=0
				currow=0
				initLocalGame()
				oldpad=pad
				while done==0 do
					screen:print(0,0,"You are winner",w)
					pad=Controls.read()
					if pad:cross() and not oldpad:cross() then
						oldpad=pad
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
			if currow == 8 then
				done=0
				currow=0
				initLocalGame()
				oldpad=pad
				while done==0 do
					screen:print(0,0,"Game Over",w)
					pad=Controls.read()
					if pad:cross() and not oldpad:cross() then
						oldpad=pad
						done=1
						break
					end
					oldpad=pad
					flip()
				end
			end
			currow=currow+1
			if currow == 8 then
				done=0
				currow=0
				initLocalGame()
				oldpad=pad
				while done==0 do
					screen:print(0,0,"Game Over",w)
					pad=Controls.read()
					if pad:cross() and not oldpad:cross() then
						oldpad=pad
						done=1
						break
					end
					oldpad=pad
					flip()
				end
			end
		end
		oldpad=pad
		
		--Render
		renderGame()
		flip()
	end
	--Multi-Player
	while mode == 2 do
	
	end
end
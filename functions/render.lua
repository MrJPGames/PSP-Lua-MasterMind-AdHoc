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
bgWin=Image.load("bgWin.png")
bgGO=Image.load("bgGameOver.png")
bgCS=Image.load("bgMakeCode.png")

--Draws everything that was rendered to the screen
function flip()
	--Renders the screen
	screen.waitVblankStart()
	screen.flip()
	screen:clear()
end

--Renders Game
function renderGame()
	screen:blit(0,0,bg)
	for i=0,3,1 do
		for j=0,7,1 do
			if j <= currow then
				if c[j][i] < 3 then
					if c[j][i] > -1 then
						screen:blit(9+27*i,246-j*30,sp,17*c[j][i],0,17,17,1)
					end
				else
					screen:blit(9+27*i,246-j*30,sp,17*(c[j][i]-3),17,17,17,1)
				end
			end
		end
	end
	if not (mp == 2 and t == "Host") then
		screen:blit(13+27*st,242-currow*30,sp,20,38,9,4,1)
		screen:blit(13+27*st,263-currow*30,sp,20,34,9,4,1)
	end
	--Render B/W pins
	--rows
	for j=0,7,1 do
		if j < currow then
		f=0
			for i=0,bpin[j]-1,1 do
				screen:blit(px[i]+122,py[i]+243-j*30,sp,10,34,10,10,1)
				f=f+1
			end
			for i=0,wpin[j]-1,1 do
				screen:blit(px[f+i]+122,py[f+i]+243-j*30,sp,0,34,10,10,1)
			end
		end
	end
end

function renderCodeSelect()
	screen:blit(0,0,bgCS)
	for i=0,3,1 do
		if gc[i] < 3 and gc[i] > -1 then
			screen:blit(68+i*91,25,sp,58+gc[i]*79,0,79,75,1)
		else
			screen:blit(68+i*91,25,sp,58+(gc[i]-3)*79,75,79,75,1)
		end
	end
	screen:blit(78+91*st,10,sp,0,44,58,14,1)
	screen:blit(78+91*st,101,sp,0,58,58,14,1)
end

function renderWin()
	screen:blit(0,0,bgWin)
end

function renderGameOver()
	screen:blit(0,0,bgGO)
end
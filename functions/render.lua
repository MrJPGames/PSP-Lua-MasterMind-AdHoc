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
					screen:blit(9+27*i,246-j*30,sp,17*c[j][i],0,17,17,1)
				else
					screen:blit(9+27*i,246-j*30,sp,17*(c[j][i]-3),17,17,17,1)
				end
			end
		end
	end
	screen:blit(13+27*st,242-currow*30,sp,20,38,9,4,1)
	screen:blit(13+27*st,263-currow*30,sp,20,34,9,4,1)
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
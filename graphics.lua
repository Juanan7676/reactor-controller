local gr = {}

function gr.progressBar(gpu,x,y,col,rell,totalWidth)
	gpu.setBackground(1,true)
	gpu.setForeground(2,true)
	gpu.set(x,y,"[")
	
	gpu.setBackground(col,true)
	gpu.fill(x+1,y,rell,1," ")
	
	gpu.setBackground(1,true)
	gpu.fill(x+rell+1,y,totalWidth-rell,1,"_")
	gpu.set(x+totalWidth+2,y,"]")
end

function gr.text(gpu,x,y,col,text)
	gpu.setForeground(col,true)

	local f = x
	for c in text:gmatch(".") do
		gpu.set(f,y,c)
		f = f + 1
	end
	gpu.setForeground(2,true)
end

return gr
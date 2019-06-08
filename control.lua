-- Reactor control computer
-- By Juanan76

-- Modulos
gr = require("gr")
component = require("component")
cfg = require("cfg")

-- Inicializar GPUs
gpu1 = component.proxy(cfg.gpu1)
gpu2 = component.proxy(cfg.gpu2)

gpu1.bind(cfg.scr1)
gpu2.bind(cfg.scr2)

-- Paleta de colores
-- [negro(1),blanco(2),rojo(3),verde(4),azul(5),amarillo(6),purpura(7)]
paleta = {0x000000,0xFFFFFF,0xFF0000,0x00FF00,0x0000FF,0xFFFF00,0xFF00FF}
for k,v in ipairs(paleta) do
	gpu1.setPaletteColor(k,v)
	gpu2.setPaletteColor(k,v)
end

-- Inicializar pantallas
w1,h1 = gpu1.getResolution()
w2,h2 = gpu2.getResolution()
gpu1.fill(1,1,w1,h1," ")
gpu2.fill(1,1,w2,w2," ")

-- Algunas constantes (config)
TjMax = 1000
pressMax = 12000

-- Bucle principal
while true do
	
	local temp = component.proxy(cfg.temp1).getTemperature()
	local perc = temp/TjMax
	local alt = 2
	gr.text(gpu1,1,alt,6,"Temperatura 1: ")
	if perc <= 0.5 then
		gr.progressBar(gpu1,17,alt,4,math.floor(20*perc),20)
		gr.text(gpu1,37,alt,4,temp.."ºC/"..TjMax.."ºC")
	elseif perc <= 0.75 then
		gr.progressBar(gpu1,17,alt,6,math.floor(20*perc),20)
		gr.text(gpu1,37,alt,6,temp.."ºC/"..TjMax.."ºC")
	else
		gr.progressBar(gpu1,17,alt,3,math.floor(20*perc),20)
		gr.text(gpu1,37,alt,3,temp.."ºC/"..TjMax.."ºC")
	end
	
	local temp = component.proxy(cfg.temp2).getTemperature()
	local perc = temp/TjMax
	local alt = 3
	gr.text(gpu1,1,alt,6,"Temperatura 2: ")
	if perc <= 0.5 then
		gr.progressBar(gpu1,17,alt,4,math.floor(20*perc),20)
		gr.text(gpu1,37,alt,4,temp.."ºC/"..TjMax.."ºC")
	elseif perc <= 0.75 then
		gr.progressBar(gpu1,17,alt,6,math.floor(20*perc),20)
		gr.text(gpu1,37,alt,6,temp.."ºC/"..TjMax.."ºC")
	else
		gr.progressBar(gpu1,17,alt,3,math.floor(20*perc),20)
		gr.text(gpu1,37,alt,3,temp.."ºC/"..TjMax.."ºC")
	end
	
	local temp = component.proxy(cfg.temp3).getTemperature()
	local perc = temp/TjMax
	local alt = 4
	gr.text(gpu1,1,alt,6,"Temperatura 3: ")
	if perc <= 0.5 then
		gr.progressBar(gpu1,17,alt,4,math.floor(20*perc),20)
		gr.text(gpu1,37,alt,4,temp.."ºC/"..TjMax.."ºC")
	elseif perc <= 0.75 then
		gr.progressBar(gpu1,17,alt,6,math.floor(20*perc),20)
		gr.text(gpu1,37,alt,6,temp.."ºC/"..TjMax.."ºC")
	else
		gr.progressBar(gpu1,17,alt,3,math.floor(20*perc),20)
		gr.text(gpu1,37,alt,3,temp.."ºC/"..TjMax.."ºC")
	end
	
	local temp = component.proxy(cfg.temp4).getTemperature()
	local perc = temp/TjMax
	local alt = 5
	gr.text(gpu1,1,alt,6,"Temperatura 4: ")
	if perc <= 0.5 then
		gr.progressBar(gpu1,17,alt,4,math.floor(20*perc),20)
		gr.text(gpu1,37,alt,4,temp.."ºC/"..TjMax.."ºC")
	elseif perc <= 0.75 then
		gr.progressBar(gpu1,17,alt,6,math.floor(20*perc),20)
		gr.text(gpu1,37,alt,6,temp.."ºC/"..TjMax.."ºC")
	else
		gr.progressBar(gpu1,17,alt,3,math.floor(20*perc),20)
		gr.text(gpu1,37,alt,3,temp.."ºC/"..TjMax.."ºC")
	end
	
	local temp = component.proxy(cfg.temp5).getTemperature()
	local perc = temp/TjMax
	local alt = 6
	gr.text(gpu1,1,alt,6,"Temperatura 5: ")
	if perc <= 0.5 then
		gr.progressBar(gpu1,17,alt,4,math.floor(20*perc),20)
		gr.text(gpu1,37,alt,4,temp.."ºC/"..TjMax.."ºC")
	elseif perc <= 0.75 then
		gr.progressBar(gpu1,17,alt,6,math.floor(20*perc),20)
		gr.text(gpu1,37,alt,6,temp.."ºC/"..TjMax.."ºC")
	else
		gr.progressBar(gpu1,17,alt,3,math.floor(20*perc),20)
		gr.text(gpu1,37,alt,3,temp.."ºC/"..TjMax.."ºC")
	end
	
	local temp = component.proxy(cfg.temp6).getTemperature()
	local perc = temp/TjMax
	local alt = 7
	gr.text(gpu1,1,alt,6,"Temperatura 6: ")
	if perc <= 0.5 then
		gr.progressBar(gpu1,17,alt,4,math.floor(20*perc),20)
		gr.text(gpu1,37,alt,4,temp.."ºC/"..TjMax.."ºC")
	elseif perc <= 0.75 then
		gr.progressBar(gpu1,17,alt,6,math.floor(20*perc),20)
		gr.text(gpu1,37,alt,6,temp.."ºC/"..TjMax.."ºC")
	else
		gr.progressBar(gpu1,17,alt,3,math.floor(20*perc),20)
		gr.text(gpu1,37,alt,3,temp.."ºC/"..TjMax.."ºC")
	end
	
	local _,press = component.proxy(cfg.cool_ent).getPipe()
	local perc = press/pressMax
	local alt = 2
	gr.text(gpu1,50,alt,6,"Salida refrigerante: ")
	if perc <= 0.5 then
		gr.progressBar(gpu1,72,alt,4,math.floor(20*perc),20)
		gr.text(gpu1,82,alt,4,press.." kPa/"..pressMax.." kPa")
	elseif perc <= 0.75 then
		gr.progressBar(gpu1,72,alt,6,math.floor(20*perc),20)
		gr.text(gpu1,82,alt,6,press.." kPa/"..pressMax.." kPa")
	else
		gr.progressBar(gpu1,72,alt,3,math.floor(20*perc),20)
		gr.text(gpu1,82,alt,3,press.." kPa/"..pressMax.." kPa")
	end
	
	local _,press = component.proxy(cfg.cool_sal).getPipe()
	local perc = press/pressMax
	local alt = 3
	gr.text(gpu1,50,alt,6,"Entrada refrigerante: ")
	if perc <= 0.5 then
		gr.progressBar(gpu1,72,alt,4,math.floor(20*perc),20)
		gr.text(gpu1,82,alt,4,press.." kPa/"..pressMax.." kPa")
	elseif perc <= 0.75 then
		gr.progressBar(gpu1,72,alt,6,math.floor(20*perc),20)
		gr.text(gpu1,82,alt,6,press.." kPa/"..pressMax.." kPa")
	else
		gr.progressBar(gpu1,72,alt,3,math.floor(20*perc),20)
		gr.text(gpu1,82,alt,3,press.." kPa/"..pressMax.." kPa")
	end
	
	os.sleep(1)
end

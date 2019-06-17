-- Reactor control computer
-- By Juanan76

-- Modulos
gr = require("gr")
component = require("component")
cfg = require("cfg")
act = require("actuators")

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

scrammed = false

function processTempSensor(alt,temp,n)
	local perc = temp/TjMax
	gr.text(gpu1,1,alt,6,"Temperatura "..n..": ")
	if perc <= 0.5 then
		gr.progressBar(gpu1,17,alt,4,math.floor(20*perc),20)
		gr.text(gpu1,37,alt,4,temp.."ºC/"..TjMax.."ºC")
	elseif perc <= 0.75 then
		gr.progressBar(gpu1,17,alt,6,math.floor(20*perc),20)
		gr.text(gpu1,37,alt,6,temp.."ºC/"..TjMax.."ºC")
	elseif perc < 1 then
		gr.progressBar(gpu1,17,alt,3,math.floor(20*perc),20)
		gr.text(gpu1,37,alt,3,temp.."ºC/"..TjMax.."ºC")
	else -- El reactor ha alcanzado TjMax, SCRAM
		act.triggerSCRAM(component.proxy(cfg.reactor_cpu),component.proxy(cfg.alarm))
		scrammed = true
	end
end

-- Bucle principal
while true do
	
	if scrammed then
		gr.text(gpu1,20,20,3,"Reactor was SCRAMed! Check for reactor integrity!")
		os.sleep(30)
		act.disableAlarm(component.proxy(cfg.alarm))
		break
	end
	
	local temp = component.proxy(cfg.temp1).getTemperature()
	processTempSensor(2,temp,1)
	
	local temp = component.proxy(cfg.temp2).getTemperature()
	processTempSensor(3,temp,2)
	
	local temp = component.proxy(cfg.temp3).getTemperature()
	processTempSensor(4,temp,3)
	
	local temp = component.proxy(cfg.temp4).getTemperature()
	processTempSensor(5,temp,4)
	
	local temp = component.proxy(cfg.temp5).getTemperature()
	processTempSensor(6,temp,5)
	
	local temp = component.proxy(cfg.temp6).getTemperature()
	processTempSensor(7,temp,6)
	
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
	entOpen = false
	salOpen = false
	
	gr.text(gpu1,50,alt,6,"Entrada refrigerante: ")
	if perc <= 0.5 then -- La presion es muy baja, abrir válvula de entrada
		act.openValve(component.proxy(cfg.in_cool))
		entOpen = true
	elseif entOpen then
		act.closeValve(component.proxy(cfg.in_cool))
		entOpen = false
	end
	
	if perc >= 0.95 then -- La presion es muy alta, abrir válvula de salida
		act.openValve(component.proxy(cfg.out_cool))
		salOpen = true
	elseif salOpen then
		act.closeValve(component.proxy(cfg.out_cool))
		salOpen = false
	end
	
	if entOpen then 
		gr.text(gpu1,110,alt,7,"IN-VALVE OPEN")
	elseif salOpen then
		gr.text(gpu1,110,alt,7,"OUT-VALVE OPEN")
	end
	
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

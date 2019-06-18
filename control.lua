-- Reactor control computer
-- By Juanan76

-- Modulos
gr = require("gr")
component = require("component")
cfg = require("config")
act = require("actuators")

-- Inicializar GPUs
gpu1 = component.proxy(cfg.gpu1)
if cfg.gpu2 ~= '' then gpu2 = component.proxy(cfg.gpu2) end

gpu1.bind(cfg.scr1)
if gpu2 ~= nil then gpu2.bind(cfg.scr2) end

-- Paleta de colores
-- [negro(1),blanco(2),rojo(3),verde(4),azul(5),amarillo(6),purpura(7)]
paleta = {0x000000,0xFFFFFF,0xFF0000,0x00FF00,0x0000FF,0xFFFF00,0xFF00FF}
for k,v in ipairs(paleta) do
	gpu1.setPaletteColor(k,v)
	if gpu2 ~= nil then gpu2.setPaletteColor(k,v) end
end

-- Inicializar pantallas
w1,h1 = gpu1.getResolution()
if gpu2 ~= nil then w2,h2 = gpu2.getResolution() end
gpu1.fill(1,1,w1,h1," ")
if gpu2 ~= nil then gpu2.fill(1,1,w2,w2," ") end

-- Algunas constantes (config)
TjMax = 500
pressMax = 50000

scrammed = false

function processTempSensor(alt,temp,n)
	local perc = temp/TjMax
	gr.text(gpu1,1,alt,6,"Temperatura "..n..": ")
	if perc <= 0.5 then
		gr.progressBar(gpu1,17,alt,4,math.floor(20*perc),20)
		gr.text(gpu1,41,alt,4,temp.."C/"..TjMax.."C")
	elseif perc <= 0.75 then
		gr.progressBar(gpu1,17,alt,6,math.floor(20*perc),20)
		gr.text(gpu1,41,alt,6,temp.."C/"..TjMax.."C")
	elseif perc < 1 then
		gr.progressBar(gpu1,17,alt,3,math.floor(20*perc),20)
		gr.text(gpu1,41,alt,3,temp.."C/"..TjMax.."C")
	else -- El reactor ha alcanzado TjMax, SCRAM
		act.triggerSCRAM(component.proxy(cfg.reactor_cpu),component.proxy(cfg.alarm))
		scrammed = true
	end
end

act.closeValve(component.proxy(cfg.in_cool))
act.closeValve(component.proxy(cfg.out_cool))
entOpen = false
salOpen = false

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
	local alt = 3
	
	gr.text(gpu1,55,alt,6,"Entrada refrigerante: ")
	if perc <= 0.5 and not entOpen then -- La presion es muy baja, abrir válvula de entrada
		act.openValve(component.proxy(cfg.in_cool))
		entOpen = true
	elseif perc > 0.5 and entOpen then
		act.closeValve(component.proxy(cfg.in_cool))
		entOpen = false
	end
	
	if perc >= 0.95 and not salOpen then -- La presion es muy alta, abrir válvula de salida
		act.openValve(component.proxy(cfg.out_cool))
		salOpen = true
	elseif perc < 0.95 and salOpen then
		act.closeValve(component.proxy(cfg.out_cool))
		salOpen = false
	end
	
	if entOpen then 
		gr.text(gpu1,122,alt,7,"IN-VALVE OPEN")
	elseif salOpen then
		gr.text(gpu1,122,alt,7,"OUT-VALVE OPEN")
	else
		gr.text(gpu1,122,alt,7,"                 ")
	end
	
	if perc <= 0.5 then
		gr.progressBar(gpu1,77,alt,4,math.floor(20*perc),20)
		gr.text(gpu1,102,alt,3,press.." kPa/"..pressMax.." kPa")
	elseif perc <= 0.75 then
		gr.progressBar(gpu1,77,alt,6,math.floor(20*perc),20)
		gr.text(gpu1,102,alt,4,press.." kPa/"..pressMax.." kPa")
	else
		gr.progressBar(gpu1,77,alt,3,math.floor(20*perc),20)
		gr.text(gpu1,102,alt,3,press.." kPa/"..pressMax.." kPa")
	end
	
	os.sleep(1)
end

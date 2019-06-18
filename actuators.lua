local a = {}

function a.triggerSCRAM(reactor, alarm)
	reactor.lowerRods()
	alarm.setOutput(1,15)
end

function a.disableAlarm(alarm)
	alarm.setOutput(1,0)
end

function a.openValve(valve)
	valve.setOutput({15,15,15,15,15,15})
end

function a.closeValve(valve)
	valve.setOutput({0,0,0,0,0,0})
end

return a
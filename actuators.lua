function triggerSCRAM(reactor, alarm)
	reactor.lowerControlRods()
	alarm.setOutput(1,15)
end

function disableAlarm(alarm)
	alarm.setOutput(1,0)
end

function openValve(valve)
	valve.setOutput({15,15,15,15,15,15})
end

function closeValve(valve)
	valve.setOutput({0,0,0,0,0,0})
end
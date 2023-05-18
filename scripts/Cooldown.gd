var maxtime = 0
var time = 0

# warning-ignore:shadowed_variable
func _init(maxtime):
	self.maxtime = maxtime
	self.time = 0
	
func tick(delta):
	time -= 1 * delta
	if time <= 0:
		time = 0
	return time

func is_ready():
	if time > 0:
		return false
	time = maxtime
	return true

func _timesup():
	if time == 0:
		return true

func _reset():
	if time > 0:
		time = 0



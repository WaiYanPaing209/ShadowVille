extends Control

onready var label = $RichTextLabel

var millisecond = 0
var second = 0
var minute = 0
var hour = 0

func _physics_process(delta):
	millisecond += 10 * delta
	if millisecond >= 10:
		second += 1
		millisecond = 0
	if second >= 60:
		minute += 1
		second = 0
	if minute >= 60:
		hour += 1
		minute = 0
	label.set_text(str(hour)+" : "+str(minute)+" : "+str(stepify(second,1))+" : "+str(stepify(millisecond,0.1)))

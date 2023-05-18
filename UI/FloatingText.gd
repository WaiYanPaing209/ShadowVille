extends Position2D

onready var label = $Label
onready var tween = $Tween

var type = ""
var amount = 0

var velocity = Vector2.ZERO
var maxSize = Vector2(1,1)

func _ready():
	label.text = str(round(amount))
	
	match type:
		"Damage":
			label.set("custom_colors/font_color",Color("ff3131"))
		"Heal":
			label.set("custom_colors/font_color",Color("2eff27"))
		"Critical":
			maxSize = Vector2(2,2)
			label.set("custom_colors/font_color",Color("ff3131"))
	randomize()
	var sideMovement = randi() % 100 - 60
	velocity = Vector2(sideMovement, 50)
	tween.interpolate_property(self, 'scale', scale, maxSize, 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_property(self, 'scale', Vector2(1,1), maxSize, .7, Tween.TRANS_LINEAR, Tween.EASE_OUT, .3)
	tween.start()

func _on_Tween_tween_all_completed():
	queue_free()

func _process(delta):
	position -= velocity * delta

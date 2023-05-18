extends Area2D

onready var canheal = false
onready var healRate = PlayerStats.MAX_HP * 0.05 # 5%
onready var textPath = preload("res://UI/FloatingText.tscn")

var millisecond = 0
var second = 0

func _process(delta):
	if canheal == true:
		millisecond += 10 * delta
		if millisecond >= 10 or millisecond == 0:
			second += 1
			millisecond = 0
			PlayerStats.HP += healRate
			var text = textPath.instance()
			text.amount = healRate
			text.type = "Heal"
			add_child(text)
		PlayerStats._set_max_health()
		if PlayerStats.HP == PlayerStats.MAX_HP:
			canheal = false
		

func _on_HealCircle_body_entered(body):
	if body.name == "Character":
		canheal = true


func _on_HealCircle_body_exited(_body):
	canheal = false
	PlayerStats._set_max_health()
	

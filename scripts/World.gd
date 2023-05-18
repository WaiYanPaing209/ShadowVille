extends Node2D

onready var ghostCD = $UserInterface/Cooldown/Border/CD
onready var ghostCD_label = $UserInterface/Cooldown/Border/numberCD

func _ready():
	pass
	
func _process(_delta):
	ghostCD.max_value = PlayerStats.ghostCooldown
	ghostCD.value = PlayerStats.ghostTick
	
	if PlayerStats.ghostTick <= 0:
		ghostCD_label.hide()
		ghostCD.texture_over = null
	
	else:
		ghostCD_label.show()
		ghostCD_label.text = str(round(PlayerStats.ghostTick))
	
		if PlayerStats.teleported == false:
			ghostCD.texture_over = load("res://assets/Ghost_Jaunt_icon.png")
			
		else:
			ghostCD.texture_over = null
		
		if PlayerStats.teleported == false and PlayerStats.spell_destroyed == true:
			ghostCD_label.show()
			ghostCD.texture_over = null
			
		elif PlayerStats.teleported == true:
			ghostCD_label.show()
		else:
			ghostCD_label.hide()



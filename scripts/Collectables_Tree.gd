extends StaticBody2D

onready var sprite = $Sprite

func _process(_delta):
	pass


func _on_PlayerEnterZone_body_entered(body):
	if body.name == "Character":
		sprite.modulate = Color("61ffffff")


func _on_PlayerEnterZone_body_exited(_body):
	sprite.modulate = Color("ffffff")




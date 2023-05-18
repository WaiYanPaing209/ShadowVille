extends StaticBody2D

func _process(_delta):
	pass


func _on_PlayerEnterZone_body_entered(body):
	if body.name == "Character":
		$PineTree.modulate = Color("61ffffff")


func _on_PlayerEnterZone_body_exited(_body):
	$PineTree.modulate = Color("ffffff")

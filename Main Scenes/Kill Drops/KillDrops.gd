extends KinematicBody2D

onready var stats = $KillDropStats

func _on_PlayerEnterZone_body_entered(body):
	if body.name == "Character":
		PlayerStats.HP += stats.HP
		queue_free()

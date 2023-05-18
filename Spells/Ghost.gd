extends KinematicBody2D

var velocity = Vector2.ZERO
var location = Vector2.ZERO

export (int) var speed = 300

onready var timer = $Timer

func _ready():
	PlayerStats.spell_destroyed = false
	PlayerStats.teleported = false
	$AnimationPlayer.play("Default")

func _physics_process(delta):
# warning-ignore:return_value_discarded
	move_and_collide(velocity.normalized() * delta * speed)
	location = self.global_position
	PlayerStats.ghostPosition = location
	$Sprite.flip_h = velocity.x < 0
	if PlayerStats.teleported == true:
		queue_free()

func self_destruct():
	queue_free()

func _on_Timer_timeout():
	PlayerStats.spell_destroyed = true
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	PlayerStats.spell_destroyed = true
	queue_free()

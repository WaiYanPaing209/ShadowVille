extends KinematicBody2D

onready var velocity = Vector2.ZERO
onready var look_vec = Vector2.ZERO
onready var spritepath = $AnimatedSprite

<<<<<<< HEAD
export (int) var speed = 6
=======
var speed = 6
>>>>>>> 975870f479064bc9fd4525c5a97b9aaa4e95f42d
var player = null

func _ready():
	look_vec = player.position - global_position
	
func _physics_process(delta):
	velocity = velocity.move_toward(look_vec, delta)
	velocity = velocity.normalized() * speed
	position += velocity



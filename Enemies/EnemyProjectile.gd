extends KinematicBody2D

onready var velocity = Vector2.ZERO
onready var look_vec = Vector2.ZERO
onready var spritepath = $AnimatedSprite

var speed = 6
var player = null

func _ready():
	look_vec = player.position - global_position
	
func _physics_process(delta):
	velocity = velocity.move_toward(look_vec, delta)
	velocity = velocity.normalized() * speed
	position += velocity



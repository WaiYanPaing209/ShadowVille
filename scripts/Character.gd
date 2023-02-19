extends KinematicBody2D

const acceleration = 700
const max_speed = 150
const friction = 600

onready var animationPlayer = $AnimationPlayer
onready var animationtree = $AnimationTree
onready var animationstate = animationtree.get("parameters/playback")
onready var velocity = Vector2.ZERO

enum {
	MOVE,
	ATTACK
}
var state = MOVE
func _ready():
	animationtree.active = true

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state()
			
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		animationtree.set("parameters/Idle/blend_position",input_vector)
		animationtree.set("parameters/Walk/blend_position",input_vector)
		animationtree.set("parameters/Attack/blend_position",input_vector)
		animationstate.travel("Walk")
		velocity = velocity.move_toward(input_vector * max_speed, acceleration * delta)
	
	else:
		animationstate.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("ui_accept"):
		state = ATTACK
	
func attack_state():
	velocity = Vector2.ZERO
	animationstate.travel("Attack")
	
func on_attack_animation_finished():
	state = MOVE

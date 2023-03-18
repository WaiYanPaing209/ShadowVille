extends KinematicBody2D

onready var playerDetectionZone = $PlayerDetectionZone
onready var knockback = Vector2.ZERO
export (int) var acceleration 
export (int) var dash_speed
onready var cooldown = preload("res://scripts/Cooldown.gd")

onready var delayCooldown = cooldown.new(3)
onready var ran_num
onready var velocity = Vector2.ZERO
onready var originPosition = self.global_position

func _on_Hurtbox_area_entered(area):
	$RichTextLabel.show()
	$RichTextLabel.text = "ow"
	var knockbackVetor = area.knockbackVector
	knockback = knockbackVetor * 120

func _on_Hurtbox_area_exited(_area):
	$RichTextLabel.hide()
	
var state

enum {
	ROAM,
	IDLE,
	CHASE,
	DASH
}

func _ready():
	state = IDLE


func _process(_delta):
	pass
# warning-ignore:unused_argument
func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)
	velocity = move_and_slide(velocity)
	match state:
		ROAM:
			pass
		IDLE:
			seek_player()
			velocity = position.direction_to(originPosition) * acceleration
			if self.global_position == originPosition:
				velocity = Vector2.ZERO
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				var direction = position.direction_to(player.position)
				velocity = direction * acceleration
				var distance = round(self.position.distance_to(player.position))
				if distance <= ran_num:
					state = DASH
			else:
				state = IDLE
		DASH:
			var player = playerDetectionZone.player
			if player != null:
				var direction = position.direction_to(player.position)
				velocity = direction * dash_speed
			else:
				state = IDLE

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func _pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _pick_random_number(ran1,ran2):
	ran_num = rand_range(ran1,ran2)
	return ran_num


func _on_Timer_timeout():
	_pick_random_number(105,190)

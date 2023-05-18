extends KinematicBody2D

onready var playerDetectionZone = $PlayerDetectionZone
onready var knockback = Vector2.ZERO
onready var acceleration = 50
onready var dash_speed = 120
onready var cooldown = preload("res://scripts/Cooldown.gd")

# preload scenes
onready var projectilepath = preload("res://Enemies/EnemyProjectile.tscn")

onready var shootCooldown = cooldown.new(.8)
onready var ran_num 

onready var velocity = Vector2.ZERO
onready var originPosition = self.global_position

func _on_Hurtbox_area_entered(area):
	$RichTextLabel.show()
	$RichTextLabel.text = "ow"
	var knockbackVetor = area.knockbackVector
	knockback = knockbackVetor * 125

func _on_Hurtbox_area_exited(_area):
	$RichTextLabel.hide()
	
var state
var player = null

enum {
	ROAM,
	IDLE,
	CHASE,
	DASH
}

func _ready():
	state = IDLE


func _process(delta):
	shootCooldown.tick(delta)
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
			player = playerDetectionZone.player
			if player != null:
				var direction = position.direction_to(player.position)
				velocity = direction * acceleration
				var distance = round(self.position.distance_to(player.position))
				print(distance)
				if distance <= ran_num:
					velocity = Vector2.ZERO
				if playerDetectionZone.can_see_player() and shootCooldown.is_ready():
					var projectile = projectilepath.instance()
					projectile.player = player
					projectile.position = $Node2D.global_position
					get_parent().add_child(projectile)
			else:
				state = IDLE
		DASH:
			player = playerDetectionZone.player
			if player != null:
				var direction = position.direction_to(player.position)
				velocity = direction * dash_speed
			else:
				state = IDLE

func _shoot():
	var projectile = projectilepath.instance()
	projectile.player = player
	projectile.position = $Node2D.global_position
	get_parent().add_child(projectile)

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
	_pick_random_number(326,225)


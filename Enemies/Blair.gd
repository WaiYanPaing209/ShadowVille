extends KinematicBody2D

onready var playerDetectionZone = $PlayerDetectionZone
onready var knockback = Vector2.ZERO

export (int) var knock_back_force = 150

export (int) var acceleration 
export (int) var dash_speed

onready var cooldown = preload("res://scripts/Cooldown.gd")
onready var floatingText = preload("res://UI/FloatingText.tscn")
onready var hp_drop = preload("res://Main Scenes/Kill Drops/HP.tscn")
onready var stats = $Stats

onready var delayCooldown = cooldown.new(.3)
onready var refreshVisionCooldown = cooldown.new(.5)
onready var ran_num = _pick_random_number(105,190)
onready var velocity = Vector2.ZERO
onready var originPosition = self.global_position

func _on_Hurtbox_area_entered(area):
	on_hit(area)

func on_hit(area):
	randomize()
	var armorChance = rand_range(0.0, 1.0)
	var damageReduction = armorChance * stats.armor / stats.max_armor
	area.damage = area.damage - (area.damage * damageReduction)
	var realDamage = area.damage - stats.armor
	var text = floatingText.instance()
	text.amount = realDamage
	text.type = "Damage"
	stats.hp -= realDamage
	add_child(text)
	if stats.hp <= 0:
		die()
	var knockbackVetor = area.knockbackVector
	knockback = knockbackVetor * knock_back_force
	
func die():
	queue_free()
	
var state

enum {
	ROAM,
	IDLE,
	CHASE,
	DASH
}

func _ready():
	state = IDLE

func _process(delta):
	$HpBar/Hp.max_value = stats.maxHp
	$HpBar/Hp.value = stats.hp
	delayCooldown.tick(delta)
	
# warning-ignore:unused_argument
func _physics_process(delta):
	if delayCooldown.is_ready():
		$Hitbox/CollisionShape2D.disabled = false
	else:
		$Hitbox/CollisionShape2D.disabled = true
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
				if distance <= ran_num and player != null:
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

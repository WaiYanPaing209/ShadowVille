extends KinematicBody2D

onready var playerDetectionZone = $PlayerDetectionZone
onready var knockback = Vector2.ZERO
export (int) var acceleration = 50
onready var dash_speed = 120
onready var cooldown = preload("res://scripts/Cooldown.gd")
onready var stats = $Stats
onready var rayCast = $Beam/RayCast2D
onready var begin = $Beam/Begin
onready var beam = $Beam/Beam
onready var end = $Beam/End
onready var particles = $Beam/End/Particles2D
onready var rayLength = 320

# preload scenes
onready var projectilepath = preload("res://Enemies/EnemyProjectile.tscn")
onready var blairPath = preload("res://Enemies/Blair.tscn")
onready var floatingText = preload("res://UI/FloatingText.tscn")
onready var hp_drop = preload("res://Main Scenes/Kill Drops/HP.tscn")

onready var shootCooldown = cooldown.new(stats.shootcooldown)
onready var summonCooldown = cooldown.new(stats.summonCooldown)
onready var healSpellCooldown = cooldown.new(stats.healSpellCooldown)
onready var beamTimer = cooldown.new(stats.beamBlinkTimer)
onready var ran_num 

onready var velocity = Vector2.ZERO
onready var originPosition = self.global_position

var millisecond = 0
var second = 0

func self_regeneration(delta):
	if stats.hp <= stats.maxHp / .8:
		if stats.hp <= stats.maxHp:
			stats.hp += 10 * delta

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
	knockback = knockbackVetor * 130

func rejuvenation():
	var minHealthPercentage = stats.maxHp * .3
	var heal = stats.maxHp * .5
	if stats.hp <= minHealthPercentage and healSpellCooldown.is_ready():
		var text = floatingText.instance()
		text.amount = heal
		text.type = "Heal"
		$HealSpell.frame = 0
		$HealSpell.play("default")
		$Healtimer.wait_time = .5
		$Healtimer.start()
		$HealSpell.show()
		stats.hp += heal
		add_child(text)
		if stats.hp >= stats.maxHp:
			stats.hp = stats.maxHp

func summon():
	if summonCooldown.is_ready():
		var blair = blairPath.instance()
		blair.position = self.global_position + Vector2(rand_range(-100, 150), rand_range(50,150))
		get_parent().add_child(blair)


func die():
	queue_free()

	
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
	_pick_random_number(326,225)
	beam.scale = Vector2(.5,.5)
	begin.scale = Vector2(.5,.5)
	particles.scale = Vector2(.5,.5)
	$Beam.hide()
	

func _process(delta):
	shootCooldown.tick(delta)
	summonCooldown.tick(delta)
	healSpellCooldown.tick(delta)
	$HpBar/Hp.max_value = stats.maxHp
	$HpBar/Hp.value = stats.hp
	$Cooldown/Border/CD.max_value = stats.summonCooldown
	$Cooldown/Border/CD.value = summonCooldown.time
	$Cooldown/Border/CD/numberCD.text = str(round(summonCooldown.time))
	$Cooldown/Border/CD/numberCD.show()
	if summonCooldown.time <= 0:
		$Cooldown/Border/CD/numberCD.hide()
	$Cooldown/Border2/CD.max_value = stats.healSpellCooldown
	$Cooldown/Border2/CD.value = healSpellCooldown.time
	$Cooldown/Border2/CD/numberCD.text = str(round(healSpellCooldown.time))
	$Cooldown/Border2/CD/numberCD.show()
	if healSpellCooldown.time <= 0:
		$Cooldown/Border2/CD/numberCD.hide()

		
func castBeam(delta):
	if playerDetectionZone.player != null:
		beamTimer.tick(delta)
		$Beam.show()
		var direction = position.direction_to(playerDetectionZone.player.global_position)
		rayCast.cast_to = direction * rayLength 
		if rayCast.is_colliding():
			end.global_position = rayCast.get_collision_point()
			if beamTimer.is_ready():
				$Beam/End/Hitbox/CollisionShape2D.disabled = true
			else:
				$Beam/End/Hitbox/CollisionShape2D.disabled = false
		beam.rotation = rayCast.cast_to.angle()
		beam.region_rect.end.x = end.position.length() * 2
	else:
		$Beam.hide()

# warning-ignore:unused_argument
func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)
	velocity = move_and_slide(velocity)
	rejuvenation()
#	castBeam(delta)
	if playerDetectionZone.can_see_player():
		summon()
	match state:
		ROAM:
			pass
		IDLE:
			seek_player()
			velocity = position.direction_to(originPosition) * acceleration
			if (self.global_position - originPosition).length() <= 1.0:
				velocity = Vector2.ZERO
		CHASE:
			player = playerDetectionZone.player
			if player != null:
				var direction = position.direction_to(player.position)
				velocity = direction * acceleration
				var distance = round(self.position.distance_to(player.position))
				if distance <= ran_num:
					velocity = -(velocity)
				if playerDetectionZone.can_see_player() and shootCooldown.is_ready():
					var projectile = projectilepath.instance()
					projectile.player = player
					projectile.position = $Node2D/Position2D.global_position
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

func _on_Healtimer_timeout():
	$HealSpell.hide()



	
	

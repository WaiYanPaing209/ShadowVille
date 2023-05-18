extends KinematicBody2D

export (int) var acceleration = 700
var speed = 150
var friction = 700
var distance = 0
var loaction = Vector2.ZERO

const cooldown = preload("res://scripts/Cooldown.gd")

#preload packedscenes
onready var floatingTextPath = preload("res://UI/FloatingText.tscn")
onready var ghostspellPath = preload("res://Spells/Ghost.tscn")
onready var projectilePath = preload("res://Spells/Projectile.tscn")

onready var animationPlayer = $AnimationPlayer
onready var animationtree = $AnimationTree
onready var spellCaster = $spellCaster/Position2D
onready var hitbox = $PlayerHitbox
onready var animationstate = animationtree.get("parameters/playback")
onready var velocity = Vector2.ZERO
onready var projectileCooldown = cooldown.new(PlayerStats.projectileCooldown)
onready var ghostCooldown = cooldown.new(PlayerStats.ghostCooldown)

enum {
	MOVE,
	ATTACK
}

var state = MOVE

func _ready():
	collision_layer = 2
	$Hurtbox/CollisionShape2D.disabled = false
	$SprintEffect.hide()
	$PlayerHitbox.damage = PlayerStats.damage
	animationtree.active = true

func _process(delta):
	projectileCooldown.tick(delta)
	ghostCooldown.tick(delta)
	PlayerStats.ghostTick = ghostCooldown.time
	
func spellcast():
	var ghostSpell = ghostspellPath.instance()
	if Input.is_action_just_pressed("1") and ghostCooldown.is_ready() and PlayerStats.ghostSpellManaCost <= PlayerStats.MP:
		PlayerStats.MP -= PlayerStats.ghostSpellManaCost
		get_parent().add_child(ghostSpell)
		ghostSpell.position = spellCaster.global_position
		ghostSpell.velocity = get_global_mouse_position() - ghostSpell.position
		ghostSpell.timer.start()
		PlayerStats.teleported = false
	elif Input.is_action_just_pressed("1") and not ghostCooldown.is_ready() and PlayerStats.teleported == false:
		self.global_position = PlayerStats.ghostPosition
		PlayerStats.teleported = true
		
func Sprint(delta):
	if Input.get_action_strength("Sprint"):
		if Input.is_action_just_pressed("Sprint"):
			$SprintEffect.show()
			$SprintEffect.frame = 0 
			$SprintEffect.play("default")
		speed = 250
		PlayerStats.STAMINA -= PlayerStats.sprintEnergyCost * delta
		if PlayerStats.STAMINA <= 0:
			PlayerStats.STAMINA = 0
			speed = 150
			$SprintEffect.stop()
			$SprintEffect.hide()
	else:
		$SprintEffect.stop()
		$SprintEffect.hide()
		speed = 150
		if PlayerStats.STAMINA < PlayerStats.MAX_STAMINA:
			PlayerStats.STAMINA += 30 * delta

func projectileSpell():
	var projectile = projectilePath.instance()
	get_parent().add_child(projectile)
	projectile.position = spellCaster.global_position
	projectile.rotation = (get_global_mouse_position() - position).angle()
	projectile.velocity = get_global_mouse_position() - projectile.position
	

func _physics_process(delta):
	loaction = self.global_position
	PlayerStats.PLAYER_LOCATION = loaction
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state()
			
func move_state(delta):
	if PlayerStats.canShoot == true and Input.is_action_just_pressed("ui_mouse_left_click") and projectileCooldown.is_ready():
		$Position2D.look_at(get_global_mouse_position())
		projectileSpell()
		
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		hitbox.knockbackVector = input_vector
		animationtree.set("parameters/Idle/blend_position",input_vector)
		animationtree.set("parameters/Walk/blend_position",input_vector)
		animationtree.set("parameters/Attack/blend_position",input_vector)
		animationstate.travel("Walk")
		velocity = velocity.move_toward(input_vector * speed, acceleration * delta)
	
	else:
		animationstate.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("ui_accept"):
		if PlayerStats.STAMINA >= PlayerStats.basicAttackEnergyCost:
			PlayerStats.STAMINA -= PlayerStats.basicAttackEnergyCost 
			state = ATTACK
			if PlayerStats.STAMINA <= 0:
				PlayerStats.STAMINA = 0
				state = MOVE
		
	Sprint(delta)
	spellcast()
	if PlayerStats.die():
		queue_free()
	
func attack_state():
	velocity = Vector2.ZERO
	animationstate.travel("Attack")
	
	
	
func on_attack_animation_finished():
	state = MOVE

func _input(event):
	if event.is_action_pressed("pickup"):
		if $PickUpZone.items_in_range.size() > 0:
			var pickup_item = $PickUpZone.items_in_range.values()[0]
			pickup_item.pick_up_item(self)
			$PickUpZone.items_in_range.erase(pickup_item)


	
func _on_Hurtbox_area_entered(area):
	randomize()
	var armorChance = rand_range(0.0, 1.0)
	var damageReduction = armorChance * PlayerStats.ARMOR / PlayerStats.MAX_ARMOR
	area.damage = area.damage - (area.damage * damageReduction)
	var realDamage = area.damage - PlayerStats.ARMOR
	var text = floatingTextPath.instance()
	text.amount = realDamage
	text.type = "Damage"
	PlayerStats.HP -= realDamage
	add_child(text)
	




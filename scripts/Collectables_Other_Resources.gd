extends StaticBody2D

# scene instances
onready var bloodPath = preload("res://Main Scenes/Item Drops/Blood.tscn")
onready var bonePath = preload("res://Main Scenes/Item Drops/Bone.tscn")
onready var soulPath = preload("res://Main Scenes/Item Drops/Soul.tscn")

onready var sprite = $Sprite
export (int) var collectSpeed = 50

var canCollect = false
var canSpawn = false
var Spawned = false 


func _ready():
	$CollectUI/Label.text = "Collect (E)"
	$CollectUI.hide()
	$CollectUI/CollectProgress.value = 0

# new variable to keep track of whether a potion has been spawned

func _process(delta):
	randomize()
	if canCollect == true and Input.get_action_strength("gather"):
		$CollectUI/CollectProgress.value += collectSpeed * delta
		if $CollectUI/CollectProgress.value == $CollectUI/CollectProgress.max_value:
			canSpawn = true
	elif canSpawn == true and not Spawned: 
		var spawnChance = randf()
		print(spawnChance)
		if spawnChance <= 0.8:
			spawnBlood()
		elif spawnChance <= 0.8 + 0.5:
			spawnBone()
		elif spawnChance <= 0.8 + 0.3 + 0.1:
			spawnSoul()
		
	elif canCollect == true:
		$CollectUI/CollectProgress.value -= 300 * delta
		if $CollectUI/CollectProgress.value < 0:
			$CollectUI/CollectProgress.value = 0
			Spawned = false


func spawnBlood():
	var blood = bloodPath.instance()
	blood.position = self.global_position + Vector2(rand_range(-10, -50), rand_range(10, 50))
	find_parent("Collectables").add_child(blood)
	$CollectUI.hide()
	Spawned = true
	canSpawn = false
	self.queue_free()

func spawnBone():
	var bone = bonePath.instance()
	bone.position = self.global_position + Vector2(rand_range(-10, -50), rand_range(10, 50))
	find_parent("Collectables").add_child(bone)
	$CollectUI.hide()
	Spawned = true
	canSpawn = false
	self.queue_free()

func spawnSoul():
	var soul = soulPath.instance()
	soul.position = self.global_position + Vector2(rand_range(-10, -50), rand_range(10, 50))
	find_parent("Collectables").add_child(soul)
	$CollectUI.hide()
	Spawned = true
	canSpawn = false
	self.queue_free()


func _on_PlayerEnterZone_body_entered(body):
	if body.name == "Character":
		canCollect = true
		$CollectUI.show()


func _on_PlayerEnterZone_body_exited(_body):
	$CollectUI.hide()

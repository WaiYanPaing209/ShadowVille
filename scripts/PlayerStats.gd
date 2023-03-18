extends Node

var STAMINA = 100
var MAX_STAMINA = 100
var MAX_HP = 100
var MAX_MP = 100
var HP = 90
var MP = 50

signal stats_changed
signal health_changed

# Main Stats
var STRENGTH : float = 10
var SANITY = 100
var MAX_SANITY = 100
var INTELLIGENCE : float = 10

# Funtion Determiners
var canShoot = true
var canHeal = true

var baseDamage = 2
var damage 

func _process(_delta):
	pass

func _set_stats(new_strength, new_intelligence):
	STRENGTH = STRENGTH + new_strength
	INTELLIGENCE = INTELLIGENCE + new_intelligence
	MAX_HP += 10 * stepify((STRENGTH/8),0.1)
	MAX_MP += 10 * stepify((INTELLIGENCE/8),0.1)
	
func _ready():
#	_set_stats(STRENGTH,INTELLIGENCE)
	var damageModifier = float(JsonData.item_data["Magic Wand"]["ItemDamageModifier"])
	damage = baseDamage + (baseDamage * damageModifier)


func _healDeterminer():
	if HP >= MAX_HP:
		canHeal = false

func _set_health():
	if HP >= MAX_HP:
		HP = MAX_HP

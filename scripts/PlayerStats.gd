extends Node

<<<<<<< HEAD
# Signals
signal health_changed

var STAMINA = 100
var MAX_STAMINA = 100
var MAX_HP = 1000   #base 1000 
var MAX_MP = 1000 #base 1000
var HP = 800 
var MP = 500

# Game Stats
var PLAYER_LOCATION = Vector2.ZERO

# Energy and Mana Costs
# --- Energy Costs ---
var sprintEnergyCost = 50
var basicAttackEnergyCost = 10

# --- Mana Costs ---
var ghostSpellManaCost = 150

# Main Stats
var STRENGTH: float = 10
var SANITY = 100
var MAX_SANITY = 100
var INTELLIGENCE : float = 10
var ARMOR = 2
var MAX_ARMOR = 99

# Cooldowns
var projectileCooldown = .2
var ghostCooldown = 8
var ghostTick = 0.0
var eldritchBlastCooldown = 12

#Ghostspell Variable
var ghostPosition = Vector2.ZERO
var teleported = false

# Universal Spell Varaibles
var spell_destroyed = false
=======
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
>>>>>>> 975870f479064bc9fd4525c5a97b9aaa4e95f42d

# Funtion Determiners
var canShoot = true
var canHeal = true
<<<<<<< HEAD
var canCast = true

# Basic Melee Attack Damage and Modifiers
var baseDamage = 100
var damage 

=======

var baseDamage = 2
var damage 

func _process(_delta):
	pass
>>>>>>> 975870f479064bc9fd4525c5a97b9aaa4e95f42d

func _set_stats(new_strength, new_intelligence):
	STRENGTH = STRENGTH + new_strength
	INTELLIGENCE = INTELLIGENCE + new_intelligence
<<<<<<< HEAD
	MAX_HP += STRENGTH * 25
	MAX_MP += INTELLIGENCE * 20
	
func _ready():
=======
	MAX_HP += 10 * stepify((STRENGTH/8),0.1)
	MAX_MP += 10 * stepify((INTELLIGENCE/8),0.1)
	
func _ready():
#	_set_stats(STRENGTH,INTELLIGENCE)
>>>>>>> 975870f479064bc9fd4525c5a97b9aaa4e95f42d
	var damageModifier = float(JsonData.item_data["Magic Wand"]["ItemDamageModifier"])
	damage = baseDamage + (baseDamage * damageModifier)


func _healDeterminer():
	if HP >= MAX_HP:
		canHeal = false

<<<<<<< HEAD
func _set_max_health():
	if HP >= MAX_HP:
		HP = MAX_HP
	
func die():
	if HP <= 0:
		HP = 0
		return true
=======
func _set_health():
	if HP >= MAX_HP:
		HP = MAX_HP
>>>>>>> 975870f479064bc9fd4525c5a97b9aaa4e95f42d

extends Node

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

# Funtion Determiners
var canShoot = true
var canHeal = true
var canCast = true

# Basic Melee Attack Damage and Modifiers
var baseDamage = 100
var damage 


func _set_stats(new_strength, new_intelligence):
	STRENGTH = STRENGTH + new_strength
	INTELLIGENCE = INTELLIGENCE + new_intelligence
	MAX_HP += STRENGTH * 25
	MAX_MP += INTELLIGENCE * 20
	
func _ready():
	var damageModifier = float(JsonData.item_data["Magic Wand"]["ItemDamageModifier"])
	damage = baseDamage + (baseDamage * damageModifier)


func _healDeterminer():
	if HP >= MAX_HP:
		canHeal = false

func _set_max_health():
	if HP >= MAX_HP:
		HP = MAX_HP
	
func die():
	if HP <= 0:
		HP = 0
		return true

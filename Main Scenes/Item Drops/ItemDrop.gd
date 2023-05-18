extends KinematicBody2D

const ACCELERATION = 460
const MAX_SPEED = 225
var velocity = Vector2.ZERO
export (String) var item_name

var player = null
var being_picked_up = false

func _ready():
	$Sprite/Label.text = "Pick Up (Z)"
	$Sprite/Label.hide()
	$Sprite/Name.text = item_name
	
func _physics_process(delta):
	if being_picked_up == false:
#		velocity = velocity.move_toward(Vector2(0, MAX_SPEED), ACCELERATION * delta)
		velocity =Vector2.ZERO
	else:
		var direction = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
		
		var distance = global_position.distance_to(player.global_position)
		if distance < 4:
			PlayerInventory.add_item(item_name, 1)
			print(PlayerInventory.inventory)
			queue_free()
	velocity = move_and_slide(velocity, Vector2.UP)

func pick_up_item(body):
	player = body
	being_picked_up = true


func _on_PlayerEnterZone_body_entered(body):
	if body.name == "Character":
		$Sprite/Label.show()


func _on_PlayerEnterZone_body_exited(_body):
	$Sprite/Label.hide()

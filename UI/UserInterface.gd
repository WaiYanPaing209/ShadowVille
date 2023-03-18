extends CanvasLayer
var holding_item = null

func _input(event):
	if event.is_action_pressed("Inventory"):
		$Inventory.visible = !$Inventory.visible
		$Inventory.initialize_inventory()
	
	if event.is_action_pressed("scroll_up"):
		PlayerInventory.active_item_scroll_down()
	elif event.is_action_pressed("scroll_down"):
		PlayerInventory.active_item_scroll_up()

func _process(_delta):
	$StaminaBar.value = PlayerStats.STAMINA
	$MP.text = str(PlayerStats.MP) + " / " + str(PlayerStats.MAX_MP)

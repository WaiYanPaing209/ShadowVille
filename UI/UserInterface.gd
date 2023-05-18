extends CanvasLayer
var holding_item = null

func _ready():
	pass

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
	$HpBar.value = PlayerStats.HP
	$HpBar.value = PlayerStats.HP
	$HpBar.max_value = PlayerStats.MAX_HP
	$mpBar.value = PlayerStats.MP
	$mpBar.max_value = PlayerStats.MAX_MP
	
	$HpBar/Label.text = str(round(PlayerStats.HP)) + " / " + str(PlayerStats.MAX_HP)
	$mpBar/Label.text = str(round(PlayerStats.MP)) + " / " + str(PlayerStats.MAX_MP) 
	$StaminaBar/Label.text = str(round(PlayerStats.STAMINA)) + " / " + str(PlayerStats.MAX_STAMINA)
	
	if PlayerStats.die():
		$DeathUI.show()
	
#	if PlayerStats.HP <= PlayerStats.MAX_MP * .5:
#		$HpBar.set("custom_styles/fg",Color("d2be23"))
#	elif PlayerStats.HP <= PlayerStats.MAX_HP * .25:
#		$HpBar.set("custom_styles/fg",Color("ab1212"))
#	else:
#		$HpBar.set("custom_styles/fg",Color("36a41b"))

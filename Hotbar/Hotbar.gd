extends Node2D

const SlotClass = preload("res://Inventory/Slot/Slot.gd")
<<<<<<< HEAD
const ItemClass = preload("res://Items/Item.gd")

onready var hotbar_slots = $HotbarSlots
onready var active_item_label = $ActiveItemLabel

onready var slots = hotbar_slots.get_children()
onready var item_category
onready var stack_size = 0
=======

onready var hotbar_slots = $HotbarSlots
onready var active_item_label = $ActiveItemLabel
onready var slots = hotbar_slots.get_children()
onready var item_category
onready var stack_size
>>>>>>> 975870f479064bc9fd4525c5a97b9aaa4e95f42d
onready var heal

func _ready():
	print(PlayerInventory.equips)
	
	heal = int(JsonData.item_data["Slime Potion"]["AddHealth"])
	PlayerInventory.connect("active_item_updated", self, "update_active_item_label")
	for i in range(slots.size()):
		PlayerInventory.connect("active_item_updated", slots[i], "refresh_style")
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		slots[i].slotType = SlotClass.SlotType.HOTBAR
		slots[i].slot_index = i
	initialize_hotbar()
	update_active_item_label()

func update_active_item_label():
	if slots[PlayerInventory.active_item_slot].item != null:
		active_item_label.text = slots[PlayerInventory.active_item_slot].item.item_name
	else:
		active_item_label.text = ""

<<<<<<< HEAD

func _process(_delta):
	var inventory = find_parent("UserInterface").find_node("Inventory")
=======
func _process(_delta):
>>>>>>> 975870f479064bc9fd4525c5a97b9aaa4e95f42d
	if slots[PlayerInventory.active_item_slot].item != null:
		item_category = JsonData.item_data[slots[PlayerInventory.active_item_slot].item.item_name]["ItemCategory"]
		var item_name = slots[PlayerInventory.active_item_slot].item.item_name 
		active_item_label.text = item_name
		match item_name:
			"Magic Wand":
<<<<<<< HEAD
				if inventory.visible == false:
					PlayerStats.canShoot = true
				else: 
					PlayerStats.canShoot = false
			"Slime Potion":
				if stack_size == 0:
					stack_size = int(slots[PlayerInventory.active_item_slot].item.item_quantity)
=======
				PlayerStats.canShoot = true
			"Slime Potion":
				stack_size = int(slots[PlayerInventory.active_item_slot].item.item_quantity)
>>>>>>> 975870f479064bc9fd4525c5a97b9aaa4e95f42d
				PlayerStats._healDeterminer()
				if Input.is_action_just_pressed("ui_mouse_right_click") and PlayerStats.canHeal == true:
					if stack_size > 0:
						stack_size -= 1
						print(stack_size)
						PlayerStats.HP += heal
<<<<<<< HEAD
						PlayerStats._set_max_health()
					if stack_size == 0:
						PlayerStats.canHeal = false
=======
						PlayerStats._set_health()
					if stack_size == 0:
>>>>>>> 975870f479064bc9fd4525c5a97b9aaa4e95f42d
						print("gone")
	else:
		PlayerStats.canShoot = false

<<<<<<< HEAD
=======

>>>>>>> 975870f479064bc9fd4525c5a97b9aaa4e95f42d
func initialize_hotbar():
	for i in range(slots.size()):
		if PlayerInventory.hotbar.has(i):
			slots[i].initialize_item(PlayerInventory.hotbar[i][0], PlayerInventory.hotbar[i][1])


<<<<<<< HEAD
=======

>>>>>>> 975870f479064bc9fd4525c5a97b9aaa4e95f42d
func _input(_event):
	if find_parent("UserInterface").holding_item:
		find_parent("UserInterface").holding_item.global_position = get_global_mouse_position()

func slot_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			if find_parent("UserInterface").holding_item != null:
				if !slot.item:
					left_click_empty_slot(slot)
				else:
					if find_parent("UserInterface").holding_item.item_name != slot.item.item_name:
						left_click_different_item(event, slot)
					else:
						left_click_same_item(slot)
						
			elif slot.item:
				left_click_not_holding(slot)
			update_active_item_label()

func left_click_empty_slot(slot: SlotClass):
	PlayerInventory.add_item_to_empty_slot(find_parent("UserInterface").holding_item, slot)
	slot.putIntoSlot(find_parent("UserInterface").holding_item)
	find_parent("UserInterface").holding_item = null
	
func left_click_different_item(event: InputEvent, slot: SlotClass):
	PlayerInventory.remove_item(slot)
	PlayerInventory.add_item_to_empty_slot(find_parent("UserInterface").holding_item, slot)
	var temp_item = slot.item
	slot.pickFromSlot()
	temp_item.global_position = event.global_position
	slot.putIntoSlot(find_parent("UserInterface").holding_item)
	find_parent("UserInterface").holding_item = temp_item

func left_click_same_item(slot: SlotClass):
	stack_size = int(JsonData.item_data[slot.item.item_name]["StackSize"])
	var able_to_add = stack_size - slot.item.item_quantity
	if able_to_add >= find_parent("UserInterface").holding_item.item_quantity:
		PlayerInventory.add_item_quantity(slot, find_parent("UserInterface").holding_item.item_quantity)
		slot.item.add_item_quantity(find_parent("UserInterface").holding_item.item_quantity)
		find_parent("UserInterface").holding_item.queue_free()
		find_parent("UserInterface").holding_item = null
	else:
		PlayerInventory.add_item_quantity(slot, able_to_add)
		slot.item.add_item_quantity(able_to_add)
		find_parent("UserInterface").holding_item.decrease_item_quantity(able_to_add)
		
func left_click_not_holding(slot: SlotClass):
	PlayerInventory.remove_item(slot)
	find_parent("UserInterface").holding_item = slot.item
	slot.pickFromSlot()
	find_parent("UserInterface").holding_item.global_position = get_global_mouse_position()


extends Node

signal active_item_updated

const SlotClass = preload("res://Inventory/Slot/Slot.gd")
const ItemClass = preload("res://Items/Item.gd")


const NUM_INVENTORY_SLOTS = 20
const NUM_HOTBAR_SLOTS = 8

var active_item_slot = 0

func _process(_delta):
	pass

var inventory = {

	0: ["Magic Wand", 1],  #--> slot_index: [item_name, item_quantity]
	1: ["Slime Potion", 11],
	2: ["Slime Potion", 15],
	3: ["Blood", 5],
<<<<<<< HEAD
	4: ["Blood", 6],
	5: ["Tree Branch", 24],
	7: ["Bone", 5]
}

func _ready():
=======
	4: ["Blood", 6]
}

func _ready():
	
>>>>>>> 975870f479064bc9fd4525c5a97b9aaa4e95f42d
	var attribute : Dictionary = JsonData.item_data["Hood"]["Attributes"]
	print(attribute)
	var strength = attribute["Strength"]
	var intelligence = attribute["Intelligence"]
	PlayerStats._set_stats(strength,intelligence)

var hotbar = {
	0: ["Magic Wand", 1],
<<<<<<< HEAD
	3: ["Slime Potion", 6]
=======
	3: ["Slime Potion", 4]
>>>>>>> 975870f479064bc9fd4525c5a97b9aaa4e95f42d
}

var equips = {
	
	0: ["Hood", 1],
	1: ["Chest Robe", 1], 
	2: ["Blue Jeans", 1],  
	3: ["Brown Boots", 1]
}

# TODO: First try to add to hotbar
func add_item(item_name, item_quantity):
	var slot_indices: Array = inventory.keys()
	slot_indices.sort()
	for item in slot_indices:
		if inventory[item][0] == item_name:
			var stack_size = int(JsonData.item_data[item_name]["StackSize"])
			var able_to_add = stack_size - inventory[item][1]
			if able_to_add >= item_quantity:
				inventory[item][1] += item_quantity
				update_slot_visual(item, inventory[item][0], inventory[item][1])
				return
			else:
				inventory[item][1] += able_to_add
				update_slot_visual(item, inventory[item][0], inventory[item][1])
				item_quantity = item_quantity - able_to_add
	
	# item doesn't exist in inventory yet, so add it to an empty slot
	for i in range(NUM_INVENTORY_SLOTS):
		if inventory.has(i) == false:
			inventory[i] = [item_name, item_quantity]
			update_slot_visual(i, inventory[i][0], inventory[i][1])
			return

# TODO: Make compatible with hotbar as well
func update_slot_visual(slot_index, item_name, new_quantity):
	var slot = get_tree().root.get_node("/root/Main/World/UserInterface/Inventory/GridContainer/Slot" + str(slot_index + 1))
	if slot.item != null:
		slot.item.set_item(item_name, new_quantity)
	else:
		slot.initialize_item(item_name, new_quantity)

func remove_item(slot: SlotClass):
	match slot.SlotType:
		SlotClass.SlotType.HOTBAR:
			hotbar.erase(slot.slot_index)
		SlotClass.SlotType.INVENTORY:
			inventory.erase(slot.slot_index)
		_:
			equips.erase(slot.slot_index)

func add_item_to_empty_slot(item: ItemClass, slot: SlotClass):
	match slot.SlotType:
		SlotClass.SlotType.HOTBAR:
			hotbar[slot.slot_index] = [item.item_name, item.item_quantity]
		SlotClass.SlotType.INVENTORY:
			inventory[slot.slot_index] = [item.item_name, item.item_quantity]
		_:
			equips[slot.slot_index] = [item.item_name, item.item_quantity]

func add_item_quantity(slot: SlotClass, quantity_to_add: int):
	match slot.SlotType:
		SlotClass.SlotType.HOTBAR:
			hotbar[slot.slot_index][1] += quantity_to_add
		SlotClass.SlotType.INVENTORY:
			inventory[slot.slot_index][1] += quantity_to_add
#		_:
#			equips[slot.slot_index][1] += quantity_to_add
			
func deduce_item_quantity(slot: SlotClass, quantity_to_deduce: int):
<<<<<<< HEAD
	match slot.SlotType:
		SlotClass.SlotType.HOTBAR:
			var item = hotbar[slot.slot_index]
			item[1] -= quantity_to_deduce
			if item[1] <= 0:
				hotbar.erase(slot.slot_index)
				slot.destroy_item()
			else:
				slot.set_item(item[0], item[1])
		SlotClass.SlotType.INVENTORY:
			var item = inventory[slot.slot_index]
			item[1] -= quantity_to_deduce
			if item[1] <= 0:
				inventory.erase(slot.slot_index)
				slot.destroy_item()
			else:
				slot.set_item(item[0], item[1])
		_:
			var item = equips[slot.slot_index]
			item[1] -= quantity_to_deduce
			if item[1] <= 0:
				equips.erase(slot.slot_index)
				slot.destroy_item()
			else:
				slot.set_item(item[0], item[1])
=======
	match slot.slotType:
		SlotClass.SlotType.HOTBAR:
			hotbar[slot.slot_index][1] -= quantity_to_deduce
		SlotClass.SlotType.INVENTORY:
			inventory[slot.slot_index][1] -= quantity_to_deduce
#		_:
			equips[slot.slot_index][1] -= quantity_to_deduce
>>>>>>> 975870f479064bc9fd4525c5a97b9aaa4e95f42d
###
### Hotbar Related Functions
func active_item_scroll_up():
	active_item_slot = (active_item_slot + 1) % NUM_HOTBAR_SLOTS
	emit_signal("active_item_updated")

func active_item_scroll_down():
	if active_item_slot == 0:
		active_item_slot = NUM_HOTBAR_SLOTS - 1
	else:
		active_item_slot -= 1
	emit_signal("active_item_updated")






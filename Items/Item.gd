extends Node2D

var item_name 
var item_quantity
var item_description

func _ready():
	pass

func set_item(nm, qt):
	item_name = nm
	item_quantity = qt
	$TextureRect.texture = load("res://Items/item_icons/" + item_name + ".png")
	$TextureRect.rect_scale = Vector2(.4,.4)
	$TextureRect.rect_min_size = Vector2(20,20)
	$TextureRect.margin_top = 2
	$TextureRect.expand = true
	var stack_size = int(JsonData.item_data[item_name]["StackSize"])
	item_description = str(JsonData.item_data[item_name]["Description"])
	var cat =  str(JsonData.item_data[item_name]["ItemCategory"])
	$NameTag/Category.text = cat
	$NameTag.text = item_name
	$NameTag.rect_position = Vector2(-10,-10)
#	$Description.text = item_description
	if stack_size == 1:
		$Label.text = String(1)
		$Label.visible = true
		$Label.add_color_override("font_color",Color(0,0,0,0))
<<<<<<< HEAD
		$Label.add_color_override("font_outline_modulate",Color("00000000"))
		$Label.rect_scale = Vector2(.8,.8)
		
	elif stack_size <= 0:
		queue_free()
		
=======
		$Label.rect_scale = Vector2(.8,.8)
>>>>>>> 975870f479064bc9fd4525c5a97b9aaa4e95f42d
	else:
		$Label.visible = true
		$Label.text = String(item_quantity)
		$Label.rect_scale = Vector2(.8,.8)



func add_item_quantity(amount_to_add):
	item_quantity += amount_to_add
	$Label.text = String(item_quantity)
	
func decrease_item_quantity(amount_to_remove):
	item_quantity -= amount_to_remove
	$Label.text = String(item_quantity)


func _on_Label_mouse_entered():
	$NameTag.show()

func _on_Label_mouse_exited():
	$NameTag.hide()

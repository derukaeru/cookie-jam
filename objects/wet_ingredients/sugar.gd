extends TextureRect

var dragging := false
var drag_offset := Vector2()

var min_pos := Vector2(32, 32)
var max_pos := Vector2(1028 - 32, 720 - 32)


func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			raise()
			dragging = event.pressed
			if dragging:
				drag_offset = event.position
	elif event is InputEventMouseMotion and dragging:
		var new_position = global_position + event.relative
		
		new_position.x = clamp(new_position.x, min_pos.x, max_pos.x)
		new_position.y = clamp(new_position.y, min_pos.y, max_pos.y)
		global_position = new_position

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		dragging = false

func raise():
	var parent = get_parent()
	for child in parent.get_children():
		if child is CanvasItem:
			child.z_index = 0 
	self.z_index = 1

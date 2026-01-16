extends Control

var dragging := false
var drag_offset := Vector2()

var min_pos := Vector2(32, 32)
var max_pos := Vector2(1028 - 32, 720 - 32)

var sway_rotation := 0.0
var sway_velocity := 0.0

@export var sway_strength := 0.002
@export var sway_return_speed := 10.0
@export var max_sway := 0.25

var to_pour = false
var pouring = false

func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			if dragging:
				drag_offset = event.position
				var center_x = size.x * 0.5
				var grab_bias = (drag_offset.x - center_x) / center_x
				sway_rotation = sway_rotation + grab_bias * 0.15
				z_index = 1
	elif event is InputEventMouseMotion and dragging:
		var new_position = global_position + event.relative
	
		new_position.x = clamp(new_position.x, min_pos.x, max_pos.x)
		new_position.y = clamp(new_position.y, min_pos.y, max_pos.y)
		global_position = new_position
		
		# horizontal motion affects sway
		sway_velocity += event.relative.x * sway_strength

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		dragging = false
		z_index = 0

func _process(delta):
	# apply velocity
	sway_rotation += sway_velocity
	sway_velocity = lerp(sway_velocity, 0.0, delta * 8.0)
	
	# return to rest
	sway_rotation = lerp(sway_rotation, 0.0, delta * sway_return_speed)
	sway_rotation = clamp(sway_rotation, -max_sway, max_sway)
	
	$TextureRect.rotation = sway_rotation
	
	for area in $butter_area.get_overlapping_areas():
		if area.name == "bowl_area" and not pouring and dragging:
			pouring = true
			$TextureRect/AnimationPlayer.play("to_pour")
			await $TextureRect/AnimationPlayer.animation_finished
			$TextureRect/AnimationPlayer.play("pouring")
		
	if pouring and not dragging:
		pouring = false
		$TextureRect/AnimationPlayer.play_backwards("to_pour")
		await $TextureRect/AnimationPlayer.animation_finished
		$TextureRect/AnimationPlayer.play("RESET")
	
	if pouring:
		pass

func _on_butter_area_area_exited(area):
	if area.name == "bowl_area" and dragging:
		pouring = false
		$TextureRect/AnimationPlayer.play_backwards("to_pour")
		await $TextureRect/AnimationPlayer.animation_finished
		$TextureRect/AnimationPlayer.play("RESET")

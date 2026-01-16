extends Node2D

enum AREAS { COUNTER, OVEN }
var area:AREAS = AREAS.COUNTER

func to_counter():
	if area == AREAS.COUNTER: return
	$Camera2D/ui/to_counter.hide()
	$Camera2D/ui/to_oven.hide()
	$Camera2D/AnimationPlayer.play_backwards("move")
	await $Camera2D/AnimationPlayer.animation_finished
	$Camera2D/ui/to_oven.show()
	area = AREAS.COUNTER
	

func to_oven():
	if area == AREAS.OVEN: return
	$Camera2D/ui/to_oven.hide()
	$Camera2D/ui/to_counter.hide()
	$Camera2D/AnimationPlayer.play("move")
	await $Camera2D/AnimationPlayer.animation_finished
	$Camera2D/ui/to_counter.show()
	area = AREAS.OVEN
	

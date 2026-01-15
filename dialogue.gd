extends Node


var dialog_scene := load("res://addons/dialogue_manager/example_balloon/example_balloon.tscn")
var dres := load("res://dialogues/main.dialogue")
var dialog_open := false
var curr_dialog := ""

func _ready():
	DialogueManager.dialogue_ended.connect(dialog_end)

func change_resource(path):
	dres = load(path)

func dialog(id):
	if not dialog_open:
		var c = G.gn("dialogue_balloon")
		if c == null:
			var d = dialog_scene.instantiate()
			G.gn("camera").get_node("CanvasLayer/dialogue_cover").add_child(d)
		
		G.gn("dialogue_balloon").start(dres, id)
		dialog_open = true
		curr_dialog = id

func dialog_end(id):
	pass

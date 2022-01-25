extends Area2D

onready var fade_class = load("res://Levels/CutsceneTransition.tscn")
onready var cutscene_class = load("res://Levels/MackenzieCutscene1.tscn")
export(String, FILE) var Video = cutscene_class

func _on_MackenziePortal_body_entered(body):
	if body.is_in_group('Player'):
		var fade_scene = fade_class.instance()
		Globals.cutscene = true
		fade_scene.connect("finished",  self, "load_cutscene")
		get_parent().add_child(cutscene_class.instance())
#	if get_stream_positon() >= vid_length - 500:
		
		pass

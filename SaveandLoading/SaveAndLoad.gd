extends Node

var save_path = "user://save.dat"
var room = "res://Brock_Bosses/Bamm/Bamm.tscn"

func _Save():
	var data = {
		"1" : room,
		"2" : "two",
		"3" : "three",
		"4" : "four",
		"5" : "five"
	}
	var file = File.new()
	var error = file.open(save_path,File.WRITE)
	if error == OK: 
		file.store_var(data)
		file.close()
	
func _Load():
	var file = File.new()
	if file.file_exists(save_path):
		var error = file.open(save_path, File.READ)
		if error == OK:
			var player_data = file.get_var()
			file.close()
			room = player_data["1"]
			get_tree().change_scene(room)
			print(player_data["1"])

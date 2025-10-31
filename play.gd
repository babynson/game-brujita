extends Button

# boton jugar 
func _on_play_pressed():
	get_tree().change_scene_to_file("res://Main.tscn")

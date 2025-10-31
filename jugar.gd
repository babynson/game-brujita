extends Button

# boton jugar 
func _on_play_pressed():
	get_tree().change_scene_to_file("res://Main.tscn")

# boton instrucciones
func _on_instruccion_pressed():
	get_tree().change_scene_to_file("res://instrucciones.tscn")

# boton instrucciones
func _on_nivel2_pressed():
	get_tree().change_scene_to_file("res://Main_nivel2.tscn")

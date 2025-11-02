extends Button

# boton jugar 
func _on_play_pressed():
	get_tree().change_scene_to_file("res://Main.tscn")

func _on_empezar_pressed():
	get_tree().change_scene_to_file("res://nivel1.tscn")


# boton instrucciones
func _on_instruccion_pressed():
	get_tree().change_scene_to_file("res://instrucciones.tscn")

# boton instrucciones
func _on_nivel2_pressed():
	get_tree().change_scene_to_file("res://Main_nivel2.tscn")

#Boton salir
func _on_salir_pressed() -> void:
	get_tree().quit()

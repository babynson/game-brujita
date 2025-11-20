extends Area2D

@export var is_good: bool = true
@export var fall_speed: float = 280.0



func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _process(delta: float) -> void:
	position.y += fall_speed * delta
	var vh := get_viewport_rect().size.y
	if position.y > vh + 64.0:
		queue_free()


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		if is_good and body.has_method("add_point"):
			print("atrape-objetobueno")

			# Clasificación del objeto según el nombre de la escena
			if "GoodObject2" in scene_file_path:
				if body.has_method("add_corazon"):
					body.add_corazon()

			elif "GoodObject3" in scene_file_path:
				if body.has_method("add_estrella"):
					body.add_estrella()

			elif "GoodObject1" in scene_file_path:
				if body.has_method("add_botella"):
					body.add_botella()

			elif "GoodObject6" in scene_file_path:
				if body.has_method("add_ojo"):
					body.add_ojo()

			elif "GoodObject5" in scene_file_path:
				if body.has_method("add_caramelo"):
					body.add_caramelo()

			elif "GoodObject4" in scene_file_path:
				if body.has_method("add_botella2"):
					body.add_botella2()

			# sumar punto general
			body.add_point()
			if body.has_method("_check_level_complete"):
				body._check_level_complete()

		
		elif not is_good and body.has_method("lose_life"):
			print("atrepe el malo")
			body.lose_life()

		queue_free()

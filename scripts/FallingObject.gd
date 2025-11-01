
extends Area2D

@export var is_good: bool = true
@export var fall_speed: float = 220.0

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
				# Clasificación del objeto según nombre o tipo
			if "GoodObject2" in scene_file_path:
				body.corazon += 1
				body.item_collected.emit("corazon", body.corazon)
				print("❤️ Sumo un corazón. Total:", body.corazon)
			elif "GoodObject3" in scene_file_path:
				body.estrella += 1
				body.item_collected.emit("estrella", body.estrella)
				print("⭐ Sumo una estrella. Total:", body.estrella)
			elif "GoodObject1" in scene_file_path:
				body.botella += 1
				body.item_collected.emit("botella", body.botella)
				print("🍾 Sumo una botella. Total:", body.botella)
				
			body.add_point()
		elif not is_good and body.has_method("lose_life"):
			print("atrepe el malo")
			body.lose_life()
		queue_free()


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
			body.add_point()
		elif not is_good and body.has_method("lose_life"):
			body.lose_life()
		queue_free()

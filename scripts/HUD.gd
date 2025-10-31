extends Control

# @export var required_goods: int = 5
# @export var speed: float = 280.0
# @export var genial: String = "¡Genial! +1"
# @export var ouch: String = "¡Ouch! -1"

# @onready var message_label: Label = $Message
# @onready var message_label2: Label = $Message2

# var score: int = 0
# var lives: int = 15
# var good_collected: int = 0

var velocity := Vector2.ZERO

signal score_changed(new_score: int)
signal lives_changed(new_lives: int)
signal game_over
signal level_complete
signal good_collected_changed(count: int, total: int)



# func add_point() -> void:
# 	score += 1
# 	score_changed.emit(score)
# 	_show_message(genial)

# func lose_life() -> void:
# 	lives -= 1
# 	lives_changed.emit(lives)
# 	_show_message2(ouch)
# 	if lives <= 0:
# 		game_over.emit()

# func _on_body_entered(body: Node) -> void:
# 	if body.is_in_group("good_objects"):
# 		good_collected += 1
# 		add_point()
# 		body.queue_free()
# 		good_collected_changed.emit(good_collected, required_goods)
# 		if good_collected >= required_goods:
# 			level_complete.emit()

# 	if body.is_in_group("bad_objects"):
# 		lose_life()
# 		body.queue_free()

# func _show_message(text: String) -> void:
# 	if message_label == null: return
# 	message_label.text = text
# 	message_label.visible = true
# 	await get_tree().create_timer(1.1).timeout
# 	message_label.visible = false

# func _show_message2(text: String) -> void:
# 	if message_label2 == null: return
# 	message_label2.text = text
# 	message_label2.visible = true
# 	await get_tree().create_timer(1.1).timeout
# 	message_label2.visible = false

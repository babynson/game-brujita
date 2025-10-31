extends Control

# @export var required_goods: int = 5
# @export var speed: float = 280.0
# @export var genial: String = "¡Genial! +1"
# @export var ouch: String = "¡Ouch! -1"

# @onready var message_label: Label = $Message
# @onready var message_label2: Label = $Message2

var score: int = 0
var lives: int = 15
# var good_collected: int = 0
@onready var score_label: Label = $Margin/Row/Score   # o el path correcto de tu Label
@onready var lives_label: Label = $Margin/Row/Lives   # opcional, si mostrás vidas también

var velocity := Vector2.ZERO

signal lives_changed(new_lives: int)
signal game_over
signal level_complete
signal good_collected_changed(count: int, total: int)

func _ready() -> void:
	# Buscar el nodo del player (usa el grupo que definiste)
	var player := get_tree().get_first_node_in_group("player")
	if player:
		player.score_changed.connect(_on_score_changed)


		# Inicializar labels con valores actuales
		_on_score_changed(player.score)

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

# --- Receptor de la señal de score
func _on_score_changed(new_score: int) -> void:
	score = new_score
	if score_label:
		score_label.text = "Puntos: %d" % score
	print("HUD actualizó el score:", score)

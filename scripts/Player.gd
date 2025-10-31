extends CharacterBody2D

@export var required_goods: int = 5      # cantidad necesaria para pasar de nivel
@export var speed: float = 280.0
@export var genial: String = "¡Genial! +1"  # mensaje para obj buenos 
@export var ouch: String = "¡Ouch! -1"     # mensaje para obj malos

@onready var message_label: Label = $Message
@onready var message_label2: Label = $Message2

var score: int = 0
var lives: int = 5
var good_collected: int = 0

signal score_changed(new_score: int)
signal lives_changed(new_lives: int)
signal game_over
signal level_complete
signal good_collected_changed(count: int, total: int)  # <-- ¡Declarada!

func _ready() -> void:
	add_to_group("player")
	message_label.visible = false
	message_label2.visible = false
	# Emito el estado inicial para que el HUD/Spawner se sincronicen
	good_collected_changed.emit(good_collected, required_goods)

# Movimiento
func _process(delta: float) -> void:
	var dir := 0.0
	if Input.is_action_pressed("ui_right"):
		dir += 1.0
	if Input.is_action_pressed("ui_left"):
		dir -= 1.0
	velocity.x = dir * speed
	move_and_slide()

	# Limitar a pantalla si existe viewport
	var vw := get_viewport_rect().size.x
	position.x = clamp(position.x, 16.0, vw - 16.0)

# Puntos y vidas
func add_point() -> void:
	score += 1
	score_changed.emit(score)
	_show_message(genial)              # Mostrar “¡Genial!” al sumar punto

func lose_life() -> void:
	lives -= 1
	lives_changed.emit(lives)
	_show_message2(ouch)               # Mostrar “¡Ouch!” al tocar malo
	if lives <= 0:
		print("DEBUG: Game Over - emitiendo señal")
		game_over.emit()

# Colisiones
func _on_body_entered(body: Node) -> void:
	# Buenos
	if body.is_in_group("good_objects"):
		good_collected += 1
		add_point()
		body.queue_free()

		# Aviso el progreso del objetivo
		good_collected_changed.emit(good_collected, required_goods)

		# ¿se completó el nivel?
		if good_collected >= required_goods:
			level_complete.emit()

	# Malos
	if body.is_in_group("bad_objects"):
		lose_life()
		body.queue_free()
		# acá podrías también restar puntos si querés

# --- Mensaje 1: usa el Label $Message (buenos)
func _show_message(text: String) -> void:
	message_label.text = text
	message_label.visible = true
	await get_tree().create_timer(1.1).timeout
	message_label.visible = false

# --- Mensaje 2: usa el Label $Message2 (malos)
func _show_message2(text: String) -> void:
	message_label2.text = text
	message_label2.visible = true
	await get_tree().create_tween().tween_property(message_label2, "modulate:a", 1.0, 0.0) # no anim, solo placeholder
	await get_tree().create_timer(1.1).timeout
	message_label2.visible = false

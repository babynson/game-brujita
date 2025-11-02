extends CharacterBody2D

@export var required_goods := 30        # necesarios para pasar de nivel
@export var speed: float = 480.0

@export var genial: String = "¡Bravo! +1"   # mensaje para buenos
@export var ouch: String = "¡buuuu! -1"       # mensaje para malos

@onready var message_label: Label = $Message
@onready var message_label2: Label = $Message2
@onready var audio_player: AudioStreamPlayer2D = AudioStreamPlayer2D.new()

# sonidos
@export var point_sound: AudioStream = preload("res://assets/musi/cach-ok.mp3")
@export var fail_sound: AudioStream  = preload("res://assets/musi/fallo.mp3")
#@export var level_ok_sound: AudioStream = preload("res://assets/musi/level_ok.mp3") # poné el que quieras

@export var tipo := "corazon"  # puede ser "estrella" o "botella"


var score: int = 0
var lives: int = 5
var good_collected: int = 0

var ojo: int=0
var caramelo: int=0
var botella2: int=0

signal item_collected(tipo: String, count: int)  # agrego para recolectar "corazon" | "estrella" | "botella"

signal ojo_changed(new_ojo: int)
signal caramelo_changed(new_caramelo: int)
signal botella2_changed(new_botella2: int)


signal score_changed(new_score: int)
signal lives_changed(new_lives: int)
signal game_over
signal level_complete

func _ready() -> void:
	add_to_group("player")
	add_child(audio_player)
	message_label.visible = false
	message_label2.visible = false

	# IMPORTANTE: conectar la señal del CatchArea (si no la conectaste desde el editor)
	# $CatchArea.area_entered.connect(_on_catch_area_area_entered)

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

func add_point() -> void:
	score += 1
	score_changed.emit(score)
	_show_message(genial)
	_play(point_sound)

func lose_life() -> void:
	lives -= 1
	lives_changed.emit(lives)
	_show_message2(ouch)
	_play(fail_sound)
	if lives <= 0:
		game_over.emit()

# ------- COLISIÓN (con CatchArea.area_entered) -------
func _on_catch_area_area_entered(area: Area2D) -> void:
	# Si el área que entró pertenece a un objeto bueno/malo:
	if area.is_in_group("good_objects"):
	
		print ("agarre objeto-bueno:")		
		add_point()
		good_collected += 1
		area.queue_free()

		if good_collected >= required_goods:
			#_play(level_ok_sound)
			level_complete.emit()

	elif area.is_in_group("bad_objects"):
		print("agarre objeto malo:")	
		lose_life()
		area.queue_free()

# ------- Utilidades visuales/sonoras -------
func _show_message(txt: String) -> void:
	message_label.text = txt
	message_label.visible = true
	await get_tree().create_timer(0.8).timeout
	message_label.visible = false

func _show_message2(txt: String) -> void:
	message_label2.text = txt
	message_label2.visible = true
	await get_tree().create_timer(0.8).timeout
	message_label2.visible = false

func _play(stream: AudioStream) -> void:
	if stream == null:
		return
	audio_player.stream = stream
	audio_player.play()

#chequear nivel completo 
func _check_level_complete() -> void:
	if ojo >= 3 and botella2 >= 2 and caramelo >= 4:
		print("🎉 Nivel completo, pasamos al siguiente!")
		level_complete.emit()   # usa tu señal existente
		

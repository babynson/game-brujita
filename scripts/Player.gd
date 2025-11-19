extends CharacterBody2D

@export var required_goods := 30        # necesarios para pasar de nivel
@export var speed: float = 280.0

@export var genial: String = "¡Genial! +1"   # mensaje para buenos
@export var ouch: String = "¡Ouch! -1"       # mensaje para malos

@onready var message_label: Label = $Message
@onready var message_label2: Label = $Message2
@onready var audio_player: AudioStreamPlayer2D = AudioStreamPlayer2D.new()

# sonidos
@export var point_sound: AudioStream = preload("res://assets/musi/cach-ok.mp3")
@export var fail_sound: AudioStream  = preload("res://assets/musi/fallo.mp3")
#@export var level_ok_sound: AudioStream = preload("res://assets/musi/level_ok.mp3") # poné el que quieras

#@export var tipo := "corazon"  # puede ser "estrella" o "botella"
#@export var tipo := "estrella"  # puede ser "estrella" o "botella"
#@export var tipo := "botella"  # puede ser "estrella" o "botella"
enum TipoObjeto { corazon, ESTRELLA, BOTELLA, OJO, CARAMELO, BOTELLA2 }
@export var tipo: TipoObjeto = TipoObjeto.corazon
@export var corazon_objetivo: int = 3  # máximo permitido 
@export var estrella_objetivo: int = 4 # máximo permitido 
@export var botella_objetivo: int = 2 # máximo permitido 

var score: int = 0
var lives: int = 5
var good_collected: int = 0

var corazon: int=0
var estrella: int=0
var botella: int=0

var ojo: int=0
var caramelo: int=0
var botella2: int=0

signal item_collected(tipo: String, count: int)  # agrego para recolectar "corazon" | "estrella" | "botella"

signal corazon_changed(new_corazon: int)
signal estrella_changed(new_estrella: int)
signal botella_changed(new_botella: int)

signal ojo_changed(new_ojo: int)
signal caramelo_changed(new_caramelo: int)
signal botella2_changed(new_botella2: int)


signal score_changed(new_score: int)
signal lives_changed(new_lives: int)
signal game_over
signal level_complete
signal level2_complete

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
	#_show_message(genial)
	#_play(point_sound)

func lose_life() -> void:
	lives -= 1
	lives_changed.emit(lives)
	_show_message2(ouch)
	_play(fail_sound)
	if lives <= 0:
		game_over.emit()
		
#funcion corazon 
func add_corazon():
	# Todavía no llegué al objetivo → sumo
	if corazon < corazon_objetivo:
		corazon += 1
		emit_signal("corazon_changed", corazon)
		item_collected.emit("corazon", corazon)
		_show_message(genial)
		_play(point_sound)
		print("❤️ Sumo un corazón. Total:", corazon)
	else:
		# Ya llegué al objetivo → pierdo una vida
		print("⚠️ Te pasaste del máximo de corazones, perdés una vida")
		if has_method("lose_life"):
			_show_message2(ouch)
			_play(fail_sound)
			lose_life()  # si ya tenés esta función, mejor reutilizarla
		else:
			lives -= 1
			emit_signal("lives_changed", lives)		

#funcion estrella 
func add_estrella():
	# Todavía no llegué al objetivo → sumo
	if estrella < estrella_objetivo:
		estrella += 1
		emit_signal("estrella_changed", estrella)
		item_collected.emit("estrella", estrella)
		_show_message(genial)
		_play(point_sound)
		print("❤️ Sumo una estrella. Total:", estrella)
	else:
		# Ya llegué al objetivo → pierdo una vida
		print("⚠️ Te pasaste del máximo de estrellas, perdés una vida")
		if has_method("lose_life"):
			_show_message2(ouch)
			_play(fail_sound)
			lose_life()  # si ya tenés esta función, mejor reutilizarla
		else:
			lives -= 1
			emit_signal("lives_changed", lives)		

#funcion botella 
func add_botella():
	# Todavía no llegué al objetivo → sumo
	if botella < botella_objetivo:
		botella += 1
		emit_signal("botella_changed", botella)
		item_collected.emit("botella", botella)
		_show_message(genial)
		_play(point_sound)
		print("❤️ Sumo una botella. Total:", botella)
	else:
		# Ya llegué al objetivo → pierdo una vida
		print("⚠️ Te pasaste del máximo de botellas, perdés una vida")
		if has_method("lose_life"):
			_show_message2(ouch)
			_play(fail_sound)
			lose_life()  # si ya tenés esta función, mejor reutilizarla
		else:
			lives -= 1
			emit_signal("lives_changed", lives)		


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
#func _check_level_complete() -> void:
	#if corazon >= 3 and botella >= 2 and estrella >= 4:
		#print("🎉 Nivel completo, pasamos al siguiente!")
		#level_complete.emit()   # usa tu señal existente
		#
	#elif ojo >= 3 and botella2 >= 2 and caramelo >= 4:
		#print("🎉 2 Nivel2 completo, pasamos al siguiente!")
		#level2_complete.emit()   # usa tu señal existente 	

var nivel_actual := 1

func _check_level_complete() -> void:
	if nivel_actual == 1 and corazon >= 3 and botella >= 2 and estrella >= 4:
		print("🎉 Nivel 1 completo!")
		level_complete.emit()
		nivel_actual = 2

	elif nivel_actual == 2 and ojo >= 3 and botella2 >= 2 and caramelo >= 4:
		print("🎉 Nivel 2 completo!")
		level2_complete.emit()
		nivel_actual = 3

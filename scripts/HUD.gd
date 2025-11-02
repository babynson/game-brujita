extends Control

@onready var score_label: Label = $Margin/Row/Score
@onready var lives_label: Label = $Margin/Row/Lives
@export var nivel_ok_Sound: AudioStream = preload("res://assets/musi/nivel-logrado.mp3")
@onready var audio_player: AudioStreamPlayer = AudioStreamPlayer.new()
#cargo variables para cambiar de escenas 
@export var win_scene: String = "res://win_scene.tscn"
@export var game_over_scene: String = "res://game_over_scene.tscn"

@onready var corazon_label: Label = $Objetos/lista/Corazon
@onready var estrella_label: Label = $Objetos/lista2/Estrella
@onready var botella_label: Label = $Objetos/lista3/Botella
#signal game_over

func _ready() -> void:
	var player := get_tree().get_first_node_in_group("player")
	#sonido
	add_child(audio_player)
	if player:
		player.score_changed.connect(_on_score_changed)
		player.lives_changed.connect(_on_lives_changed)
		player.corazon_changed.connect(_on_corazon_changed)
		player.estrella_changed.connect(_on_estrella_changed)
		player.botella_changed.connect(_on_botella_changed)	
		
		
		player.item_collected.connect(_on_item_collected)
		
		player.game_over.connect(_on_game_over)
		_on_score_changed(player.score)
		_on_lives_changed(player.lives)
		_on_corazon_changed(player.corazon)
		_on_estrella_changed(player.estrella)
		_on_botella_changed(player.botella)
		
		player.level_complete.connect(_on_player_level1_complete)
		#player.level2_complete.connect(_on_player_level2_complete)

func _on_item_collected(tipo: String, count: int) -> void:
	match tipo:
		"corazon":
			corazon_label.text = "Corazones:3/  %d" % count
		"estrella":
			estrella_label.text = "Estrellas:4/ %d" % count
		"botella":
			botella_label.text = "Botellas:2/ %d" % count

func _update_counters(player: Node) -> void:
	if player.has_method("_ready") or true:
		corazon_label.text  = "Corazones:3/ %d" % (player.corazon if "corazon" in player else 0)
		estrella_label.text = "Estrellas:4/ %d" % (player.estrella if "estrella" in player else 0)
		botella_label.text  = "Botellas:2/  %d" % (player.botella if "botella" in player else 0)
					

func _on_corazon_changed(new_corazon: int) -> void:
	corazon_label.text = "Corazones:3/  %d" % new_corazon

func _on_estrella_changed(new_estrella: int) -> void:
	estrella_label.text = "Estrellas:4/ %d" % new_estrella
	
func _on_botella_changed(new_botella: int) -> void:
	botella_label.text = "Botellas:2/  %d" % new_botella	

func _on_score_changed(new_score: int) -> void:
	score_label.text = "Puntos: %d" % new_score

	
	
	#cuadno llego a 2 me manda a cambiar de escena 
	if new_score >= 30:
		audio_player.stream = nivel_ok_Sound
		audio_player.play()
		call_deferred("cambiar_ganaste")

func _on_lives_changed(new_lives: int) -> void:
	lives_label.text = "Vidas: %d" % new_lives
	
	#Cuadno llego a 0 me manda a cambiar de escena
	if new_lives <= 0:
		call_deferred("game_over_scene")

func _on_game_over() -> void:
	call_deferred("cambiar_perdiste")
	
#llama a la escena de gane 
func cambiar_ganaste() -> void:
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file(win_scene)
	
#llama a la escena de perder
func cambiar_perdiste() -> void:
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file(game_over_scene)
	
func _on_good_collected(count: int, total: int):
	$Label.text = "Objetos: %d / %d" % [count, total]

func _on_player_level1_complete():
	get_tree().change_scene_to_file("res://nivel2.tscn")
	
#func _on_player_level2_complete():
		#get_tree().change_scene_to_file("res://win_scene.tscn")

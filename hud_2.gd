extends Control

@onready var score_label: Label = $Margin/Row/Score
@onready var lives_label: Label = $Margin/Row/Lives
@export var nivel_ok_Sound: AudioStream = preload("res://assets/musi/nivel-logrado.mp3")
@onready var audio_player: AudioStreamPlayer = AudioStreamPlayer.new()
#cargo variables para cambiar de escenas 
@export var win_scene: String = "res://win_scene.tscn"
@export var game_over_scene: String = "res://game_over_scene.tscn"

@onready var ojo_label: Label = $Objetos/lista/ojo
@onready var caramelo_label: Label = $Objetos/lista2/caramelo
@onready var botella2_label: Label = $Objetos/lista3/botella2
#signal game_over

func _ready() -> void:
	var player2 := get_tree().get_first_node_in_group("player")
	#sonido
	add_child(audio_player)
	if player2:
		player2.score_changed.connect(_on_score_changed)
		player2.lives_changed.connect(_on_lives_changed)
		player2.ojo_changed.connect(_on_ojo_changed)
		player2.caramelo_changed.connect(_on_caramelo_changed)
		player2.botella2_changed.connect(_on_botella2_changed)	
		
		
		player2.item_collected.connect(_on_item_collected)
		
		player2.game_over.connect(_on_game_over)
		_on_score_changed(player2.score)
		_on_lives_changed(player2.lives)
		_on_ojo_changed(player2.ojo)
		_on_caramelo_changed(player2.caramelo)
		_on_botella2_changed(player2.botella2)
	
		
		player2.level_complete.connect(_on_player2_level2_complete)

func _on_item_collected(tipo: String, count: int) -> void:
	match tipo:
		"ojo":
			ojo_label.text = "3/ %d" % count
		"caramelo":
			caramelo_label.text = "4/ %d" % count
		"botella2":
			botella2_label.text = "2/ %d" % count

func _update_counters(player: Node) -> void:
	if player.has_method("_ready") or true:
		ojo_label.text  = "3/ %d" % (player.ojo if "ojo" in player else 0)
		caramelo_label.text = "4/ %d" % (player.caramelo if "caramelo" in player else 0)
		botella2_label.text  = "2/ %d" % (player.botella2 if "botella2" in player else 0)
					

func _on_ojo_changed(new_ojo: int) -> void:
	ojo_label.text = "3/ %d" % new_ojo

func _on_caramelo_changed(new_caramelo: int) -> void:
	caramelo_label.text = "4/ %d" % new_caramelo
	
func _on_botella2_changed(new_botella2: int) -> void:
	botella2_label.text = "2/ %d" % new_botella2	

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


func _on_player2_level2_complete():
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file("res://win_scene.tscn")

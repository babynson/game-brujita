
extends CharacterBody2D

@export var required_goods := 5  # cantidad necesaria para pasar de nivel
@export var speed: float = 280.0

var score: int = 0
var lives: int = 5
var good_collected:=0

signal score_changed(new_score: int)
signal lives_changed(new_lives: int)
signal game_over
signal level_complete 


func _ready() -> void:
	add_to_group("player")

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
	print("sumovida:")
	print(score)
	score_changed.emit(score)
	

func lose_life() -> void:
	lives -= 1
	lives_changed.emit(lives)
	print("pierdo una vida:")
	print(lives)
	if lives <= 0:
		print("DEBUG: Game Over - emitiendo señal")
		game_over.emit()
		
func _on_body_entered(body):
	if body.is_in_group ("good_objects"):
		good_collected +=1
		body.queue_free()
		
		if good_collected>=required_goods:
			emit_signal("level_complete")
		elif body.is_in_group("bad_objects"):
			body.queue_free()
				#ver aca si se resta puntos para llegar		
	
	

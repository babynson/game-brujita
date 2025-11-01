
extends Node2D
@export var tipo := "corazon"  # puede ser "estrella" o "botella"

@export var good_objects: Array[PackedScene] = [
	preload("res://GoodObject1.tscn"),
	preload("res://GoodObject2.tscn"),
	preload("res://GoodObject3.tscn")
]

@export var bad_objects: Array[PackedScene] = [
	preload("res://BadObject1.tscn"),
	preload("res://BadObject2.tscn")
]

@export var spawn_interval: float = 1.2
@export var spawn_padding: float = 24.0

var rng := RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()
	var timer := Timer.new()
	timer.wait_time = spawn_interval
	timer.one_shot = false
	timer.autostart = true
	add_child(timer)
	timer.timeout.connect(_on_spawn_timeout)

	# NUEVO: escuchar señales del player
	var player := get_tree().get_first_node_in_group("player")
	if player:
		if player.has_signal("level_complete"):
			player.level_complete.connect(_on_level_complete)
		if player.has_signal("good_collected"):
			player.good_collected.connect(_on_good_collected)

func _on_spawn_timeout() -> void:
	var obj_scene: PackedScene = _choose_object()
	if obj_scene == null:
		return
	var obj := obj_scene.instantiate()

	var vw := get_viewport_rect().size.x
	obj.position = Vector2(
		rng.randi_range(int(spawn_padding), int(vw - spawn_padding)),
		-32
	)

	get_tree().current_scene.add_child(obj)

func _choose_object() -> PackedScene:
	if good_objects.is_empty() and bad_objects.is_empty():
		return null
#rango de porcentaje 
	var value := rng.randf()
	if value < 0.7 and not good_objects.is_empty():
		var index := rng.randi_range(0, good_objects.size() - 1)
		print("lanza objetos buenos numero:")
		print(index)
		
		return good_objects[index]
	else:
		if bad_objects.is_empty():
			return null
		var index := rng.randi_range(0, bad_objects.size() - 1)
		print("lanza objeto malo numero:")
		print(index)
		return bad_objects[index]

# NUEVO: handlers
func _on_good_collected(count: int, total: int) -> void:
	#Opcional: debug o lógica adicional
	print("Objetos buenos:", count, "/", total)
	pass

func _on_level_complete() -> void:
	# Frenar el spawner
	for child in get_children():
		if child is Timer:
			child.stop()
			break

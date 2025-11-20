class_name TimerCustom2
extends Node2D

@export var SetMinutos: int = 0
@export var SetSegundos: int = 50

var minutos: int
var segundos: float

signal time_up

func _ready() -> void:
	reset_timer2()

func reset_timer2() -> void:
	minutos = SetMinutos
	segundos = SetSegundos

func _process(delta: float) -> void:
	if minutos <= 0 and segundos <= 0.0:
		emit_signal("time_up")
		return

	segundos -= delta

	if segundos < 0.0:
		if minutos > 0:
			minutos -= 1
			segundos = 59.0
		else:
			segundos = 0.0

func get_time_string() -> String:
	return "%02d:%02d" % [int(minutos), int(segundos)]

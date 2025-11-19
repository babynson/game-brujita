class_name TimerCustom2
extends Node2D

@export var SetMinutos := 0
@export var SetSegundos := 10

var minutos: int
var segundos: float

signal time_up2

func _ready():
	reset_timer2()

func reset_timer2():
	minutos = SetMinutos
	segundos = SetSegundos

func _process(delta2):
	if minutos <= 0 and segundos <= 0:
		emit_signal("time_up2")
		return

	segundos -= delta2

	if segundos < 0:
		if minutos > 0:
			minutos -= 1
			segundos = 59
		else:
			segundos = 0

func get_time_string() -> String:
	return "%02d:%02d" % [int(minutos), int(segundos)]

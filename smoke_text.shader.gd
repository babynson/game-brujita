extends Label

@export var smoke_duration := 1.2
@export var smoke_offset_y := -30.0

var base_position: Vector2

func _ready():
	base_position = position   # guardamos la posición original
	

func smoke_out(new_text: String = ""):
	# si querés cambiar el texto cada vez:
	if new_text != "":
		text = new_text

	# 🔄 REINICIAR ESTADO ANTES DE CADA ANIMACIÓN
	position = base_position
	modulate.a = 1.0

	if material:
		material.set("shader_parameter/dissolve_amount", 0.0)
		material.set("shader_parameter/blur", 0.0)

	# 🌀 TWEEN DE HUMO
	var t := create_tween()

	# subir
	t.tween_property(self, "position:y", base_position.y + smoke_offset_y, smoke_duration)

	# blur + disolver en paralelo
	if material:
		t.parallel().tween_property(material, "shader_parameter/blur", 8.0, smoke_duration)
		t.parallel().tween_property(material, "shader_parameter/dissolve_amount", 1.0, smoke_duration)

	# desvanecer alfa
	t.parallel().tween_property(self, "modulate:a", 0.0, smoke_duration)

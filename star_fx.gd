extends CPUParticles2D
# También sirve si tu nodo es GPUParticles2D:
# extends GPUParticles2D

func _ready() -> void:
	# Emitimos el efecto SOLO cuando esté listo
	emitting = true
	
	# Cuando termina la vida del efecto, lo borramos
	# (lifetime es el tiempo total de las partículas)
	await get_tree().create_timer(lifetime).timeout
	
	queue_free()

extends GPUParticles2D
@onready var sparkle_explosion: GPUParticles2D = $"."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sparkle_explosion.emitting = true
	await get_tree().create_timer(2.0).timeout
	queue_free()

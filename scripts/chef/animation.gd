extends Node2D
var anim_speed_vary = randi_range(7,25)
@onready var anim_outfit: AnimatedSprite2D = $"../AnimOutfit"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim_outfit.speed_scale = float(anim_speed_vary) / 10


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

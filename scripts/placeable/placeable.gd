extends Sprite2D
@export_file("*.png") var selected_texture: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture = load(selected_texture)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

extends Node2D

@onready var hitbox: Area2D = $Hitbox
@onready var target_sprite: AnimatedSprite2D = $TargetSprite
var selected_object = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = get_global_mouse_position()
	if Input.is_action_just_pressed("Mouse1"):
		click()
	target_sprite.visible = false
	if selected_object:
		target_sprite.visible = true
		target_sprite.position = (selected_object.position - global_position) + Vector2(0,-12)

func click():
	if selected_object:
		selected_object.move(global_position)
	selected_object = null
	var collisions = hitbox.get_overlapping_bodies()
	for obj in collisions:
		if obj.name == "Chef":
			selected_object = obj
			break

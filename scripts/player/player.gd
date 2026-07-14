extends Node2D

@onready var hitbox: Area2D = $Hitbox
@onready var target_sprite: AnimatedSprite2D = $TargetSprite
var selected_object = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	global_position = get_global_mouse_position()
	if Input.is_action_just_pressed("Mouse1"):
		select()
	if Input.is_action_just_pressed("Mouse2"):
		place()
	target_sprite.visible = false
	if selected_object:
		target_sprite.visible = true
		target_sprite.position = (selected_object.position - global_position) + Vector2(0,-12) # png offset

func select():
	selected_object = null # Deselect object when no object is found
	var collisions = hitbox.get_overlapping_bodies()
	for obj in collisions:
		if obj.is_in_group("chef"):
			selected_object = obj
			break
		if obj.is_in_group("dish"): # Dish checked after chefs are. To get info about dish
			break
			
func place():
	if selected_object:
		selected_object.give_target(global_position)

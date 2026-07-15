extends Node2D

const TARGET_SPRITE = preload("res://assets/vfx/target_sprite.tscn")
@onready var hitbox: Area2D = $Hitbox
@onready var grid_highlight: AnimatedSprite2D = $GridHighlight
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
	if selected_object:
		if !selected_object.has_node("TargetSprite"):
			var tar = TARGET_SPRITE.instantiate()
			selected_object.add_child(tar)
	calculate_grid_highlight()

func select():
	if selected_object:
		var tar = selected_object.get_node("TargetSprite")
		tar.queue_free()
	selected_object = null # Deselect object when no object is found
	var collisions = hitbox.get_overlapping_bodies()
	for obj in collisions:
		if obj.is_in_group("chef"):
			selected_object = obj
			break
		if obj.is_in_group("dish"): # Dish checked after chefs are. To get info about dish
			print(obj)
			break

func place():
	if selected_object:
		selected_object.give_target(global_position)
		
func calculate_grid_highlight():
	grid_highlight.global_position = global_position.snapped(Vector2(16, 16))
	grid_highlight.global_position += Vector2(8,8) # a crappy offset

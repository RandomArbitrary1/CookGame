extends Node2D

const TARGET_SPRITE = preload("res://assets/vfx/target_sprite.tscn")
@onready var hitbox: Area2D = $Hitbox
@onready var grid_highlight: AnimatedSprite2D = $GridHighlight
@onready var tile_map: TileMapLayer = $"../NavigationRegion2D/TileMapLayer"
var selected_object = null
const SELECTABLE_SPRITE = preload("res://assets/vfx/selectable_sprite.tscn")
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
	var collisions = hitbox.get_overlapping_bodies()
	for obj in collisions:
		if !obj.has_node("SelectableSprite"):
			var tar2 = SELECTABLE_SPRITE.instantiate()
			obj.add_child(tar2)
			break
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
	var collision = hitbox.get_overlapping_areas()
	for obj in collisions:
		if obj.is_in_group("dish"): # Dish checked after chefs are. To get info about dish
			selected_object = obj
			print(obj)
			break

func place():
	if selected_object:
		selected_object.give_target(global_position)
		
func calculate_grid_highlight():
	var cell = tile_map.local_to_map(tile_map.to_local(global_position))
	grid_highlight.global_position = tile_map.to_global(tile_map.map_to_local(cell))

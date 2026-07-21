extends CharacterBody2D
# chef enters gridspot when reached
@onready var nav_agent: NavigationAgent2D = $NavAgent2d
@onready var tile_map: TileMapLayer = $"../NavigationRegion2D/TileMapLayer"
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var check_hitbox: Area2D = $CheckBox
@onready var trash_sfx: AudioStreamPlayer2D = $trash_sfx
@onready var place_sfx: AudioStreamPlayer2D = $place_sfx
@onready var storage_sfx: AudioStreamPlayer2D = $storage_sfx
@onready var cut_sfx: AudioStreamPlayer2D = $cut_sfx
@onready var error_sfx: AudioStreamPlayer2D = $error

@onready var root: Node2D = $".."
const PLACEABLE = preload("res://assets/placeables/placeable.tscn")

var speed = 2000.0
var direction = Vector2(0.0,0.0)
var player = null
var done_following = true
var time_taken_collision = 0.0
var work_state = ""
var held_item = null

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	move_process(delta)
	if !self in player.hitbox.get_overlapping_bodies():
		var nod = get_node_or_null("SelectableSprite")
		if nod:
			nod.queue_free()

func give_target(given_pos):
	var pos = Vector2(int(given_pos[0]),int(given_pos[1]))
	nav_agent.target_position = pos
	var cell = tile_map.local_to_map(tile_map.to_local(pos))
	var tile_data: TileData = tile_map.get_cell_tile_data(cell)
	if !tile_data:
		return
	if tile_data.get_custom_data("tile_type"):
		cell = Vector2(cell[0]+0.5,cell[1]+0.5)
		var cal = cell * 16
		nav_agent.target_position = cal
	done_following = false

func move_process(delta):
	var pos = tile_map.local_to_map(tile_map.to_local(nav_agent.target_position))
	var cell = Vector2(pos[0]+0.5,pos[1]+0.5)
	var cal = cell * 16
	check_hitbox.global_position = cal
	if nav_agent.is_navigation_finished():
		if !done_following:
			action()
			done_following = true
	var next_point = nav_agent.get_next_path_position()
	var dir = (next_point - global_position).normalized()
	velocity = dir * speed * delta
	move_and_slide()
	
func action():
	await get_tree().create_timer(0.1).timeout # to align hitbox, it lags behind sadly
	var pos = tile_map.local_to_map(tile_map.to_local(nav_agent.target_position))
	var tile_data: TileData = tile_map.get_cell_tile_data(pos)
	var tile_sub_data = tile_data.get_custom_data("tile_type")
	
	if tile_sub_data == "oven":
		oven()
	if tile_sub_data == "tray":
		tray()
	if tile_sub_data == "storage": # needs work
		storage_select()
	if tile_sub_data == "counter": # Finished!
		if held_item:
			place(pos) 
		else:
			pick_up(tile_sub_data, pos)
	if tile_sub_data == "cutboard": # Finished, just not nice
		cut(pos)
	if tile_sub_data == "trash": # Finished
		trash()
func tray():
	var texture_path = held_item.texture.resource_path
	var file_name = texture_path.get_file().get_basename()
	if file_name == "pot_tomato":
		pass
func oven():
	if !held_item:
		return
	var texture_path = held_item.texture.resource_path
	var file_name = texture_path.get_file().get_basename()
	if !file_name.begins_with("cut_"):
		return
	var checked_str = file_name.replace("cut_", "")
	var cut_path = "res://assets/placeables/pot_" + checked_str + ".png"
	if ResourceLoader.exists(cut_path):
		held_item.texture = load(cut_path)
func pick_up(item, cell): # pick up ingredients
	if held_item:
		return
	var hits = check_hitbox.get_overlapping_areas()
	var placeable = get_tree().get_nodes_in_group("placeable")
	for obj in hits:
		if obj != check_hitbox:
			if obj != player.hitbox:
				var obj_root = obj.get_parent()
				if obj_root in placeable:
					obj_root.global_position = global_position
					held_item = obj_root
					obj_root.reparent(self)
					place_sfx.play()
					break
func place(pos): # place ingredients
	pos = Vector2(pos[0]+0.5,pos[1]+0.2)
	var cal = pos * 16
	if held_item:
		check_hitbox.global_position = cal
		var hits = check_hitbox.get_overlapping_areas() # all collisions that arent the mouse and checkbox
		for obj in hits:# checks an object that isnt checkbox or playerhitbox
			if obj != check_hitbox:
				if obj != player.hitbox:
					return # returns when an object has been found
		place_sfx.play()
		var item = held_item
		remove_child(item)
		root.add_child(item)
		item.global_position = cal
		held_item = null
	
func cut(pos): # cut and dice ingredients
	if !held_item:
		return
	var texture_path = held_item.texture.resource_path
	var file_name = texture_path.get_file().get_basename()
	var cut_path = "res://assets/placeables/cut_" + file_name + ".png"
	if ResourceLoader.exists(cut_path):
		held_item.texture = load(cut_path)
		cut_sfx.play()
	else:
		error_sfx.play()
func trash():
	if held_item:
		trash_sfx.play()
		held_item.queue_free()
		held_item = null
		
func storage_select():
	if held_item:
		return
	storage_sfx.play()
	var placa = PLACEABLE.instantiate()
	held_item = placa
	add_child(placa)

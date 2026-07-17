extends CharacterBody2D
# chef enters gridspot when reached
@onready var nav_agent: NavigationAgent2D = $NavAgent2d
@onready var tile_map: TileMapLayer = $"../NavigationRegion2D/TileMapLayer"
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var test_audio: AudioStreamPlayer2D = $TestAudio
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
	if tile_data.get_custom_data("tile_type"):
		cell = Vector2(cell[0]+0.5,cell[1]+0.5)
		var cal = cell * 16
		nav_agent.target_position = cal
	done_following = false

func move_process(delta):
	if nav_agent.is_navigation_finished():
		if !done_following:
			action()
			done_following = true
	var next_point = nav_agent.get_next_path_position()
	var dir = (next_point - global_position).normalized()
	velocity = dir * speed * delta
	move_and_slide()
	
func action():
	test_audio.play()
	var cell = tile_map.local_to_map(tile_map.to_local(nav_agent.target_position))
	var tile_data: TileData = tile_map.get_cell_tile_data(cell)
	var tile_sub_data = tile_data.get_custom_data("tile_type")
	if tile_sub_data == "storage":
		pick_up(tile_sub_data)
	if tile_sub_data == "counter":
		if held_item:
			place(cell)
		else:
			pick_up(tile_data)
	if tile_sub_data == "cutboard":
		cut()
	print("I have this: " + str(held_item))

func pick_up(item_string): # pick up ingredients
	if !held_item:
		#held_item = item_string # final result
		held_item = "tomato"
		var placa = PLACEABLE.instantiate()
		add_child(placa)
		print("I HAVE PICKED UP")
func place(cell): # place ingredients
	cell = Vector2(cell[0]+0.5,cell[1]+0.2)
	var cal = cell * 16
	held_item = null
	var placa = get_node_or_null("Placeable")
	if placa:
		placa.queue_free()
		var plac2 = PLACEABLE.instantiate()
		root.add_child(plac2)
		plac2.global_position = cal
	
func cut(): # cut and dice ingredients
	pass

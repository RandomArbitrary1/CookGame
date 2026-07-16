extends CharacterBody2D

@onready var nav_agent: NavigationAgent2D = $NavAgent2d
@onready var tile_map: TileMapLayer = $"../NavigationRegion2D/TileMapLayer"
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
var speed = 2000.0
var direction = Vector2(0.0,0.0)
var player = null
var done_following = true
var time_taken_collision = 0.0

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
	done_following = false

func move_process(delta):
	#var vel = velocity
	if !done_following:
		if !done_following:
			velocity = Vector2.ZERO
			print("I'm done walking, lets see what im gonna do")
			var cell = tile_map.local_to_map(tile_map.to_local(nav_agent.target_position))
			var tile_data: TileData = tile_map.get_cell_tile_data(cell)
			print(tile_data.get_custom_data("tile_type"))
			done_following = true
		return
	var next_point = nav_agent.get_next_path_position()
	var dir = (next_point - global_position).normalized()
	velocity = dir * speed * delta

	move_and_slide()

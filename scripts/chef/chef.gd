extends CharacterBody2D

@onready var nav_agent: NavigationAgent2D = $NavAgent2d
var speed = 2000.0
var direction = Vector2(0.0,0.0)
var player = null

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	move_process(delta)
	if !self in player.hitbox.get_overlapping_bodies():
		var nod = get_node("SelectableSprite")
		if nod:
			nod.queue_free()

func give_target(given_pos):
	var pos = Vector2(int(given_pos[0]),int(given_pos[1]))
	nav_agent.target_position = pos

func move_process(delta):
	var distance = global_position.distance_to(nav_agent.target_position)
	if distance < 2.5:
		velocity = Vector2.ZERO
		#print("I'm done walking")
		return
	var next_point = nav_agent.get_next_path_position()
	var dir = (next_point - global_position).normalized()
	velocity = dir * speed * delta

	move_and_slide()

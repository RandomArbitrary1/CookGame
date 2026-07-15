extends CharacterBody2D

@onready var nav_agent: NavigationAgent2D = $NavAgent2d
var speed = 40.0
var direction = Vector2(0.0,0.0)

func _physics_process(delta: float) -> void:
	var next_point = nav_agent.get_next_path_position()
	var direction = (next_point - global_position).normalized()
	velocity = direction * speed * delta
	
	var distance = global_position.distance_to(nav_agent.target_position)
	if distance < 2.5:
		velocity = Vector2.ZERO
		nav_agent.target_position = Vector2(int(nav_agent.target_position[0]),
		int(nav_agent.target_position[1]))
	move_and_collide(velocity)

func give_target(given_pos):
	var pos = Vector2(int(given_pos[0]),int(given_pos[1]))
	nav_agent.target_position = pos

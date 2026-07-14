extends CharacterBody2D

@onready var target_position = global_position
@onready var nav_agent: NavigationAgent2D = $NavAgent2d
var speed = 40.0
var direction = Vector2(0.0,0.0)

func _physics_process(delta: float) -> void:
	var next_point = nav_agent.get_next_path_position()
	var direction = (next_point - global_position).normalized()
	velocity = direction * speed * delta
	
	var distance = global_position.distance_to(target_position)
	if distance < 2.5:
		velocity = Vector2.ZERO
		
	move_and_collide(velocity)

func give_target(given_pos):
	target_position = given_pos
	nav_agent.target_position = given_pos

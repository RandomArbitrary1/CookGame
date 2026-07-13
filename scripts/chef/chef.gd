extends CharacterBody2D

var speed = 40.0
@onready var target_position = global_position

func _physics_process(delta: float) -> void:
	global_position = global_position.move_toward(target_position, speed * delta)

func move(given_pos):
	target_position = given_pos
	print(given_pos)

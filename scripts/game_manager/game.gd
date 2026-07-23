extends Node2D

@onready var bell_sfx: AudioStreamPlayer = $bell_sfx
@onready var finish_order_sfx: AudioStreamPlayer = $finish_order_sfx

var rand_timer = 1.0
var orders = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_order("pot_tomato")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if len(orders) < 3:
		rand_timer -= delta
	if rand_timer < 0.0:
		add_order("pot_tomato")
		rand_timer = randi_range(15,20)
func add_order(str):
	orders.append(str)
	bell_sfx.play()
	print(orders)
func remove_order(str):
	orders.erase(str)
	print(orders)
	finish_order_sfx.play()

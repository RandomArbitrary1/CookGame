extends BaseButton


func _ready() -> void:
	mouse_entered.connect(func():
		get_node("Outline").visible = true
	)
	mouse_exited.connect(func():
		get_node("Outline").visible = false
		self_modulate = Color(1,1,1)
	)
	button_down.connect(func():
		self_modulate = Color(.6,.6,.6)
	)
	button_up.connect(func():
		self_modulate = Color(1,1,1)
	)

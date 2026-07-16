extends BaseButton

@onready var icon = get_node_or_null("Icon")

func _ready() -> void:
	mouse_entered.connect(func():
		if not disabled:
			get_node("Outline").visible = true
	)
	mouse_exited.connect(func():
		get_node("Outline").visible = false
		self_modulate = Color(1,1,1)
		if icon:
			icon.self_modulate = Color(1,1,1)
	)
	button_down.connect(func():
		self_modulate = Color(.6,.6,.6)
		if icon:
			icon.self_modulate = Color(.6,.6,.6)
	)
	button_up.connect(func():
		self_modulate = Color(1,1,1)
		if icon:
			icon.self_modulate = Color(1,1,1)
	)

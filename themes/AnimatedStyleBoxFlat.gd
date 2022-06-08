extends StyleBoxFlat


const distance: = 1 # Pixels

export var speed: = 1

var node: Control = get_current_item_drawn()
var tween: = node.get_tree().create_tween()

func _init() -> void:
	node.connect("mouse_entered", self, "hover", [true])
	node.connect("mouse_exited", self, "hover", [true])

func hover(start: bool):
	pass

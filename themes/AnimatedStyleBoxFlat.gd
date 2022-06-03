extends StyleBoxFlat


const distance: = 1 # Pixels

export var speed: = 1

var node: Control = get_current_item_drawn()


func _init() -> void:
	node.connect("mouse_entered", self, "hover_start")

func hover_start():
	pass

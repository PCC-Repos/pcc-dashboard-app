tool
extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var tree = $VBoxContainer/Tree
	var root = tree.create_item()
	tree.set_column_title(0, "Protocols")
	var child1 = tree.create_item(root)
	child1.set_text(0, "assets://")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

extends WindowDialog


func _process(_delta):
	rect_size = get_child(1).rect_size  # 0 occupied for TextureRect

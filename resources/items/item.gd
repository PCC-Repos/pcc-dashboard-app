extends MouseButton


var item_name
var item_text
var item_price

onready var item_name_lbl = $VBoxContainer/Name
onready var item_desc_lbl = $VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/ScrollContainer/Description
onready var item_price_lbl = $VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/Price

func _ready():
	item_name_lbl.text = item_name
	item_desc_lbl.text = item_text
	item_price_lbl.text = str(item_price) + " tokens"

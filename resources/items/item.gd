extends MouseButton


var item_name: String
var item_text: String
var item_price: String

onready var item_name_lbl = $"%Name"
onready var item_desc_lbl = $"%Description"
onready var item_price_lbl = $"%Price"

func _ready():
	item_name_lbl.text = item_name
	item_desc_lbl.text = item_text
	item_price_lbl.text = str(item_price) + " tokens"

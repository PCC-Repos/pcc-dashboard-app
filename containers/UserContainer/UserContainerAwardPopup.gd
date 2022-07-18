extends CustomWinDia

onready var name_label = $WD/VB/SC/Body/VB/Name
onready var modifer_label = $WD/VB/SC/Body/VB/Modifier
onready var description_label = $WD/VB/SC/Body/VB/Description
onready var awarded_at_label = $WD/VB/SC/Body/VB/AwardedAt

var _award: PartialAward

func _ready() -> void:
	_award = null


func from_object(award: PartialAward):
	_award = award
	name_label.text = award.name
	modifer_label.text = "Modifier is " + str(award.modifier)
	description_label.bbcode_text = award.description
	#awarded_at_label.text = "Awarded At: " + awarded_at


func _on_copyid_btn_pressed(_button):
	OS.clipboard = _award.id


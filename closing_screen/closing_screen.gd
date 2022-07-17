extends ColorRect


# warning-ignore:unused_signal
signal status_changed

onready var video: = $VideoPlayer
onready var anim_player: = $AnimationPlayer

func _ready():
	pass


# Doing this cause there's no looping property found either in the Video Resource or the `VideoPlayer` Node
func _on_VideoPlayer_finished() -> void:
	video.play()


func close(delete_from_memory: bool):
	yield(video, "finished")
	anim_player.play("Label Stretching Out")
	if delete_from_memory: queue_free(); else: hide()

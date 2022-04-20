extends AudioStreamPlayer


export(Array, AudioStream) var audio_stream_list = []

var index = 0


func _on_AudioStreamRandomPlayer_finished():
	index = (index + 1) % audio_stream_list.size()
	stream = audio_stream_list[index]
	play()


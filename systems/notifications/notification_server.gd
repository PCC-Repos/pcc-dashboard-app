extends Node


var queue = []

enum {
	VERBOSE,
	INFO,
	WARNING,
	ERROR,
	CRITICAL,
}

func push_notification(error, notification_message: String):
	queue.push_back([error, notification_message])

func get_notification():
	return queue.pop_front()

func is_notification_available():
	return not queue.empty()


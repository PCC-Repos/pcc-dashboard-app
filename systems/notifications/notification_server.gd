extends Node


var queue = []

enum ErrorType {
	VERBOSE,
	INFO,
	WARNING,
	ERROR,
	CRITICAL,
}

func push_notification(error, notification_message: String):
	print(error, notification_message)
	queue.push_back([error, notification_message])

func get_notification():
	return queue.pop_front()

func is_notification_available():
	return not queue.empty()

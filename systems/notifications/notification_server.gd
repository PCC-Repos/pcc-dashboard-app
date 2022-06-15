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

func notify_warning(notification_message: String):
	push_notification(WARNING, notification_message)

func notify_info(notification_message: String):
	push_notification(INFO, notification_message)

func notify_error(notification_message: String):
	push_notification(ERROR, notification_message)

func notify_critical(notification_message: String):
	push_notification(CRITICAL, notification_message)

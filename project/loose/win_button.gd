extends Button

func _on_pressed() -> void:
	BasicEvents.retire_request.emit()

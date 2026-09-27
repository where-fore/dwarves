extends Button

func _on_pressed() -> void:
	BasicEvents.dwarf_speed_increase_request.emit()

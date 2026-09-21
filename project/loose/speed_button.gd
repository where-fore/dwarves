extends Button

func _on_pressed() -> void:
	DebugEvents.dwarf_speed_increase_request.emit()

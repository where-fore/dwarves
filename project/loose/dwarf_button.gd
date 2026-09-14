extends Button

func _on_pressed() -> void:
	DebugEvents.dwarf_spawn_request.emit()

extends Button

func _on_pressed() -> void:
	BasicEvents.cheat_resource_increase_request.emit(200)

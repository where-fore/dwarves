extends Button

var allowed_to_spawn_dwarves:bool = true

func _ready() -> void:
	DebugEvents.dwarf_spawn_completed.connect(allow_to_spawn_dwarves)
	DebugEvents.dwarf_spawn_confirmed.connect(disallow_to_spawn_dwarves)

func _on_pressed() -> void:
	if allowed_to_spawn_dwarves:
		DebugEvents.dwarf_spawn_request.emit()

func allow_to_spawn_dwarves() -> void:
	allowed_to_spawn_dwarves = true
	modulate = Color(1,1,1)

func disallow_to_spawn_dwarves() -> void:
	allowed_to_spawn_dwarves = false
	modulate = Color(0.5,0.5,0.5)

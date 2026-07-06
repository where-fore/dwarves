extends Node2D

@export var individual_dwarf:PackedScene

func spawn_a_dwarf() -> void:
	var new_dwarf:Node = individual_dwarf.instantiate()
	add_child(new_dwarf)

func _unhandled_input(event: InputEvent) -> void:
	@warning_ignore("unsafe_property_access")
	if event is InputEventKey and event.pressed:
		@warning_ignore("unsafe_property_access")
		if event.keycode == KEY_1:
			spawn_a_dwarf()

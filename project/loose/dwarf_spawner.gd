extends Node2D

@export var individual_dwarf:PackedScene

var current_speed_level:int = 1

func _ready() -> void:
	DebugEvents.dwarf_spawn_confirmed.connect(spawn_a_dwarf)
	DebugEvents.dwarf_speed_increase_confirmed.connect(increase_dwarf_speed)

func increase_dwarf_speed() -> void:
	current_speed_level += 1

func spawn_a_dwarf() -> void:
	var new_dwarf:Node2D = individual_dwarf.instantiate()
	add_child(new_dwarf)
	
	@warning_ignore("unsafe_method_access")
	new_dwarf.setup(current_speed_level)

#func _unhandled_input(event: InputEvent) -> void:
	#@warning_ignore("unsafe_property_access")
	#if event is InputEventKey and event.pressed:
		#@warning_ignore("unsafe_property_access")
		#if event.keycode == KEY_1:
			#spawn_a_dwarf()

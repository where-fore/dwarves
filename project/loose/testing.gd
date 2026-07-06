extends TileMapLayer

func _input(event: InputEvent) -> void:
	@warning_ignore("unsafe_property_access")
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var global_mouse_position:Vector2 = get_global_mouse_position()
		var mouse_position_on_map:Vector2 = local_to_map(to_local(global_mouse_position))
		erase_cell(mouse_position_on_map)
		set_cells_terrain_connect([mouse_position_on_map], 0, -1, true)

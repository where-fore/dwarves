extends TileMapLayer

func _input(event: InputEvent) -> void:
	@warning_ignore("unsafe_property_access")
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var global_mouse_position:Vector2 = get_global_mouse_position()
		var mouse_position_on_map:Vector2 = local_to_map(to_local(global_mouse_position))
		
		if get_cell_tile_data(mouse_position_on_map):
			var cell_to_check:TileData = get_cell_tile_data(mouse_position_on_map)
			var ore_type:String = cell_to_check.get_custom_data("Ore Type")
			if ore_type:
				print_debug(ore_type)
			else:
				print_debug("no ore type provided")
		else:
			print_debug("no cell")
		
		erase_cell(mouse_position_on_map)

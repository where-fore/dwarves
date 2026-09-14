extends TileMapLayer
class_name StoneLayer

signal map_updated

#func _input(event: InputEvent) -> void:
	#@warning_ignore("unsafe_property_access")
	#if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		#var global_mouse_position:Vector2 = get_global_mouse_position()
		#var mouse_position_on_map:Vector2 = local_to_map(to_local(global_mouse_position))
		#destroy_cell(mouse_position_on_map)

func destroy_cell(at_location:Vector2) -> void:
	DebugEvents.remove_tile_at.emit(at_location)
	erase_cell(at_location)
	set_cells_terrain_connect([at_location], 0, -1, true)
	map_updated.emit()

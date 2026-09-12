extends TileMapLayer

const gold_id:Vector2i = Vector2i(3,0)
const diamond_id:Vector2i = Vector2i(4,0)
const coal_id:Vector2i = Vector2i(13,0)

func _ready() -> void:
	randomize_spawn()

func randomize_spawn() -> void:
	var width:int = 29
	var height:int = 16
	
	for x in width:
		for y in height:
			
			#cut out a central block for the spawn
			if x >= 12 and x <= 17 and y >= 5 and y <= 11: continue
			
			var coords:Vector2i = Vector2i(x,y)
			var chance_to_spawn:int = 20
			if randi_range(1,100) <= chance_to_spawn:
				var rolled_ore:int = randi_range(1,3)
				var rolled_coords:Vector2i
				match rolled_ore:
					1: rolled_coords = gold_id
					2: rolled_coords = diamond_id
					3: rolled_coords = coal_id
				
				self.set_cell(coords, 0, rolled_coords)

func _input(event: InputEvent) -> void:
	@warning_ignore("unsafe_property_access")
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var global_mouse_position:Vector2 = get_global_mouse_position()
		var mouse_position_on_map:Vector2 = local_to_map(to_local(global_mouse_position))
		print_debug(mouse_position_on_map)
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

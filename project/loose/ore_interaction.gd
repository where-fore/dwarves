extends TileMapLayer

const gold_id:Vector2i = Vector2i(3,0)
const diamond_id:Vector2i = Vector2i(4,0)
const coal_id:Vector2i = Vector2i(13,0)

var gold_value:int = 50
var diamond_value:int = 100
var coal_value:int = 10

func _ready() -> void:
	randomize_spawn()
	DebugEvents.remove_tile_at.connect(destroy_cell)

func randomize_spawn() -> void:
	var width:int = 29
	var height:int = 16
	
	for x in width:
		for y in height:
			
			#cut out a central block for the spawn
			if x >= 12 and x <= 17 and y >= 5 and y <= 11: continue
			
			var coords:Vector2i = Vector2i(x,y)
			var chance_to_spawn:int = 30
			if randi_range(1,100) <= chance_to_spawn:
				var rolled_ore:int = randi_range(1,3)
				var rolled_coords:Vector2i
				match rolled_ore:
					1: rolled_coords = gold_id
					2: rolled_coords = diamond_id
					3: rolled_coords = coal_id
				
				self.set_cell(coords, 0, rolled_coords)


func destroy_cell(at_location:Vector2) -> void:
	if get_cell_tile_data(at_location):
		var cell_to_check:TileData = get_cell_tile_data(at_location)
		var ore_type:String = cell_to_check.get_custom_data("Ore Type")
		if ore_type:
			#print_debug(ore_type)
			var score_gained:int
			match ore_type:
				"Gold": score_gained = gold_value
				"Diamond": score_gained = diamond_value
				"Coal": score_gained = coal_value
			UiEvents.score_change_additive.emit(score_gained)
		else:
			push_error("no ore type provided by this cell at: ", at_location)
		erase_cell(at_location)
	else:
		#print_debug("no cell at that location on this layer")
		pass

#func _input(event: InputEvent) -> void:
	#@warning_ignore("unsafe_property_access")
	#if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		#var global_mouse_position:Vector2 = get_global_mouse_position()
		#var mouse_position_on_map:Vector2 = local_to_map(to_local(global_mouse_position))
		#if get_cell_tile_data(mouse_position_on_map):
			#var cell_to_check:TileData = get_cell_tile_data(mouse_position_on_map)
			#var ore_type:String = cell_to_check.get_custom_data("Ore Type")
			#if ore_type:
				##print_debug(ore_type)
				#pass
			#else:
				##print_debug("no ore type provided")
				#pass
		#else:
			##print_debug("no cell")
			#pass
		#
		##erase_cell(mouse_position_on_map)

extends NavigationRegion2D

@onready var foreground_stone:TileMapLayer = $ForegroundStone
@onready var foreground_minerals:TileMapLayer = $AuxiliaryMinerals

func _ready() -> void:
	@warning_ignore("unsafe_property_access", "unsafe_method_access")
	foreground_stone.map_updated.connect(remap_navigation)

func remap_navigation() -> void:
	#print_debug("rebaking navigation")
	bake_navigation_polygon()

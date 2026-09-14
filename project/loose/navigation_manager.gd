extends NavigationRegion2D

@onready var foreground_stone:StoneLayer = $ForegroundStone
@onready var foreground_minerals:TileMapLayer = $AuxiliaryMinerals

func _ready() -> void:
	foreground_stone.map_updated.connect(remap_navigation)

func remap_navigation() -> void:
	#print_debug("rebaking navigation")
	bake_navigation_polygon()

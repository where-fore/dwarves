extends CharacterBody2D

@onready var navigation_agent_2d:NavigationAgent2D = $NavigationAgent2D
@export var mining_detection_raycasts:Array[RayCast2D]
@export var name_label:Label
@export var name_label_positioner:Node2D
@export var selection_highlight_parent:Node2D
@export var grabbed_highlight_parent:Node2D

var speed:float = 50.0

var spawn_in_animation_timer:float = 1.5
var active:bool = false
var grabbed_by_mouse:bool = false

var follow_cursor:bool = false

var redirect_cooldown_reset:float = 12
var redirect_cooldown:float = 0

var mining_cooldown_reset:float = 1.5
var mining_cooldown:float = 0

var rotation_when_grabbed_cooldown_reset:float = 0.025
var rotation_when_grabbed_cooldown:float = 0

var current_movement_goal:Vector2i

var speed_level_multiplier:float = 1.25

var grabbed_scale_factor:float = 1.5

func _ready() -> void:
	selection_highlight_parent.visible = false
	grabbed_highlight_parent.visible = false
	scale = Vector2.ZERO
	
	spawn_in_animation()
	
	generate_name()
	
	BasicEvents.dwarf_speed_increase_confirmed.connect(increase_speed_by)

func setup(speed_levels_to_start_with:int) -> void:
	increase_speed_by(speed_levels_to_start_with)

func _physics_process(delta: float) -> void:
	if active:
		redirect_cooldown -= delta
		mining_cooldown -= delta
		rotation_when_grabbed_cooldown -= delta
		process_mining()
		process_movement()

func process_mining() -> void:
	if grabbed_by_mouse: return
	
	if mining_cooldown <= 0:
		for raycast:RayCast2D in mining_detection_raycasts:
			if raycast.is_colliding():
				var detection_point:Vector2 = raycast.get_collision_point()
				
				if raycast.get_collider() is StoneLayer:
					var tilemap_detected:StoneLayer = raycast.get_collider()
					var point_position_on_map:Vector2i = tilemap_detected.local_to_map(tilemap_detected.to_local(detection_point))
					if tilemap_detected.get_cell_tile_data(point_position_on_map):
						var cell_to_check:TileData = tilemap_detected.get_cell_tile_data(point_position_on_map)
						var is_mineable:bool = cell_to_check.get_custom_data("Is Mineable")
						if is_mineable:
							if mining_cooldown <= 0:
								mining_cooldown = mining_cooldown_reset
								tilemap_detected.destroy_cell(point_position_on_map)
								#process_movement()


func process_movement() -> void:
	if grabbed_by_mouse:
		global_position = global_position.lerp(get_global_mouse_position(), 0.2)
		if rotation_when_grabbed_cooldown <= 0:
			rotation_degrees = randi_range(0,360) # okay this is probably a bit too fast
			name_label_positioner.global_rotation = 0
			rotation_when_grabbed_cooldown = rotation_when_grabbed_cooldown_reset
		return
	
	if redirect_cooldown <= 0:
		redirect_cooldown = redirect_cooldown_reset
		set_movement_goal()

	if not current_movement_goal: set_movement_goal()
	if current_movement_goal.distance_to(global_position) <= 20: set_movement_goal()
	navigation_agent_2d.target_position = current_movement_goal
	var next_path_position:Vector2 = navigation_agent_2d.get_next_path_position()
	var new_velocity:Vector2 = global_position.direction_to(next_path_position)
	
	velocity = new_velocity * speed
	if velocity.length() > 0:
		rotation = velocity.angle()
		name_label_positioner.global_rotation = 0
	move_and_slide()

func set_movement_goal() -> void:
	var direction_vertical:float = [-1, -0.5, 0, 0.5, 1].pick_random()
	var direction_horizontal:float = [-1, -0.5, 0, 0.5, 1].pick_random()
	if direction_vertical == 0 and direction_horizontal == 0:
		var decision:int = [0,1].pick_random()
		match decision:
			0: direction_horizontal = 1
			1: direction_vertical = 1
	var direction:Vector2 = Vector2(direction_vertical, direction_horizontal) * 350
	current_movement_goal = Vector2i(global_position) + Vector2i(direction)

func spawn_in_animation() -> void:
	var tween:Tween = create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1,1), spawn_in_animation_timer)
	await tween.finished
	BasicEvents.dwarf_spawn_completed.emit()
	active = true

func generate_name() -> void:
	name_label.text = DwarfNames.make_dwarf_name()

func increase_speed_by(levels:int = 1) -> void:
	speed *= levels * speed_level_multiplier
	mining_cooldown_reset /= levels * speed_level_multiplier


func _on_mouse_entered() -> void:
	if not grabbed_by_mouse:
		selection_highlight_parent.visible = true

func _on_mouse_exited() -> void:
	selection_highlight_parent.visible = false

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		toggle_mouse_grab()

func toggle_mouse_grab() -> void:
	grabbed_by_mouse = !grabbed_by_mouse
	
	if grabbed_by_mouse:
		selection_highlight_parent.visible = false
		grabbed_highlight_parent.visible = true
		scale *= grabbed_scale_factor
	
	elif not grabbed_by_mouse:
		grabbed_highlight_parent.visible = false
		scale /= grabbed_scale_factor
		
		redirect_cooldown = 0

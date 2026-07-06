extends CharacterBody2D

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

var speed:float = 50.0

func _physics_process(_delta: float) -> void:
	navigation_agent_2d.target_position = get_global_mouse_position()
	var next_path_position:Vector2 = navigation_agent_2d.get_next_path_position()
	var new_velocity:Vector2 = global_position.direction_to(next_path_position)
	
	velocity = new_velocity * speed
	move_and_slide()

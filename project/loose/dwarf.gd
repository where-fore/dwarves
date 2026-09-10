extends CharacterBody2D

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

var speed:float = 50.0

var spawn_in_animation_timer:float = 1.5
var active:bool

func _ready() -> void:
	active = false
	scale = Vector2.ZERO
	
	spawn_in_animation()

func _physics_process(_delta: float) -> void:
	if active:
		navigation_agent_2d.target_position = get_global_mouse_position()
		var next_path_position:Vector2 = navigation_agent_2d.get_next_path_position()
		var new_velocity:Vector2 = global_position.direction_to(next_path_position)
		
		velocity = new_velocity * speed
		move_and_slide()

func spawn_in_animation() -> void:
	var tween:Tween = create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1,1), spawn_in_animation_timer)
	await tween.finished
	active = true

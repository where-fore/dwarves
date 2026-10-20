extends Label

@export var kerblam_particles_scenes:Array[PackedScene]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	BasicEvents.retire_confirmed.connect(show_label)
	visibility_changed.connect(kerblam_particles)

func show_label() -> void:
	visible = true

func kerblam_particles() -> void:
	if visible == true:
		var particles_to_spawn:int = 100
		while particles_to_spawn > 0:
			@warning_ignore("unsafe_method_access", "unsafe_cast")
			var new_explosion:CPUParticles2D = kerblam_particles_scenes.pick_random().instantiate() as CPUParticles2D
			@warning_ignore("narrowing_conversion")
			new_explosion.global_position.x = randi_range(0,get_viewport().get_visible_rect().end.x)
			@warning_ignore("narrowing_conversion")
			new_explosion.global_position.y = randi_range(0,get_viewport().get_visible_rect().end.y)
			add_child(new_explosion)
			
			particles_to_spawn -= 1

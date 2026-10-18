extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	BasicEvents.retire_confirmed.connect(show_label)

func show_label() -> void:
	visible = true

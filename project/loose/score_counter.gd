extends Label

var base_label_string:String = "Richness: "

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UiEvents.score_change_additive.connect(change_score_additive)
	DebugEvents.dwarf_spawn_request.connect(spend_score_to_spawn_dwarf)
	DebugEvents.dwarf_speed_increase_request.connect(spend_score_to_increase_speed)
	self.text = base_label_string + str(0)
	change_score_additive(100)

func change_score_additive(value:int) -> void:
	var current_score:int = get_score_from_label_text()
	var new_score:int = current_score + value
	self.text = base_label_string + str(new_score)

func spend_score_to_spawn_dwarf() -> void:
	var current_score:int = get_score_from_label_text()
	if current_score >= 50:
		change_score_additive(-50)
		DebugEvents.dwarf_spawn_confirmed.emit()

func spend_score_to_increase_speed() -> void:
	var current_score:int = get_score_from_label_text()
	if current_score >= 100:
		change_score_additive(-100)
		DebugEvents.dwarf_speed_increase_confirmed.emit()

func get_score_from_label_text() -> int:
	var regex_for_number:RegEx = RegEx.create_from_string(r"\d+")
	return regex_for_number.search(self.text).get_string().to_int()
	

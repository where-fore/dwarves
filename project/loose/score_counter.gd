extends Label

var base_label_string:String = "Richness: "

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UiEvents.score_change_additive.connect(change_score_additive)
	self.text = base_label_string + str(0)

func change_score_additive(value:int) -> void:
	var regex_for_number:RegEx = RegEx.create_from_string(r"\d+")
	var current_score:int = regex_for_number.search(self.text).get_string().to_int()
	var new_score:int = current_score + value
	self.text = base_label_string + str(new_score)

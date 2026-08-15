extends RigidBody3D

var story_dialogue = 0
var relationship_dialogue = 0

func load_dialogue():
	$"../character".set_meta("current_action","speaking")

func _process(delta: float) -> void:
	pass

func _on_interactor_starter_investigate_request(id) -> void:
	if id == $".".get_meta("name"):
		pass

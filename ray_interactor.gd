extends RayCast3D

var characters = ["maizono","kuwada"]

signal investigate_request(character_id)

func _process(delta: float) -> void:
	if $".".is_colliding():
		for pers in characters:
			if $".".get_collider().has_meta("name"):
				if $".".get_collider().get_meta("name") == pers:
					$"../cursor/investigate_segment".visible = true
					investigate_request.emit(pers)
			else:
				return
	else:
		$"../cursor/investigate_segment".visible = false

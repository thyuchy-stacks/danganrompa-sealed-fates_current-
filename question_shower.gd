extends Node3D

var mode = "button"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(3.9).timeout
	$".".visible = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("free_move"):
		var slide = get_tree().create_tween()
		if mode == "button":
			$button.visible = false
			slide.tween_property($question_box,"position",Vector3($question_box.position.x - 2,$question_box.position.y, $question_box.position.z),0.2)
			mode = "info"
		elif mode == "info":
			slide.tween_property($question_box,"position",Vector3($question_box.position.x + 2,$question_box.position.y, $question_box.position.z),0.2)
			await get_tree().create_timer(0.2).timeout
			$button.visible = true
			mode = "button"

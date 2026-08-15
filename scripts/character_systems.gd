extends RigidBody3D

var gravity = 5
const speed = 0.1
var dialogue_advance = -1
var debug = 0

var dialogues = ["The doors were stuck and 
only 5 of us were outside.", "The killer is the one 
who was in the bathroom.", "Lets start determining 
allibis."]

func _physics_process(delta: float) -> void:
	$".".position.y -= gravity * delta
	var movement_int := Input.get_vector("left","right","forward","back")
	var forward_dir = $world_camera.global_transform.basis.z * movement_int.y
	var side_dir = $world_camera.global_transform.basis.x * movement_int.x
	var direction = (forward_dir + side_dir).normalized()
	if direction:
		$".".position.x += direction.x * speed
		$".".position.z += direction.z * speed
	if Input.is_action_pressed("camera_left"):
		$".".rotate_y(0.1)
	if Input.is_action_pressed("camera_right"):
		$".".rotate_y(-0.1)
	if Input.is_action_just_pressed("debug_tool"):
		debug  += 1
		if debug == 1:
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
			$cursor.visible = true
			$text_ui.visible = false
		elif debug == 2:
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
			$cursor.visible = false
			$text_ui.visible = true
			debug = 0
func _on_body_entered(body: Node) -> void:
	if body:
		gravity = 0
		print(body.name)
		print(gravity)
	else:
		print(body.name)

func _on_body_exited(body: Node) -> void:
	if body.get_meta("type") == "slope":
		gravity = 5


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("next") and dialogue_advance < dialogues.size() - 1:
		var sentence = ""
		dialogue_advance += 1
		for letter in dialogues[dialogue_advance]:
			sentence = sentence + letter
			$text_ui/dialogue.text = sentence
			await  get_tree().create_timer(0.01).timeout

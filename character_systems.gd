extends RigidBody3D

var gravity = 5
const speed = 0.1
var dialogue_advance = -1
var debug = 0
var debug_2 = 0
var cursor_mode = "hallway"
var line_max = 4
var set_free_move = false
var mouse_pos_2d
var mouse_sensistivity = 0.005
var mouse_input: Vector2
var Player_control: Vector2
var movement_int : Vector2

func player_movement(buffer):
	$".".position.y -= gravity * buffer
	var forward_dir = $world_camera.global_transform.basis.z * movement_int.y
	var side_dir = $world_camera.global_transform.basis.x * movement_int.x
	var direction = (forward_dir + side_dir).normalized()
	$".".set_meta("Cam_dir", $test_cube.global_position)
	if direction:
		$".".position.x += direction.x * speed
		$".".position.z += direction.z * speed
	if Input.is_action_pressed("camera_left"):
		$".".rotate_y(0.1)
	if Input.is_action_pressed("camera_right"):
		$".".rotate_y(-0.1)

func ui_shift(cursor_toggle,texbox_toggle,option_box_toggle,present_give_toggle):
	$cursor.visible = cursor_toggle
	match cursor_toggle:
		true:
			$cursor.process_mode = Node.PROCESS_MODE_INHERIT
		false: 
			$cursor.process_mode = Node.PROCESS_MODE_DISABLED
	$text_ui.visible = texbox_toggle
	match texbox_toggle:
		true:
			$text_ui.process_mode = Node.PROCESS_MODE_INHERIT
		false: 
			$text_ui.process_mode = Node.PROCESS_MODE_DISABLED
	$options.visible = option_box_toggle
	match option_box_toggle:
		true:
			$options.process_mode = Node.PROCESS_MODE_INHERIT
		false: 
			$options.process_mode = Node.PROCESS_MODE_DISABLED
	match present_give_toggle:
		true:
			$inventory.process_mode = Node.PROCESS_MODE_INHERIT
		false: 
			$inventory.process_mode = Node.PROCESS_MODE_DISABLED
	$inventory.visible = present_give_toggle

func mode_shift():
		match $".".get_meta("current_action"):
			"investigate":
				cursor_mode = "hallway"
				movement_int = Input.get_vector("left","right","forward","back")
				ui_shift(true,false,false,false)
			"speaking":
				cursor_mode = "room"
				ui_shift(false,true,false,false)
			"progress":
				ui_shift(false,true,false,false)
			"decide":
				ui_shift(false,true,true,false)
			"gifting":
				ui_shift(false,false,false,true)

func cursor_mode_shift(mode):
	match mode:
		"hallway":
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			$".".rotation.y = mouse_input.x
		"room":
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and cursor_mode == "hallway":
		mouse_input.x += -event.screen_relative.x * mouse_sensistivity


func _process(delta):
	pass

func _physics_process(delta: float) -> void:
	player_movement(delta)
	mode_shift()
	cursor_mode_shift(cursor_mode)

func _on_body_exited(body: Node) -> void:
	if body.get_meta("type") == "slope":
		gravity = 5

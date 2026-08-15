extends Sprite3D

var depth = 1.0
var mouse_pos_2d
var mouse_pos_3d 

func _ready() -> void:
	
	mouse_pos_2d = get_viewport().get_mouse_position()
	mouse_pos_3d = $"../world_camera".project_position(mouse_pos_2d, depth)

func _process(delta: float) -> void:
	mouse_pos_2d = get_viewport().get_mouse_position()
	mouse_pos_3d = $"../world_camera".project_position(mouse_pos_2d, depth)
	global_position = mouse_pos_3d
	

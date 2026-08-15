extends Camera3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("next"):
		calculate_mouse_3d()

func calculate_mouse_3d():
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_lenth = 1000
	var from = project_ray_origin(mouse_pos)
	var to = from + project_local_ray_normal(mouse_pos) * ray_lenth
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	var raycast_result = space.intersect_ray(ray_query)
	print(raycast_result)

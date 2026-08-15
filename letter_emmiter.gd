extends Sprite3D

var word_  
var cut_word = []
var start = false
var current_letter = 0
var word_lenth = 0
var letter_object_holder_instances: Array[Sprite3D] = []
var all_letters = []
var pool_of_letters = -1
var direction_list = ["left","right"]
var letter_holder_instances 

func letter_count():
	for chars in word_:
		if not all_letters.has(chars) and chars != "_":
			all_letters.append(chars)
			pool_of_letters += 1
		else:
			pass

func letter_object_appear():
	randomize() 
	var luck = randi_range(0,pool_of_letters)
	var time_rng = randi_range(3,6)
	self.find_child("spawn_time").wait_time = time_rng
	var clone = self.duplicate()
	self.get_parent().get_parent().find_child("rng_letters").add_child(clone)
	clone.name = "letter_apearance"
	clone.visible = true
	clone.get_child(0).text = all_letters[luck]
	clone.get_child(2).get_child(0).disabled = false
	clone.position = self.position
	letter_object_holder_instances.append(clone)

func letter_object_collect(speed,delta):
	for clone in letter_object_holder_instances:
		if clone.get_meta("direction") == "left":
			clone.position += Vector3(-speed * delta,0,0)
		elif clone.get_meta("direction") == "right":
			clone.position += Vector3(speed * delta,0,0)
		if clone.position.x <= -2.5 or clone.position.x >= 2.5:
			clone.queue_free()
			letter_object_holder_instances.erase(clone)

func spawn_action():
	letter_object_appear()

func detection_cursor_3d():
	var mouse_pos := get_viewport().get_mouse_position()
	var camera := get_viewport().get_camera_3d()
	var world_pos := camera.project_position(mouse_pos, 10.0)
	$"../../mc/cursor_3d".global_position = Vector3(world_pos.x,world_pos.y,0)

func cutting_word():
	for letter in word_.split():
		if letter == "_":
			pass
		else:
			cut_word.append(letter)
	cut_word.append("")

func _ready() -> void:
	word_ = $"../../letters".get_meta("word")
	cutting_word()
	for letter in cut_word:
		word_lenth += 1
	letter_holder_instances = $"../../letters".get_meta("letters_ui")
	$"../../mc".start_minigame.connect(minigame_starter)
	letter_count()
	self.get_child(1).timeout.connect(spawn_action)

func minigame_starter():
	start = true

func _process(delta: float) -> void:
	if current_letter == word_lenth -1:
		for rng_letter in $"../../rng_letters".get_children():
			rng_letter.queue_free()
		$"../../letters".set_meta("completed_minigame",true)
	else:
		letter_object_collect(0.5,delta)

func _physics_process(delta: float) -> void:
	if delta:
		detection_cursor_3d()

func _on_cursor_3d_area_entered(area: Area3D) -> void:
	var clone = area.get_parent()
	if area.get_parent().get_child(0).text == cut_word[current_letter]:
		letter_holder_instances[current_letter].get_child(1).visible = true
		letter_holder_instances[current_letter].get_child(1).modulate.a = 1
		if current_letter < word_lenth:
			current_letter += 1
		print(current_letter)
	var disapear = get_tree().create_tween()
	disapear.tween_property(clone,"modulate:a",0,0.1)
	await get_tree().create_timer(0.1).timeout
	letter_object_holder_instances.erase(clone)
	if clone:
		clone.queue_free()

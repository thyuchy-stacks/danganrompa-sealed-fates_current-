extends Sprite3D

var word_ = "SECRET_ROOM"
var start = false
var current_letter = 0
var letter_found = false
var letter_object_holder_instances: Array[Sprite3D] = []
var all_letters = []
var pool_of_letters = -1
var direction_list = ["left","right"]

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
	var time_rng = randi_range(2,3)
	self.get_parent().get_child(1).wait_time = time_rng
	var clone = self.duplicate()
	self.get_parent().add_child(clone)
	clone.visible = true
	clone.get_child(0).text = all_letters[luck]
	clone.position = self.position
	letter_object_holder_instances.append(clone)

func letter_object_collect():
	for clone in letter_object_holder_instances:
		if clone.get_meta("direction") == "left":
			clone.position += Vector3(-0.01,0,0)
		elif clone.get_meta("direction") == "right":
			clone.position += Vector3(0.01,0,0)
		if clone.position.x <= -1.2 or clone.position.x >= 1.2:
			clone.queue_free()
			letter_object_holder_instances.erase(clone)
			print("deleted")
	if letter_found == true:
		current_letter += 1

func _ready() -> void:
	$"../../mc".start_minigame.connect(minigame_starter)
	letter_count()

func minigame_starter():
	start = true

func _on_spawn_time_timeout() -> void:
	if start == true:
		letter_object_appear()

func _on_movement_time_timeout() -> void:
	if start == true:
		letter_object_collect()

extends AnimatedSprite3D

var question
var word_ 
var current_letter = 0
var letter_word 
var letter_holder_instances 
signal start_minigame()

func play_end_minigame():
	pass

func word_scene_generate():
	for letter in letter_word.size():
		if letter_word[letter] == "_":
			pass
		else:
			var clone = $"../letters/letter_holder".duplicate()
			$"../letters".add_child(clone)
			clone.position = Vector3(-1.1+ (0.12 * letter),2.94,0.589)
			clone.visible = false
			clone.name = "letter_holder_clone_" + str(letter)
			clone.get_child(1).text = letter_word[letter]
			clone.get_child(1).visible = false
			clone.get_child(1).modulate.a = 0
			letter_holder_instances.append(clone)

func minigame_animation():
	$"../box".visible = false
	$"../box/text_box".visible = false
	$"../bar".visible = false
	var zoom = get_tree().create_tween()
	zoom.tween_property($"../mc_camera","fov",80,1.5)
	await get_tree().create_timer(1.5).timeout
	$"../bar".visible = true
	var bar = get_tree().create_tween()
	bar.set_parallel()
	bar.tween_property($"../bar","position",Vector3(0.576,3.357,0.8),0.2)
	await get_tree().create_timer(0.2).timeout
	$"../box".visible = true
	$"../box/text_box".visible = true
	$"../bar".visible = false
	var spawn = get_tree().create_tween()
	spawn.set_parallel()
	spawn.tween_property($"../mc_camera","fov",70,1.5)
	spawn.tween_property($"../box","modulate:a",0.8,0.1)
	spawn.tween_property($"../box","position",Vector3(-0.4,3.317,0.8),1.5)
	spawn.tween_property($"../box/text_box","modulate:a",1,0.1)
	await get_tree().create_timer(1.5).timeout
	var exit = get_tree().create_tween()
	exit.set_parallel()
	exit.tween_property($"../box","position",Vector3(3,3.317,0.8),0.6)
	await get_tree().create_timer(0.6).timeout
	$"../box".visible = false
	$"../box/text_box".visible = false
	$"../bar".visible = false
	var minigame = get_tree().create_tween()
	minigame.set_parallel()
	minigame.tween_property($".","modulate",Color(),0.2)
	minigame.tween_property($"../map","modulate:a",1,0.2)
	minigame.tween_property($".","modulate:a",0.7,0.1)
	for letter in letter_holder_instances.size():
		var minigame_2 = get_tree().create_tween()
		letter_holder_instances[letter].visible = true
		minigame_2.tween_property(letter_holder_instances[letter],"modulate:a",1,0.1)
		await get_tree().create_timer(0.1).timeout
	start_minigame.emit()

func _ready() -> void:
	$"../question/question_box/question_text".text = $"../letters".get_meta("quesion")
	question = $"../letters".get_meta("quesion")
	word_ = $"../letters".get_meta("word")
	letter_word = word_.split("")
	print(letter_holder_instances)
	letter_holder_instances = $"../letters".get_meta("letters_ui")
	word_scene_generate()
	minigame_animation()

func _process(delta: float) -> void:
	if $"../letters".get_meta("completed_minigame") == true:
		play_end_minigame()

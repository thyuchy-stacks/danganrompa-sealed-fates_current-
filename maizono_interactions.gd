extends RigidBody3D
var story_dialogue = -1
var relationship_status = 0
var start_dialogue = false
var pause = false
var stop = ""
var loaded_dialogue = ""
var max_relationship = 6
var how_many_lines = 0
var original_tran 
var states = ["smile","idle","concerned","down","silent_idle","down_concerend","happy","inspired","defensive","annoyed","terrified","enraged","sad_glance","concerned_glance","fear_look","fear_down","curious"]
var maizono_daily_life = "res://assets/art/dialogue/maizono_dialogue/"
var files = DirAccess.get_files_at(maizono_daily_life)
var decide_interact_trigger = "Should I spend some time with Sayaka"
var give_present_trigger = "Would you like to give Sayaka a present?"
var negative_response = ["Sayaka Maizono","Oh alright, see you later."]
var gift_responses = ["Sayaka Maizono","Goodbye Makoto."]
var mc_name = ["Makoto Naegi.","Makoto Naegi"]
var mc_name_thought = "Makoto Naegi."
var given_gift
var mc_visible = false

func letter_writer(text,origin,trigger_end):
	pause = true
	if trigger_end == true:
		$"../character".set_meta("current_action","progress")
	var current_text = ""
	for chars in text:
		current_text += chars
		origin.text = current_text
		await get_tree().create_timer(0.01).timeout
	if trigger_end == true:
		await get_tree().create_timer(0.8).timeout
		stop = "stopped_dialogue"
	if pause == true:
		pause = false

func _ready() -> void:
	original_tran = %speaking_maizono.global_transform


func load_daily_life_animation(original,clone,speak_clone,character,clone_new_origin,inventory_item):
	var time_1 = 0.2
	var time_2 = 0.5
	Globals.bounce_effect(original,time_1,time_2,original.global_position,1.5)
	await get_tree().create_timer(time_1 + time_2).timeout
	for i in range(10):
		clone.modulate.a -= 0.1
		await get_tree().create_timer(0.01).timeout
	clone.visible = false
	Globals.border_effect($"../character/cover0",$"../character/cover_1",true)
	await get_tree().create_timer(0.05).timeout
	speak_clone.modulate.a = 0
	speak_clone.visible = true
	speak_clone.reparent(character)
	speak_clone.global_transform = clone_new_origin.global_transform
	speak_clone.global_transform.origin.y += 1
	for i in range(10):
		speak_clone.modulate.a += 0.1
		await get_tree().create_timer(0.01).timeout
	await get_tree().create_timer(1).timeout

func exit_daily_life_animation(clone,speak_clone):
	for i in range(10):
		speak_clone.modulate.a -= 0.1
		await get_tree().create_timer(0.01).timeout
	speak_clone.reparent($".")
	speak_clone.visible = false
	speak_clone.global_transform = original_tran
	clone.visible = true
	Globals.border_effect($"../character/cover0",$"../character/cover_1",false)
	for i in range(10):
		clone.modulate.a += 0.1
		await get_tree().create_timer(0.01).timeout

func load_dialogue(character,clone,original,speaking_clone,new_origin,text_box,name_box,option_1,option_2,inventory_item,body):
	for file in files:
		if file == files[relationship_status]:
			var text_file = FileAccess.open(maizono_daily_life + file,FileAccess.READ)
			loaded_dialogue = text_file.get_as_text()
			while not text_file.eof_reached():
				text_file.get_line()
				how_many_lines += 1
			text_file.close()
	var lines = loaded_dialogue.split("\n")
	load_daily_life_animation(original,clone,speaking_clone,character,new_origin,inventory_item)
	await  get_tree().create_timer(1).timeout
	character.set_meta("current_action","speaking")
	full_dialogue_cycle(character,lines,text_box,name_box,%speaking_maizono)

func end_dialogue(character,textbox,cloned,speaking_clone,completed_dialogue):
	stop = ""
	start_dialogue = false
	character.set_meta("current_action","investigate")
	textbox.text = ""
	loaded_dialogue = ""
	story_dialogue = -1
	how_many_lines = 0
	option_selection = 0
	if completed_dialogue == true:
		relationship_status += 1
	exit_daily_life_animation(cloned,speaking_clone)
var animation_buffer = false
var option_selection = 0

func matcher(option_1,option_2):
	
	var slider = get_tree().create_tween()
	match  option_selection:
		1:
			slider.tween_property(option_1, "position",Vector3(option_1.position.x + 2,option_1.position.y,option_1.position.z),0.1)
			slider.tween_property(option_2, "position",Vector3(0,option_2.position.y,option_2.position.z),0.1)
			slider.tween_property(option_1, "modulate", Color("#ffff00"), 0.1)
			slider.tween_property(option_2, "modulate", Color("#3d3a39"), 0.1)
		2:
			slider.tween_property(option_1, "position",Vector3(0,option_1.position.y,option_1.position.z),0.1)
			slider.tween_property(option_2, "position",Vector3(option_2.position.x + 2,option_2.position.y,option_2.position.z),0.1)
			slider.tween_property(option_2, "modulate", Color("#ffff00"), 0.1)
			slider.tween_property(option_1, "modulate", Color("#3d3a39"), 0.1)
			option_selection = 0

func letter_color(lines_resource,textbox,namebox):
	match  lines_resource:
		"Makoto Naegi.":
			textbox.modulate = Color("00ddf0")
		"":
			textbox.modulate = Color("00cc20ff")
		_:
			textbox.modulate = Color("ffffffff")

func should_I_speak(option_1,option_2,ani_buffer,box,namebox,character,lines,body): 
	$"../character/options/option_1/option_1_text".text = "Spend some time with Sayaka"
	$"../character/options/option_2/options_2_text".text = "Go see who else is around"
	$"../character/text_ui/dialogue".modulate = Color("00ddf0")
	namebox.text = ""
	if ani_buffer == false:
		animation_buffer = true
		var slide = get_tree().create_tween()
		option_1.position.x = 25.0
		option_2.position.x = 25.0
		slide.tween_property(option_1, "position",Vector3(option_1.position.x - 25.0,option_1.position.y,option_1.position.z),0.1)
		slide.tween_property(option_2, "position",Vector3(option_2.position.x - 25.0,option_2.position.y,option_2.position.z),0.1)
	if Input.is_action_just_pressed("forward"):
		match option_selection:
			0: option_selection = 1
			1: option_selection = 2
		matcher(option_1,option_2)
	if Input.is_action_just_pressed("back"):
		match option_selection:
			1: option_selection = 2
			0: option_selection = 1
		matcher(option_1,option_2)
	if Input.is_action_just_pressed("next"):
		match option_selection:
			1: 
				if option_1.modulate == Color("#ffff00") and character.get_meta("current_action") == "decide":
					character.set_meta("current_action","speaking")
					story_dialogue += 1
					namebox.text = lines[story_dialogue]
					story_dialogue += 1
					change_sprite_maizono(lines,body)
					story_dialogue += 1
					story_dialogue += 1
					letter_color(lines[story_dialogue],$"../character/text_ui/dialogue",$"../character/text_ui/name_ui/name")
					letter_writer(lines[story_dialogue],box,false)
					animation_buffer = false
			0: 
				if option_2.modulate == Color("#ffff00") and character.get_meta("current_action") == "decide":
					character.set_meta("current_action","speaking")
					namebox.text = negative_response[0]
					animation_buffer = false
					letter_color(negative_response[0],$"../character/text_ui/dialogue",$"../character/text_ui/name_ui/name")
					letter_writer(negative_response[1],box,true)
		option_1.modulate = Color("#3d3a39")
		option_1.position.x = 0
		option_2.modulate = Color("#3d3a39")
		option_2.position.x = 0

func inventory(inventory_of_items,character,max_Line,textbox,name_box,old_lines,body):
	var base_start = 0
	var all_pos = []
	var count_x = 0
	var understeps = 0
	var position_of_select = Vector2(0,0)
	var standard_repos = 0.3
	var clone_start = Vector2(-0.5,0.6)
	var decided_item = false
	var target = Vector3(clone_start.x + standard_repos * position_of_select.x,clone_start.y + standard_repos * position_of_select.y,0.43)
	inventory_of_items.position.y = -1
	var slide = get_tree().create_tween()
	slide.tween_property(inventory_of_items, "position",Vector3(inventory_of_items.position.x,inventory_of_items.position.y + 1.5,inventory_of_items.position.z),0.3)
	for items in character.get_meta("list_of_gifts"):
		var clone = $"../character/inventory/item_ui".duplicate()
		clone.visible = true
		var clone_Name = clone.get_child(0)
		inventory_of_items.add_child(clone)
		clone_Name.text = items[0]
		clone.name = "clone_item_ui"
		if count_x >= max_Line:
			understeps += 1
			count_x = 0
		clone.position.y = clone_start.y - standard_repos * understeps
		clone.position.x = clone_start.x + (standard_repos * count_x)
		all_pos.push_back(clone.position)
		count_x += 1
	while decided_item == false:
		if Input.is_action_pressed("left"):
			if position_of_select.x > base_start:
				position_of_select.x -= 1
				print(position_of_select)
		if Input.is_action_pressed("right"):
			if position_of_select.x < max_Line - 1:
				position_of_select.x += 1
				print(position_of_select)
		if Input.is_action_pressed("forward"):
			if position_of_select.y > base_start:
				position_of_select.y -= 1
				print(position_of_select)
		if Input.is_action_pressed("back"):
			if position_of_select.y < understeps:
				position_of_select.y += 1
				print(position_of_select)
		target = Vector3(clone_start.x + standard_repos * position_of_select.x,clone_start.y - standard_repos * position_of_select.y,0.43)
		for ui in inventory_of_items.get_children():
				if not ui.name == 'UI':
					if ui.position.is_equal_approx(target):
						ui.modulate = Color.YELLOW
						if Input.is_action_pressed("give_present"):
							for pos in range(all_pos.size()):
								if all_pos[pos] == ui.position:
									given_gift = character.get_meta("list_of_gifts")[pos]
									print(given_gift)
									decided_item = true
									gift_response(character,textbox,name_box,body)
					elif ui.name.contains("clone_item_ui"):
						ui.modulate = Color("#7a7a7a")
		await get_tree().create_timer(0.1).timeout

func gift_response(character,textbox,name_box,body):
	var maizono_responses = "res://assets/art/dialogue/maizono_dialogue/maizono_item_responces.txt"
	var response_list = FileAccess.open(maizono_responses, FileAccess.READ)
	var contents = response_list.get_as_text()
	var lines = contents.split("\n")
	for type in Globals.object_types:
		if type == given_gift[1]:
			name_box.text = lines[0]
			letter_color(lines,textbox,name_box)
			match type:
				"music": 
					letter_writer(lines[1],textbox,false)
					character.set_meta("current_action","progress")
					body.frame = 6
				"food": 
					letter_writer(lines[2],textbox,false)
					character.set_meta("current_action","progress")
					body.frame = 13
				"tool": 
					letter_writer(lines[3],textbox,false)
					character.set_meta("current_action","progress")
					body.frame = 5
				"entertainment": 
					letter_writer(lines[4],textbox,false)
					character.set_meta("current_action","progress")
					body.frame = 12
				"clothing": 
					letter_writer(lines[5],textbox,false)
					character.set_meta("current_action","progress")
					body.frame = 0
				"trinket": 
					letter_writer(lines[6],textbox,false)
					character.set_meta("current_action","progress")
					body.frame = 16
				"special":
					letter_writer(lines[7],textbox,false)
					body.frame = 11

func screenflash():
	const effect = preload("res://assets/art/flash.jpg")
	var body = Sprite3D.new()
	body.texture = effect
	$"../character".add_child(body)
	body.position.y += 0.5
	body.modulate.a = 0
	var switch_transition = create_tween()
	switch_transition.tween_property(body,"modulate:a",1,0.1)
	switch_transition.tween_property(body,"modulate:a",0,0.1)

func sprite_effect(lines,sprite,state,flash):
	var switch_transition = create_tween()
	switch_transition.tween_property(sprite,"modulate:a", 0.0,0.1)
	sprite.frame = state
	if flash == true:
		screenflash()
	switch_transition.tween_property(sprite,"modulate:a", 1, 0.1)

func change_sprite_maizono(lines,sprite):
	for state in states.size():
		if states[state] == lines[story_dialogue]:
			if state == 0:
				sprite_effect(lines,sprite,state,false)
			elif state == 8:
				sprite_effect(lines,sprite,state,false)
			elif state == 11:
				sprite_effect(lines,sprite,state,true)
			else:
				sprite_effect(lines,sprite,state,false)

func give_present(character,option_1,option_2,namebox,box,inventory_of_items,textbox,name_box,old_lines,body):
	if character.get_meta("current_action") == "speaking":
		character.set_meta("current_action","decide")
	if animation_buffer == false and character.get_meta("current_action") == "decide":
		$"../character/options/option_1/option_1_text".text = "Yes,definitely"
		$"../character/options/option_2/options_2_text".text = "Not really, no"
		animation_buffer = true
		var slide = get_tree().create_tween()
		option_1.position.x = 25.0
		option_2.position.x = 25.0
		slide.tween_property(option_1, "position",Vector3(option_1.position.x - 25.0,option_1.position.y,option_1.position.z),0.1)
		slide.tween_property(option_2, "position",Vector3(option_2.position.x - 25.0,option_2.position.y,option_2.position.z),0.1)
	if Input.is_action_just_pressed("forward"):
		match option_selection:
			0: option_selection = 1
			1: option_selection = 2
		matcher(option_1,option_2)
	if Input.is_action_just_pressed("back"):
		match option_selection:
			1: option_selection = 2
			0: option_selection = 1
		matcher(option_1,option_2)
	if Input.is_action_just_pressed("next") or Input.is_action_just_pressed("interact_with_object"):
		match option_selection:
			1: 
				if option_1.modulate == Color("#ffff00") and character.get_meta("current_action") == "decide":
					animation_buffer = false
					character.set_meta("current_action","gifting")
					inventory(inventory_of_items,character,4,textbox,name_box,old_lines,body)
			0: 
				if option_2.modulate == Color("#ffff00")  and character.get_meta("current_action") == "decide":
					character.set_meta("current_action","speaking")
					namebox.text = gift_responses[0]
					letter_color(gift_responses[0],$"../character/text_ui/dialogue",$"../character/text_ui/name_ui/name")
					letter_writer(gift_responses[1],box,true)
					animation_buffer = false
					relationship_status += 1
		option_1.modulate = Color("#3d3a39")
		option_1.position.x = 0
		option_2.modulate = Color("#3d3a39")
		option_2.position.x = 0

func border_adjust(talk_sprite,mc_sprite,cover_1,cover_2,text):
	if text == "duo":
		mc_visible = true
		var speed = 0.2
		var slider = get_tree().create_tween()
		slider.set_parallel()
		slider.tween_property(talk_sprite, "position",Vector3(talk_sprite.position.x - 0.7,talk_sprite.position.y,talk_sprite.position.z),speed)
		slider.tween_property(mc_sprite, "position",Vector3(mc_sprite.position.x - 1.8,mc_sprite.position.y,mc_sprite.position.z),speed)
		slider.tween_property(cover_2, "position",Vector3(cover_2.position.x + 0.5,cover_2.position.y,cover_2.position.z),speed)
		get_tree().create_tween().tween_property(cover_2, "rotation", Vector3(deg_to_rad(0), deg_to_rad(0), deg_to_rad(12)), speed)
		slider.tween_property(cover_1, "position",Vector3(cover_1.position.x - 1.5,cover_1.position.y,cover_1.position.z),speed)
		get_tree().create_tween().tween_property(cover_1, "rotation", Vector3(deg_to_rad(0), deg_to_rad(0), deg_to_rad(12)), speed)
	elif text == "mono":
		mc_visible = true
		var speed = 0.2
		var slider = get_tree().create_tween()
		slider.set_parallel()
		slider.tween_property(talk_sprite, "position",Vector3(talk_sprite.position.x + 0.7,talk_sprite.position.y,talk_sprite.position.z),speed)
		slider.tween_property(mc_sprite, "position",Vector3(mc_sprite.position.x + 1.8,mc_sprite.position.y,mc_sprite.position.z),speed)
		slider.tween_property(cover_2, "position",Vector3(cover_2.position.x - 0.5,cover_2.position.y,cover_2.position.z),speed)
		get_tree().create_tween().tween_property(cover_2, "rotation", Vector3(deg_to_rad(0), deg_to_rad(0), deg_to_rad(0)), speed)
		slider.tween_property(cover_1, "position",Vector3(cover_1.position.x + 1.5,cover_1.position.y,cover_1.position.z),speed)
		get_tree().create_tween().tween_property(cover_1, "rotation", Vector3(deg_to_rad(0), deg_to_rad(0), deg_to_rad(0)), speed)
	else:
		pass

func change_mc_sprite(mc_sprite,lines,mc_states):
	if mc_visible == true:
		mc_sprite.visible = true
		for state in mc_states.size():
			print(mc_states[state])
			if mc_states[state] == lines:
				sprite_effect(lines,mc_sprite,state,false)

func full_dialogue_cycle(character,lines_resource,textbox,name_box,body_of_character):
	if character.get_meta("current_action") == "speaking" or character.get_meta("current_action") == "progress":
		if story_dialogue < lines_resource.size() - 1:
			story_dialogue += 1
			letter_color(lines_resource[story_dialogue],$"../character/text_ui/dialogue",$"../character/text_ui/name_ui/name")
			print(lines_resource[story_dialogue])
			name_box.text = lines_resource[story_dialogue]
		if story_dialogue < lines_resource.size() -1 :
			story_dialogue += 1
			border_adjust(body_of_character,$"../character/mc_sprites",$"../character/cover0",$"../character/cover_1",lines_resource[story_dialogue])
		if story_dialogue < lines_resource.size() -1:
			if lines_resource[story_dialogue] == mc_name[0]:
				$"../character/text_ui/name_ui/name".text = mc_name[1]
			story_dialogue += 1
			change_sprite_maizono(lines_resource,body_of_character)
			change_mc_sprite($"../character/mc_sprites",lines_resource[story_dialogue],$"../character/mc_sprites".get_meta("states"))
		if story_dialogue < lines_resource.size() -1 :
			story_dialogue += 1
			letter_writer(lines_resource[story_dialogue],textbox,false)

func advance_dialogue(character,lines_resource,textbox,name_box,option_1,option_2,inventory_item,automatic,body_of_character):
	if Input.is_action_just_pressed("next") and pause == false:
		full_dialogue_cycle(character,lines_resource,textbox,name_box,body_of_character)
	if  story_dialogue == lines_resource.size() - 1:
		stop = "dialogue_complete"
	if stop == "dialogue_complete":
		end_dialogue($"../character",$"../character/text_ui/dialogue",$maizono,%speaking_maizono,true)
	elif stop == "stopped_dialogue":
		end_dialogue($"../character",$"../character/text_ui/dialogue",$maizono,%speaking_maizono,false)
	match lines_resource[story_dialogue]:
		decide_interact_trigger:
			if character.get_meta("current_action") == "speaking":
				character.set_meta("current_action","decide")
			if character.get_meta("current_action") == "decide":
				animation_buffer = false
				should_I_speak(option_1,option_2,animation_buffer,textbox,name_box,character,lines_resource,body_of_character)
				
		give_present_trigger:
			if character.get_meta("current_action") == "speaking":
				character.set_meta("current_action","decide")
			if character.get_meta("current_action") == "decide":
				animation_buffer = false
				give_present(character,option_1,option_2,name_box,textbox,inventory_item,textbox,name_box,lines_resource,body_of_character)

func dialogue_sequence(character):
	var lines
	if start_dialogue == true:
		lines = loaded_dialogue.split("\n")
		advance_dialogue(character,lines,$"../character/text_ui/dialogue",$"../character/text_ui/name_ui/name",$"../character/options/option_1",$"../character/options/option_2",$"../character/inventory",false,%speaking_maizono)

func _process(delta: float) -> void:
	var flat_target_position = Vector3($"../character".global_position.x, $".".global_position.y, $"../character".global_position.z)
	$maizono.look_at($"../character".get_meta("Cam_dir"),Vector3.UP)
	dialogue_sequence($"../character")

func _on_interactor_starter_investigate_request(id) -> void:
	if id == $".".get_meta("name"):
		if Input.is_action_just_pressed("interact_with_object"):
			if start_dialogue == false:
				load_dialogue($"../character",$maizono,$".",%speaking_maizono,$"../character/character_representation",$"../character/text_ui/dialogue",$"../character/text_ui/name_ui/name",$"../character/options/option_1",$"../character/options/option_2",$"../character/inventory",%speaking_maizono)
				start_dialogue = true

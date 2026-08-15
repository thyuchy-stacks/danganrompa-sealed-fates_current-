extends RigidBody3D

var object_types = ["music",
"food",
"tool",
"entertainment",
"clothing",
"trinket",
"special"
]

func border_effect(option_1,option_2,flow):
	var rate = 1.5
	var rate_2 = 1.7
	if flow == true:
		option_1.modulate.a = 0
		option_1.modulate.a = 0
		option_1.visible = true
		option_2.visible = true
		var appear = get_tree().create_tween()
		var scroll = get_tree().create_tween()
		appear.set_parallel()
		appear.tween_property(option_1, "modulate:a", 1.0, 0.5)
		appear.tween_property(option_2, "modulate:a", 1.0, 0.5)
		scroll.set_parallel()
		scroll.tween_property(option_1, "position",Vector3(option_1.position.x + rate,option_1.position.y,option_1.position.z),0.2).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN)
		scroll.tween_property(option_2, "position",Vector3(option_2.position.x - rate_2,option_2.position.y,option_2.position.z),0.2).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN)
	elif flow == false:
		var scroll = get_tree().create_tween()
		scroll.set_parallel()
		scroll.tween_property(option_1, "position",Vector3(option_1.position.x - rate,option_1.position.y,option_1.position.z),0.2).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN)
		scroll.tween_property(option_2, "position",Vector3(option_2.position.x + rate_2,option_2.position.y,option_2.position.z),0.2).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN)
		await get_tree().create_timer(0.2).timeout
		option_1.visible = false
		option_2.visible = false

func bounce_effect(body,seconds_1,seconds_2,current_position,bounce_force):
	var bouncer = get_tree().create_tween()
	bouncer.tween_property(body, "position",Vector3(current_position.x,current_position.y + bounce_force,current_position.z),seconds_1)
	bouncer.tween_property(body, "position",Vector3(current_position.x,current_position.y,current_position.z),seconds_2).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)

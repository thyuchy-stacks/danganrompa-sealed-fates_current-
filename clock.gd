extends Sprite3D

signal minigame_failed()

func _ready() -> void:
	$"../clock_tick".wait_time = 600
	$"../../mc".start_minigame.connect(minigame_start)

func minigame_start():
	$"../clock_tick".start()

func _on_clock_tick_timeout() -> void:
	minigame_failed.emit()

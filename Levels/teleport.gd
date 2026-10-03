extends InteractionZone


func interaction():
	if GameManager.test_flags.has_key:
		player.global_position = Vector2(50.0, 150.0)
	else:
		label.text = "Нужен ключ"

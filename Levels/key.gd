extends InteractionZone


@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D


func interaction():
	if GameManager.test_flags.has_key:
		print("У вас уже есть ключ")
	else:
		GameManager.test_flags.has_key = true
		collision.disabled = true
		sprite.hide()
		print("Вы взяли ключ")

extends InteractionZone


@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D


func interaction():
	if not GameManager.test_flags.has_key:
		GameManager.test_flags.has_key = true
		collision.disabled = true
		sprite.hide()

	GameManager.set_gamestate(GameManager.GameState.DIALOG)
	await get_tree().create_timer(1.0).timeout
	GameManager.set_gamestate(GameManager.GameState.EXPLORATION)

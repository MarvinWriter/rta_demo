extends InteractionZone


@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var example_balloon: CanvasLayer = $ExampleBalloon

func _ready() -> void:
	super()
	if GameManager.test_flags.has_key:
		collision.disabled = true
		sprite.hide()
	else:
		collision.disabled = false
		sprite.show()


func interaction():
	in_interaction = true
	
	GameManager.set_gamestate(GameManager.GameState.DIALOG)
	example_balloon.start()
	await DialogueManager.dialogue_ended
	GameManager.set_gamestate(GameManager.GameState.EXPLORATION)
	
	
	if GameManager.test_flags.has_key:
		collision.disabled = true
		sprite.hide()
	elif not GameManager.test_flags.has_key:
		collision.disabled = false
		sprite.show()
	
	await get_tree().create_timer(0.01).timeout
	in_interaction = false

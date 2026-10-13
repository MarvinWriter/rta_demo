extends InteractionZone


@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var dialog_window: CanvasLayer = $DialogWindow


func _ready() -> void:
	super()
	
	# Проверяем флаг при загрузке сцены, чтобы не было "фантома"
	if GameManager.test_flags.has_key:
		collision.disabled = true
		sprite.hide()
	else:
		collision.disabled = false
		sprite.show()


func interaction():
	# Говорим, что находимся во взаимодействии
	in_interaction = true
	
	# Меняем состояние с EXPLORATION на DIALOG* и запускаем диалог
	# *(см. диздок, Игровой Процесс, Системы и Механики, Игровой менеджер)
	GameManager.set_gamestate(GameManager.GameState.DIALOG)
	dialog_window.start()
	
	# Ждём окончания диалога и меняем состояние обратно
	await DialogueManager.dialogue_ended
	GameManager.set_gamestate(GameManager.GameState.EXPLORATION)
	
	# Проверяем флаг после диалога, чтобы понять взял ли игрок ключ или нет
	if GameManager.test_flags.has_key:
		collision.disabled = true
		sprite.hide()
	elif not GameManager.test_flags.has_key:
		collision.disabled = false
		sprite.show()
	
	# Ждём одну сотую секунды, чтобы избежать повторного взаимодействия,
	# и говорим, что вышли из взаимодействия
	await get_tree().create_timer(0.01).timeout
	in_interaction = false

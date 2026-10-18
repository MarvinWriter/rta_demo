extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PauseMenu.hide()
	$PauseMenu.resume_button.pressed.connect(_on_resume_button_pressed)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("menu") and GameManager.current_gamestate == GameManager.GameState.EXPLORATION:
		GameManager.set_gamestate(GameManager.GameState.UI_MENU)
		$PauseMenu.show()
		$PauseMenu.resume_button.grab_focus()

func _on_resume_button_pressed():
	$PauseMenu.hide()
	GameManager.set_gamestate(GameManager.GameState.EXPLORATION)

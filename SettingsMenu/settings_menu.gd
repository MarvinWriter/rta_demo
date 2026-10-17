extends Control


@onready var settings_confirm_button: Button = %SettingsConfirmButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_language_option_button_item_selected(GameManager.language_index)
	_on_window_resolution_option_button_item_selected(GameManager.resolution_index)
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		%FullscreenCheckBox.button_pressed = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_master_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))


func _on_music_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))


func _on_sfx_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))


func _on_language_option_button_item_selected(index: int) -> void:
	match index:
		0:
			TranslationServer.set_locale("ru")
			GameManager.language_index = 0
		1:
			TranslationServer.set_locale("en")
			GameManager.language_index = 1


func _on_fullscreen_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		%WindowResolutionOptionButton.disabled = true
		%FullscreenCheckBox.text = tr("FULLSCREEN_MODE_ON")
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	elif not toggled_on:
		%WindowResolutionOptionButton.disabled = false
		%FullscreenCheckBox.text = tr("FULLSCREEN_MODE_OFF")
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		_on_window_resolution_option_button_item_selected(GameManager.resolution_index)

func _on_window_resolution_option_button_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(640, 360))
			GameManager.resolution_index = 0
		1:
			DisplayServer.window_set_size(Vector2i(1280, 720))
			GameManager.resolution_index = 1
		2:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
			GameManager.resolution_index = 2
		3:
			DisplayServer.window_set_size(Vector2i(2560, 1440))
			GameManager.resolution_index = 3

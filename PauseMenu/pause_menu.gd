extends Control


@onready var resume_button: Button = %ResumeButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SettingsMenu.hide()
	$SettingsMenu.settings_confirm_button.pressed.connect(_on_settings_confirm_button_pressed)
	%ResumeButton.grab_focus()


func buttons_disable():
	%ResumeButton.focus_mode = Control.FOCUS_NONE
	%SettingsButton.focus_mode = Control.FOCUS_NONE
	%InMainMenuButton.focus_mode = Control.FOCUS_NONE


func buttons_enable():
	%ResumeButton.focus_mode = Control.FOCUS_ALL
	%SettingsButton.focus_mode = Control.FOCUS_ALL
	%InMainMenuButton.focus_mode = Control.FOCUS_ALL


func _on_settings_button_pressed() -> void:
	buttons_disable()
	%PauseOverlay.hide()
	$SettingsMenu.show()
	$SettingsMenu.master_volume_slider.grab_focus()


func _on_settings_confirm_button_pressed():
	buttons_enable()
	%PauseOverlay.show()
	$SettingsMenu.hide()
	%SettingsButton.grab_focus()


func _on_in_main_menu_button_pressed() -> void:
	buttons_disable()
	LoadingScreen.animation_player.play("fade_in")
	await LoadingScreen.animation_player.animation_finished
	LoadingScreen.animation_player.play("loading")
	get_tree().change_scene_to_file("res://MainMenu/main_menu.tscn")

extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%ConfirmExitDialog.hide()
	%StartButton.grab_focus()


func buttons_disable():
	%StartButton.focus_mode = Control.FOCUS_NONE
	%SettingsButton.focus_mode = Control.FOCUS_NONE
	%AboutButton.focus_mode = Control.FOCUS_NONE
	$%ExitButton.focus_mode = Control.FOCUS_NONE


func buttons_enable():
	%StartButton.focus_mode = Control.FOCUS_ALL
	%SettingsButton.focus_mode = Control.FOCUS_ALL
	%AboutButton.focus_mode = Control.FOCUS_ALL
	$%ExitButton.focus_mode = Control.FOCUS_ALL


func _on_start_button_pressed() -> void:
	buttons_disable()
	LoadingScreen.animation_player.play("fade_in")
	await LoadingScreen.animation_player.animation_finished
	LoadingScreen.animation_player.play("loading")
	get_tree().change_scene_to_file("res://MainScene/main_scene.tscn")


func _on_settings_button_pressed() -> void:
	pass # Replace with function body.


func _on_about_button_pressed() -> void:
	pass # Replace with function body.


func _on_exit_button_pressed() -> void:
	buttons_disable()
	%ConfirmExitDialog.show()
	%ConfirmExitDialogButtons/NoButton.grab_focus()


func _on_no_button_pressed() -> void:
	buttons_enable()
	%ConfirmExitDialog.hide()
	%ExitButton.grab_focus()


func _on_yes_button_pressed() -> void:
	get_tree().quit()

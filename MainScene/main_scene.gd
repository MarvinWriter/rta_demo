extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player.facing_direction = Vector2.UP
	set_camera_border()
	GameManager.level_change_requested.connect(change_level)
	LoadingScreen.animation_player.play("fade_out")
	await LoadingScreen.animation_player.animation_finished
	GameManager.set_gamestate(GameManager.GameState.EXPLORATION)

# Функция смены локации
func change_level(path: String, spawn_point_name: String, facing: Vector2):
	LoadingScreen.animation_player.play("fade_in")
	await LoadingScreen.animation_player.animation_finished
	LoadingScreen.animation_player.play("loading")
	if $LevelHolder.get_child_count() > 0:
		$LevelHolder.get_child(0).queue_free()
	
	var new_level = load(path).instantiate()
	$LevelHolder.add_child(new_level)
	
	await get_tree().process_frame
	
	var spawn_point = new_level.get_node(spawn_point_name)
	$Player.global_position = spawn_point.global_position
	$Player.facing_direction = facing
	
	set_camera_border()
	
	LoadingScreen.animation_player.play("fade_out")
	await LoadingScreen.animation_player.animation_finished
	
	GameManager.set_gamestate(GameManager.GameState.EXPLORATION)

func set_camera_border():
	var current_level = $LevelHolder.get_child(0)
	
	if current_level.has_node("CameraBorders"):
		var camera_borders = current_level.get_node("CameraBorders")
		
		var top_border = camera_borders.get_node("TopBorder").global_position.y
		var bottom_border = camera_borders.get_node("BottomBorder").global_position.y
		var left_border = camera_borders.get_node("LeftBorder").global_position.x
		var right_border = camera_borders.get_node("RightBorder").global_position.x
		
		$Player/Camera2D.limit_top = top_border
		$Player/Camera2D.limit_bottom = bottom_border
		$Player/Camera2D.limit_left = left_border
		$Player/Camera2D.limit_right = right_border

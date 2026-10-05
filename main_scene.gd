extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.level_change_requested.connect(change_level)


func change_level(path: String, spawn_point_name: String, facing: Vector2):
	
	if $LevelHolder.get_child_count() > 0:
		$LevelHolder.get_child(0).queue_free()
	
	var new_level = load(path).instantiate()
	$LevelHolder.add_child(new_level)
	
	await get_tree().process_frame
	var spawn_point = new_level.get_node(spawn_point_name)
	$Player.global_position = spawn_point.global_position
	$Player.facing_direction = facing
	
	GameManager.set_gamestate(GameManager.GameState.EXPLORATION)

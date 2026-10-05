extends Node


signal changed_gamestate(new_gamestate: GameState)
signal level_change_requested(path: String, spawn_point_name: String, facing: Vector2)

enum GameState {
	EXPLORATION,
	LOADING,
	BATTLE_TRANSIT,
	BATTLE,
	MAIN_MENU,
	UI_MENU,
	DIALOG,
	CUTSCENE,
}

var current_gamestate := GameState.EXPLORATION

var test_flags: Dictionary = {
	"has_key": false,
}


func set_gamestate(new_gamestate: GameState):
	current_gamestate = new_gamestate
	gamestate_machine()
	changed_gamestate.emit(new_gamestate)


func request_level_change(path: String, spawn_point_name: String, facing: Vector2):
	set_gamestate(GameState.LOADING)
	level_change_requested.emit(path, spawn_point_name, facing)


func gamestate_machine():
	match current_gamestate:
		GameState.EXPLORATION:
			print("Режим исследования")
		GameState.LOADING:
			pass
		GameState.BATTLE_TRANSIT:
			pass
		GameState.BATTLE:
			pass
		GameState.MAIN_MENU:
			pass
		GameState.UI_MENU:
			pass
		GameState.DIALOG:
			print("Режим диалога")
		GameState.CUTSCENE:
			pass

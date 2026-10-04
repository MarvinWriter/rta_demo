extends Node


signal changed_gamestate(new_gamestate: GameState)

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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_gamestate(new_gamestate: GameState):
	current_gamestate = new_gamestate
	gamestate_machine()
	changed_gamestate.emit(new_gamestate)


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

extends Node


enum GameState {
	EXPLORATION,
	LOCATION_TRANSIT,
	BATTLE_TRANSIT,
	BATTLE,
	MENU,
	DIALOG,
	CUTSCENE,
}

var test_flags: Dictionary = {
	"has_key": false,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

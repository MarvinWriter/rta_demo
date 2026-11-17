class_name Enemy
extends BattleCharacter


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_target(player_team: Node2D):
	var new_target = player_team.get_child(randi_range(0, player_team.get_child_count() - 1))
	set_action(new_target)


func set_action(curent_target: BattleCharacter):
	var random_chance = randf()
	
	if random_chance < 1.0:
		attack(curent_target)

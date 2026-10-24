extends Node2D


@export var player_team_list: Array[String] = []
@export var enemy_team_list:  Array[String] = []

var is_selecting_target: bool = false

var initiative_list: Array[BattleCharacter] = []

var current_character: BattleCharacter
var current_target: BattleCharacter
var enemy_index: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%AttackButton.grab_focus()
	spawn_characters(player_team_list, enemy_team_list)
	print("Текущий персонаж: " + current_character.character_name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	if is_selecting_target:
		target_selection()


func _on_attack_button_pressed() -> void:
	buttons_disable()
	is_selecting_target = true
	enemy_index = 0


func buttons_disable():
	%AttackButton.focus_mode = Control.FOCUS_NONE
	%SkillButton.focus_mode = Control.FOCUS_NONE
	%DefenseButton.focus_mode = Control.FOCUS_NONE
	%EscapeButton.focus_mode = Control.FOCUS_NONE


func buttons_enable():
	%AttackButton.focus_mode = Control.FOCUS_ALL
	%SkillButton.focus_mode = Control.FOCUS_ALL
	%DefenseButton.focus_mode = Control.FOCUS_ALL
	%EscapeButton.focus_mode = Control.FOCUS_ALL


func print_initiative_list():
	for i in initiative_list.size():
		print(initiative_list[i].character_name + ", инициатива: " + str(initiative_list[i].initiative))


func spawn_characters(player_team_list: Array[String], enemy_team_list: Array[String]):
	for player in player_team_list.size():
		if player <= ($PlayerTeamPositions.get_child_count() - 1):
			var next_character = load("res://BattleSystem/BattleCharacter/" + str(player_team_list[player]) + ".tscn").instantiate()
			$PlayerTeam.add_child(next_character)
			$PlayerTeam.get_child(player).global_position = $PlayerTeamPositions.get_child(player).global_position
			$PlayerTeam.get_child(player).z_index = 3 - player
			initiative_list.append($PlayerTeam.get_child(player))
			if player == 0:
				current_character = $PlayerTeam.get_child(player)
		else:
			player_team_list.erase(player_team_list.back())
	
	for enemy in enemy_team_list.size():
		if enemy <= ($EnemyTeamPositions.get_child_count() - 1):
			var next_character = load("res://BattleSystem/Enemies/" + str(enemy_team_list[enemy]) + ".tscn").instantiate()
			$EnemyTeam.add_child(next_character)
			$EnemyTeam.get_child(enemy).global_position = $EnemyTeamPositions.get_child(enemy).global_position
			$EnemyTeam.get_child(enemy).z_index = 3 - enemy
			$EnemyTeam.get_child(enemy).initiative = randi_range(5, 12)
			initiative_list.append($EnemyTeam.get_child(enemy))
			$EnemyTeam.get_child(enemy).character_name = $EnemyTeam.get_child(enemy).character_name + " " + str(enemy + 1)
		else:
			enemy_team_list.erase(enemy_team_list.back())
	
	initiative_list.sort_custom(func(a, b): return a.initiative > b.initiative)
	print_initiative_list()


func target_selection():
	
	if Input.is_action_just_pressed("move_up"):
		if enemy_index >= ($EnemyTeam.get_child_count() - 1):
			enemy_index = 0
		else:
			enemy_index += 1
		print(enemy_index)
	if Input.is_action_just_pressed("move_down"):
		if enemy_index <= 0:
			enemy_index = ($EnemyTeam.get_child_count() - 1)
		else:
			enemy_index -= 1
		print(enemy_index)
	
	if Input.is_action_just_pressed("accept"):
		buttons_enable()
		%AttackButton.grab_focus()
		is_selecting_target = false
		current_target = $EnemyTeam.get_child(enemy_index)
		current_target.take_damage(current_character.damage)
		if current_target.is_dead:
			current_target.queue_free()
			initiative_list.erase(current_target)
			print_initiative_list()
	
	if Input.is_action_just_pressed("cancel"):
		buttons_enable()
		%AttackButton.grab_focus()
		is_selecting_target = false

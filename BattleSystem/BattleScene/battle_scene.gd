extends Node2D


signal player_confirmed

enum battle_state {
	BATTLE_START,
	PLAYER_TURN,
	ENEMY_TURN,
	VICTORY,
	DEFEAT,
	CHECK_TURN,
}

var current_battle_state: battle_state = battle_state.BATTLE_START

@export var player_team_list: Array[String] = []
@export var enemy_team_list:  Array[String] = []
@export var is_have_turns_limit: bool = false
@export var battle_turns_limit: int

var is_selecting_target: bool = false
var is_waiting_player_confirmed: bool = false

var initiative_list: Array[BattleCharacter] = []
var initiative_index: int = 0

var current_character: BattleCharacter
var current_target: BattleCharacter
var target_index: int = 0

var battle_turns_counter: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	battle_state_machine(battle_state.BATTLE_START)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _unhandled_input(_event: InputEvent) -> void:
	if is_selecting_target:
		target_selection()
	
	if is_waiting_player_confirmed:
		if Input.is_action_just_pressed("accept"):
			player_confirmed.emit()


func _on_attack_button_pressed() -> void:
	buttons_disable()
	is_selecting_target = true
	target_index = 0


func _on_defense_button_pressed() -> void:
	buttons_disable()
	current_character.in_defense = true
	
	_on_action_log("%s ушёл в защиту." % [current_character.character_name])
	is_waiting_player_confirmed = true
	await player_confirmed
	await battle_state_machine(battle_state.CHECK_TURN)


func _on_action_log(text_log: String):
	%ActionLogLabel.text = text_log + "\n\n"


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


func battle_state_machine(new_battle_state: battle_state):
	current_battle_state = new_battle_state
	
	match current_battle_state:
		battle_state.BATTLE_START:
			print("СТАРТ БОЯ")
			buttons_disable()
			spawn_characters()
			_on_action_log("Завязался бой!")
			is_waiting_player_confirmed = true
			await player_confirmed
			if initiative_list[initiative_index].get_parent() == $PlayerTeam:
				print("Передаю ход игроку")
				await battle_state_machine(battle_state.PLAYER_TURN)
			elif initiative_list[initiative_index].get_parent() == $EnemyTeam:
				print("Передаю ход врагу") 
				await battle_state_machine(battle_state.ENEMY_TURN)
		battle_state.PLAYER_TURN:
			print("ХОД ИГРОКА")
			
			var random_log: int = randi_range(0, 2)
			
			current_character = initiative_list[initiative_index]
			current_character.in_defense = false
			buttons_enable()
			%AttackButton.grab_focus()
			
			match random_log:
				0:
					_on_action_log("%s перехватывает инициативу." % [current_character.character_name])
				1:
					_on_action_log("Твой очередь, %s!" % [current_character.character_name])
				2:
					_on_action_log("Ходит %s." % [current_character.character_name])
		battle_state.ENEMY_TURN:
			print("ХОД ВРАГА")
			
			current_character = initiative_list[initiative_index]
			current_character.in_defense = false
			current_character.set_target($PlayerTeam)
			await current_character.turn_is_end
			is_waiting_player_confirmed = true
			await player_confirmed
			await battle_state_machine(battle_state.CHECK_TURN)
		battle_state.VICTORY:
			print("ПОБЕДА")
			
			_on_action_log("Наши победили!")
			is_waiting_player_confirmed = true
			await player_confirmed
		battle_state.DEFEAT:
			print("ПОРАЖЕНИЕ")
			
			_on_action_log("Враги, злорадствуя, вышли сухими...")
			is_waiting_player_confirmed = true
			await player_confirmed
		battle_state.CHECK_TURN:
			if $PlayerTeam.get_child_count() == 0:
				await battle_state_machine(battle_state.DEFEAT)
			elif $EnemyTeam.get_child_count() == 0:
				await battle_state_machine(battle_state.VICTORY)
			else:
				if initiative_index < (initiative_list.size() - 1):
					initiative_index += 1
					if initiative_list[initiative_index].get_parent() == $PlayerTeam:
						await battle_state_machine(battle_state.PLAYER_TURN)
					elif initiative_list[initiative_index].get_parent() == $EnemyTeam: 
						await battle_state_machine(battle_state.ENEMY_TURN)
				else:
					initiative_index = 0
					if initiative_list[initiative_index].get_parent() == $PlayerTeam:
						await battle_state_machine(battle_state.PLAYER_TURN)
					elif initiative_list[initiative_index].get_parent() == $EnemyTeam: 
						await battle_state_machine(battle_state.ENEMY_TURN)


func spawn_characters():
	for player in player_team_list.size():
		if player <= ($PlayerTeamPositions.get_child_count() - 1):
			var next_character = load("res://BattleSystem/BattleCharacter/" + str(player_team_list[player]) + ".tscn").instantiate()
			$PlayerTeam.add_child(next_character)
			$PlayerTeam.get_child(player).global_position = $PlayerTeamPositions.get_child(player).global_position
			$PlayerTeam.get_child(player).z_index = 3 - player
			initiative_list.append($PlayerTeam.get_child(player))
			$PlayerTeam.get_child(player).action_log.connect(_on_action_log)
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
			$EnemyTeam.get_child(enemy).action_log.connect(_on_action_log)
			$EnemyTeam.get_child(enemy).character_name = $EnemyTeam.get_child(enemy).character_name + " " + str(enemy + 1)
		else:
			enemy_team_list.erase(enemy_team_list.back())
	
	initiative_list.sort_custom(func(a, b): return a.initiative > b.initiative)
	print_initiative_list()


func target_selection():
	
	if Input.is_action_just_pressed("move_up"):
		if target_index >= ($EnemyTeam.get_child_count() - 1):
			target_index = 0
		else:
			target_index += 1
		print(target_index)
	
	if Input.is_action_just_pressed("move_down"):
		if target_index <= 0:
			target_index = ($EnemyTeam.get_child_count() - 1)
		else:
			target_index -= 1
		print(target_index)
	
	if Input.is_action_just_pressed("accept"):
		is_selecting_target = false
		current_target = $EnemyTeam.get_child(target_index)
		current_character.attack(current_target)
		await current_character.turn_is_end
		is_waiting_player_confirmed = true
		await player_confirmed
		await battle_state_machine(battle_state.CHECK_TURN)
	
	if Input.is_action_just_pressed("cancel"):
		buttons_enable()
		%AttackButton.grab_focus()
		is_selecting_target = false

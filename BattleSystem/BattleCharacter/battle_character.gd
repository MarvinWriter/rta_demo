class_name BattleCharacter
extends Node2D

signal action_log(text_log: String)
signal turn_is_end

@export var character_name: String = "Name Example"

@export var max_hp: int = 100

var current_hp: int = max_hp:
	set(value):
		current_hp = clamp(value, 0, max_hp)
		if current_hp == 0:
			print(character_name + " is dead")
			is_dead = true

var is_dead: bool = false

@export var initiative: int = 10
@export var damage: int = 10
@export var defense: int = 10

var in_defense: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_hp = max_hp
	print("Я %s!" % character_name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func attack(target: BattleCharacter):
	action_log.emit("%s атаковал %s" % [character_name, target.character_name])
	await get_tree().process_frame
	get_parent().get_parent().is_waiting_player_confirmed = true
	await get_parent().get_parent().player_confirmed
	
	target.take_damage(damage)
	if target.is_dead:
		target.queue_free()
		get_parent().get_parent().initiative_list.erase(target)
		action_log.emit("%s погибает" % [target.character_name])
	
	await get_tree().process_frame
	turn_is_end.emit()


func take_damage(new_amount: int):
	var amount = new_amount
	
	if in_defense:
		amount = amount - defense * 2
	else:
		amount = amount - defense
	
	if amount <= 0:
		amount = 1
	current_hp -= amount
	
	action_log.emit("%s получает %d урона" % [character_name, amount])
	print(character_name + " ОЗ: " + str(current_hp))
